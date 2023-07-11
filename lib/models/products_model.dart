import 'package:flutter/material.dart';

class Sale {
  final int id;
  final int productId;
  final String start;
  final String end;
  final int discountRate;
  final String createdAt;
  final String updatedAt;
  final double newPrice;

  Sale({
    required this.id,
    required this.productId,
    required this.start,
    required this.end,
    required this.discountRate,
    required this.createdAt,
    required this.updatedAt,
    required this.newPrice,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      productId: json['product_id'],
      start: json['start'],
      end: json['end'],
      discountRate: json['discount_rate'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      newPrice: json['new_price'].toDouble(),
    );
  }
}

class ProductModel with ChangeNotifier {
  final int id;
  final String name;
  final String description;
  final double price;
  final int instock;
  final String image;
  final String publish;
  final int categoryId;
  final int userId;
  final String createdAt;
  final String updatedAt;
  final int? userIdMessage;
  final String? userNameMessage;
  final Sale? sale;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.instock,
    required this.image,
    required this.publish,
    required this.categoryId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.userIdMessage,
    required this.userNameMessage,
    this.sale,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    int? userIdMessage;
    String? userNameMessage;
    if (json['user'] != null && json['user'].isNotEmpty) {
      userIdMessage = json['user'][0]['id'];
      userNameMessage = json['user'][0]['name'].toString();
    }

    Sale? sale;
    if (json['sale'] != null) {
      sale = Sale.fromJson(json['sale']);
    }

    return ProductModel(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        price: double.parse(json['price'].toString()),
        instock: json['instock'],
        image: json['image'],
        publish: json['publish'],
        categoryId: json['category_id'],
        userId: json['user_id'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        userIdMessage: userIdMessage,
        userNameMessage: userNameMessage,
        sale: sale);
  }
}
