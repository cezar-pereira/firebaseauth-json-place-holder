import '../../../../core/core.dart';
import '../../post.dart';

abstract class PostDatasource {
  Future<List<PostModel>> fetchPosts({required int start, required int limit});
  Future<AuthorModel> fetchAuthor(int id);
}

class PostDatasourceImp implements PostDatasource {
  final RestClient restClient;

  PostDatasourceImp(this.restClient);

  @override
  Future<List<PostModel>> fetchPosts({
    required int start,
    required int limit,
  }) async {
    final response = await restClient.get(
      "https://jsonplaceholder.typicode.com/posts?_start=$start&_limit=$limit",
    );
    await Future.delayed(Duration(seconds: 1));

    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((e) => PostModel.fromJson(e)).toList();
    } else {
      throw Exception("Erro ao buscar posts");
    }
  }

  @override
  Future<AuthorModel> fetchAuthor(int id) async {
    final response = await restClient.get(
      "https://jsonplaceholder.typicode.com/users/$id",
    );
    await Future.delayed(Duration(seconds: 1));

    if (response.statusCode == 200) {
      final data = response.data;
      return AuthorModel.fromJson(data);
    } else {
      throw Exception("Erro ao buscar autor");
    }
  }
}
