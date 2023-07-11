import 'package:flutter/material.dart';

import '../../../root_screen.dart';
import '../../../widgets/texts/subtitle_text.dart';
import '../../../widgets/texts/title_text.dart';

class SuccessfullScreen extends StatelessWidget {
  static const routeName = '/SuccessfullScreen';
  const SuccessfullScreen(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.imagePath})
      : super(key: key);
  final String title, subtitle, imagePath;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(60.h),
        //   child: const InnerAppBarWidget(
        //     title: "Payment successfull",
        //   ),
        // ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 150,
                  ),
                  Image.asset(
                    imagePath,
                    height: 120,
                    width: 120,
                  ),
                  TitlesTextWidget(
                    label: title,
                    fontSize: 24,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SubtitlesTextWidget(
                    label: subtitle,
                    fontSize: 14,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RootScreen.routeName);
                      // Navigator.canPop(context) ? Navigator.pop(context) : null;
                    },
                    child: const Text(
                      'OK',
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
