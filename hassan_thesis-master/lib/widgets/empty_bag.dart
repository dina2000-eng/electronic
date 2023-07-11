import 'package:electronics_market/widgets/go_back_widget.dart';
import 'package:flutter/material.dart';
import '../services/utils.dart';
import 'texts/subtitle_text.dart';
import 'texts/title_text.dart';

class EmptyBagWidget extends StatelessWidget {
  const EmptyBagWidget({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  }) : super(key: key);
  final String imagePath;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Navigator.canPop(context)
            ? const Align(
                alignment: Alignment.topLeft,
                child: GoBackWidget(),
              )
            : const SizedBox.shrink(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // if (Navigator.canPop(context))
                  //   const Align(
                  //     alignment: Alignment.topLeft,
                  //     child: GoBackWidget(),
                  //   ),

                  Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: size.height * 0.35,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Whoops!',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 40,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TitlesTextWidget(label: title, fontSize: 20),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SubtitlesTextWidget(
                      label: subtitle,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // CustomElevatedButton(
                  //   buttonText: buttonText,
                  //   horizontalPadding: 50,
                  //   verticalPadding: 20,
                  //   elevation: 1,
                  //   fct: () {},
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
