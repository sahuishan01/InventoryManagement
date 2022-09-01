// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  final double deviceHeight;
  const ForgotPassword(this.deviceHeight, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(deviceHeight * 0.0001),
        child: Center(
          child: TextButton(
              child: const Text('Forgot Password?'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Forgot Password"),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
