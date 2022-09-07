import 'package:flutter/material.dart';

import './temp_chem_model.dart';

class ChemList with ChangeNotifier {
  final List<ChemModel> _chemicalList = [
    ChemModel(id: '1', name: 'Methane', formula: 'CH3CH3', molWeight: 20),
    ChemModel(id: '2', name: 'Ethane', formula: 'CH3CH2CH3', molWeight: 30),
    ChemModel(
        id: '3', name: 'DiEthylEther', formula: 'CH3CH2CH2CH3', molWeight: 45),
    ChemModel(id: '4', name: "Anything", formula: 'CH3BAg3', molWeight: 108)
  ];

  List<ChemModel> get elements {
    return [..._chemicalList];
  }

  void addElement(ChemModel value) {
    _chemicalList.add(value);
    notifyListeners();
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
          (elements) => elements.name.startsWith(
            RegExp(name, caseSensitive: false),
          ),
        )
        .toList();
  }
}
