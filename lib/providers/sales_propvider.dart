import 'dart:convert';
import 'package:electronics_market/consts/constants.dart';
import 'package:flutter/material.dart';
import '../models/order_display.dart';
import 'package:http/http.dart' as http;

import '../models/salesModel.dart';

class SalesDisplayProvider with ChangeNotifier {
  List<SalesModel> _sales = [];

  List<SalesModel> get sales {
    return [..._sales];
  }

  Future<void> fetchAndSetSales({required String token}) async {
    var headers = {'Authorization': 'Bearer $token'};
    var request =
        http.Request('GET', Uri.parse('https://hasan.cloud/api/my-sales'));

    request.headers.addAll(headers);

    http.StreamedResponse streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);

    List jasonData = json.decode(response.body);

    if (response.statusCode == 200) {
      List<SalesModel> loadedOrders = [];
      for (var p in jasonData) {
        var a = SalesModel.fromJson(p);
        loadedOrders.add(a);
      }

      _sales = loadedOrders;
      notifyListeners();
    } else {
      print(response.reasonPhrase);
    }
  }
}
