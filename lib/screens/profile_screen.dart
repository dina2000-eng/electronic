import 'dart:developer';

import 'package:electronics_market/loading_manager.dart';
import 'package:electronics_market/screens/inner_screens/contact_us.dart';
import 'package:electronics_market/screens/inner_screens/edit_profile.dart';
import 'package:electronics_market/screens/inner_screens/sales_screen.dart';
import 'package:electronics_market/screens/inner_screens/upload_product_form.dart';
import 'package:electronics_market/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../models/get_user_info_model.dart';
import '../providers/auth_provider.dart';
import '../providers/get_user_info_provider.dart';
import '../providers/theme_provider.dart';
import '../services/assets_manager.dart';
import '../services/global_method.dart';
import '../widgets/profile_image.dart';
import '../widgets/texts/subtitle_text.dart';
import '../widgets/texts/title_text.dart';
import 'auth/login_page.dart';
import 'inner_screens/orders_screen.dart';
import 'inner_screens/owned_products_screen.dart';
import 'inner_screens/viewed_recently.dart';
import 'inner_screens/wishlist.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  UserGetInfoModel? userInfo;
  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  bool isLoading = true;
  Future<void> fetchUserInfo() async {
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration.zero, () async {
      try {
        final authProv = Provider.of<AuthProvider>(context, listen: false);
        final getUserInfoProv =
        Provider.of<UserGetInfoProvider>(context, listen: false);
        if (authProv.getToken == null) {
          return;
        }
        userInfo = await APIServices.getUserGetInfoModel(authProv.getToken!);
        getUserInfoProv.setUserInfo(user: userInfo!);
        setState(() {
          isLoading = false;
        });
      } catch (error) {
        if (!mounted) return;
        log("error.toString() in profle, ${error.toString()}");
        await GlobalMethods.warningOrErrorDialog(
          subtitle: error.toString(),
          fct: () {},
          context: context,
          isError: true,
        );
      }
    });
  }

  // @override
  // void didChangeDependencies() {
  //   fetchUserInfo();
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    final getUserInfoProv = Provider.of<UserGetInfoProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    //Notice the super-call here.
    super.build(context);
    final authProv = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const TitlesTextWidget(
          label: "Profile & Settings",
          fontSize: 18,
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await fetchUserInfo();
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.blue,
              ))
        ],
      ),
      body: LoadingManager(
        isLoading: isLoading,
        child: SafeArea(
          child: SingleChildScrollView(
            child: RefreshIndicator(
              onRefresh: fetchUserInfo,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const ProfileImageWidget(),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitlesTextWidget(
                              label: getUserInfoProv.getUserGetInfoModel != null
                                  ? getUserInfoProv.getUserGetInfoModel!.name
                                  : "userName",
                            ),
                            SubtitlesTextWidget(
                              label: getUserInfoProv.getUserGetInfoModel != null
                                  ? getUserInfoProv.getUserGetInfoModel!.email
                                  : "Email",
                            ),
                            SubtitlesTextWidget(
                              label: getUserInfoProv.getUserGetInfoModel != null
                                  ? getUserInfoProv.getUserGetInfoModel!.phone
                                  : "phone",
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              if (getUserInfoProv.getUserGetInfoModel == null) {
                                return;
                              }
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(
                                      userGetInfoModel:
                                      getUserInfoProv.getUserGetInfoModel!),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 24,
                              color: Colors.blue,
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TitlesTextWidget(
                          label: 'General',
                          fontSize: 14,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomListTile(
                          text: 'All Order',
                          imagePath: AssetsManager.orderSvg,
                          function: () async {
                            await Navigator.pushNamed(
                                context, OrdersScreen.routeName);
                          },
                        ),
                        CustomListTile(
                          text: 'All Sales',
                          imagePath: AssetsManager.shoppingCart,
                          function: () async {
                            await Navigator.pushNamed(
                                context, SalesScreen.routeName);
                          },
                        ),
                        CustomListTile(
                          text: 'Wishlist',
                          imagePath: AssetsManager.wishlistSvg,
                          function: () async {
                            await Navigator.pushNamed(
                                context, WishlistScreen.routeName);
                          },
                        ),
                        CustomListTile(
                          text: 'Viewed recently',
                          imagePath: AssetsManager.recent,
                          function: () async {
                            await Navigator.pushNamed(
                                context, ViewedRecScreen.routeName);
                          },
                        ),
                        // CustomListTile(
                        //   text: 'Admin mode',
                        //   imagePath: AssetsManager.personne,
                        //   function: () async {
                        //     await Navigator.pushNamed(
                        //         context, ViewedRecScreen.routeName);
                        //   },
                        // ),
                        CustomListTile(
                          text: 'Owned product',
                          imagePath: AssetsManager.shoppingBasket,
                          function: () async {
                            await Navigator.pushNamed(
                              context,
                              OwnedProductsScreen.routeName,
                            );
                          },
                        ),
                        CustomListTile(
                          text: 'Upload a product',
                          imagePath: AssetsManager.upload,
                          function: () async {
                            await Navigator.pushNamed(
                              context,
                              UploadProductForm.routeName,
                            );
                          },
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 10,
                        ),
                        const TitlesTextWidget(
                          label: 'Settings',
                          fontSize: 14,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            value: themeProvider.getIsDarkTheme,
                            onChanged: (value) {
                              setState(() {
                                themeProvider.setDarkTheme = value;
                              });
                            },
                            visualDensity: VisualDensity.compact,
                            title: SubtitlesTextWidget(
                              label: themeProvider.getIsDarkTheme
                                  ? 'Dark mode'
                                  : 'Light mode',
                              fontSize: 14,
                            ),
                            secondary: Image.asset(
                              AssetsManager.theme,
                              height: 32,
                            ),
                          ),
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 10,
                        ),
                        const TitlesTextWidget(
                          label: 'Others',
                          fontSize: 14,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomListTile(
                          text: 'Contact us',
                          imagePath: AssetsManager.mobiles,
                          function: () async {
                            await Navigator.pushNamed(
                              context,
                              ContactUsScreen.routeName,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomListTile(
                            text: authProv.getisLoggedIn ? "Logout" : "Login",
                            imagePath: authProv.getisLoggedIn
                                ? AssetsManager.logout
                                : AssetsManager.login,
                            function: () async {
                              if (authProv.getisLoggedIn) {
                                await GlobalMethods.signOutDialog(
                                    context: context,
                                    fct: () {
                                      try {
                                        authProv.logout();
                                        Navigator.of(context).pop();
                                        authProv.checkLoginStatus();
                                        if (!mounted) return;

                                        Navigator.pushNamed(
                                            context, LoginPage.routeName);
                                      } catch (e) {
                                        log("error on logout ${authProv.logout()}");
                                      }
                                    });
                              }
                            }),
                      ],
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

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {super.key,
        required this.imagePath,
        required this.text,
        required this.function});

  final String imagePath, text;
  final VoidCallback function;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      onTap: function,
      leading: Image.asset(
        imagePath,
        height: 32,
      ),
      title: SubtitlesTextWidget(
        label: text,
        fontSize: 14,
      ),
      trailing: const Icon(
        IconlyLight.arrowRight2,
        size: 14,
      ),
    );
  }
}
