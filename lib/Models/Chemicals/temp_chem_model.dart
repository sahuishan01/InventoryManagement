import 'package:flutter/material.dart';

class ChemModel with ChangeNotifier {
  String id;
  String name;
  String formula;
  double molWeight;
  String description;

  ChemModel(
      {required this.id,
      required this.name,
      required this.formula,
      this.description = "",
      this.molWeight = 0});
}
