import 'package:flutter/material.dart';

import '../services/assets_manager.dart';

class Constants {
  static const String BASE_URL = 'https://hasan.cloud/api';
  // list of string options
  static List<String> ordersOptions = [
    'All Orders',
    'Completed',
    'In-Process',
  ];

  static const String imageUrl =
      "https://images.unsplash.com/photo-1491553895911-0055eca6402d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80";
  static const String appName = "Electronics";
  static List<String> brandsList = [
    'Brandless',
    'Addidas',
    'Apple',
    'Dell',
    'H&M',
    'Nike',
    'Samsung',
    'Huawei',
  ];
  static List<String> categoriesList = [
    'Phones',
    'Clothes',
    'Beauty',
    'Shoes',
    'Funiture',
    'Watches',
  ];
  static List<String> bannersImages = [
    AssetsManager.banner1,
    AssetsManager.banner2,
  ];

  static List<DropdownMenuItem<String>>? get categoriesDropDownList {
    List<DropdownMenuItem<String>>? menuItems =
        List<DropdownMenuItem<String>>.generate(
      categoriesList.length,
      (idx) => DropdownMenuItem(
        value: categoriesList[idx],
        child: Text(categoriesList[idx]),
      ),
    );
    return menuItems;
  }

  static List<DropdownMenuItem<String>> get brandsDropDownList {
    List<DropdownMenuItem<String>> menuItems =
        List<DropdownMenuItem<String>>.generate(
      brandsList.length,
      (idx) => DropdownMenuItem(
        value: brandsList[idx],
        child: Text(brandsList[idx]),
      ),
    );
    return menuItems;
  }
}
