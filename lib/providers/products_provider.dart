import 'dart:convert';
import 'dart:developer';

import 'package:electronics_market/consts/constants.dart';
import 'package:flutter/material.dart';

import '../models/products_model.dart';

import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<ProductModel> products = []; // Initialize with an empty list

  List<ProductModel> get getProducts {
    return [...products];
  }

  ProductModel? findById(int id) {
    return products.firstWhere((element) => element.id == id);
  }

  List<ProductModel> findByCategoryId({required int categoryId}) {
    return products
        .where((element) => element.categoryId == categoryId)
        .toList();
  }

  List<ProductModel> searchQuery({required String searchText}) {
    return products
        .where(
          (element) => element.name.toLowerCase().contains(
                searchText.toLowerCase(),
              ),
        )
        .toList();
  }

  Future<void> fetchProducts({required String token}) async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.BASE_URL}/all-products'),
        headers: {
          'Authorization': "Bearer $token",
        },
      );
      final data = json.decode(response.body) as List;
      products = data.map((item) => ProductModel.fromJson(item)).toList();
      notifyListeners();
    } catch (error) {
      log("error $error");
    }
  }

  bool isOnSale(int id) {
    final product = findById(id);
    if (product != null && product.sale != null) {
      return true;
    }
    return false;
  }
}
