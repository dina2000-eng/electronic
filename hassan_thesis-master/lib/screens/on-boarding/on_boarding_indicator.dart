import 'package:electronics_market/consts/app_color.dart';
import 'package:flutter/material.dart';

class OnBoardingIndicator extends StatelessWidget {
  final bool selected;

  OnBoardingIndicator({
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        color: selected ? AppColor.ON_BOARDING_COLOR : AppColor.GRADIENT_START_COLOR,
        shape: BoxShape.circle,
        border: !selected
            ? Border.all(
                width: 1,
                color: AppColor.GRADIENT_START_COLOR,
              )
            : null,
      ),
    );
  }
}
