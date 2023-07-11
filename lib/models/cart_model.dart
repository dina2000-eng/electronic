import 'dart:developer';

import 'package:flutter/cupertino.dart';

class CartModel with ChangeNotifier {
  final String cartId;
  final String productId;
  final int quantity;

  CartModel({
    required this.cartId,
    required this.productId,
    required this.quantity,
  });

  String toMapString() {
    return '$cartId:$productId:$quantity';
  }

  factory CartModel.fromMapString(String cartItemString) {
    final List<String> cartItemData = cartItemString.split(':');
    if (cartItemData.length != 3) {
      log('Invalid cart item format: $cartItemString');
      return CartModel(
        cartId: '',
        productId: '',
        quantity: 0,
      );
    }
    final String cartId = cartItemData[0];
    final String productId = cartItemData[1];
    int? quantity;
    try {
      quantity = int.tryParse(cartItemData[2]);
    } catch (e) {
      log('Error parsing quantity: $e');
    }
    return CartModel(
      cartId: cartId,
      productId: productId,
      quantity: quantity ?? 0,
    );
  }
}
