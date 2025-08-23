import 'package:flutter_bloc/flutter_bloc.dart';
import '../../post.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepository repository;

  int _page = 0;
  final int _limit = 10;
  final List<PostModel> _posts = [];

  bool _isFetching = false;

  PostCubit(this.repository) : super(PostInitial());

  Future<void> fetchPosts() async {
    if (_isFetching) return;
    _isFetching = true;

    if (_page == 0) emit(PostLoading());

    final result = await repository.fetchPosts(
      start: _page * _limit,
      limit: _limit,
    );

    result.fold(
      (failure) {
        emit(PostError(failure.message));
      },
      (newPosts) {
        if (newPosts.isEmpty && _posts.isEmpty) {
          emit(PostEmpty());
        } else {
          _posts.addAll(newPosts);
          _page++;
          emit(
            PostLoaded(posts: List.from(_posts), hasMore: newPosts.isNotEmpty),
          );
        }
      },
    );
    _isFetching = false;
  }
}
