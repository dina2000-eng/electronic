import 'dart:developer';

import 'package:electronics_market/extension/extension.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../services/utils.dart';
import '../../widgets/app_name_text.dart';
import '../../widgets/no_result_found.dart';
import '../../widgets/product/heart_btn.dart';
import '../../widgets/rounded_icon_btn.dart';
import '../../widgets/texts/subtitle_text.dart';
import '../../widgets/texts/title_text.dart';
import '../../widgets/go_back_widget.dart';
import '../messages_screens.dart';
import 'inner_messages_screen.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = '/ProductDetails';

  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrProduct = productsProvider.findById(int.parse(productId));
    final size = Utils(context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppNameTextWidget(fontSize: 18),
        leading: const GoBackWidget(),
        actions: [
          Badge(
            label: Text(cartProvider.getCartItems.length.toString()),
            alignment: AlignmentDirectional.topStart,
            child: RoundedIconButton(
              function: () {},
              icon: IconlyLight.bag2,
            ),
          ),
        ],
      ),
      body: getCurrProduct == null
          ? const Center(
              child: NoResultFound(
                message: "Product info not found",
              ),
            )
          : SafeArea(
              child: getCurrProduct == null
                  ? const NoResultFound(
                      message:
                          "Cant find info of this product, please try again later, and if the issue persists, feel free to send us a message")
                  : RefreshIndicator(
                      onRefresh: () async {},
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Hero(
                              tag: getCurrProduct.id,
                              child: FancyShimmerImage(
                                imageUrl: getCurrProduct.image,
                                height: size.height * 0.36,
                                width: double.infinity,
                                boxFit: BoxFit.contain,
                              ),
                            ),
                            Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: TitlesTextWidget(
                                                label: getCurrProduct.name,
                                                fontSize: 18,
                                                maxLines: 3,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Row(
                                              children: [
                                                if (getCurrProduct.sale != null)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: FittedBox(
                                                      child: TitlesTextWidget(
                                                        label: getCurrProduct
                                                            .sale!.newPrice
                                                            .toString()
                                                            .toCurrencyFormat()
                                                            .toString(),
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: FittedBox(
                                                    child: TitlesTextWidget(
                                                      textDecoration:
                                                          getCurrProduct.sale !=
                                                                  null
                                                              ? TextDecoration
                                                                  .lineThrough
                                                              : null,
                                                      label: getCurrProduct
                                                          .price
                                                          .toString()
                                                          .toCurrencyFormat()
                                                          .toString(),
                                                      color:
                                                          getCurrProduct.sale !=
                                                                  null
                                                              ? Colors.red
                                                              : Colors.blue,
                                                      fontSize:
                                                          getCurrProduct.sale !=
                                                                  null
                                                              ? 16
                                                              : 20,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // TitlesTextWidget(
                                            //   label: getCurrProduct.price
                                            //       .toString()
                                            //       .toCurrencyFormat()
                                            //       .toString(),
                                            //   color: Colors.lightBlue,
                                            //   fontSize: 22,
                                            // ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              if (getCurrProduct
                                                      .userIdMessage ==
                                                  null) {
                                                return;
                                              }
                                              log("user id for message ${getCurrProduct.userIdMessage}");
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return InnerMessageScreen(
                                                  secondSideId: getCurrProduct
                                                      .userIdMessage!,
                                                  sellerName: getCurrProduct
                                                      .userNameMessage!,
                                                );
                                              }));
                                            },
                                            icon: const Icon(IconlyLight.send),
                                            label: const Text(
                                              "Contact seller",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 4,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            // mainAxisSize: MainAxisSize.max,
                                            children: [
                                              SizedBox(
                                                height:
                                                    kBottomNavigationBarHeight -
                                                        10,
                                                child: HeartBTN(
                                                  productId: productId,
                                                  isInWishlist: wishlistProvider
                                                      .isProdInWishlist(
                                                    productId: getCurrProduct.id
                                                        .toString(),
                                                  ),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .buttonTheme
                                                          .colorScheme!
                                                          .primaryContainer,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 7,
                                              ),
                                              Expanded(
                                                child: SizedBox(
                                                  height:
                                                      kBottomNavigationBarHeight -
                                                          10,
                                                  child: ElevatedButton.icon(
                                                      onPressed: () {
                                                        if (cartProvider.isProdInCart(
                                                            productId:
                                                                getCurrProduct
                                                                    .id
                                                                    .toString())) {
                                                          return;
                                                        }
                                                        cartProvider
                                                            .addProductToCart(
                                                          productId:
                                                              getCurrProduct.id
                                                                  .toString(),
                                                        );
                                                      },
                                                      label: Text(
                                                        cartProvider.isProdInCart(
                                                                productId:
                                                                    getCurrProduct
                                                                        .id
                                                                        .toString())
                                                            ? "Item added to cart"
                                                            : "Add to cart",
                                                      ),
                                                      icon: Icon(
                                                        cartProvider.isProdInCart(
                                                                productId:
                                                                    getCurrProduct
                                                                        .id
                                                                        .toString())
                                                            ? Icons.done_all
                                                            : Icons.add,
                                                      )),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // RowButtonWidgets(
                                        // btnText: cartProvider.isProdInCart(
                                        //         productId: getCurrProduct.productId)
                                        // ? "Item is in cart"
                                        // : "Add to cart",
                                        //   roundedBtnFunction: () {},
                                        //   elevatedButtonFCT: () {
                                        //     if (cartProvider.isProdInCart(
                                        //         productId:
                                        //             getCurrProduct.productId)) {
                                        //       return;
                                        //     }
                                        //     cartProvider.addProductToCart(
                                        //       productId: getCurrProduct.productId,
                                        //     );
                                        //   },
                                        //   roundedBtnIcon: IconlyLight.heart,
                                        // ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        productInfoWidget(
                                          title: "About this item",
                                          subtitle: getCurrProduct.description,
                                          ctg: getCurrProduct.categoryId
                                              .toString(),
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        // Card(
                                        //   child: IntrinsicHeight(
                                        //     child: Row(
                                        //       mainAxisAlignment:
                                        //           MainAxisAlignment.spaceEvenly,
                                        //       children: [
                                        //         productInfoWidget(
                                        //           title: "Product Brand",
                                        //           subtitle:
                                        //               getCurrProduct.productBrand,
                                        //         ),
                                        //         const VerticalDivider(thickness: 2),
                                        //         productInfoWidget(
                                        //           title: "Product Category",
                                        //           subtitle:
                                        //               getCurrProduct.productCategory,
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                                // const SizedBox(
                                //   height: 15,
                                // ),
                                const Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                  height: 1,
                                ),
                                const SizedBox(
                                  height: kBottomNavigationBarHeight + 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
    );
  }

  Widget productInfoWidget(
      {required String title, required String subtitle, required String ctg}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TitlesTextWidget(
              label: title,
              fontSize: 18,
            ),
            FittedBox(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Theme.of(context).cardColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SubtitlesTextWidget(
                    label: "In $ctg",
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5.0),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SubtitlesTextWidget(
            label: subtitle,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5.0),
        // const Divider(),
      ],
    );
  }
}
