import 'package:electronics_market/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../services/assets_manager.dart';
import '../../services/global_method.dart';
import '../../widgets/empty_bag.dart';
import '../../widgets/rounded_icon_btn.dart';
import '../../widgets/texts/title_text.dart';
import '../inner_screens/checkout/checkout_screen.dart';
import 'bottom_checkout.dart';
import 'cart_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);

    return cartProvider.getCartItems.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: AssetsManager.shoppingCart,
              title: "Your cart is empty",
              subtitle:
                  "Looks like you have not added anything to your cart. Go ahead & explore top categories",
            ),
          )
        : Scaffold(
            bottomSheet: CartBottomSheetWidget(
              buttonText: 'Checkout',
              amount: cartProvider.getTotal(productsProvider: productsProvider),
              function: () {
                Navigator.pushNamed(context, CheckoutScreen.routeName);
              },
            ),
            appBar: AppBar(
              centerTitle: false,
              title: const TitlesTextWidget(label: "Shopping basket"),
              leading: Padding(
                padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                child: Image.asset(
                  AssetsManager.shoppingCart,
                ),
              ),
              actions: [
                RoundedIconButton(
                    function: () async {
                      await GlobalMethods.warningOrErrorDialog(
                        isError: false,
                        subtitle: "All products in your cart will be removed",
                        fct: () {
                          cartProvider.clearLocalCart();
                        },
                        context: context,
                      );
                    },
                    icon: Icons.delete_forever_rounded)
              ],
            ),
            body: SingleChildScrollView(
              // physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cartProvider.getCartItems.length,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: cartProvider.getCartItems.values
                            .toList()
                            .reversed
                            .toList()[index],
                        child: const CartWidget(),
                      );
                    },
                  ),
                  const SizedBox(
                    height: kBottomNavigationBarHeight + 5,
                  )
                ],
              ),
            ));
  }
}
