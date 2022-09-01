class ChemModel {
  String id;
  String name;
  String formula;
  double molWeight;
  ChemModel(
      {required this.id,
      required this.name,
      required this.formula,
      this.molWeight = 0});
}
