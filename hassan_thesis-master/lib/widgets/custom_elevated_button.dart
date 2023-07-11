import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {super.key,
      required this.buttonText,
      required this.fct,
      this.verticalPadding = 0.0,
      this.horizontalPadding = 0.0,
      this.elevation = 0,
      this.borderRadius = 8.0,
      this.fontSize = 18,
      this.color,
      this.textColor,
      this.margin = 0.0});
  final String buttonText;
  final double elevation, borderRadius, fontSize;
  final Function fct;
  final Color? color;
  final Color? textColor;
  // final List<double> widthHeightpadding;
  final double verticalPadding, horizontalPadding;
  final double margin;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(margin),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius), // <-- Radius
          ),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
        ),
        onPressed: () async {
          fct();
        },
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
          ),
        ),
      ),
    );

    // Padding(
    //   padding: EdgeInsets.all(margin),
    //   child: ElevatedButton(
    //     onPressed: () {
    //       fct();
    //     },
    //     style: ElevatedButton.styleFrom(
    //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //       backgroundColor: color,
    //       elevation: elevation,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(borderRadius),
    //         // side: BorderSide(
    //         //   color: Theme.of(context).cardColor,
    //         // ),
    //       ),
    //       padding: EdgeInsets.symmetric(
    //           horizontal: widthHeightpadding[0],
    //           vertical: widthHeightpadding[1]),
    //       // textStyle: TextStyle(
    //       //   fontSize: fontSize,
    //       //   fontWeight: FontWeight.w400,
    //       // ),
    //     ),
    //     child: FittedBox(
    //       child: SubtitlesTextWidget(
    //         fontSize: fontSize,
    //         label: buttonText,
    //         color: textColor,
    //         fontWeight: FontWeight.w500,
    //       ),
    //     ),
    //   ),
    // );
  }
}
