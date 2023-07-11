class UserAuth {
  final String name;
  final String email;
  final String phone;
  final String updatedAt;
  final String createdAt;
  final int id;

  UserAuth(this.name, this.email, this.phone, this.updatedAt, this.createdAt,
      this.id);

  UserAuth.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        phone = json['phone'],
        updatedAt = json['updated_at'],
        createdAt = json['created_at'],
        id = json['id'];
}

class LoginResponse {
  final String accessToken;
  final String tokenType;
  final int expiresIn;

  LoginResponse(this.accessToken, this.tokenType, this.expiresIn);

  LoginResponse.fromJson(Map<String, dynamic> json)
      : accessToken = json['access_token'],
        tokenType = json['token_type'],
        expiresIn = json['expires_in'];
}
