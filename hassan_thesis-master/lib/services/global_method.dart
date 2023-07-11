import 'package:flutter/material.dart';

import '../widgets/texts/subtitle_text.dart';
import 'assets_manager.dart';

class GlobalMethods {
  static Future<void> signOutDialog(
      {required BuildContext context, required Function fct}) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Sign out'),
            onPressed: () {
              fct();
            },
          ),
        ],
      ),
    );
  }

  static Future<void> warningOrErrorDialog({
    required String subtitle,
    bool isError = false,
    IconData? iconData,
    required Function fct,
    Color? color,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  isError ? AssetsManager.error : AssetsManager.warning,
                  height: 60,
                  width: 60,
                ),
                const SizedBox(
                  height: 15,
                ),
                SubtitlesTextWidget(
                  label: subtitle,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isError)
                      TextButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        child: SubtitlesTextWidget(
                          color: Colors.cyan,
                          label: 'Cancel'.toUpperCase(),
                          fontSize: 18,
                        ),
                      ),
                    TextButton(
                      onPressed: () {
                        fct();
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      child: const SubtitlesTextWidget(
                        color: Colors.red,
                        label: 'OK',
                        fontSize: 18,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
