import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../consts/constants.dart';
import '../models/order_mode.dart';

// OrderProvider
class OrdersProvider with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

// In your OrdersProvider
  Future<void> fetchAndSetOrders({required String token}) async {
    final response = await http.get(
      Uri.parse('${Constants.BASE_URL}/my-orders'),
      headers: {"Authorization": "Bearer $token"},
    );

    final List<Order> loadedOrders = [];
    final extractedData = json.decode(response.body) as List<dynamic>;

    if (extractedData == null) {
      return;
    }

    for (var orderData in extractedData) {
      loadedOrders.add(Order.fromJson(orderData as Map<String, dynamic>));
    }

    _items = loadedOrders;
    notifyListeners();
  }

  // Future<void> fetchAndSetOrders({required String token}) async {
  //   final response = await http.get(
  //     Uri.parse('${Constants.BASE_URL}/my-orders'),
  //     headers: {"Authorization": "Bearer $token"},
  //   );

  //   final List<Order> loadedOrders = [];
  //   final extractedData = json.decode(response.body) as List<dynamic>;

  //   if (extractedData == null) {
  //     return;
  //   }

  //   extractedData.forEach((orderData) {
  //     loadedOrders.add(Order.fromJson(orderData as Map<String, dynamic>));
  //   });

  //   _items = loadedOrders;
  //   notifyListeners();
  // }

  Future<void> addOrder({
    required String address,
    required String cardNumber,
    required String expMonth,
    required String expYear,
    required String cvc,
    required List<OrderItem> items,
    required String token,
  }) async {
    final orderData = {
      "card_number": cardNumber,
      "exp_month": expMonth,
      "exp_year": expYear,
      "cvc": cvc,
      'address': address,
      'arrayOfObjects': items.map((item) => item.toJson()).toList(),
    };

    final response = await http.post(
      Uri.parse('${Constants.BASE_URL}/add-order'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(orderData),
    );

    var resBody = json.decode(response.body);

    if (response.statusCode == 200) {
      fetchAndSetOrders(token: token);
    } else {
      throw Exception('Failed to place order. ${resBody['message']}');
    }
  }
}
