import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../consts/constants.dart';
import '../models/user_auth.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<UserAuth> registerUser(String name, String email,
      String password, String passwordConfirmation, String phone) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.BASE_URL}/api-register'),
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'phone': phone,
        },
      );

      // if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      // log("responseBody $responseBody");
      if (responseBody['email'] != null) {
        final errorMessage = responseBody['email'][0];
        // log("email error: $errorMessage");
        throw Exception(errorMessage);
      } else {
        return UserAuth.fromJson(responseBody['user']);
      }
      // }
    } catch (error) {
      rethrow;
    }
  }

  static Future<LoginResponse> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('${Constants.BASE_URL}/api-login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return LoginResponse.fromJson(responseBody);
    } else {
      final responseBody = jsonDecode(response.body);
      // log("responseBody[error]; ${responseBody["error"]}");

      throw Exception(responseBody["error"]);
    }
  }

  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }
}
