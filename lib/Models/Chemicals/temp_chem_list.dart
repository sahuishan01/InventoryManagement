// ignore_for_file: no_leading_underscores_for_local_identifiers
import '../http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './temp_chem_model.dart';

class ChemList with ChangeNotifier {
  final double? authToken;
  ChemList(this.authToken, this._chemicalList);
  List<ChemModel> _chemicalList = [];

  List<ChemModel> get elements {
    return [..._chemicalList];
  }

  Map<String, dynamic> _tempChemList = {};
  Future<void> getLoadedData() async {
    List<ChemModel> _tempChemical = [];
    final url = Uri.parse(
        'https://inventory-db0eb-default-rtdb.asia-southeast1.firebasedatabase.app/chemicalList.json?auth=$authToken');
    try {
      final response = await http.get(url);
      _tempChemList = json.decode(response.body) as Map<String, dynamic>;
      _tempChemList.forEach((elementId, value) {
        _tempChemical.add(
          ChemModel(
            id: elementId,
            name: value['name'],
            formula: value['formula'],
            molWeight: value['molWeight'],
            description: value['description'],
          ),
        );
      });
      _chemicalList = _tempChemical;
      notifyListeners();
    } catch (error) {
      rethrow;
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

  Future<void> updateElement(ChemModel value, String id) async {
    final url = Uri.parse(
        'https://inventory-db0eb-default-rtdb.asia-southeast1.firebasedatabase.app/chemicalList/$id.json');
    try {
      await http.patch(
        url,
        body: json.encode(
          {
            "name": value.name,
            "formula": value.formula,
            "description": value.description,
            "molWeight": value.molWeight,
          },
        ),
      );
    } catch (err) {
      rethrow;
    }

    final updateIndex = _chemicalList.indexWhere((element) => element.id == id);
    _chemicalList[updateIndex] = value;
    notifyListeners();
  }

  Future<void> deleteElement(ChemModel value) async {
    final url = Uri.parse(
        'https://inventory-db0eb-default-rtdb.asia-southeast1.firebasedatabase.app/chemicalList/${value.id}.json');

    final existingChemicalElementIndex =
        _chemicalList.indexWhere((element) => element.id == value.id);
    ChemModel? existingChemicalElement =
        _chemicalList[existingChemicalElementIndex];
    _chemicalList.removeAt(existingChemicalElementIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _chemicalList.insert(
          existingChemicalElementIndex, existingChemicalElement);
      notifyListeners();
      throw HTTPExtension('Deletion Failed');
    }
    existingChemicalElement = null;
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
