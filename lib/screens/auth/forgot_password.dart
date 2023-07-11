import 'package:electronics_market/screens/auth/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/ForgotPasswordScreen';

  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController _emailController;

  late final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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

  Future<void> resetPassword(
      String token, String email, String password, String passwordConfirmation) async {
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

  Future<void> _resetPassword() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();

      final email = _emailController.text;
      final token = 'YOUR_RESET_TOKEN'; // Replace with your actual reset token
      final password = 'NEW_PASSWORD'; // Replace with the new password
      final passwordConfirmation = 'NEW_PASSWORD_CONFIRMATION'; // Replace with the new password confirmation

      await resetPassword(token, email, password, passwordConfirmation);

      Fluttertoast.showToast(
        msg: "Password reset successful!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Forgot Password',
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Image.asset(
              'assets/images/forgot_password.jpg',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            const Text(
              'Forgot password',
              style: TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Please enter the email address you\'d like your password reset information sent to',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _emailController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, ResetPasswordScreen.routeName,);
              },
              child: const Text('Request reset link'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  final token = '50349277f7423f7a0a2b2aae3f193576b97fd1fc0cb907976e3521bc5c47052a';
  final email = 'ayaa.ham.2000@gmail.com';
  final password = '123123';
  final passwordConfirmation = '123123';


  runApp(MaterialApp(
    home: ForgotPasswordScreen(),
  ));
}
