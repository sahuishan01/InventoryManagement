// ignore_for_file: file_names

import 'package:flutter/material.dart';

class SignInText extends StatelessWidget {
  final double deviceHeight, deviceWidth;
  const SignInText(this.deviceHeight, this.deviceWidth, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
// customizing size and width

      width: deviceWidth,
      child: Padding(
        padding: EdgeInsets.only(
          top: deviceHeight * 0.15,
          bottom: deviceHeight * 0.15,
          left: 30,
        ),

        //sign in text

        child: Text(
          'SIGN IN',
          style: TextStyle(
              shadows: [
                Shadow(
                    offset: const Offset(0, 5),
                    blurRadius: 5,
                    color: Colors.grey.shade500)
              ],
              fontFamily: 'Oswald',
              fontWeight: FontWeight.w600,
              fontSize: 60,
              color: const Color(0xFFAD1457)),
        ),
      ),
    );
  }
}
