import 'dart:developer';

import 'package:electronics_market/providers/auth_provider.dart';
import 'package:electronics_market/screens/inner_screens/checkout/successful_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../loading_manager.dart';
import '../../../models/order_mode.dart';
import '../../../models/payment_method.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/order_display_provider.dart';
import '../../../providers/orders_provider.dart';
import '../../../providers/products_provider.dart';
import '../../../services/global_method.dart';
import '../../../widgets/payment_method.dart';
import '../../../widgets/texts/title_text.dart';
import '../../../widgets/go_back_widget.dart';
import '../../cart/bottom_checkout.dart';
import 'credit_card.dart';

class CheckoutScreen extends StatefulWidget {
  static const routeName = '/CheckoutScreen';
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool isLoading = false;
  String chosenPaymentMethod = paymentsMehtodsList[0].title;
  int chosenShippingMethod = 0;

  final _formKey = GlobalKey<FormState>();
  final cardNumberController = TextEditingController();
  final fullNameController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvCodeController = TextEditingController();
  final addressController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controllers when the widget is removed
    cardNumberController.dispose();
    fullNameController.dispose();
    expiryDateController.dispose();
    cvvCodeController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: LoadingManager(
        isLoading: isLoading,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: const TitlesTextWidget(
              label: "Checkout",
            ),
            centerTitle: true,
            leading: const GoBackWidget(),
          ),
          bottomSheet: CartBottomSheetWidget(
            buttonText: 'Purshase',
            amount: cartProvider.getTotal(productsProvider: productsProvider),
            function: () async {
              await placeOrder(context);
            },
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /////Delivery Address
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TitlesTextWidget(
                          label: 'Delivery Address',
                          fontSize: 16,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: addressController,
                          decoration:
                              const InputDecoration(labelText: 'Address'),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your address';
                            } else if (value.length < 5) {
                              return 'Your address is very short';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    //////payment method/////
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const TitlesTextWidget(
                                label: 'Payment Method',
                                fontSize: 16,
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              ListView.builder(
                                itemCount: paymentsMehtodsList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (ctx, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: PaymentMethodCart(
                                      title: paymentsMehtodsList[index].title,
                                      leadingIcon:
                                          paymentsMehtodsList[index].iconData,
                                      function: () {
                                        setState(() {
                                          if (paymentsMehtodsList[index]
                                                  .title
                                                  .toLowerCase() ==
                                              "cash on delivery") {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "This method is not available at the moment");
                                            return;
                                          }
                                          chosenPaymentMethod =
                                              paymentsMehtodsList[index].title;
                                        });
                                      },
                                      isChosen: chosenPaymentMethod ==
                                          paymentsMehtodsList[index].title,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CreditCardForm(
                      cardNumberController: cardNumberController,
                      fullNameController: fullNameController,
                      expiryDateController: expiryDateController,
                      cvvCodeController: cvvCodeController,
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    const SizedBox(
                      height: kBottomNavigationBarHeight + 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> placeOrder(BuildContext ctx) async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      final cartProvider = Provider.of<CartProvider>(ctx, listen: false);
      final productProvider = Provider.of<ProductsProvider>(ctx, listen: false);
      final ordersProvider = Provider.of<OrdersProvider>(ctx, listen: false);
      final authProv = Provider.of<AuthProvider>(ctx, listen: false);

      // Prepare order items (outside the loop)
      List<OrderItem> items = [];

      // Loop over all cart items
      for (var cartEntry in cartProvider.getCartItems.entries) {
        final key = cartEntry.key;
        final value = cartEntry.value;

        final getCurrProduct =
            productProvider.findById(int.parse(value.productId));

        // Add each item to the order items list
        items.add(OrderItem(
          product: value.productId,
          quantity: value.quantity.toString(),
        ));
      }

      try {
        setState(() {
          isLoading = true;
        });

        // Place the order (only once, with all items)
        await ordersProvider.addOrder(
          cardNumber: cardNumberController.text.trim(),
          cvc: cvvCodeController.text.trim(),
          expMonth: expiryDateController.text.split("/")[0],
          expYear: expiryDateController.text.split("/")[1],
          address: addressController.text,
          items: items,
          token: authProv.getToken!,
        );

        // Clear the cart
        await cartProvider.clearLocalCart();
        cartProvider.clearLocalCart();

        // Show a toast message
        await Fluttertoast.showToast(
          msg: "Your order has been placed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        if (!mounted) return;
        final orderProv =
            Provider.of<OrdersDisplayProvider>(ctx, listen: false);
        await orderProv.fetchAndSetOrders(token: authProv.getToken!);

        if (!mounted) return;
        await Navigator.pushNamed(context, SuccessfullScreen.routeName);
      } catch (error) {
        await GlobalMethods.warningOrErrorDialog(
          subtitle: error.toString(),
          context: ctx,
          isError: true,
          fct: () {},
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Future<void> placeOrder(BuildContext ctx) async {
  //   final cartProvider = Provider.of<CartProvider>(ctx, listen: false);
  //   final productProvider = Provider.of<ProductsProvider>(ctx, listen: false);
  //   final ordersProvider = Provider.of<OrdersProvider>(ctx, listen: false);

  //   // Loop over all cart items
  //   for (var cartEntry in cartProvider.getCartItems.entries) {
  //     // final key = cartEntry.key;
  //     final value = cartEntry.value;

  //     final getCurrProduct =
  //         productProvider.findById(int.parse(value.productId));
  //     // final totalPrice = getCurrProduct!.price * value.quantity;

  //     // Prepare order items
  //     List<OrderItem> items = [
  //       OrderItem(
  //         product: value.productId,
  //         quantity: value.quantity.toString(),
  //       ),
  //     ];

  //     try {
  //       setState(() {
  //         isLoading = true;
  //       });
  //       // Place the order
  //       await ordersProvider.addOrder("addressssss", items);

  //       // Clear the cart
  //       await cartProvider.clearLocalCart();
  //       cartProvider.clearLocalCart();

  //       // Show a toast message
  //       await Fluttertoast.showToast(
  //         msg: "Your order has been placed",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //       );
  //     } catch (error) {
  //       GlobalMethods.warningOrErrorDialog(
  //         subtitle: error.toString(),
  //         context: ctx,
  //         isError: true,
  //         fct: () {},
  //       );
  //     } finally {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   }

  //   // Fetch updated orders list
  //   ordersProvider.fetchAndSetOrders();
  // }
}
