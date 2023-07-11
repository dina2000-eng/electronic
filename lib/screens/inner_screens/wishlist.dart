import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/assets_manager.dart';
import '../../../services/global_method.dart';
import '../../../widgets/empty_bag.dart';
import '../../loading_manager.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/go_back_widget.dart';
import '../../widgets/product/products_widget.dart';
import '../../widgets/rounded_icon_btn.dart';
import '../../widgets/texts/title_text.dart';

class WishlistScreen extends StatefulWidget {
  static const routeName = '/WishlistScreen';

  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return wishlistProvider.getWishlistItems.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: AssetsManager.bagWish,
              title: "Your wishlist is empty!",
              subtitle: "Seems like you don't have any wishes here.",
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: TitlesTextWidget(
                label: "Wishlist (${wishlistProvider.getWishlistItems.length})",
              ),
              leading: const GoBackWidget(),
              actions: [
                RoundedIconButton(
                  function: () {
                    GlobalMethods.warningOrErrorDialog(
                        subtitle: 'Alll items in your wishlist will be removed',
                        fct: () {
                          wishlistProvider.clearLocalWishlist();
                        },
                        context: context);
                  },
                  icon: Icons.delete_forever,
                )
              ],
            ),
            body:
                //  LoadingManager(
                //           isLoading: snapshot.connectionState == ConnectionState.waiting,
                //           child: EmptyBagWidget(
                //             title: 'Your Wishlist is empty',
                //             subtitle: 'Add something and make me happy :)',
                //             buttonText: 'Shop now',
                //             imagePath: AssetsManager.bagWish,
                //           ),
                //         );

                LoadingManager(
              isLoading: false,
              child: Column(
                children: [
                  Expanded(
                    child: DynamicHeightGridView(
                      // shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      itemCount: wishlistProvider.getWishlistItems.length,
                      crossAxisCount: 2,
                      builder: (ctx, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ProductsWidget(
                            productId: wishlistProvider.getWishlistItems.values
                                .toList()[index]
                                .productId,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: kBottomNavigationBarHeight + 12,
                  )
                ],
              ),
            ),
          );
  }
}
// }
