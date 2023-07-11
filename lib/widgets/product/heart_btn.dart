import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../../providers/wishlist_provider.dart';
import '../../services/utils.dart';
import '../loading_widget.dart';

class HeartBTN extends StatefulWidget {
  const HeartBTN(
      {Key? key,
      required this.productId,
      this.isInWishlist = false,
      this.backgroundColor = Colors.transparent})
      : super(key: key);
  final String productId;
  final bool? isInWishlist;
  final Color? backgroundColor;
  @override
  State<HeartBTN> createState() => _HeartBTNState();
}

class _HeartBTNState extends State<HeartBTN> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final Color color = Utils(context).color;
    return Material(
      // color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
      color: widget.backgroundColor,
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: () async {
          wishlistProvider.addRemoveProductToWishlist(
              productId: widget.productId);
          // setState(() {
          //   loading = true;
          // });
          // try {
          //   // final User? user = FirebaseAuth.instance.currentUser;

          //   // if (user == null) {
          //   //   GlobalMethods.errorDialog(
          //   //       subtitle: 'No user found, Please login first',
          //   //       context: context);
          //   //   return;
          //   // }
          //   if (widget.isInWishlist == false && widget.isInWishlist != null) {
          //     await wishlistProvider.addToWishlist(
          //         productId: widget.productId, context: context);
          //   } else {
          //     await wishlistProvider.removeOneItem(
          //         wishlistId: wishlistProvider
          //             .getWishlistItems[getCurrProduct.productId]!.id,
          //         productId: widget.productId);
          //   }
          //   await wishlistProvider.fetchWishlist();
          //   setState(() {
          //     loading = false;
          //   });
          // } catch (error) {
          //   GlobalMethods.errorDialog(subtitle: '$error', context: context);
          // } finally {
          //   setState(() {
          //     loading = false;
          //   });
          // }
        },
        color: Colors.red,
        icon: loading
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 15,
                  width: 15,
                  child: LoadingWidget(loaderSize: 10),
                ),
              )
            : Icon(
                widget.isInWishlist != null && widget.isInWishlist == true
                    ? IconlyBold.heart
                    : IconlyLight.heart,
                size: 20,
                color:
                    widget.isInWishlist != null && widget.isInWishlist == true
                        ? Colors.red
                        : color,
              ),
      ),
    );
  }
}
