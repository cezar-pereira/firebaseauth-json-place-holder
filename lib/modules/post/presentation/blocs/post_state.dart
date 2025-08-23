import '../../post.dart';

sealed class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostEmpty extends PostState {}

class PostLoaded extends PostState {
  final List<PostModel> posts;
  final bool hasMore;

  PostLoaded({required this.posts, required this.hasMore});
}

class PostError extends PostState {
  final String message;

  PostError(this.message);
}
