import 'dart:convert';
import 'package:electronics_market/consts/constants.dart';
import 'package:flutter/material.dart';
import '../models/order_display.dart';
import 'package:http/http.dart' as http;

class SalesDisplayProvider with ChangeNotifier {
  List<OrderDisplayModel> _orders = [];

  List<OrderDisplayModel> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetSales({required String token}) async {
    final response = await http.get(
      Uri.parse('${Constants.BASE_URL}/my-sales'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    List<OrderDisplayModel> loadedOrders = [];
    var ordersData = json.decode(response.body) as List;
    for (var orderData in ordersData) {
      List<ProductOrderDisplay> loadedProducts = [];
      orderData['products'].forEach((productData) {
        loadedProducts.add(
          ProductOrderDisplay(
            productData['id'],
            productData['name'],
            productData['description'],
            productData['price'].toDouble(),
            productData['image'],
            productData['pivot']['quantity_of_product'],
            productData['pivot']['priceOfSellingProduct'] ?? null,
          ),
        );
      });
      loadedOrders.add(
        OrderDisplayModel(
          orderData['id'],
          orderData['total_price'].toDouble(),
          orderData['address'],
          orderData['created_at'],
          loadedProducts,
        ),
      );
    }
    _orders = loadedOrders;
    notifyListeners();
  }
}
