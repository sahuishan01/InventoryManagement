// import 'package:flutter/material.dart';
// import '../Models/Chemicals/temp_chem_model.dart';
// import 'package:uuid/uuid.dart';
// import '../Models/Chemicals/temp_chem_list.dart';

// class EditCreateElement extends StatelessWidget {
//   EditCreateElement({Key? key}) : super(key: key);
//   final _descriptionFocus = FocusNode();
//   final _molWeightFocus = FocusNode();
//   final _formulaFocus = FocusNode();
//   final _form = GlobalKey<FormState>();
//   var uuid = const Uuid();

//   ChemModel _tempChemical =
//       ChemModel(id: '', name: '', formula: '', description: '', molWeight: 0);

//   var _initValues = {
//     'name': '',
//     'id': '',
//     'formula': '',
//     'description': '',
//     'molWeight': 0,
//   };
//   @override
//   void dispose() {
//     _descriptionFocus.dispose();

//     super.dispose();
//   }

//   void _saveForm() {
//     final isValid = _form.currentState!.validate();
//     if (!isValid) {
//       return;
//     }

//     _form.currentState!.save();
//     if (_tempChemical.id.isEmpty) {
//       String id = uuid.v1();
//       _tempChemical.id = id;
//       ChemList.chemicalList.add(_tempChemical);
//     } else {
//       final updateIndex = ChemList.chemicalList
//           .indexWhere((element) => element.id == _tempChemical.id);
//       ChemList.chemicalList[updateIndex] = _tempChemical;
//     }

//     Navigator.pushReplacementNamed(context, '/');
//   }

//   var _isInit = true;
//   @override
//   void didChangeDependencies() {
//     if (_isInit) {
//       final chemicalId =
//           ModalRoute.of(context)!.settings.arguments as List<String>;

//       _tempChemical =
//           ChemList.element.firstWhere((element) => element.id == chemicalId[0]);
//       _initValues = {
//         'name': _tempChemical.name,
//         'id': _tempChemical.id,
//         'formula': _tempChemical.formula,
//         'description': _tempChemical.description,
//         'molWeight': _tempChemical.molWeight.toString(),
//       };
//     }
//     _isInit = false;
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double deviceHeight = MediaQuery.of(context).size.height;
//     double deviceWidth = MediaQuery.of(context).size.width;
//     AppBar appBar = AppBar(
//       title: Text(
//         'New Element',
//         style: Theme.of(context).textTheme.titleLarge,
//       ),
//       actions: <Widget>[
//         IconButton(
//           onPressed: _saveForm,
//           icon: const Icon(Icons.save_alt_outlined),
//         )
//       ],
//     );
//     // double appBarHeight = appBar.preferredSize.height;

//     return Scaffold(
//       appBar: appBar,
//       body: Form(
//         key: _form,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(
//                 vertical: deviceHeight * 0.07, horizontal: deviceWidth * 0.05),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 const Text('Hello this is new chemical addition form'),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 TextFormField(
//                   initialValue: _initValues['name'].toString(),
//                   onSaved: (value) => {
//                     if (value != null && value.isNotEmpty)
//                       {
//                         _tempChemical.name = value,
//                         _tempChemical.id = _initValues['id'].toString(),
//                       }
//                   },
//                   validator: (value) => value!.isEmpty
//                       ? "Please enter the name of chemical"
//                       : null,
//                   textAlign: TextAlign.center,
//                   decoration: const InputDecoration(
//                     labelText: "Chemical Name",
//                   ),
//                   textInputAction: TextInputAction.next,
//                   onFieldSubmitted: (_) =>
//                       Focus.of(context).requestFocus(_descriptionFocus),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 TextFormField(
//                   initialValue: _initValues['description'].toString(),
//                   onSaved: (value) => {
//                     if (value != null && value.isNotEmpty)
//                       {
//                         _tempChemical.description = value,
//                         _tempChemical.id = _initValues['id'].toString(),
//                       }
//                   },
//                   validator: (value) => value!.isEmpty
//                       ? "Please enter the description of chemical"
//                       : null,
//                   decoration: const InputDecoration(
//                     labelText: "Description",
//                   ),
//                   textInputAction: TextInputAction.next,
//                   focusNode: _descriptionFocus,
//                   onFieldSubmitted: (_) =>
//                       Focus.of(context).requestFocus(_formulaFocus),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 TextFormField(
//                   initialValue: _initValues['formula'].toString(),
//                   onSaved: (value) => {
//                     if (value != null && value.isNotEmpty)
//                       {
//                         _tempChemical.formula = value,
//                         _tempChemical.id = _initValues['id'].toString(),
//                       }
//                   },
//                   textAlign: TextAlign.center,
//                   validator: (value) => value!.isEmpty
//                       ? "Please enter the formula of chemical"
//                       : null,
//                   decoration: const InputDecoration(
//                     labelText: "Formula",
//                   ),
//                   textInputAction: TextInputAction.next,
//                   focusNode: _formulaFocus,
//                   onFieldSubmitted: (_) =>
//                       Focus.of(context).requestFocus(_molWeightFocus),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 TextFormField(
//                   initialValue: _initValues['molWeight'].toString(),
//                   onSaved: (value) => {
//                     if (value != null && value.isNotEmpty)
//                       {
//                         _tempChemical.molWeight = double.parse(value),
//                         _tempChemical.id = _initValues['id'].toString(),
//                       }
//                   },
//                   textAlign: TextAlign.center,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Enter weight";
//                     } else if (double.tryParse(value) == null) {
//                       return "Enter weight in number format";
//                     } else if (double.parse(value) <= 0) {
//                       return "Weight has to be greater than 0";
//                     }
//                     return null;
//                   },
//                   decoration: const InputDecoration(
//                     labelText: "Molecular Weight",
//                   ),
//                   keyboardType: TextInputType.number,
//                   textInputAction: TextInputAction.done,
//                   focusNode: _molWeightFocus,
//                   onFieldSubmitted: (_) => _saveForm(),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
