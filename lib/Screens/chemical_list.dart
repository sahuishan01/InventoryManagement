import 'package:flutter/material.dart';
import '../Models/Chemicals/temp_chem_model.dart';
import './new_chemical.dart';
import '../Widgets/chemlist/single_chemical_card.dart';
import '../Models/Chemicals/temp_chem_list.dart';
import 'package:provider/provider.dart';

class ChemicalList extends StatefulWidget {
  const ChemicalList({Key? key}) : super(key: key);
  static const routeName = "/chem_list";
  @override
  State<ChemicalList> createState() => _ChemicalListState();
}

class _ChemicalListState extends State<ChemicalList> {
  void newChemical(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(NewChemical.routeName);
  }

  List<ChemModel> tempList = [];
  var _init = true;
  var _isLoaded = false;
  @override
  void didChangeDependencies() {
    if (_init) {
      setState(
        () {
          _isLoaded = true;
        },
      );
      Provider.of<ChemList>(context).getLoadedData().catchError(
        (onError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(onError.toString()),
          ));
        },
      ).then(
        (value) {
          setState(() {
            _init = false;
          });
        },
      );
    }
    setState(() {
      _isLoaded = true;
    });
    tempList = Provider.of<ChemList>(context, listen: true).elements;
    setState(() {
      _isLoaded = false;
    });
    super.didChangeDependencies();
  }

//for searching elements by name
  void searchText(text) {
    setState(
      () {
        tempList =
            Provider.of<ChemList>(context, listen: false).findByName(text);
      },
    );
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
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: SizedBox(
        height: deviceHeight,
        width: deviceWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: deviceHeight * 0.02),
              height: (deviceHeight - appBarHeight) * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //Search
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: deviceWidth * 0.1),
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
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
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
                        margin:
                            EdgeInsets.symmetric(horizontal: deviceWidth * 0.1),
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
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          onPressed: () => {},
                        )),
                  ),
                ],
              ),
            ),

            //Bottom bar for search and scan with Floating button for adding new elements
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                //Displaying all Chemicals
                SizedBox(
                  height: (deviceHeight - appBarHeight) * 0.8,
                  child: !_isLoaded
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                              vertical: deviceHeight * 0.02),
                          itemCount: tempList.length,
                          itemBuilder: (ctx, index) =>
                              ChangeNotifierProvider.value(
                            value: tempList[index],
                            child: SingleChemicalCard(tempList),
                          ),
                        ),
                ),
                FloatingActionButton(
                  splashColor: Colors.black54,
                  elevation: 10,
                  onPressed: () => newChemical(context),
                  child: const Icon(Icons.add),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
