import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/auth.dart';
import './Screens/authentication.dart';
import './Screens/new_chemical.dart';
import './Screens/chemical_list.dart';
import './Screens/single_chemical.dart';
import 'package:provider/provider.dart';
import 'Models/Chemicals/temp_chem_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, ChemList>(
          create: (ctx) => ChemList('', []),
          update: (ctx, auth, previousChemList) => ChemList(
            auth.token != null ? auth.token as String : '',
            previousChemList == null ? [] : previousChemList.elements,
          ),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
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
              headline6: TextStyle(color: Colors.pink),
            ),
          ),
          home: auth.isAuth
              ? const ChemicalList()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const Scaffold(
                              body: Center(child: CircularProgressIndicator()),
                            )
                          : const Authentication(),
                ),
          routes: {
            Authentication.routeName: (ctx) => const Authentication(),
            ChemicalList.routeName: (ctx) => const ChemicalList(),
            SingleChemical.routeName: (ctx) => SingleChemical(),
            NewChemical.routeName: (ctx) => const NewChemical(),
          },
        ),
      ),
    );
  }
}
