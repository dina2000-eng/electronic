import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../models/user_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  // final AuthService _authService = AuthService();

  UserAuth? _user;
  String? _token;

  UserAuth? get user => _user;
  String? get getToken => _token;
  bool isLoggedIn = false;

  void setisLoggedIn({required bool logged}) {
    isLoggedIn = logged;
    notifyListeners();
  }

  bool get getisLoggedIn {
    return isLoggedIn;
  }

  Future<bool> registerUser(String name, String email, String password,
      String passwordConfirmation, String phone) async {
    try {
      _user = await AuthService.registerUser(
          name, email, password, passwordConfirmation, phone);
      notifyListeners();
      return true;
    } catch (e) {
      log("error is auth provider on sign up/ register ${e.toString()}");
      rethrow;
    }
  }

  Future<bool> loginUser(String email, String password) async {
    try {
      LoginResponse loginResponse =
          await AuthService.loginUser(email, password);
      _token = loginResponse.accessToken;
      log("_token $_token");
      await AuthService.saveToken(_token!);
      notifyListeners();
      setisLoggedIn(logged: true);
      return true;
    } catch (e) {
      setisLoggedIn(logged: false);
      // Here, you might want to handle errors based on your needs.
      log("error is auth provider on login ${e.toString()}");
      // return false;
      rethrow;
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    await AuthService.removeToken();
    notifyListeners();
  }

  Future<bool> checkLoginStatus() async {
    _token = await AuthService.getToken();
    if (_token != null) {
      log("Token is not null");
      log(_token.toString());
      setisLoggedIn(logged: true);
      return true;
    } else {
      log("Token is null");
      setisLoggedIn(logged: false);
      return false;
    }
  }
}
