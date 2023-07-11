import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/empty_bag.dart';
import '../../models/viewed_prod_model.dart';
import '../../providers/viewed_prod_provider.dart';
import '../../services/assets_manager.dart';
import '../../widgets/go_back_widget.dart';
import '../../widgets/product/products_widget.dart';
import '../../widgets/texts/title_text.dart';

class ViewedRecScreen extends StatefulWidget {
  static const routeName = '/ViewedRecScreen';

  const ViewedRecScreen({Key? key}) : super(key: key);

  @override
  State<ViewedRecScreen> createState() => _ViewedRecScreenState();
}

class _ViewedRecScreenState extends State<ViewedRecScreen> {
  @override
  Widget build(BuildContext context) {
    final viewedRecProvider =
        Provider.of<ViewedProdProvider>(context, listen: false);
    Map<String, ViewedProdModel> viewedProd =
        viewedRecProvider.getViewedProdItems;

    return Scaffold(
      appBar: AppBar(
        title: viewedProd.isEmpty
            ? null
            : const TitlesTextWidget(label: "Seen products"),
        leading: const GoBackWidget(),
      ),
      body: viewedProd.isEmpty
          ? EmptyBagWidget(
              title: 'You didn\'t view any products yet ',
              subtitle: '',
              imagePath: AssetsManager.orderBag,
            )
          : Column(
              children: [
                Expanded(
                  child: DynamicHeightGridView(
                      // shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewedProd.length,
                      crossAxisCount: 2,
                      builder: (ctx, index) {
                        return ChangeNotifierProvider.value(
                          value: viewedProd[index],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ProductsWidget(
                              productId:
                                  viewedProd.values.toList()[index].productId,
                            ),
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  height: kBottomNavigationBarHeight + 12,
                )
              ],
            ),
    );
  }
}
