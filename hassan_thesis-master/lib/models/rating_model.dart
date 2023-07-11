class Rating {
  final String productId;
  final String userId;
  final String userName;
  final String userImage;
  final int ratingValue;
  final String comment;
  // final Timestamp createdAt;

  Rating({
    required this.productId,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.ratingValue,
    // required this.createdAt,
    required this.comment,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      productId: json['productId'],
      userId: json['userId'],
      userName: json['userName'],
      userImage: json['userImage'],
      ratingValue: json['ratingValue'],
      // createdAt: json['createdAt'],
      comment: json['comment'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'ratingValue': ratingValue,
      // 'createdAt': createdAt,
      'comment': comment,
    };
  }
}
