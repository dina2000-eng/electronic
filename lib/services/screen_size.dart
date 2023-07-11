import 'package:flutter/material.dart';

class ScreenSize {
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getScreenAspectRatio(BuildContext context) {
    return MediaQuery.of(context).size.aspectRatio;
  }
}
