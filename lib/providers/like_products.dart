import 'dart:developer';
import 'dart:io';

import 'package:electronics_market/consts/constants.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LikesProvider with ChangeNotifier {
  Future<void> likeProduct(
      {required String productId, required String token}) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.BASE_URL}/like-product'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({'product_id': int.parse(productId)}),
      );
      log("response like ${jsonDecode(response.body)}");

      // If server responses with a bad status, throw an error
      // if (response.statusCode >= 400) {
      //   throw const HttpException(
      //       'Could not like product. Please try again later.');
      // }

      getLikesCount(productId: productId, token: token);
      notifyListeners();
    } catch (error) {
      log("error on like $error");
      rethrow;
    }
  }

  Future<void> unlikeProduct(
      {required String productId, required String token}) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.BASE_URL}/unlike-product'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({'product_id': int.parse(productId)}),
      );
      log("response like ${jsonDecode(response.body)}");

      // If server responses with a bad status, throw an error
      // if (response.statusCode >= 400) {
      //   throw const HttpException(
      //       'Could not like product. Please try again later.');
      // }

      getLikesCount(productId: productId, token: token);
      notifyListeners();
    } catch (error) {
      log("error on like $error");
      rethrow;
    }
  }

  // Future<void> unlikeProduct(
  //     {required String productId, required String token}) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('${Constants.BASE_URL}/unlike-product'),
  //       headers: {
  //         "Authorization": "Bearer $token",
  //       },
  //       body: jsonEncode({'product_id': int.parse(productId)}),
  //     );
  //     log("response unlike ${jsonDecode(response.body)}");

  //     // If server responses with a bad status, throw an error
  //     // if (response.statusCode >= 400) {
  //     //   throw const HttpException(
  //     //       'Could not unlike product. Please try again later.');
  //     // }
  //     getLikesCount(productId: productId, token: token);
  //     notifyListeners();
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  Future<int> getLikesCount(
      {required String productId, required String token}) async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.BASE_URL}/like-rate?product_id=$productId'),
        headers: {"Authorization": "Bearer $token"},
      );
      // log("response getLikesCount ${jsonDecode(response.body)}");
      // if (response.statusCode >= 400) {
      //   throw const HttpException('Failed to fetch likes count.');
      // }
      notifyListeners();
      return int.parse(response.body);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> checkIfLiked(
      {required String productId, required String token}) async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.BASE_URL}/like-check?product_id=$productId'),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode >= 400) {
        throw const HttpException('Failed to check like status.');
      }
      notifyListeners();
      return response.body.toLowerCase() == 'true';
    } catch (error) {
      rethrow;
    }
  }
}
