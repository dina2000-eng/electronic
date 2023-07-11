import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../consts/constants.dart';
import '../models/message_model.dart';

class MessageProvider with ChangeNotifier {
  List<Message> _items = [];
  int unreadMessagesCount = 0;

  List<Message> get items {
    return [..._items];
  }

  Future<void> fetchMessages(
      {required int secondSide, required String token}) async {
    final response = await http.post(
      Uri.parse('${Constants.BASE_URL}/my-messages-with-another'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode({'second_side': secondSide}),
    );

    final List<Message> loadedMessages = [];
    final extractedData = json.decode(response.body) as List<dynamic>;

    if (extractedData == null) {
      return;
    }

    for (var messageData in extractedData) {
      loadedMessages.add(Message.fromJson(messageData as Map<String, dynamic>));
    }

    _items = loadedMessages;
    notifyListeners();
  }

  Future<void> sendMessage({
    required int secondSide,
    required String message,
    required String token,
  }) async {
    final response = await http.post(
      Uri.parse('${Constants.BASE_URL}/send-message'),
      headers: {"Authorization": "Bearer $token"},
      body: {
        'second_side': secondSide.toString(),
        'message': message,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to send message');
    }
  }

  List<Chat> _chats = [];

  List<Chat> get chats {
    return [..._chats];
  }

  // Future<void> fetchChats({required String token}) async {
  //   final response = await http.get(
  //     Uri.parse('https://hasan.cloud/api/all-chats'),
  //     headers: {"Authorization": "Bearer $token"},
  //   );
  //   final data = json.decode(response.body) as Map<String, dynamic>;

  //   List<Chat> loadedChats = [];
  //   data.forEach((key, value) {
  //     loadedChats.add(Chat.fromJson(value));
  //   });

  //   _chats = loadedChats;
  //   notifyListeners();
  // }
// [
//     {
//         "id": 1,
//         "name": "Hasan"
//     },
//     {
//         "id": 3,
//         "name": "hasn ns"
//     }
// ]

  Future<void> fetchChats({required String token}) async {
    final response = await http.get(
      Uri.parse('${Constants.BASE_URL}/all-chats'),
      headers: {"Authorization": "Bearer $token"},
    );

    // Now, we are assuming that the data is a List of Maps.
    final data = json.decode(response.body) as List;

    List<Chat> loadedChats = [];
    for (var value in data) {
      loadedChats.add(Chat.fromJson(value));
    }

    _chats = loadedChats;
    notifyListeners();
  }

  Future<void> getunreadMessagesCoung({required String token}) async {
    final response = await http.get(
      Uri.parse('${Constants.BASE_URL}/unread-msgs-count'),
      headers: {"Authorization": "Bearer $token"},
    );

    // Now, we are assuming that the data is a List of Maps.
    final data = json.decode(response.body);

    unreadMessagesCount = UnreadMessages.fromJson(data).count;
    notifyListeners();
  }

  //   Future<void> fetchChats({required String token}) async {
  //   final response = await http.get(
  //     Uri.parse('${Constants.BASE_URL}/all-chats'),
  //     headers: {"Authorization": "Bearer $token"},
  //   );

  //   // Here is the main change, we are now assuming that the data is a Map
  //   final data = json.decode(response.body) as Map<String, dynamic>;

  //   List<Chat> loadedChats = [];
  //   data.forEach((key, value) {
  //     loadedChats.add(Chat.fromJson(value));
  //   });

  //   _chats = loadedChats;
  //   notifyListeners();
  // }
}
