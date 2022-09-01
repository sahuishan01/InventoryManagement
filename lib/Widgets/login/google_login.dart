// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

class googleLogin extends StatelessWidget {
  const googleLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade500,
                blurRadius: 2,
                offset: const Offset(0, 4))
          ]),
      child: IconButton(
        onPressed: () {
          null;
        },
        icon: const Icon(FontAwesome5.google),
        iconSize: 32,
      ),
    );
  }
}
