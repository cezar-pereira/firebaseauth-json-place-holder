import 'package:fpdart/fpdart.dart';

import '../../post.dart';

abstract class PostRepository {
  Future<Either<PostFailure, List<PostModel>>> fetchPosts({
    required int start,
    required int limit,
  });

  Future<Either<AuthorFailure, AuthorModel>> fetchAuthor(int id);
}
