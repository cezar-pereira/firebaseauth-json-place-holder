import 'package:equatable/equatable.dart';

class LoginWithEmailPasswordDtoRequest extends Equatable {
  final String email;
  final String password;

  const LoginWithEmailPasswordDtoRequest({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
