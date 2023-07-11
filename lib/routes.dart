import 'package:electronics_market/screens/auth/new_password.dart';
import 'package:electronics_market/screens/auth/reset_password.dart';
import 'package:electronics_market/screens/inner_screens/sales_screen.dart';
import 'package:electronics_market/services/assets_manager.dart';
import 'package:flutter/material.dart';

import 'root_screen.dart';
import 'screens/auth/forgot_password.dart';
import 'screens/auth/login_page.dart';
import 'screens/auth/register.dart';
import 'screens/inner_screens/checkout/checkout_screen.dart';
import 'screens/inner_screens/checkout/successful_screen.dart';
import 'screens/inner_screens/contact_us.dart';
import 'screens/inner_screens/inner_messages_screen.dart';
import 'screens/inner_screens/orders_screen.dart';
import 'screens/inner_screens/owned_products_screen.dart';
import 'screens/inner_screens/product_details.dart';
import 'screens/inner_screens/upload_product_form.dart';
import 'screens/inner_screens/viewed_recently.dart';
import 'screens/inner_screens/wishlist.dart';
import 'screens/search_screen.dart';

Map<String, WidgetBuilder> get appRoutes {
  return {
    RootScreen.routeName: (ctx) => const RootScreen(),
    newpassword.routeName:(ctx)=> newpassword(),
    ResetPasswordScreen.routeName:(ctx)=> ResetPasswordScreen(email: '',),
    RegisterScreen.routeName: (ctx) => const RegisterScreen(),
    // EditProfileScreen.routeName: (ctx) => const EditProfileScreen(),
    LoginPage.routeName: (ctx) => const LoginPage(),
    ForgotPasswordScreen.routeName: (ctx) => const ForgotPasswordScreen(),
    CheckoutScreen.routeName: (ctx) => const CheckoutScreen(),
    ProductDetails.routeName: (ctx) => const ProductDetails(),
    SearchScreen.routeName: (ctx) => const SearchScreen(),
    WishlistScreen.routeName: (ctx) => const WishlistScreen(),
    ViewedRecScreen.routeName: (ctx) => const ViewedRecScreen(),
    // OrdersScreenFree.routeName: (ctx) => const OrdersScreenFree(),
    OrdersScreen.routeName: (ctx) => const OrdersScreen(),
    SalesScreen.routeName : (ctx) => const SalesScreen(),
    UploadProductForm.routeName: (ctx) => const UploadProductForm(),
    OwnedProductsScreen.routeName: (ctx) => const OwnedProductsScreen(),
    ContactUsScreen.routeName: (ctx) => const ContactUsScreen(),
    // ChatScreen.routeName: (ctx) => const ChatScreen(),
    SuccessfullScreen.routeName: (ctx) => SuccessfullScreen(
        title: "Payment successful",
        subtitle: "Your order has been placed",
        imagePath: AssetsManager.confettis),
  };
}
