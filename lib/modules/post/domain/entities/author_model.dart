class AuthorModel {
  final String name;
  final String username;
  final String email;
  final int id;

  AuthorModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
    );
  }
}
