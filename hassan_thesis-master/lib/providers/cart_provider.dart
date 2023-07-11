import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/cart_model.dart';
import '../models/products_model.dart';
import 'products_provider.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};

  Map<String, CartModel> get getCartItems {
    return {..._cartItems};
  }

  CartProvider() {
    // clearLocalCart();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? cartItemStrings = prefs.getStringList('cartItems');

    if (cartItemStrings != null) {
      _cartItems.clear();
      for (final String cartItemString in cartItemStrings) {
        final CartModel cartItem = CartModel.fromMapString(cartItemString);
        _cartItems[cartItem.productId] = cartItem;
      }
    }

    notifyListeners();
  }

  Future<void> _saveCartItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> cartItemStrings =
        _cartItems.values.map((cartItem) => cartItem.toMapString()).toList();

    await prefs.setStringList('cartItems', cartItemStrings);
  }

  bool isProdInCart({required String productId}) {
    return _cartItems.containsKey(productId);
  }

  double getTotal({required ProductsProvider productsProvider}) {
    double total = 0.0;
    _cartItems.forEach((key, value) {
      final ProductModel? getCurrProduct =
          productsProvider.findById(int.parse(value.productId));
      if (getCurrProduct == null) {
        total += 0;
      } else {
        if (getCurrProduct.sale != null) {
          total += getCurrProduct.sale!.newPrice * value.quantity;
        } else {
          total += getCurrProduct.price * value.quantity;
        }
      }
    });
    return total;
  }

  int getQTY({required ProductsProvider productsProvider}) {
    int totalQTY = 0;
    _cartItems.forEach((key, value) {
      totalQTY += value.quantity;
    });
    return totalQTY;
  }

  void reduceItemByOne(String productId) {
    if (_cartItems.containsKey(productId)) {
      final CartModel existingCartItem = _cartItems[productId]!;
      final updatedCartItem = CartModel(
        cartId: existingCartItem.cartId,
        productId: existingCartItem.productId,
        quantity: existingCartItem.quantity - 1,
      );
      if (updatedCartItem.quantity <= 0) {
        _cartItems.remove(productId);
      } else {
        _cartItems[productId] = updatedCartItem;
      }
      _saveCartItems();
      notifyListeners();
    }
  }

  Future<void> removeItem({required String productId}) async {
    _cartItems.remove(productId);
    _saveCartItems();
    notifyListeners();
  }

  Future<void> clearLocalCart() async {
    _cartItems.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartItems');
    notifyListeners();
  }

  void addProductToCart({required String productId}) async {
    if (_cartItems.containsKey(productId)) {
      final CartModel existingCartItem = _cartItems[productId]!;
      final updatedCartItem = CartModel(
        cartId: existingCartItem.cartId,
        productId: existingCartItem.productId,
        quantity: existingCartItem.quantity + 1,
      );
      _cartItems[productId] = updatedCartItem;
    } else {
      _cartItems[productId] = CartModel(
        cartId: const Uuid().v4(),
        productId: productId,
        quantity: 1,
      );
    }
    _saveCartItems();
    notifyListeners();
  }

  void updateQuantity({
    required String productId,
    required int newQuantity,
  }) {
    if (_cartItems.containsKey(productId)) {
      final CartModel existingCartItem = _cartItems[productId]!;
      final updatedCartItem = CartModel(
        cartId: existingCartItem.cartId,
        productId: existingCartItem.productId,
        quantity: newQuantity,
      );
      _cartItems[productId] = updatedCartItem;
      _saveCartItems();
      notifyListeners();
    }
  }
}
