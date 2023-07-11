class Message {
  final int id;
  final String firstSide;
  final String secondSide;
  final String message;
  final bool isRead;
  final String createdAt;
  final String updatedAt;
  final int firstSideId;
  final int secondSideId;
  final String me;
  final String secondUser;

  Message({
    required this.id,
    required this.firstSide,
    required this.secondSide,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    required this.firstSideId,
    required this.secondSideId,
    required this.me,
    required this.secondUser,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      firstSide: json['first_side'],
      secondSide: json['second_side'],
      message: json['message'],
      isRead: json['is_read'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      firstSideId: json['first_side_id'],
      secondSideId: json['second_side_id'],
      me: json['me'],
      secondUser: json['second_user'],
    );
  }
}
// chat.dart

class Chat {
  final int id;
  final String name;

  Chat({
    required this.id,
    required this.name,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      name: json['name'],
    );
  }
}

class UnreadMessages {
  final int count;

  UnreadMessages({
    required this.count,
  });

  factory UnreadMessages.fromJson(Map<String, dynamic> json) {
    return UnreadMessages(
      count: json['un_read_msgs'],
    );
  }
}
