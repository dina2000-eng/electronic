class UserGetInfoModel {
  final int id;
  final String name;
  final String email;

  final String phone;

  UserGetInfoModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory UserGetInfoModel.fromJson(Map<String, dynamic> json) {
    return UserGetInfoModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}
