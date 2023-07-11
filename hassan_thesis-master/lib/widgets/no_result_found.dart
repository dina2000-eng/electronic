import 'package:flutter/material.dart';

import '../services/assets_manager.dart';
import 'texts/title_text.dart';

class NoResultFound extends StatelessWidget {
  const NoResultFound({
    Key? key,
    required this.message,
  }) : super(key: key);
  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          Image.asset(
            AssetsManager.emptySearch,
            height: 150,
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TitlesTextWidget(
              label: message,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
