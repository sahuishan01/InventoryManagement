import 'package:flutter/material.dart';

class Form1 extends StatelessWidget {
  final double deviceHeight, deviceWidth;
  // final GlobalKey<FormState> _formKey;
  const Form1(this.deviceHeight, this.deviceWidth, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      // key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Email entry
          Container(
            // Adding shadow to the box Email

            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 6,
                    offset: const Offset(0, 7),
                  ),
                ]),

            //Padding Inside box
            padding: const EdgeInsets.all(5),
            width: deviceWidth * 0.5,
            //Email TextFormField
            child: TextFormField(
              style: const TextStyle(fontSize: 20),
              //Removing underline from the input field
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                hintText: 'Enter Email',
              ),
              validator: (String? value) {
                if (value == null ||
                    !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+") //Regex for email verification
                        .hasMatch(value)) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),

          //Empty box for inserting space between form input fields
          SizedBox(height: deviceHeight * 0.03),

          //Password Field
          Container(
            //Password box shadow
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 6,
                    offset: const Offset(0, 7),
                  ),
                ]),
            width: deviceWidth * 0.5,
            padding: const EdgeInsets.all(5),

            // password box
            child: TextFormField(
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                hintText: 'Enter Password',
              ),
              validator: (String? value) {
                if (value == null ||
                    !RegExp(r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$") //Regex for password verification with Minimum eight characters, at least one letter, one number and one special character:
                        .hasMatch(value)) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),

          //Empty box for space
          SizedBox(height: deviceHeight * 0.03),

          //Sign In button
          SizedBox(
            width: deviceWidth * 0.3,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[800],
                foregroundColor: Colors.white,
                shadowColor: Colors.red,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Sending Message"),
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
