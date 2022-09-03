import './temp_chem_model.dart';

class ChemList {
  static var chemicalList = [
    ChemModel(id: '1', name: 'Methane', formula: 'CH3CH3', molWeight: 20),
    ChemModel(id: '2', name: 'Ethane', formula: 'CH3CH2CH3', molWeight: 30),
    ChemModel(
        id: '3', name: 'DiEthylEther', formula: 'CH3CH2CH2CH3', molWeight: 45),
    ChemModel(id: '4', name: "Anything", formula: 'CH3BAg3', molWeight: 108)
  ];
  List<ChemModel> get elements {
    return [...chemicalList];
  }

  ChemModel findById(String id) {
    return chemicalList.firstWhere((element) => element.id == id);
  }
}
