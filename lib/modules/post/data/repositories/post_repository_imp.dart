import 'package:fpdart/fpdart.dart';

import '../../post.dart';

class PostRepositoryImp implements PostRepository {
  final PostDatasource datasource;

  PostRepositoryImp(this.datasource);

  @override
  Future<Either<PostFailure, List<PostModel>>> fetchPosts({
    required int start,
    required int limit,
  }) async {
    try {
      final result = await datasource.fetchPosts(start: start, limit: limit);
      return Right(result);
    } catch (e) {
      return Left(PostErrorFailure(e.toString()));
    }
  }

  @override
  Future<Either<AuthorFailure, AuthorModel>> fetchAuthor(int id) async {
    try {
      final result = await datasource.fetchAuthor(id);
      return Right(result);
    } on AuthorFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AuthorUnknownFailure());
    }
  }
}
