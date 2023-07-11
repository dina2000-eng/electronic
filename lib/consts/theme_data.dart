import 'package:flutter/material.dart';

import 'app_color.dart';

class Styles {
  static ThemeData themeData({
    required bool isDarkTheme,
    required BuildContext context,
    required ColorScheme colorScheme,
  }) {
    final textBorderRadius = BorderRadius.circular(8);
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDarkTheme
          ? AppColor.darkScaffoldColor
          : AppColor.lightScaffoldColor,
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkTheme
            ? AppColor.darkScaffoldColor
            : AppColor.lightScaffoldColor,
      ),
      cardColor: isDarkTheme
          ? const Color.fromARGB(255, 13, 6, 37)
          : AppColor.lightCardColor,
      // primaryColor: isDarkTheme ? AppColor.darkPrimary : AppColor.lightPrimary,
      // textSelectionTheme: const TextSelectionThemeData(
      //   cursorColor: Colors.red,
      //   selectionColor: Colors.green,
      //   selectionHandleColor: Colors.blue,
      // ),
      // brightness: isDarkTheme ? Brightness.dark : Brightness.light,

      // textButtonTheme: TextButtonThemeData(
      //   style: ButtonStyle(
      //     foregroundColor: MaterialStateProperty.all(
      //       isDarkTheme
      //           ? AppColor.darkTextButtonColor
      //           : AppColor.lightTextButtonColor,
      //     ),
      //   ),
      // ),
      // elevatedButtonTheme: ElevatedButtonThemeData(
      //   style: ButtonStyle(
      //     backgroundColor: MaterialStateProperty.all(
      //       isDarkTheme ? AppColor.darkBackground : AppColor.lightBackground,
      //     ),
      //   ),
      // ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        contentPadding: const EdgeInsets.all(10),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: isDarkTheme ? Colors.white : Colors.black,
          ),
          borderRadius: textBorderRadius,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.error,
          ),
          borderRadius: textBorderRadius,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.error,
          ),
          borderRadius: textBorderRadius,
        ),
      ),
    );
  }
}
