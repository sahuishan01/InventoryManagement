import 'package:flutter/material.dart';
import '../Models/Chemicals/temp_chem_list.dart';
import 'package:provider/provider.dart';
import '../Screens/new_chemical.dart';

class SingleChemical extends StatefulWidget {
  const SingleChemical({Key? key}) : super(key: key);

  static const routeName = '/single-chemical';

  @override
  State<SingleChemical> createState() => _SingleChemicalState();
}

class _SingleChemicalState extends State<SingleChemical> {
  // final String chemName;
  List<Widget> singleHazardWidget = [];

//display hazard images
  bool _loadImage = false;
  addImage(element) {
    setState(
      () => singleHazardWidget.add(
        Image.asset(
          'assets/images/$element.png',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldContext = ScaffoldMessenger.of(context);
    void popScreen() {
      Navigator.pop(context, false);
    }

    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;

    final element =
        Provider.of<ChemList>(context, listen: false).findById(routeArgs['id']);
    final bool isAdmin = routeArgs['isAdmin'] as bool;

    final hazards = element.hazard;

//get images of hazards

    if (!_loadImage) {
      for (var element in hazards) {
        addImage(element);
      }
    }

    _loadImage = true;

    final appBar = AppBar(title: Text(element.name.toUpperCase()));
    Size deviceSize = MediaQuery.of(context).size;

//body

    return Scaffold(
      appBar: appBar,
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            height: deviceSize.height - appBar.preferredSize.height,
            width: deviceSize.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Center(
                    child: Text(element.formula),
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    children: [
                      ...singleHazardWidget,
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                isAdmin
                    ? Expanded(
                        child: Row(
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
                                  await Provider.of<ChemList>(context,
                                          listen: false)
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
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
