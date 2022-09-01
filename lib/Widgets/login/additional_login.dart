// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'google_login.dart';

class additionalLogin extends StatelessWidget {
  final double deviceHeight;
  const additionalLogin(this.deviceHeight, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: deviceHeight * 0.05,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [googleLogin()],
      ),
    );
  }
}
