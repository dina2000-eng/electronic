import 'package:flutter/material.dart';

import '../consts/my_icons.dart';

class GoBackWidget extends StatelessWidget {
  const GoBackWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        AppIcons.chevron_left,
      ),
      onPressed: () {
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      },
    );
  }
}
