import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:electronics_market/providers/owned_products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/assets_manager.dart';
import '../../../widgets/empty_bag.dart';
import '../../loading_manager.dart';
import '../../widgets/go_back_widget.dart';
import '../../widgets/product/products_widget.dart';
import '../../widgets/texts/title_text.dart';

class OwnedProductsScreen extends StatefulWidget {
  static const routeName = '/OwnedProductsScreen';

  const OwnedProductsScreen({Key? key}) : super(key: key);

  @override
  State<OwnedProductsScreen> createState() => _OwnedProductsScreenState();
}

class _OwnedProductsScreenState extends State<OwnedProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final ownedProductsProvider = Provider.of<OwnedProductsProvider>(context);
    return ownedProductsProvider.getProducts.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: AssetsManager.shoppingBasket,
              title: "No owned product yet!",
              subtitle: "Your products will be displayed here.",
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: TitlesTextWidget(
                label:
                    "Owned products (${ownedProductsProvider.getProducts.length})",
              ),
              leading: const GoBackWidget(),
            ),
            body: LoadingManager(
              isLoading: false,
              child: Column(
                children: [
                  Expanded(
                    child: DynamicHeightGridView(
                      // shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      itemCount: ownedProductsProvider.getProducts.length,
                      crossAxisCount: 2,
                      builder: (ctx, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ProductsWidget(
                            productId: ownedProductsProvider
                                .getProducts[index].id
                                .toString(),
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
