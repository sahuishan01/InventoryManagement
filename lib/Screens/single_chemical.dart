import 'package:flutter/material.dart';
import '../Models/Chemicals/temp_chem_list.dart';

class SingleChemical extends StatelessWidget {
  static const routeName = '/single-chemical';
  // final String chemName;
  const SingleChemical({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as List<String>;

    final element =
        chemicalList.firstWhere((element) => element.id == routeArgs[0]);

    return Scaffold(
      appBar: AppBar(title: Text(element.name)),
      body: Center(
        child: Text(element.formula),
      ),
    );
  }
}
