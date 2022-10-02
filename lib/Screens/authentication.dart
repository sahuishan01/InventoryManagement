import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../Models/auth.dart';
import '../Widgets/login/signin_text.dart';
import '../Models/http_exception.dart';

class Authentication extends StatefulWidget {
  static const routeName = '/auth';
  const Authentication({Key? key}) : super(key: key);

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
    'name': '',
    'class': ''
  };

  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _classController = TextEditingController();
  final _emailController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLogin = true;

  void _clearAllFields() {
    _passwordController.clear();
    _nameController.clear();
    _classController.clear();
    _emailController.clear();
    _confirmPasswordController.clear();
  }

  void _showError(String msg) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('An error Occurred'),
              content: Text(msg),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Okay'),
                ),
              ],
            ));
  }

  Future<void> _signupFunction() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        _clearAllFields();
        await Provider.of<Auth>(context, listen: false).signup(
            _authData['email'].toString(),
            _authData['password'].toString(),
            _authData['name'].toString(),
            _authData['class'].toString());
      } on HTTPExtension catch (err) {
        var errorMessage = 'SignUp Failed';
        if (err.toString().contains('EMAIL_EXISTS')) {
          errorMessage = 'Email already exists';
        } else if (err.toString().contains('INVALID_EMAIL')) {
          errorMessage = "Invalid Email";
        } else if (err.toString().contains('WEAK_PASSWORD')) {
          errorMessage = 'Password too weak';
        }
        _showError(errorMessage);
      } catch (err) {
        const errorMessage = 'Something went wrong, please try again';
        _showError(errorMessage);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signinFunction() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        _clearAllFields();
        await Provider.of<Auth>(context, listen: false).signin(
            _authData['email'] as String, _authData['password'] as String);
      } on HTTPExtension catch (err) {
        var errorMessage = 'Something went wrong';
        if (err.toString().contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'Can not find a user with this email.';
        } else if (err.toString().contains('INVALID_PASSWORD')) {
          errorMessage = "Invalid Password ";
        }
        print(err);
        _showError(errorMessage);
      } catch (err) {
        const errorMessage = 'Network error!';
        _showError(errorMessage);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _contactUs() async {
    await launchUrlString("mailto:ishan2001.s@gmail.com");
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: deviceSize.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/authentication_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _isLogin
                ?
//login screen
                SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SignInText(
                            deviceSize.height, deviceSize.width, 'SIGN IN'),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
// Email entry
                              Container(
                                // Adding shadow to the box Email

                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.transparent),
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
                                width: deviceSize.width * 0.5,
                                //Email TextFormField
                                child: TextFormField(
                                  controller: _emailController,
                                  style: const TextStyle(fontSize: 20),
                                  //Removing underline from the input field
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: 15,
                                        bottom: 11,
                                        top: 11,
                                        right: 15),
                                    hintText: ' Email',
                                  ),
                                  validator: (String? value) {
                                    if (value == null ||
                                        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+") //Regex for email verification
                                            .hasMatch(value)) {
                                      return 'Please enter valid email';
                                    }
                                    return null;
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  textInputAction: TextInputAction.next,
                                  onSaved: (value) {
                                    _authData['email'] =
                                        value.toString().trim();
                                  },
                                ),
                              ),

                              //Empty box for inserting space between form input fields
                              SizedBox(height: deviceSize.height * 0.03),

//Password Field
                              Container(
                                //Password box shadow
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 6,
                                        offset: const Offset(0, 7),
                                      ),
                                    ]),
                                width: deviceSize.width * 0.5,
                                padding: const EdgeInsets.all(5),

                                // password box
                                child: TextFormField(
                                  controller: _passwordController,
                                  style: const TextStyle(fontSize: 20),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: 15,
                                        bottom: 11,
                                        top: 11,
                                        right: 15),
                                    hintText: 'Password',
                                  ),
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  validator: (String? value) {
                                    if (value == null) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _authData['password'] = value as String;
                                  },
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (value) {
                                    _formKey.currentState!.save();
                                    _signinFunction();
                                  },
                                ),
                              ),

                              //Empty box for space
                              SizedBox(height: deviceSize.height * 0.03),

                              //Sign In button
                              SizedBox(
                                width: deviceSize.width * 0.3,
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
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Text(
                                      'Sign In',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  onPressed: () {
                                    _formKey.currentState!.save();
                                    _signinFunction();
                                  },
                                ),
                              ),

                              Divider(
                                color: Colors.grey.shade400,
                                thickness: 3,
                                indent: deviceSize.width * 0.2,
                                endIndent: deviceSize.width * 0.2,
                                height: deviceSize.height * 0.07,
                              ),
                              SizedBox(
                                child: TextButton(
                                  child: const Text(
                                    'Need to sign up? Click here',
                                    style: TextStyle(
                                        fontSize: 16,
                                        decoration: TextDecoration.underline),
                                  ),
                                  onPressed: () => {
                                    _clearAllFields(),
                                    setState(() {
                                      _isLogin = false;
                                    })
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: _contactUs,
                          child: const Text('Need help?'),
                        )
                      ],
                    ),
                  )
                :
//signup screen
                SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SignInText(
                            deviceSize.height, deviceSize.width, 'SIGN UP'),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
//Name entry
                              Container(
                                // Adding shadow to the box Name

                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 7),
                                    ),
                                  ],
                                ),
                                //Padding Inside box
                                padding: const EdgeInsets.all(5),
                                width: deviceSize.width * 0.5,

                                //name TextFormField
                                child: TextFormField(
                                  controller: _nameController,
                                  style: const TextStyle(fontSize: 20),
                                  //Removing underline from the input field
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: 15,
                                        bottom: 11,
                                        top: 11,
                                        right: 15),
                                    hintText: 'Name',
                                  ),
                                  autofocus: true,
                                  textInputAction: TextInputAction.next,
                                  validator: (String? value) {
                                    if (value != null && value.length <= 2) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          dismissDirection:
                                              DismissDirection.endToStart,
                                          content: Text('Enter valid name'),
                                        ),
                                      );

                                      return 'Name!!!';
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    if (newValue != null &&
                                        newValue.isNotEmpty) {
                                      _authData['name'] = newValue.toString();
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: deviceSize.height * 0.02),
//Class entry
                              Container(
                                // Adding shadow to the box Class

                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 7),
                                      ),
                                    ]),

                                //Padding Inside box
                                padding: const EdgeInsets.all(5),
                                width: deviceSize.width * 0.5,
                                //Class TextFormField
                                child: TextFormField(
                                    controller: _classController,
                                    style: const TextStyle(fontSize: 20),
                                    //Removing underline from the input field
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          left: 15,
                                          bottom: 11,
                                          top: 11,
                                          right: 15),
                                      hintText: 'Class',
                                    ),
                                    textInputAction: TextInputAction.next,
                                    validator: (String? value) {
                                      if (value != null && value.length <= 3) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            dismissDirection:
                                                DismissDirection.endToStart,
                                            content: Text(
                                                'Please mention your full class'),
                                          ),
                                        );
                                        return 'Class!!!';
                                      }
                                      return null;
                                    },
                                    onSaved: ((value) {
                                      if (value != null && value.isNotEmpty) {
                                        _authData['class'] = value.toString();
                                      }
                                    })),
                              ),

                              //Empty box for inserting space between form input fields
                              SizedBox(height: deviceSize.height * 0.02),
// Email entry
                              Container(
                                // Adding shadow to the box Email

                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 7),
                                      ),
                                    ]),

                                //Padding Inside box
                                padding: const EdgeInsets.all(5),
                                width: deviceSize.width * 0.5,
                                //Email TextFormField
                                child: TextFormField(
                                  controller: _emailController,
                                  onSaved: (value) => {
                                    if (value != null && value.isNotEmpty)
                                      {
                                        _authData['email'] = value,
                                      }
                                  },
                                  textInputAction: TextInputAction.next,
                                  style: const TextStyle(fontSize: 20),
                                  //Removing underline from the input field
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: 15,
                                        bottom: 11,
                                        top: 11,
                                        right: 15),
                                    hintText: 'Email',
                                  ),
                                  validator: (String? value) {
                                    if (value == null ||
                                        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+") //Regex for email verification
                                            .hasMatch(value)) {
                                      return 'Please enter valid email';
                                    }
                                    return null;
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                ),
                              ),

                              //Empty box for inserting space between form input fields
                              SizedBox(height: deviceSize.height * 0.02),

//Password Field
                              Container(
                                //Password box shadow
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 7),
                                      ),
                                    ]),
                                width: deviceSize.width * 0.5,
                                padding: const EdgeInsets.all(5),

                                // password box
                                child: TextFormField(
                                  controller: _passwordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.next,
                                  style: const TextStyle(fontSize: 20),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: 15,
                                        bottom: 11,
                                        top: 11,
                                        right: 15),
                                    hintText: 'Password',
                                  ),
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  validator: (String? value) {
                                    if (value == null ||
                                        !RegExp(r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$") //Regex for password verification with Minimum eight characters, at least one letter, one number and one special character:
                                            .hasMatch(value)) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          dismissDirection:
                                              DismissDirection.endToStart,
                                          content: Text(
                                              'Password should contain one letter, One number, One SpecialCharacter and 8 characters are required'),
                                        ),
                                      );
                                      return 'Invalid password';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              //Empty box for space
                              SizedBox(height: deviceSize.height * 0.03),
//Confirm password
                              Container(
                                // confirm Password box shadow
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 7),
                                      ),
                                    ]),
                                width: deviceSize.width * 0.5,
                                padding: const EdgeInsets.all(5),

                                // Confirm password box
                                child: TextFormField(
                                  controller: _confirmPasswordController,
                                  style: const TextStyle(fontSize: 20),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: 15,
                                        bottom: 11,
                                        top: 11,
                                        right: 15),
                                    hintText: 'Confirm Password',
                                  ),
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  textInputAction: TextInputAction.done,
                                  onSaved: (newValue) => {
                                    if (newValue != null)
                                      {_authData['password'] = newValue}
                                  },
                                  onFieldSubmitted: (value) {
                                    _formKey.currentState!.save();
                                    _signupFunction();
                                  },
                                  validator: (String? value) {
                                    if (value != _passwordController.text) {
                                      return 'Password Do not match';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              //Empty box for space
                              SizedBox(height: deviceSize.height * 0.03),

                              //Sign Up button
                              SizedBox(
                                width: deviceSize.width * 0.3,
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
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  onPressed: () {
                                    _formKey.currentState!.save();
                                    _signupFunction();
                                  },
                                ),
                              ),

                              Divider(
                                color: Colors.grey.shade400,
                                thickness: 3,
                                indent: deviceSize.width * 0.2,
                                endIndent: deviceSize.width * 0.2,
                                height: deviceSize.height * 0.07,
                              ),
                              SizedBox(
                                child: TextButton(
                                  child: const Text(
                                    'Need to Login? Click here',
                                    style: TextStyle(
                                        fontSize: 16,
                                        decoration: TextDecoration.underline),
                                  ),
                                  onPressed: () => {
                                    _clearAllFields(),
                                    setState(() {
                                      _isLogin = true;
                                    })
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: _contactUs,
                          child: const Text('Need help?'),
                        )
                      ],
                    ),
                  ),
      ),
    );
  }
}
