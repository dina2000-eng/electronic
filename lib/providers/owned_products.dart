import 'dart:convert';

import 'package:electronics_market/consts/constants.dart';
import 'package:flutter/material.dart';

import '../models/products_model.dart';

import 'package:http/http.dart' as http;

class OwnedProductsProvider with ChangeNotifier {
  List<ProductModel> products = []; // Initialize with an empty list

  List<ProductModel> get getProducts {
    return [...products];
  }

  Future<void> fetchProducts({required String token}) async {
    final response = await http.get(
      Uri.parse('${Constants.BASE_URL}/get-my-products'),
      headers: {
        'Authorization': "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      products = data.map((item) => ProductModel.fromJson(item)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
