// ignore_for_file: no_leading_underscores_for_local_identifiers
import '../http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './temp_chem_model.dart';

class ChemList with ChangeNotifier {
  final String? authToken;
  ChemList(this.authToken, this._chemicalList);
  List<ChemModel> _chemicalList = [];

  List<ChemModel> get elements {
    return [..._chemicalList];
  }

  // Future<void> addHazards() async {
  //   final url = Uri.parse(
  //       'https://inventory-db0eb-default-rtdb.asia-southeast1.firebasedatabase.app/hazards/environmental.json?auth=$authToken');
  //   try {
  //     await http.put(
  //       url,
  //       body: json.encode({
  //         'url':
  //             'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/GHS-pictogram-pollu.svg/1200px-GHS-pictogram-pollu.svg.png'
  //       }),
  //     );
  //     print('done');
  //   } catch (err) {
  //     rethrow;
  //   }
  // }

  Future<void> getLoadedData() async {
    final url = Uri.parse(
        'https://inventory-db0eb-default-rtdb.asia-southeast1.firebasedatabase.app/chemicalList.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final List<ChemModel> _tempChemical = [];

      final _tempChemList = json.decode(response.body) as Map<String, dynamic>;

      _tempChemList.forEach((elementId, value) {
        _tempChemical.add(
          ChemModel(
            id: elementId,
            name: value['name'],
            formula: value['formula'],
            description: value['description'],
            state: value['state'],
            grade: value['grade'],
            hazard: List<String>.from(value['hazard']),
            assay: value['assay'],
            density: value['density'],
            boilingPoint: value['boilingPoint'],
            meltingPoint: value['meltingPoint'],
            molWeight: double.parse(value['molWeight'].toString()),
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
        'https://inventory-db0eb-default-rtdb.asia-southeast1.firebasedatabase.app/chemicalList.json?auth=$authToken');
    try {
      await http.post(
        url,
        body: json.encode(
          {
            'name': value.name,
            'description': value.description,
            'formula': value.formula,
            'state': value.state,
            'grade': value.grade,
            'hazard': value.hazard,
            'assay': value.assay,
            'density': value.density,
            'boilingPoint': value.boilingPoint,
            'meltingPoint': value.meltingPoint,
            'molWeight': value.molWeight,
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
        'https://inventory-db0eb-default-rtdb.asia-southeast1.firebasedatabase.app/chemicalList/$id.json?auth=$authToken');
    try {
      await http.patch(
        url,
        body: json.encode(
          {
            'name': value.name,
            'description': value.description,
            'formula': value.formula,
            'state': value.state,
            'grade': value.grade,
            'hazard': value.hazard,
            'assay': value.assay,
            'density': value.density,
            'boilingPoint': value.boilingPoint,
            'meltingPoint': value.meltingPoint,
            'molWeight': value.molWeight,
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
        'https://inventory-db0eb-default-rtdb.asia-southeast1.firebasedatabase.app/chemicalList/${value.id}.json?auth=$authToken');

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
