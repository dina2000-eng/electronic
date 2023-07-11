import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/wishlist_model.dart';

class WishlistProvider with ChangeNotifier {
  final Map<String, WishlistModel> _wishlistItems = {};

  Map<String, WishlistModel> get getWishlistItems {
    return {..._wishlistItems};
  }

  WishlistProvider() {
    _fetchWishlistItems();
  }

  Future<void> _fetchWishlistItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? wishlistItemsString = prefs.getString('wishlistItems');

    if (wishlistItemsString != null) {
      final List<dynamic> wishlistItemsJson = json.decode(wishlistItemsString);
      _wishlistItems.clear();
      for (final dynamic json in wishlistItemsJson) {
        final WishlistModel wishlistItem = WishlistModel.fromJson(json);
        _wishlistItems[wishlistItem.productId] = wishlistItem;
      }
    }

    notifyListeners();
  }

  Future<void> _saveWishlistItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> wishlistItemsJson = _wishlistItems.values
        .map((wishlistItem) => wishlistItem.toJson())
        .toList();
    final String wishlistItemsString = json.encode(wishlistItemsJson);

    await prefs.setString('wishlistItems', wishlistItemsString);
  }

  bool isProdInWishlist({required String productId}) {
    return _wishlistItems.containsKey(productId);
  }

  void addRemoveProductToWishlist({required String productId}) {
    if (_wishlistItems.containsKey(productId)) {
      _wishlistItems.remove(productId);
    } else {
      _wishlistItems.putIfAbsent(
        productId,
        () => WishlistModel(id: const Uuid().v4(), productId: productId),
      );
    }
    _saveWishlistItems();
    notifyListeners();
  }

  void clearLocalWishlist() {
    _wishlistItems.clear();
    _saveWishlistItems();
    notifyListeners();
  }
}
