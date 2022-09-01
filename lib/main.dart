import 'package:flutter/material.dart';
import './Screens/new_chemical.dart';
import './Screens/chemical_list.dart';
import './Screens/single_chemical.dart';
// import 'login/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Inventory",
      theme: ThemeData(
        primarySwatch: Colors.pink,
        primaryColor: Colors.pink,
        textTheme: const TextTheme(
            headline1: TextStyle(color: Colors.black),
            headline2: TextStyle(color: Colors.black),
            bodyText1: TextStyle(color: Colors.black),
            bodyText2: TextStyle(color: Colors.black),
            headline6: TextStyle(color: Colors.pink)),
      ),
      initialRoute: "/",
      routes: {
        '/': (ctx) => const ChemicalList(),
        SingleChemical.routeName: (ctx) => const SingleChemical(),
        NewChemical.routeName: (ctx) => const NewChemical(),
      },
    );
  }
}
