import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  bool _isAdmin = false;
  Timer? _authTimer;
  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token as String;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  bool get isAdmin {
    final url = Uri.parse(
        'https://inventory-db0eb-default-rtdb.asia-southeast1.firebasedatabase.app/users/$_userId.json?auth=$_token');

    http
        .get(url)
        .then((response) => json.decode(response.body))
        .then((value) => value['isAdmin'].toString() == 'false'
            ? _isAdmin = false
            : _isAdmin = true)
        .catchError((onError) => throw onError);

    return _isAdmin;
  }

  Future<void> _authenticate(String email, String password, String partUrl,
      {String name = '', String? studentClass = ''}) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$partUrl?key=AIzaSyBB4AmWbOqIrkKTns4PdvAP5sHf-FuEEyY');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final data = json.decode(response.body);

      if (data['error'] != null) {
        throw HTTPExtension(data['error']['message']);
      }
      _token = data['idToken'];
      _userId = data['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(data['expiresIn']),
        ),
      );
      if (partUrl.contains('signUp')) {
        final url = Uri.parse(
            'https://inventory-db0eb-default-rtdb.asia-southeast1.firebasedatabase.app/users/$_userId.json?auth=$_token');
        try {
          await http.put(
            url,
            body: json.encode(
              {
                'email': email,
                'name': name,
                'class': studentClass,
                'id': _userId,
                'isAdmin': true,
              },
            ),
          );
        } catch (error) {
          rethrow;
        }
      }
      _autoLogout();
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String()
      });
      pref.setString('user', userData);
    } catch (err) {
      rethrow;
    }
  }

  Future<void> signup(
      String email, String password, String name, String studentClass) async {
    return _authenticate(email, password, 'signUp',
        name: name, studentClass: studentClass);
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('user')) {
      return false;
    }
    final extractedUserData =
        json.decode(pref.getString('user').toString()) as Map<String, Object>;
    final expiryDate =
        DateTime.parse(extractedUserData['expiryDate'].toString());
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'].toString();
    _expiryDate = expiryDate;
    _userId = extractedUserData['userId'].toString();
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;

    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
