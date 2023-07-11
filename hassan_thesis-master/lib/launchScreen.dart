import 'package:electronics_market/consts/app_color.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class launchScreen extends StatefulWidget {
  static const routeName = '/launchScreen';
  const launchScreen({super.key});

  @override
  State<launchScreen> createState() => _launchScreenState();
}

class _launchScreenState extends State<launchScreen> {
  bool isLoggedIn = false;
   @override
  void initState() {
    // TODO: implement initState
     super.initState();
     Future.delayed(const Duration(seconds: 5), () {
       Navigator.pushReplacementNamed(context, '/on_boarding_screen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: AppColor.GRADIENT_START_COLOR,
    body: Image.asset(
        'assets/images/launch-bg.png',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
