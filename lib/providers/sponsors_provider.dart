import 'dart:convert';
import 'dart:developer';
import 'package:electronics_market/consts/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/sponsors_model.dart';

class SponsorsProvider with ChangeNotifier {
  final String _sponsorsUrl = '${Constants.BASE_URL}/sponsores';

  List<Sponsor> _sponsors = [];

  List<Sponsor> get sponsors => _sponsors;

  Future<void> fetchSponsors({required String bearerToken}) async {
    try {
      final response = await http.get(
        Uri.parse(_sponsorsUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        _sponsors = responseData.map((json) => Sponsor.fromJson(json)).toList();

        notifyListeners();
      } else {
        throw Exception('Failed to load sponsors');
      }
    } catch (e) {
      // Handle error
      log(e.toString());
    }
  }
}
