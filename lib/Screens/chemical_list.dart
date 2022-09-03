import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/new_chemical.dart';
import '../Widgets/chemlist/single_chemical_card.dart';
import '../Models/Chemicals/temp_chem_list.dart';

class ChemicalList extends StatefulWidget {
  const ChemicalList({Key? key}) : super(key: key);

  @override
  State<ChemicalList> createState() => _ChemicalListState();
}

class _ChemicalListState extends State<ChemicalList> {
  List tempList = [...chemicalList];

  void searchText(text) {
    setState(() {
      tempList = chemicalList
          .where((element) =>
              element.name.startsWith(RegExp(text, caseSensitive: false)))
          .toList();
    });
  }

  void newChemical(BuildContext ctx) {
    Navigator.pushNamed(ctx, NewChemical.routeName);
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    AppBar appBar = AppBar(
      leading: const Icon(Icons.science_outlined),
      title: const Text('Chemical List'),
      titleSpacing: 0,
    );
    double appBarHeight = appBar.preferredSize.height;

    return Scaffold(
      appBar: appBar,
      body: SizedBox(
        height: deviceHeight,
        width: deviceWidth,
        child: ListView(
          children: [
//Displaying all Chemicals
            SizedBox(
              height: (deviceHeight - appBarHeight) * 0.8,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.02),
                itemCount: tempList.length,
                itemBuilder: (ctx, index) =>
                    SingleChemicalCard(tempList, index),
              ),
            ),

//Bottom bar for search and scan with Floating button for adding new elements
            Stack(
              alignment: Alignment.topCenter,
              children: [
                FloatingActionButton(
                  splashColor: Colors.black54,
                  elevation: 10,
                  onPressed: () => newChemical(context),
                  child: const Icon(Icons.add),
                ),
                SizedBox(
                  height: (deviceHeight - appBarHeight) * 0.2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //Search
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: deviceWidth * 0.1),
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(4, 4),
                                  color: Colors.black26,
                                  blurRadius: 5)
                            ],
                            color: Colors.pink,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.pink),
                          ),
                          child: TextField(
                            onChanged: (text) => searchText(text),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                            decoration: const InputDecoration(
                              hintText: "Search",
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 20),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),

                      //Scan
                      Expanded(
                        flex: 3,
                        child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: deviceWidth * 0.1),
                            child: TextButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(5),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.all(19)),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.pink),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              child: const Text(
                                "Scan",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              onPressed: () => {},
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
