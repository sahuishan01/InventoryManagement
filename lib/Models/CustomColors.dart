import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor darkRed = MaterialColor(
    0xffe55f48, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff87202f), //10%
      100: Color(0xff7a1d2a), //20%
      200: Color(0xff6c1a26), //30%
      300: Color(0xff5f1621), //40%
      400: Color(0xff51131c), //50%
      500: Color(0xff441018), //60%
      600: Color(0xff360d13), //70%
      700: Color(0xff280a0e), //80%
      800: Color(0xff1b0609), //90%
      900: Color(0xff0d0305), //100%
    },
  );
}
