class AuthorModel {
  final String name;
  final String username;
  final String email;

  AuthorModel({
    required this.name,
    required this.username,
    required this.email,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      name: json['name'],
      username: json['username'],
      email: json['email'],
    );
  }
}
