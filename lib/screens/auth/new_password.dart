import 'package:electronics_market/consts/app_color.dart';
import 'package:electronics_market/screens/auth/forgot_password.dart';
import 'package:electronics_market/screens/auth/register.dart';
import 'package:electronics_market/screens/auth/reset_password.dart';
import 'package:electronics_market/widgets/helpers.dart';
import 'package:electronics_market/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package for making HTTP requests



class newpassword extends StatefulWidget {
  static const routeName = '/newpassword';


  @override
  _newpassword createState() => _newpassword();
}

class _newpassword extends State<newpassword> {
  late TextEditingController _passwordTextEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordTextEditingController= TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordTextEditingController.dispose();
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
                        builder: (context) => ResetPasswordScreen(email: AutofillHints.email),
                      ),
                    );
                    print("Icon Button clicked");
                  },
                ),
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 280, 35),
                  child: const Text(
                    'Create new',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  )),
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 150, 20),
                  child: const Text(
                    'And now, you can create new password and confirm it below',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  )),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'new password',
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(12),
                    ),
                    filled: true,
                  ),
                  // prefixIcon: Icons.lock,
                  obscureText: true,
                  controller: _passwordTextEditingController,
                  textInputAction: TextInputAction.next,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Confirm password',
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(12),
                    ),
                    filled: true,
                  ),
                  // prefixIcon: Icons.lock,
                  obscureText: true,
                  controller: _passwordTextEditingController,
                  textInputAction: TextInputAction.next,
                ),
              ),
              Padding(padding: const EdgeInsets.all(20.0)),
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future performForgetPassword() async {
    if (checkData()) {
      await ForgotPasswordScreen();
    }
  }

  bool checkData() {
    if (_passwordTextEditingController.text.isNotEmpty) {
      return true;
    }
    Helpers.showSnackBar(
        context: context, message: 'Enter email address', error: true);
    return false;
  }

  Future<void> initiateForgetPassword(String email) async {
    final url = Uri.parse('https://hasan.cloud/api/password/forgot');

    final response = await http.post(
      url,
      body: {'email': email},
    );

    if (response.statusCode == 200) {
      print('Forget password request sent successfully!');
    } else {
      print('Failed to send forget password request.');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }
  }
}
