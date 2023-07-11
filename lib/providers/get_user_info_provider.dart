import 'package:electronics_market/models/get_user_info_model.dart';
import 'package:flutter/material.dart';

class UserGetInfoProvider with ChangeNotifier {
  UserGetInfoModel? userGetInfoModel;
  void setUserInfo({required UserGetInfoModel user}) {
    userGetInfoModel = user;
    notifyListeners();
  }

  UserGetInfoModel? get getUserGetInfoModel {
    return userGetInfoModel;
  }
}
