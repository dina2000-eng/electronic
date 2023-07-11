import 'package:electronics_market/models/categories_model.dart';
import 'package:electronics_market/services/api_service.dart';
import 'package:flutter/cupertino.dart';

class CategoryProvider with ChangeNotifier {
  List<Category>? category;
  List<Category>? get getCategories {
    return category;
  }

  Future<List<Category>>? fetchCategories({required String token}) async {
    final ctgs = await APIServices.fetchCategories(token);
    category = ctgs;
    notifyListeners();
    return ctgs;
  }
}
