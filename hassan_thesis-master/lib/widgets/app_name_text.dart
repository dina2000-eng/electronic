import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../consts/constants.dart';
import '../services/utils.dart';
import 'texts/title_text.dart';

class AppNameTextWidget extends StatelessWidget {
  const AppNameTextWidget({super.key, this.fontSize = 30.0});
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Utils(context).getTheme;
    return Shimmer.fromColors(
      period: const Duration(seconds: 8),
      baseColor: isDarkTheme
          ? const Color.fromARGB(255, 185, 186, 250)
          : const Color.fromARGB(255, 64, 67, 255),
      highlightColor: Colors.red.shade300,
      child: TitlesTextWidget(
        label: Constants.appName,
        fontSize: fontSize ?? 30,
      ),
    );
  }
}
