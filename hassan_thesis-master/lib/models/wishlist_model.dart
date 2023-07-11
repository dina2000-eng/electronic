import 'package:flutter/foundation.dart';

class WishlistModel with ChangeNotifier {
  final String id;
  final String productId;

  WishlistModel({
    required this.id,
    required this.productId,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      id: json['id'],
      productId: json['productId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
    };
  }
}
