sealed class AuthorFailure {
  final String message;
  const AuthorFailure(this.message);
}

class AuthorNotFoundFailure extends AuthorFailure {
  const AuthorNotFoundFailure([super.message = 'Autor não encontrado']);
}

class AuthorUnknownFailure extends AuthorFailure {
  const AuthorUnknownFailure([super.message = 'Erro inesperado']);
}
