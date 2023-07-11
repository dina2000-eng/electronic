import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:electronics_market/models/product_upload.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../consts/constants.dart';
import '../models/categories_model.dart';
import 'package:http/http.dart' as http;

import '../models/get_user_info_model.dart';

class APIServices {
  static Future<List<Category>> fetchCategories(String token) async {
    final response = await http.get(
      Uri.parse('${Constants.BASE_URL}/all-categories'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);

      List<Category> categories =
          list.map((data) => Category.fromJson(data)).toList();

      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<UserGetInfoModel> getUserGetInfoModel(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.BASE_URL}/me'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      return UserGetInfoModel.fromJson(jsonDecode(response.body));
    } catch (error) {
      rethrow;
    }
    // else {
    //   throw Exception('Failed to load user info');
    // }
  }

  static Future<void> updateProfile(
      {required String name,
      required String email,
      required String phone,
      required String token}) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.BASE_URL}/update-profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'name': name,
          'email': email,
          'phone': phone,
        },
      );

      // if (response.statusCode == 200) {
      // final responseBody = jsonDecode(response.body);
      // log("responseBody $responseBody");
      // if (responseBody['message'] != null) {
      //   final errorMessage = responseBody['message'];
      //   // log("email error: $errorMessage");
      //   throw Exception(errorMessage);
      // }
    } catch (error) {
      rethrow;
    }
  }

  // Add product

// The http.Client that handles authenticated requests.
  static Future<void> addProduct(
      {required UploadProductModel product,
      required XFile pickedImage,
      required String token}) async {
    http.Client client = http.Client();

    try {
      // Read the image file into a list of bytes.
      final bytes = await File(pickedImage.path).readAsBytes();

      // Create a MultipartFile using the bytes and some additional information.
      final imageFile = http.MultipartFile.fromBytes(
        'image', // The name of the field on the server
        bytes,
        filename: pickedImage.path.split('/').last, // The filename
        contentType: MediaType('image', 'jpeg'), // The content type
      );

      // Create a multipart request.
      final request = http.MultipartRequest(
          'POST', Uri.parse('${Constants.BASE_URL}/add-product'));

      // Add the fields to the request using the Product model.
      product.toMap().forEach((key, value) {
        request.fields[key] = value;
      });

      // Add the image to the request.
      request.files.add(imageFile);

      // Set the header for the request
      request.headers['Authorization'] = 'Bearer $token';

      // Send the request.
      final response = await client.send(request);

      // Log the response from the server.
      final respStr = await response.stream.bytesToString();
      log('Response from server when uploading a product: $respStr');
    } catch (e) {
      // Any error that comes up during the upload is caught here.
      log('An error occurred while uploading the product: $e');
      rethrow;
    } finally {
      // Close the http client.
      client.close();
    }
  }

  static Future<void> sendMessageToAdmin(
      {required String name,
      required String email,
      required String phone,
      required String message,
      required String token}) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.BASE_URL}/send-message-to-admin'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'message': message,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send message to admin');
      }
    } catch (error) {
      log('Failed to send message: $error');
      rethrow;
    }
  }
}
