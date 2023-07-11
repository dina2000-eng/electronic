import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.loaderSize = 40});
  final double loaderSize;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.dotsTriangle(
        color: Colors.blue,
        // leftDotColor: const Color(0xFF1A1A3F),
        // rightDotColor: const Color(0xFFEA3799),
        size: loaderSize,
      ),
    );
  }
}
