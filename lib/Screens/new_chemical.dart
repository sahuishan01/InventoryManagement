import 'package:flutter_application_1/Models/Chemicals/temp_chem_list.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import '../Models/Chemicals/temp_chem_model.dart';

class NewChemical extends StatefulWidget {
  static const routeName = "/new-element";
  const NewChemical({Key? key}) : super(key: key);
  @override
  State<NewChemical> createState() => _NewChemicalState();
}

class _NewChemicalState extends State<NewChemical> {
  final _descriptionFocus = FocusNode();
  final _molWeightFocus = FocusNode();
  final _formulaFocus = FocusNode();
  final _form = GlobalKey<FormState>();
  var uuid = const Uuid();

  String _name = '';
  String _formula = '';
  String _description = '';
  double _molWeight = 0;
  @override
  void dispose() {
    _descriptionFocus.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    String id = uuid.v1();

    _form.currentState!.save();
    final newChemical = ChemModel(
        id: id,
        name: _name,
        formula: _formula,
        molWeight: _molWeight,
        description: _description);
    chemicalList.add(newChemical);
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    AppBar appBar = AppBar(
      title: Text(
        'New Element',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actions: <Widget>[
        IconButton(
          onPressed: _saveForm,
          icon: const Icon(Icons.save_alt_outlined),
        )
      ],
    );
    // double appBarHeight = appBar.preferredSize.height;

    return Scaffold(
      appBar: appBar,
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: deviceHeight * 0.07, horizontal: deviceWidth * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Hello this is new chemical addition form'),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onSaved: (value) =>
                      value!.isNotEmpty ? _name = value : _name = _name,
                  validator: (value) => value!.isEmpty
                      ? "Please enter the name of chemical"
                      : null,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    labelText: "Chemical Name",
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      Focus.of(context).requestFocus(_descriptionFocus),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onSaved: (value) => value!.isNotEmpty
                      ? _description = value
                      : _description = _description,
                  textAlign: TextAlign.center,
                  validator: (value) => value!.isEmpty
                      ? "Please enter the description of chemical"
                      : null,
                  decoration: const InputDecoration(
                    labelText: "Description",
                  ),
                  textInputAction: TextInputAction.next,
                  focusNode: _descriptionFocus,
                  onFieldSubmitted: (_) =>
                      Focus.of(context).requestFocus(_formulaFocus),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onSaved: (value) => value!.isNotEmpty
                      ? _formula = value
                      : _formula = _formula,
                  textAlign: TextAlign.center,
                  validator: (value) => value!.isEmpty
                      ? "Please enter the formula of chemical"
                      : null,
                  decoration: const InputDecoration(
                    labelText: "Formula",
                  ),
                  textInputAction: TextInputAction.next,
                  focusNode: _formulaFocus,
                  onFieldSubmitted: (_) =>
                      Focus.of(context).requestFocus(_molWeightFocus),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onSaved: (value) => value!.isNotEmpty
                      ? _molWeight = double.parse(value)
                      : _molWeight = _molWeight,
                  textAlign: TextAlign.center,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter weight";
                    } else if (double.tryParse(value) == null) {
                      return "Enter weight in number format";
                    } else if (double.parse(value) <= 0) {
                      return "Weight has to be greater than 0";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Molecular Weight",
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  focusNode: _molWeightFocus,
                  onFieldSubmitted: (_) => _saveForm(),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
