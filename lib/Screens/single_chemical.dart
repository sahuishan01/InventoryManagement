import 'package:flutter/material.dart';
import '../Models/Chemicals/temp_chem_list.dart';
import 'package:provider/provider.dart';
import '../Models/auth.dart';
import './new_chemical.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _followLink(url) async {
    final uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri)) {
        throw 'Could not launch $url';
      }
    } catch (err) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error Occurred'),
          content: const Text("Could not find the chemical page"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    singleHazardWidget = [];
    final scaffoldContext = ScaffoldMessenger.of(context);
    void popScreen() {
      Navigator.pop(context, false);
    }

    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;

    final element =
        Provider.of<ChemList>(context, listen: false).findById(routeArgs['id']);
    final bool isAdmin = routeArgs['isAdmin'] as bool;
    final String lab = routeArgs['lab'].toString();

    final hazards = element.hazard;

//get images of hazards

    if (!_loadImage) {
      for (var element in hazards) {
        addImage(element);
      }
    }

    _loadImage = true;

    final appBar = AppBar(
      title: Text(element.name.toUpperCase()),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<Auth>(context, listen: false).logout();
          },
          icon: const Icon(Icons.logout_outlined),
        ),
      ],
    );
    Size deviceSize = MediaQuery.of(context).size;

//body

    return Scaffold(
      appBar: appBar,
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            height: deviceSize.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).viewPadding.top,
            width: deviceSize.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: deviceSize.height * 0.03),
                  child: const Text(
                    'Specifications',
                    style: TextStyle(
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: deviceSize.width * 0.05,
                      vertical: deviceSize.height * 0.03),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FlexColumnWidth(6),
                      1: FlexColumnWidth(5)
                    },
                    children: <TableRow>[
//molecular formula
                      TableRow(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: deviceSize.height * 0.015),
                            child: const Center(
                              child: FittedBox(
                                child: Text(
                                  'Molecular Formula',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: Text(
                                element.formula,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),

//molecular weight
                      TableRow(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: deviceSize.height * 0.015),
                            child: const Center(
                              child: FittedBox(
                                child: Text(
                                  'Molecular weight',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: Text(
                                '${element.molWeight} mol',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),

//element state
                      TableRow(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: deviceSize.height * 0.015),
                            child: const Center(
                              child: FittedBox(
                                child: Text(
                                  'State',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: Text(
                                element.state,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),

//Boiling temperature
                      TableRow(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: deviceSize.height * 0.015),
                            child: const Center(
                              child: FittedBox(
                                child: Text(
                                  'Boiling Temp.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: Text(
                                '${element.boilingPoint} ℃',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
//Melting temperature
                      TableRow(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: deviceSize.height * 0.015),
                            child: const Center(
                              child: FittedBox(
                                child: Text(
                                  'Melting Temp.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: Text(
                                '${element.meltingPoint} ℃',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
//Density
                      TableRow(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: deviceSize.height * 0.015),
                            child: const Center(
                              child: FittedBox(
                                child: Text(
                                  'Density',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: Text(
                                '${element.density} gm/cc',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
//Grade
                      TableRow(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: deviceSize.height * 0.015),
                            child: const Center(
                              child: FittedBox(
                                child: Text(
                                  'Grade',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: Text(
                                element.grade,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),

//%assay
                      element.state.toLowerCase() == 'liquid'
                          ? TableRow(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: deviceSize.height * 0.015),
                                  child: const Center(
                                    child: FittedBox(
                                      child: Text(
                                        '% Assay',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    child: Text(
                                      element.assay,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : TableRow(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: deviceSize.height * 0.015),
                                  child: const Center(
                                    child: FittedBox(
                                      child: Text(
                                        '% Assay',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                                const TableCell(
                                  child: Center(
                                    child: Text(
                                      'N.A',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
//hazards
                      TableRow(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: deviceSize.height * 0.015),
                            child: const Center(
                              child: FittedBox(
                                child: Text(
                                  'Hazards',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              alignment: Alignment.center,
                              height: element.hazard.length <= 3
                                  ? deviceSize.height * 0.065
                                  : deviceSize.height * 0.13,
                              child: GridView.count(
                                crossAxisCount: 3,
                                children: [
                                  ...singleHazardWidget,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _followLink(element.description),
                    child: const Text('Want to know more?'),
                  ),
                ),
                isAdmin
                    ? SizedBox(
                        height: deviceSize.height * 0.2,
                        child: Column(
                          children: [
                            lab.toLowerCase().contains('full') ||
                                    lab.toLowerCase().contains('bio') ||
                                    lab.toLowerCase().contains('chem')
                                ? Flexible(
                                    child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text("Quantity in Bio Lab is"),
                                          SizedBox(
                                            height: deviceSize.height * 0.01,
                                          ),
                                          Text(element.bioLab.toString())
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text("Quantity in Chem Lab is"),
                                          SizedBox(
                                            height: deviceSize.height * 0.01,
                                          ),
                                          Text(element.chemLab.toString())
                                        ],
                                      )
                                    ],
                                  ))
                                : const SizedBox(),
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () => {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
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
                                    icon: const Icon(
                                        Icons.delete_forever_outlined),
                                  ),
                                ],
                              ),
                            )
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
