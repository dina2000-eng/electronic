import 'package:electronics_market/consts/app_color.dart';
import 'package:electronics_market/screens/auth/forgot_password.dart';
import 'package:electronics_market/screens/auth/new_password.dart';
import 'package:electronics_market/widgets/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http; // Import the http package for making HTTP requests



class ResetPasswordScreen extends StatefulWidget {
  static const routeName = '/ResetPasswordScree';
  final String email;

  ResetPasswordScreen({required this.email});

  @override
  _ResetPasswordScreen createState() => _ResetPasswordScreen();
}

class _ResetPasswordScreen extends State<ResetPasswordScreen> {
  late FocusNode _firstCodeFocusNode;
  late FocusNode _secondCodeFocusNode;
  late FocusNode _thirdCodeFocusNode;
  late FocusNode _fourthCodeFocusNode;

  late TextEditingController _firstCodeTextEditingController;
  late TextEditingController _secondCodeTextEditingController;
  late TextEditingController _thirdCodeTextEditingController;
  late TextEditingController _fourthCodeTextEditingController;

  late TextEditingController _passwordTextEditingController;
  late TextEditingController _passwordConfirmationTextEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstCodeFocusNode = FocusNode();
    _secondCodeFocusNode = FocusNode();
    _thirdCodeFocusNode = FocusNode();
    _fourthCodeFocusNode = FocusNode();

    _passwordTextEditingController = TextEditingController();
    _passwordConfirmationTextEditingController = TextEditingController();

    _firstCodeTextEditingController = TextEditingController();
    _secondCodeTextEditingController = TextEditingController();
    _thirdCodeTextEditingController = TextEditingController();
    _fourthCodeTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _firstCodeFocusNode.dispose();
    _secondCodeFocusNode.dispose();
    _thirdCodeFocusNode.dispose();
    _fourthCodeFocusNode.dispose();

    _passwordTextEditingController.dispose();
    _passwordConfirmationTextEditingController.dispose();

    _firstCodeTextEditingController.dispose();
    _secondCodeTextEditingController.dispose();
    _thirdCodeTextEditingController.dispose();
    _fourthCodeTextEditingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(2.0),
        margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 30, 440, 30),
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen(),
                      ),
                    );
                    print("Icon Button clicked");
                  },
                ),
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 250, 35),
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  )),
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 150, 20),
                  child: const Text(
                    'Please type OTP code that we given',
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  )),
              SizedBox(
                height: 50,
                width: 270,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _firstCodeTextEditingController,
                        focusNode: _firstCodeFocusNode,
                        minLines: null,
                        maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        onChanged: (String text) {
                          if (text.length == 1) {
                            _secondCodeFocusNode.requestFocus();
                          }
                        },
                        decoration: InputDecoration(
                          counterText: '',
                          //filled: true,
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black12,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          //fillColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _secondCodeTextEditingController,
                        focusNode: _secondCodeFocusNode,
                        minLines: null,
                        maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        onChanged: (String text) {
                          if (text.length == 1) {
                            _thirdCodeFocusNode.requestFocus();
                          }
                        },
                        decoration: InputDecoration(
                          counterText: '',
                          //filled: true,
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black12,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          //fillColor: Colors.white
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _thirdCodeTextEditingController,
                        focusNode: _thirdCodeFocusNode,
                        minLines: null,
                        maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        onChanged: (String text) {
                          if (text.length == 1) {
                            _fourthCodeFocusNode.requestFocus();
                          }
                        },
                        decoration: InputDecoration(
                          counterText: '',
                          //filled: true,
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black12,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          //fillColor: Colors.white
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _fourthCodeTextEditingController,
                        focusNode: _fourthCodeFocusNode,
                        minLines: null,
                        maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          counterText: '',
                          //filled: true,
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black12,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          //fillColor: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(padding: const EdgeInsets.fromLTRB(270, 60, 0, 0)),
                  const Text(
                    "Resend on",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  TextButton(
                    child: const Text(
                      '00:35',
                      style: TextStyle(
                          fontSize: 12, color: AppColor.ON_BOARDING_COLOR),
                    ),
                    onPressed: () {
                      //Navigator.push(context, new MaterialPageRoute(builder: (context) => new HomePage()));
                    },
                  )
                ],
              ),
              SizedBox(
                height: 55,
                width: 300,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    primary: Colors.white,
                    backgroundColor: AppColor.ON_BOARDING_COLOR,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    textStyle: const TextStyle(fontSize: 15),
                  ),
                  onPressed: () {
                    if (checkData()) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => newpassword(),
                        ),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  bool checkData() {
    if (_passwordTextEditingController.text.isNotEmpty &&
        _passwordConfirmationTextEditingController.text.isNotEmpty &&
        checkCode()) {
      return checkPasswordConfirmation();
    }

    Helpers.showSnackBar(
      context: context,
      message: 'Check required data',
      error: true,
    );
    return false;
  }

  bool checkPasswordConfirmation() {
    if (_passwordTextEditingController.text ==
        _passwordConfirmationTextEditingController.text) {
      return true;
    }
    Helpers.showSnackBar(
        context: context, message: 'Password confirmation error', error: true);
    return false;
  }

  bool checkCode() {
    if (_firstCodeTextEditingController.text.isNotEmpty &&
        _secondCodeTextEditingController.text.isNotEmpty &&
        _thirdCodeTextEditingController.text.isNotEmpty &&
        _fourthCodeTextEditingController.text.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<void> resetPassword(String token, String email, String password, String passwordConfirmation) async {
    final url = Uri.parse('https://hasan.cloud/api/password/reset');

    final response = await http.post(
      url,
      body: {
        'token': token,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );

    if (response.statusCode == 200) {
      print('Password reset successful!');
    } else {
      print('Failed to reset password.');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }
  }

  void main() {
    final token = '50349277f7423f7a0a2b2aae3f193576b97fd1fc0cb907976e3521bc5c47052a';
    final email = 'ayaa.ham.2000@gmail.com';
    final password = '123123';
    final passwordConfirmation = '123123';

    resetPassword(token, email, password, passwordConfirmation);
  }

  String getCode() {
    return _firstCodeTextEditingController.text +
        _secondCodeTextEditingController.text +
        _thirdCodeTextEditingController.text +
        _fourthCodeTextEditingController.text;
  }
}
