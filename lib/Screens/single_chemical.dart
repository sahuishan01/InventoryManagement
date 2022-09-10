import 'package:flutter/material.dart';
import '../Models/Chemicals/temp_chem_list.dart';
import 'package:provider/provider.dart';
import '../Screens/new_chemical.dart';

class SingleChemical extends StatelessWidget {
  const SingleChemical({Key? key}) : super(key: key);

  static const routeName = '/single-chemical';
  // final String chemName;

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as List<String>;

    final element =
        Provider.of<ChemList>(context, listen: false).findById(routeArgs[0]);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => {
                    Navigator.of(context).pushNamed(NewChemical.routeName,
                        arguments: [element.id]),
                  },
                  icon: const Icon(Icons.edit),
                ),
                const SizedBox(
                  width: 20,
                ),
                IconButton(
                  onPressed: () => {
                    Provider.of<ChemList>(context, listen: false)
                        .deleteElement(element),
                    Navigator.pop(context, false),
                  },
                  icon: const Icon(Icons.delete_forever_outlined),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
