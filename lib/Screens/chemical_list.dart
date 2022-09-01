import 'package:flutter/material.dart';
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
//Floating button for adding new elements
            FloatingActionButton(
              onPressed: () => {},
              child: const Icon(Icons.add),
            ),
//Bottom bar for search and scan
            Container(
              height: (deviceHeight - appBarHeight) * 0.2,
              padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
//Search
                  Container(
                    width: deviceWidth * 0.45,
                    padding: const EdgeInsets.all(1),
                    child: TextField(
                      onChanged: (text) => searchText(text),
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(hintText: "Search"),
                    ),
                  ),

//Scan
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.pink),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      onTap: (() {}),
                      child: Text('Scan',
                          style: Theme.of(context).textTheme.headline6),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
