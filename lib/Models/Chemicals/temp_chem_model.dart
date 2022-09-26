import 'package:flutter/material.dart';

class ChemModel with ChangeNotifier {
  String id;
  String name;
  String formula;
  String description;
  String state;
  String grade;
  List<String> hazard;
  String assay;
  double density;
  double molWeight;
  double boilingPoint;
  double meltingPoint;
  int bioLab;
  int chemLab;

  ChemModel({
    required this.id,
    required this.name,
    required this.formula,
    this.description = "",
    this.molWeight = 0,
    this.chemLab = 0,
    this.bioLab = 0,
    required this.state,
    required this.grade,
    required this.hazard,
    this.assay = '',
    required this.density,
    required this.boilingPoint,
    required this.meltingPoint,
  });
}
