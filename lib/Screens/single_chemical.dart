import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/new_chemical.dart';
import '../Models/Chemicals/temp_chem_list.dart';

class SingleChemical extends StatelessWidget {
  static const routeName = '/single-chemical';
  // final String chemName;
  const SingleChemical({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as List<String>;

    final element = ChemList.chemicalList
        .firstWhere((element) => element.id == routeArgs[0]);

    return Scaffold(
      appBar: AppBar(title: Text(element.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(element.formula),
            const SizedBox(
              height: 10,
            ),
            IconButton(
                onPressed: () => {
                      Navigator.of(context).pushNamed(NewChemical.routeName,
                          arguments: [element.id]),
                    },
                icon: const Icon(Icons.edit))
          ],
        ),
      ),
    );
  }
}
