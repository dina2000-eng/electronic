import 'package:flutter/cupertino.dart';
import '../models/viewed_prod_model.dart';

class ViewedProdProvider with ChangeNotifier {
  final Map<String, ViewedProdModel> _viewedItems = {};

  Map<String, ViewedProdModel> get getViewedProdItems {
    return {..._viewedItems};
  }

  void addProductToHist({
    required String productId,
    required String title,
    required String imageUrl,
  }) {
    if (_viewedItems.containsKey(productId)) {
      _viewedItems.update(
          productId,
          (exitingViewedItem) => ViewedProdModel(
                id: exitingViewedItem.id,
                productId: exitingViewedItem.productId,
              ));
    } else {
      _viewedItems.putIfAbsent(
          productId,
          () => ViewedProdModel(
                id: DateTime.now().toString(),
                productId: productId,
              ));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _viewedItems.remove(productId);
    notifyListeners();
  }

  void clearViewed() {
    _viewedItems.clear();
    notifyListeners();
  }
}
