import 'package:electronics_market/services/assets_manager.dart';
import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({super.key, this.radius = 25});
  final double radius;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.transparent,
      child: Image.asset(
        AssetsManager.personne,
        fit: BoxFit.fill,
      ),
    );
  }
}
