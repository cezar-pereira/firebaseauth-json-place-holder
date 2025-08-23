import '../../post.dart';

sealed class PostAuthorState {}

class PostAuthorInitial extends PostAuthorState {}

class PostAuthorLoading extends PostAuthorState {}

class PostAuthorLoaded extends PostAuthorState {
  final AuthorModel author;
  PostAuthorLoaded(this.author);
}

class PostAuthorError extends PostAuthorState {
  final String message;
  PostAuthorError(this.message);
}
