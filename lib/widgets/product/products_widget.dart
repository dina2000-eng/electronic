//Packages

import 'package:electronics_market/extension/extension.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/viewed_prod_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../screens/inner_screens/product_details.dart';
import '../../services/utils.dart';
import '../rounded_icon_btn.dart';
import '../texts/title_text.dart';
import 'heart_btn.dart';
import 'like_btn.dart';
//Services

class ProductsWidget extends StatefulWidget {
  const ProductsWidget({
    Key? key,
    required this.productId,
  }) : super(key: key);

  final String productId;
  @override
  State<ProductsWidget> createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final productsProvider = Provider.of<ProductsProvider>(context);
    final getCurrProduct = productsProvider.findById(
      int.parse(
        widget.productId.toString(),
      ),
    );
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    final viewedRecProvider = Provider.of<ViewedProdProvider>(context);
    return getCurrProduct == null
        ? const SizedBox.shrink()
        : Material(
            borderRadius: BorderRadius.circular(8.0),
            color: Theme.of(context).cardColor,
            child: InkWell(
              borderRadius: BorderRadius.circular(8.0),
              onTap: () async {
                viewedRecProvider.addProductToHist(
                  productId: getCurrProduct.id.toString(),
                  title: getCurrProduct.name,
                  imageUrl: getCurrProduct.image,
                );
                await Navigator.pushNamed(
                  context,
                  ProductDetails.routeName,
                  arguments: getCurrProduct.id.toString(),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Hero(
                        tag: getCurrProduct.id,
                        child: FancyShimmerImage(
                          errorWidget: const Icon(
                            IconlyBold.danger,
                            color: Colors.red,
                            size: 28,
                          ),
                          height: size.height * 0.22,
                          width: double.infinity,
                          imageUrl: getCurrProduct.image,
                          boxFit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 5,
                          child: Text(
                            getCurrProduct.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 17,
                              color: Utils(context).color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        HeartBTN(
                          productId: getCurrProduct.id.toString(),
                          isInWishlist: wishlistProvider.isProdInWishlist(
                            productId: getCurrProduct.id.toString(),
                          ),
                        ),

                        // InkWell(
                        //   splashColor: Colors.transparent,
                        //   onTap: () {},
                        //   child: const Icon(IconlyBold.heart),
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: FittedBox(
                              child: TitlesTextWidget(
                                textDecoration: getCurrProduct.sale != null
                                    ? TextDecoration.lineThrough
                                    : null,
                                label: getCurrProduct.price
                                    .toString()
                                    .toCurrencyFormat()
                                    .toString(),
                                color: getCurrProduct.sale != null
                                    ? Colors.red
                                    : Colors.blue,
                                fontSize: getCurrProduct.sale != null ? 16 : 20,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: RoundedIconButton(
                            function: () {
                              cartProvider.addProductToCart(
                                productId: widget.productId,
                              );
                            },
                            icon: cartProvider.isProdInCart(
                                    productId: getCurrProduct.id.toString())
                                ? Icons.done_all
                                : Icons.add_shopping_cart_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  LikeButtonWidget(
                    productId: getCurrProduct.id.toString(),
                  ),
                ],
              ),
            ),
          );
  }
}
