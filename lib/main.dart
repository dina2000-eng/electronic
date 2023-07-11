import 'package:dynamic_color/dynamic_color.dart';
import 'package:electronics_market/providers/category_provider.dart';
import 'package:electronics_market/providers/get_user_info_provider.dart';
import 'package:electronics_market/providers/sales_propvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'consts/app_color.dart';
import 'consts/constants.dart';
import 'consts/theme_data.dart';
import 'loading_manager.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/like_products.dart';
import 'providers/message_provider.dart';
import 'providers/order_display_provider.dart';
import 'providers/orders_provider.dart';
import 'providers/owned_products.dart';
import 'providers/products_provider.dart';
import 'providers/sponsors_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/viewed_prod_provider.dart';
import 'providers/wishlist_provider.dart';
import 'root_screen.dart';
import 'routes.dart';
import 'screens/auth/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) {
            return AuthProvider();
          })
        ],
        child: const MyApp(),
      ),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeProvider themeChangeProvider = ThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
    await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          //Notify about theme changes
          return themeChangeProvider;
        }),
        ChangeNotifierProvider(create: (_) {
          return ProductsProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return WishlistProvider();
        }),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ViewedProdProvider(),
        ),
        ChangeNotifierProvider(create:   (_) => SalesDisplayProvider(),

        ),
        ChangeNotifierProvider(
          create: (_) => UserGetInfoProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OwnedProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LikesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrdersProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrdersDisplayProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MessageProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SponsorsProvider(),
        ),
      ],
      child:
      Consumer<ThemeProvider>(builder: (context, themeChangeProvider, ch) {
        return DynamicColorBuilder(
            builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
              ColorScheme lightColorScheme;
              ColorScheme darkColorScheme;

              if (lightDynamic != null && darkDynamic != null) {
                lightColorScheme = lightDynamic.harmonized()..copyWith();
                lightColorScheme =
                    lightColorScheme.copyWith(primary: AppColor.lightPrimary);
                darkColorScheme = darkDynamic.harmonized()..copyWith();
                darkColorScheme =
                    darkColorScheme.copyWith(primary: AppColor.darkPrimary);
              } else {
                lightColorScheme =
                    ColorScheme.fromSeed(seedColor: AppColor.lightPrimary);
                darkColorScheme = ColorScheme.fromSeed(
                  seedColor: const Color.fromARGB(255, 255, 159, 250),
                  brightness: Brightness.dark,
                );
              }
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: Constants.appName, // 'Spring boot & Flutter',
                theme: Styles.themeData(
                    isDarkTheme: themeChangeProvider.getIsDarkTheme,
                    context: context,
                    colorScheme: themeChangeProvider.getIsDarkTheme
                        ? darkColorScheme
                        : lightColorScheme),
                home: FutureBuilder(
                  future: Provider.of<AuthProvider>(context, listen: false)
                      .checkLoginStatus(),
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoadingManager(
                        isLoading: true,
                        child: LoginPage(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // log(snapshot.data.toString()); a bool
                      return snapshot.data!
                          ? const RootScreen()
                          : const LoginPage();
                    }
                  },
                ),
                routes: appRoutes,
              );
            });
      }),
    );
  }
}
