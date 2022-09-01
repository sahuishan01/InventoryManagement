import 'package:flutter/material.dart';

import '../../Screens/single_chemical.dart';

class SingleChemicalCard extends StatelessWidget {
  final int index;
  final List tempList;
  const SingleChemicalCard(this.tempList, this.index, {Key? key})
      : super(key: key);

  void selectedElement(BuildContext ctx, id) {
    Navigator.pushNamed(ctx, SingleChemical.routeName,
        arguments: [id as String]);
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

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
                  tempList[index].name,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: deviceWidth * 0.4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tempList[index].formula,
                      ),
                      Text(tempList[index].molWeight.toString()),
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
              onPressed: () => selectedElement(context, tempList[index].id),
            ),
          ),
        ],
      ),
    );
  }
}
