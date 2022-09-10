// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './temp_chem_model.dart';

class ChemList with ChangeNotifier {
  List<ChemModel> _chemicalList = [];

  List<ChemModel> get elements {
    return [..._chemicalList];
  }

  Map<String, dynamic> _tempChemList = {};
  Future<void> getLoadedData() async {
    List<ChemModel> _tempChemical = [];
    final url = Uri.parse(
        'https://inventory-db0eb-default-rtdb.asia-southeast1.firebasedatabase.app/chemicalList');
    try {
      final response = await http.get(url);
      _tempChemList = json.decode(response.body) as Map<String, dynamic>;
      _tempChemList.forEach((elementId, value) {
        _tempChemical.add(ChemModel(
            id: elementId, name: value['name'], formula: value['formula']));
      });
      _chemicalList = _tempChemical;
      notifyListeners();
    } catch (error) {
      ;
    }
  }

  Future<void> addElement(ChemModel value) async {
    final url = Uri.parse(
        'https://inventory-db0eb-default-rtdb.asia-southeast1.firebasedatabase.app/chemicalList.json');
    try {
      await http.post(
        url,
        body: json.encode(
          {
            'name': value.name,
            'description': value.description,
            'molWeight': value.molWeight,
            'formula': value.formula,
          },
        ),
      );
      getLoadedData();
    } catch (err) {
      rethrow;
    }
  }

  void updateElement(ChemModel value, String id) {
    final updateIndex = _chemicalList.indexWhere((element) => element.id == id);
    _chemicalList[updateIndex] = value;
    notifyListeners();
  }

  void deleteElement(ChemModel value) {
    _chemicalList.removeWhere((element) => element.id == value.id);
    notifyListeners();
  }

  ChemModel findById(String id) {
    return _chemicalList.firstWhere((element) => element.id == id);
  }

  List<ChemModel> findByName(String name) {
    return _chemicalList
        .where(
          (element) => element.name.startsWith(
            RegExp(name, caseSensitive: false),
          ),
        )
        .toList();
  }
}
