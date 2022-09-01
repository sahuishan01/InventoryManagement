import 'package:flutter/material.dart';

class NewChemical extends StatefulWidget {
  static const routeName = "/new-element";
  const NewChemical({Key? key}) : super(key: key);

  @override
  State<NewChemical> createState() => _NewChemicalState();
}

class _NewChemicalState extends State<NewChemical> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Element',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Form(
          child: ListView(
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Chemical Name",
            ),
            textInputAction: TextInputAction.next,
          )
        ],
      )),
    );
  }
}
