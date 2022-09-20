// ignore_for_file: file_names
import 'package:flutter/material.dart';

class SignInText extends StatelessWidget {
  final double deviceHeight, deviceWidth;
  final String text1;
  const SignInText(this.deviceHeight, this.deviceWidth, this.text1, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: deviceHeight * 0.1, horizontal: deviceWidth * 0.1),
// customizing size and width
      width: deviceWidth,
      child: Padding(
        padding: EdgeInsets.only(
          top: deviceHeight * 0.05,
//if signup, decrease the gap between the form and sign up header text
          bottom: (text1 != "SIGN UP") ? deviceHeight * 0.05 : 0,
          left: 30,
        ),

        //sign in text

        child: Text(
          text1,
          style: TextStyle(
              shadows: [
                Shadow(
                    offset: const Offset(0, 5),
                    blurRadius: 5,
                    color: Colors.pink.shade100)
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
