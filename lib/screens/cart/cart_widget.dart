import 'package:electronics_market/extension/extension.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../../models/cart_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../services/global_method.dart';
import '../../services/utils.dart';
import '../../widgets/product/heart_btn.dart';
import '../../widgets/texts/subtitle_text.dart';
import '../../widgets/texts/title_text.dart';
import 'quantity_btm_sheet.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartModel = Provider.of<CartModel>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);
    final getCurrProduct = productsProvider.findById(
      int.parse(cartModel.productId),
    );

    final wishlistProvider = Provider.of<WishlistProvider>(context);
    Size size = Utils(context).getScreenSize;
    return getCurrProduct == null
        ? const SizedBox.shrink()
        : FittedBox(
            child: IntrinsicWidth(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FancyShimmerImage(
                        errorWidget: const Icon(
                          IconlyBold.danger,
                          color: Colors.red,
                          size: 28,
                        ),
                        height: size.height * 0.2,
                        width: size.height * 0.2,
                        imageUrl: getCurrProduct.image,
                        boxFit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IntrinsicWidth(
                      child: Column(
                        // mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.6,
                                child: Text(
                                  getCurrProduct.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await GlobalMethods.warningOrErrorDialog(
                                          subtitle: "Remove from cart?",
                                          fct: () {
                                            cartProvider.removeItem(
                                              productId:
                                                  getCurrProduct.id.toString(),
                                            );
                                          },
                                          context: context);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                  ),
                                  HeartBTN(
                                    productId: getCurrProduct.id.toString(),
                                    isInWishlist:
                                        wishlistProvider.isProdInWishlist(
                                      productId: getCurrProduct.id.toString(),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                children: [
                                  if (getCurrProduct.sale != null)
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: FittedBox(
                                        child: TitlesTextWidget(
                                          label: getCurrProduct.sale!.newPrice
                                              .toString()
                                              .toCurrencyFormat()
                                              .toString(),
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: FittedBox(
                                      child: TitlesTextWidget(
                                        textDecoration:
                                            getCurrProduct.sale != null
                                                ? TextDecoration.lineThrough
                                                : null,
                                        label: getCurrProduct.price
                                            .toString()
                                            .toCurrencyFormat()
                                            .toString(),
                                        color: getCurrProduct.sale != null
                                            ? Colors.red
                                            : Colors.blue,
                                        fontSize: getCurrProduct.sale != null
                                            ? 16
                                            : 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Expanded(
                              //   child: SubtitlesTextWidget(
                              //     label: getCurrProduct.price
                              //         .toString()
                              //         .toCurrencyFormat()!,
                              //   ),
                              // ),
                              const Spacer(),
                              Expanded(
                                  child: OutlinedButton.icon(
                                      onPressed: () async {
                                        await showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return QuantityBottomSheetWidget(
                                                productId: cartModel.productId,
                                              );
                                            });
                                      },
                                      icon: const Icon(IconlyLight.arrowDown2),
                                      label:
                                          Text("Qty: ${cartModel.quantity}")))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
