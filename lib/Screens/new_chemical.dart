import '../Models/CustomColors.dart';

import '../Models/Chemicals/temp_chem_list.dart';

import 'package:flutter/material.dart';
import '../Models/Chemicals/temp_chem_model.dart';
import 'package:provider/provider.dart';
import '../Models/auth.dart';

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

  var _isLoading = false;
  ChemModel _tempChemical = ChemModel(
    id: '',
    name: '',
    formula: '',
    description: '',
    state: '',
    grade: '',
    hazard: [],
    assay: '',
    density: 0,
    meltingPoint: 0,
    boilingPoint: 0,
    molWeight: 0,
  );

  var _initValues = {
    'id': '',
    'name': '',
    'formula': '',
    'description': '',
    'state': '',
    'grade': '',
    'hazard': '',
    'assay': '',
    'density': 0,
    'meltingPoint': 0,
    'boilingPoint': 0,
    'molWeight': 0,
  };
  @override
  void dispose() {
    _descriptionFocus.dispose();
    _molWeightFocus.dispose();
    _formulaFocus.dispose();

    super.dispose();
  }

  void _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_tempChemical.id.isEmpty) {
      try {
        await Provider.of<ChemList>(context, listen: false)
            .addElement(_tempChemical);
        setState(() {
          _isLoading = false;
        });
      } catch (err) {
        (err) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Something went wrong"),
              content: Text(
                err.toString(),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop,
                    child: const Text("okay")),
              ],
            ),
          );
        };
      }
    } else {
      _tempChemical.hazard = hazardList;

      await Provider.of<ChemList>(context, listen: false)
          .updateElement(_tempChemical, _tempChemical.id);
    }
    setState(() {
      _isLoading = false;
      Navigator.of(context).pop();
    });
  }

  var _isInit = true;
  bool init = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final chemicalId =
            ModalRoute.of(context)!.settings.arguments as List<String>;

        _tempChemical = Provider.of<ChemList>(context, listen: false)
            .findById(chemicalId[0]);
        _initValues = {
          'state': _tempChemical.state,
          'grade': _tempChemical.grade,
          'hazard': _tempChemical.hazard,
          'assay': _tempChemical.assay,
          'density': _tempChemical.density,
          'meltingPoint': _tempChemical.meltingPoint,
          'boilingPoint': _tempChemical.boilingPoint,
          'name': _tempChemical.name,
          'id': _tempChemical.id,
          'formula': _tempChemical.formula,
          'description': _tempChemical.description,
          'molWeight': _tempChemical.molWeight.toString(),
        };
      }
      hazardList = _tempChemical.hazard;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

//drop down
  List<String> hazardList = []; //storing list of hazards submitted by the user
  List<Widget> dropDownWidgetList = [];
  int count = 0; //for keeping track of number of hazards added
  void addDropDown(dropDown) {
    if (count > 5) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('An error Occurred'),
                content: const Text('Can not add more than 6 hazard options'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Okay'),
                  ),
                ],
              ));
    } else {
      setState(() {
        dropDownWidgetList.add(dropDown);
        count = dropDownWidgetList.length;
      });
    }
  }

  String? value;

  void deleteDropDown() {
    setState(() {
      dropDownWidgetList.removeLast();
      count = dropDownWidgetList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    final hazardsList = [
      'corrosive',
      'environmental',
      'flammable',
      'irritant',
      'reactive',
      'toxic',
    ];
    DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
          value: item,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              item,
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
            ),
          ),
        );
    final dropDown = SizedBox(
      child: DropdownButtonFormField(
        value: value,
        elevation: 5,
        items: hazardsList.map(buildMenuItem).toList(),
        onSaved: (newValue) {
          if (newValue != null) {
            hazardList.add(newValue.toString());
          }
        },
        onChanged: (value) => setState(() => this.value = value.toString()),
      ),
    );

//check for editing existing element if hazardList is empty or not
    if (hazardList.isNotEmpty && init == false) {
      for (var element in hazardList) {
        dropDownWidgetList.add(
          SizedBox(
            width: deviceSize.width,
            child: DropdownButtonFormField(
              value: element[0] + element.substring(1).toLowerCase(),
              elevation: 5,
              items: hazardsList.map(buildMenuItem).toList(),
              onSaved: (newValue) {
                if (newValue != null) {
                  hazardList.add(newValue.toString().toLowerCase());
                }
              },
              onChanged: (value) =>
                  setState(() => this.value = value.toString()),
            ),
          ),
        );
      }
      hazardList = [];
      init = true;
    }
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
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<Auth>(context, listen: false).logout();
          },
          icon: const Icon(Icons.logout_outlined),
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _form,
              child: Scrollbar(
                thumbVisibility: true,
                trackVisibility: true,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: deviceHeight * 0.03,
                        horizontal: deviceWidth * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          height: 30,
                        ),
                        //name
                        TextFormField(
                          autofocus: true,
                          initialValue: _initValues['name'].toString(),
                          onSaved: (value) => {
                            if (value != null && value.isNotEmpty)
                              {
                                _tempChemical.name = value,
                                _tempChemical.id = _initValues['id'].toString(),
                              }
                          },
                          validator: (value) => value!.isEmpty
                              ? "Please enter the name of chemical"
                              : null,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            labelText: "Element Name",
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //url
                        TextFormField(
                          initialValue: _initValues['description'].toString(),
                          onSaved: (value) => {
                            if (value != null && value.isNotEmpty)
                              {
                                _tempChemical.description = value,
                                _tempChemical.id = _initValues['id'].toString(),
                              }
                          },
                          validator: (value) => value!.isEmpty
                              ? "Please enter the url of chemical description"
                              : null,
                          decoration: const InputDecoration(
                            labelText: "Url",
                          ),
                          textAlign: TextAlign.center,
                          textInputAction: TextInputAction.next,
                          focusNode: _descriptionFocus,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //formula
                        TextFormField(
                          initialValue: _initValues['formula'].toString(),
                          onSaved: (value) => {
                            if (value != null && value.isNotEmpty)
                              {
                                _tempChemical.formula = value.toUpperCase(),
                                _tempChemical.id = _initValues['id'].toString(),
                              }
                          },
                          textAlign: TextAlign.center,
                          validator: (value) => value!.isEmpty
                              ? "Please enter the formula of chemical"
                              : null,
                          decoration: const InputDecoration(
                            labelText: "Formula",
                          ),
                          textInputAction: TextInputAction.next,
                          focusNode: _formulaFocus,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //molWeight
                        TextFormField(
                          initialValue: _initValues['molWeight'] != 0
                              ? _initValues['molWeight'].toString()
                              : '',
                          onSaved: (value) => {
                            if (value != null && value.isNotEmpty)
                              {
                                _tempChemical.molWeight = double.parse(value),
                                _tempChemical.id = _initValues['id'].toString(),
                              }
                          },
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
                          textInputAction: TextInputAction.next,
                          focusNode: _molWeightFocus,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //state
                        TextFormField(
                          initialValue: _initValues['state'].toString(),
                          onSaved: (value) => {
                            if (value != null && value.isNotEmpty)
                              {
                                _tempChemical.state = value,
                                _tempChemical.id = _initValues['id'].toString(),
                              }
                          },
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter state";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Element State",
                          ),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //grade
                        TextFormField(
                          initialValue: _initValues['grade'].toString(),
                          onSaved: (value) => {
                            if (value != null && value.isNotEmpty)
                              {
                                _tempChemical.grade = value,
                                _tempChemical.id = _initValues['id'].toString(),
                              }
                          },
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter grade";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Element Grade",
                          ),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //hazard

                        FittedBox(
                          child: SizedBox(
                            width: deviceWidth,
                            height: deviceHeight * 0.18,
                            child: Scrollbar(
                              trackVisibility: true,
                              child: GridView.count(
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                crossAxisCount: 3,
                                childAspectRatio: deviceHeight * 0.002,
                                children: [
                                  ...dropDownWidgetList,
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        alignment: Alignment.center,
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.green.shade400)),
                                    onPressed: () => addDropDown(dropDown),
                                    child: const Text(
                                      "Click to add hazard option",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  dropDownWidgetList.isNotEmpty
                                      ? ElevatedButton(
                                          style: ButtonStyle(
                                              alignment: Alignment.center,
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Palette
                                                          .darkRed.shade300)),
                                          onPressed: deleteDropDown,
                                          child: const Text(
                                            "Click to delete last hazard option",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        //assay
                        TextFormField(
                          initialValue: _initValues['assay'].toString(),
                          onSaved: (value) => {
                            if (value != null && value.isNotEmpty)
                              {
                                _tempChemical.assay = value,
                                _tempChemical.id = _initValues['id'].toString(),
                              }
                          },
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            labelText: "Assay (if applicable)",
                          ),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //density
                        TextFormField(
                          initialValue: _initValues['density'] != 0
                              ? _initValues['density'].toString()
                              : '',
                          onSaved: (value) => {
                            if (value != null && value.isNotEmpty)
                              {
                                _tempChemical.density = double.parse(value),
                                _tempChemical.id = _initValues['id'].toString(),
                              }
                          },
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter density";
                            } else if (double.tryParse(value) == null) {
                              return "Enter weight in number format";
                            } else if (double.parse(value) <= 0) {
                              return "Weight has to be greater than 0";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Element Density",
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //boilingPoint
                        TextFormField(
                            initialValue: _initValues['boilingPoint'] != 0
                                ? _initValues['boilingPoint'].toString()
                                : '',
                            onSaved: (value) => {
                                  if (value != null && value.isNotEmpty)
                                    {
                                      _tempChemical.boilingPoint =
                                          double.parse(value),
                                      _tempChemical.id =
                                          _initValues['id'].toString(),
                                    }
                                },
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
                              labelText: "Boiling Point",
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next),
                        const SizedBox(
                          height: 20,
                        ),

                        //meltingPoint
                        TextFormField(
                          initialValue: _initValues['meltingPoint'] != 0
                              ? _initValues['boilingPoint'].toString()
                              : '',
                          onSaved: (value) => {
                            if (value != null && value.isNotEmpty)
                              {
                                _tempChemical.meltingPoint =
                                    double.parse(value),
                                _tempChemical.id = _initValues['id'].toString(),
                              }
                          },
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
                            labelText: "Melting Point",
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
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
            ),
    );
  }
}
