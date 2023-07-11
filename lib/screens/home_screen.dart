import 'dart:developer';

import 'package:card_swiper/card_swiper.dart';
import 'package:electronics_market/loading_manager.dart';
import 'package:electronics_market/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../consts/constants.dart';
import '../providers/auth_provider.dart';
import '../providers/sponsors_provider.dart';
import '../services/assets_manager.dart';
import '../services/global_method.dart';
import '../services/screen_size.dart';
import '../widgets/texts/title_text.dart';
import '../widgets/app_name_text.dart';
import '../widgets/product/ctg_rounded_widget.dart';
import 'auth/login_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isLoading = true;

  @override
  void initState() {
    getCtg();
    super.initState();
  }

  Future<void> getCtg() async {
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<CategoryProvider>(context, listen: false)
          .fetchCategories(token: authProv.getToken!);
    });
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final sponsorsProvider =
    Provider.of<SponsorsProvider>(context, listen: false);
    final sponsors = sponsorsProvider.sponsors;
    //Notice the super-call here.
    super.build(context);
    Size size = ScreenSize.getScreenSize(context);

    final authProv = Provider.of<AuthProvider>(context);
    final ctgProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const AppNameTextWidget(
          fontSize: 18,
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
          child: Image.asset(
            AssetsManager.shoppingCart,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                if (authProv.getisLoggedIn) {
                  await GlobalMethods.signOutDialog(
                      context: context,
                      fct: () {
                        try {
                          authProv.logout();
                          Navigator.of(context).pop();
                          authProv.checkLoginStatus();
                          if (!mounted) return;

                          Navigator.pushNamed(context, LoginPage.routeName);
                        } catch (e) {
                          log("error on logout ${authProv.logout()}");
                        }
                      });
                }
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: LoadingManager(
        isLoading: isLoading,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SingleChildScrollView(
            // physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 18,
                ),
                FutureBuilder(
                  future: sponsorsProvider.fetchSponsors(
                      bearerToken: authProv.getToken!),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.error != null) {
                        // Handle error here
                        return const Center(
                          child: Text('An error occurred!'),
                        );
                      } else {
                        return sponsors.isEmpty
                            ? const Center(
                          child: TitlesTextWidget(label: "No Sponsor"),
                        )
                            : SizedBox(
                            height: size.height * 0.24,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12.0),
                                topRight: Radius.circular(12.0),
                              ),
                              child: Swiper(
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  // return Image.network(
                                  //   sponsorsProvider.sponsors[index].image,
                                  //   fit: BoxFit.fill,
                                  // );
                                      return Image(image: AssetImage
                                        ('assets/images/anounc2.png'),
                                        fit: BoxFit.fill,
                                      );
                                },
                                autoplay: true,
                                itemCount: sponsorsProvider.sponsors.length,
                                pagination: const SwiperPagination(
                                  alignment: Alignment.bottomCenter,
                                  builder: DotSwiperPaginationBuilder(
                                    color: Colors.white,
                                    activeColor: Colors.red,
                                  ),
                                ),
                              ),
                            ));
                      }
                    }
                  },
                ),

                const SizedBox(
                  height: 18,
                ),

                const SizedBox(
                  height: 18,
                ),
                //popular category title
                const TitlesTextWidget(
                  label: "Caregories",
                  fontSize: 22,
                ),

                const SizedBox(
                  height: 14,
                ),
                ////popular category list
                // FutureBuilder<List<Category>>(
                //   future: ctgProvider.fetchCategories(token: authProv.getToken!),
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return const Center(child: CircularProgressIndicator());
                //     } else if (snapshot.hasError) {
                //       return Center(child: Text('Error: ${snapshot.error}'));
                //     } else if (snapshot.data == null || !snapshot.hasData) {
                //       return const Center(child: Text('No data'));
                //     } else {
                // log(" snapshot.data ${snapshot.data}");
                ctgProvider.getCategories == null
                    ? const SizedBox.shrink()
                    : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ctgProvider.getCategories!.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Builder(builder: (context) {
                      return CategoryRoundedWidget(
                        id: ctgProvider.getCategories![index].id
                            .toString(),
                        name: ctgProvider.getCategories![index].name,
                      );
                    });
                  },
                ),
                //     }
                //   },
                // ),

                const SizedBox(
                  height: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
