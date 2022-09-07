import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/Chemicals/temp_chem_model.dart';
import 'package:provider/provider.dart';
import '../../Screens/single_chemical.dart';

class SingleChemicalCard extends StatelessWidget {
  const SingleChemicalCard({Key? key}) : super(key: key);

  void selectedElement(BuildContext ctx, id) {
    Navigator.pushNamed(ctx, SingleChemical.routeName,
        arguments: [id as String]);
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    final chemElement = Provider.of<ChemModel>(context, listen: false);

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(
          vertical: deviceHeight * 0.005, horizontal: deviceWidth * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: deviceHeight * 0.015, horizontal: deviceWidth * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chemElement.name,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: deviceWidth * 0.4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chemElement.formula,
                      ),
                      Text(chemElement.molWeight.toString()),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.03),
            child: TextButton(
              child: const Text("View Chemical"),
              onPressed: () => selectedElement(context, chemElement.id),
            ),
          ),
        ],
      ),
    );
  }
}
