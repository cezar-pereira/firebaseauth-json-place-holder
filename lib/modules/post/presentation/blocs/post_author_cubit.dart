import 'package:flutter_bloc/flutter_bloc.dart';
import '../../post.dart';

class PostAuthorCubit extends Cubit<PostAuthorState> {
  final PostRepository repository;

  PostAuthorCubit(this.repository) : super(PostAuthorInitial());

  Future<void> fetchAuthor(int userId) async {
    emit(PostAuthorLoading());
    final result = await repository.fetchAuthor(userId);
    result.fold(
      (failure) => emit(PostAuthorError(failure.message)),
      (author) => emit(PostAuthorLoaded(author)),
    );
  }
}
