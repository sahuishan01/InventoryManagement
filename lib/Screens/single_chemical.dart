import 'package:flutter/material.dart';
import '../Models/auth.dart';
import '../Models/Chemicals/temp_chem_list.dart';
import 'package:provider/provider.dart';
import '../Screens/new_chemical.dart';

class SingleChemical extends StatelessWidget {
  const SingleChemical({Key? key}) : super(key: key);

  static const routeName = '/single-chemical';
  // final String chemName;

  @override
  Widget build(BuildContext context) {
    bool isAdmin = false;
    try {
      isAdmin = Provider.of<Auth>(context, listen: false).isAdmin;
    } catch (error) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('An error Occurred'),
                content: Text(error.toString()),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Okay'),
                  ),
                ],
              ));
    }
    final scaffoldContext = ScaffoldMessenger.of(context);
    void popScreen() {
      Navigator.pop(context, false);
    }

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
            isAdmin
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
