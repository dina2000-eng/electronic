import 'package:electronics_market/screens/on-boarding/on-boardingcontent.dart';
import 'package:electronics_market/screens/on-boarding/on_boarding_indicator.dart';
import 'package:flutter/material.dart';
import 'size-config.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeName = '/OnboardingScreen';
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();

  }

  int _currentPage = 0;
  List colors = const [
    Color(0xffFFFFFF),
    Color(0xffFFFFFF),
    Color(0xffFFFFFF),
  ];

  AnimatedContainer _buildDots({
    int? index,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(90),
        ),
        color: Color(0xFF18CAE6),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 15,
      curve: Curves.easeIn,
      width: _currentPage == index ? 15 : 15,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;

    return Scaffold(
      backgroundColor: colors[_currentPage],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Visibility(
            visible: _currentPage != 2,
            child: Positioned(
              child: TextButton(
                onPressed: () {
                  _controller.jumpToPage(2);
                },
                child: Text('skip',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: _currentPage == 2,
            child: Positioned(
              right: 10,
              top: 25,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/LoginPage');
                },
                child: Text('start',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _controller,
              onPageChanged: (value) => setState(() => _currentPage = value),
              itemCount: contents.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    children: [
                      Image.asset(
                        contents[i].image,
                        height: SizeConfig.blockV! * 50,
                      ),
                      SizedBox(
                        height: (height >= 840) ? 50 : 30,
                      ),
                      // const SizedBox(height: 5),
                      Text(
                        contents[i].desc,
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w300,
                          fontSize: (width <= 377) ? 10 : 21,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OnBoardingIndicator(selected: _currentPage == 0),
                          OnBoardingIndicator(selected: _currentPage == 1),
                          OnBoardingIndicator(selected: _currentPage == 2),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
    ]),
      ),
    );
  }
}
