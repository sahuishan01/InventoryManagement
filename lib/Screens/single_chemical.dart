import 'package:flutter/material.dart';
import '../Models/auth.dart';
import '../Models/Chemicals/temp_chem_list.dart';
import 'package:provider/provider.dart';
import '../Screens/new_chemical.dart';

class SingleChemical extends StatelessWidget {
  SingleChemical({Key? key}) : super(key: key);

  static const routeName = '/single-chemical';
  // final String chemName;

  @override
  Widget build(BuildContext context) {
    final scaffoldContext = ScaffoldMessenger.of(context);
    void popScreen() {
      Navigator.pop(context, false);
    }

    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;

    final element =
        Provider.of<ChemList>(context, listen: false).findById(routeArgs['id']);
    final bool _isAdmin = routeArgs['isAdmin'] as bool;

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
            _isAdmin
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => {
                          Navigator.of(context).pushReplacementNamed(
                              NewChemical.routeName,
                              arguments: [element.id]),
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                        onPressed: () async {
                          try {
                            await Provider.of<ChemList>(context, listen: false)
                                .deleteElement(element);
                            popScreen();
                          } catch (err) {
                            scaffoldContext.showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Deletion failed",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.delete_forever_outlined),
                      ),
                    ],
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
