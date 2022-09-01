// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../Widgets/login/additional_login.dart';
import '../Widgets/login/signin_text.dart';
import '../Widgets/login/password_forget.dart';
import '../Widgets/login/form.dart';

class Login extends StatelessWidget {
  final GlobalKey<FormState> _formKey;
  const Login(this._formKey, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: double.infinity, // setting width to match device width

          // column for arranging different sub-child in a serial order
          child: ListView(
            // Spacing all the elements evenly vertically

            children: [
              // Sign In text
              SignInText(deviceHeight, deviceWidth),

              // Sign In form
              Form1(deviceHeight, deviceWidth, _formKey),

              //Forgot password
              ForgotPassword(deviceHeight),

              //Additional login options
              additionalLogin(deviceHeight),
            ],
          ),
        ),
      ),
    );
  }
}
