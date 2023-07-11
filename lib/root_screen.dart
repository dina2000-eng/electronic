import 'dart:developer';

import 'package:electronics_market/loading_manager.dart';
import 'package:electronics_market/providers/auth_provider.dart';
import 'package:electronics_market/providers/message_provider.dart';
import 'package:electronics_market/providers/owned_products.dart';
import 'package:electronics_market/providers/sales_propvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_display_provider.dart';
import 'providers/products_provider.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/home_screen.dart';
import 'screens/messages_screens.dart';
import 'screens/search_screen.dart';
import 'screens/profile_screen.dart';

// @override
// void setState(fn) {
//   if (mounted) super.setState(fn);
// }
class RootScreen extends StatefulWidget {
  static const routeName = '/RootScreen';
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    fetchFCT();
    _pageController = PageController(initialPage: currentScreen);
  }

  bool _isLoading = true;
  Future<void> fetchFCT() async {
    final orderProv =
        Provider.of<OrdersDisplayProvider>(context, listen: false);
    final salesProv =
    Provider.of<SalesDisplayProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final ownedProductsProvider =
        Provider.of<OwnedProductsProvider>(context, listen: false);
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final messagesProvider =
        Provider.of<MessageProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Provider.of<CategoryProvider>(context, listen: false)
      //     .fetchCategories(token: authProv.getToken!);
      if (authProvider.getToken == null) {
        log("authProvider.getToken if null");
        return;
      }

      await productsProvider.fetchProducts(token: authProvider.getToken!);
      await ownedProductsProvider.fetchProducts(token: authProvider.getToken!);
      await orderProv.fetchAndSetOrders(token: authProvider.getToken!);
      await salesProv.fetchAndSetSales(token: authProvider.getToken!);
      await messagesProvider.getunreadMessagesCoung(
          token: authProvider.getToken!);
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int currentScreen = 0;
  List<Widget> screens = [
    HomeScreen(),
    SearchScreen(),
    CartScreen(),
    MessagesScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final messagestProvider = Provider.of<MessageProvider>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   mini: true,
      //   // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      //   hoverElevation: 10,
      //   tooltip: 'Search',
      //   elevation: 0,
      //   child: const Icon(Icons.add),
      //   onPressed: () {},
      // ),
      body: LoadingManager(
        isLoading: _isLoading,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: screens, // screens[currentScreen],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentScreen = index;
            _pageController.jumpToPage(currentScreen);
          });
        },
        selectedIndex: currentScreen,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.5,
        height: kBottomNavigationBarHeight,
        destinations: [
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.home),
            icon: Icon(IconlyLight.home),
            label: 'Home',
          ),
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.search),
            icon: Icon(IconlyLight.search),
            label: 'Search',
          ),
          NavigationDestination(
            selectedIcon: const Icon(IconlyBold.bag2),
            icon: Badge(
              label: Text(cartProvider.getCartItems.length.toString()),
              child: const Icon(IconlyLight.bag2),
            ),
            label: 'Cart',
          ),
          NavigationDestination(
            selectedIcon: const Icon(IconlyBold.message),
            icon: Badge(
              label: Text(messagestProvider.unreadMessagesCount.toString()),
              child: const Icon(IconlyLight.message),
            ),
            label: 'Messages',
          ),
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.profile),
            icon: Icon(IconlyLight.profile),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
