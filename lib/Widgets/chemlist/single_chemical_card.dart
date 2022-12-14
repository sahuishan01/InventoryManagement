import 'package:flutter/material.dart';
import '../../Models/Chemicals/temp_chem_model.dart';
import 'package:provider/provider.dart';
import '../../Screens/single_chemical.dart';

class SingleChemicalCard extends StatelessWidget {
  const SingleChemicalCard(this.chemElement, this.isAdmin, this.lab, {Key? key})
      : super(key: key);
  final List<ChemModel> chemElement;
  final bool isAdmin;
  final String lab;

//For viewing single element
  void selectedElement(BuildContext ctx, id) {
    Navigator.pushNamed(ctx, SingleChemical.routeName,
        arguments: {'id': id as String, 'isAdmin': isAdmin, 'lab': lab});
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    final chemElement = Provider.of<ChemModel>(context);

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(
          vertical: deviceHeight * 0.005, horizontal: deviceWidth * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: deviceHeight * 0.015,
                  horizontal: deviceWidth * 0.02),
              child: SizedBox(
                width: deviceWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chemElement.name,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      chemElement.formula,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Text('${chemElement.molWeight} mol'),
          ),
          Flexible(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.03),
              child: TextButton(
                child: const Text("View Chemical"),
                onPressed: () => selectedElement(context, chemElement.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
