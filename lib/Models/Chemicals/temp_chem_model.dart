class ChemModel {
  final String id;
  final String name;
  final String formula;
  final double molWeight;
  final String description;
  ChemModel(
      {required this.id,
      required this.name,
      required this.formula,
      this.description = "",
      this.molWeight = 0});
}
