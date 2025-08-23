import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({required this.id, this.name, this.email, this.photoUrl});

  final String id;
  final String? name;
  final String? email;
  final String? photoUrl;

  @override
  List<Object?> get props => [id, name, email, photoUrl];
}
