import 'package:mocktail/mocktail.dart';
import 'package:oauth_json_place_holder/core/core.dart';
import 'package:oauth_json_place_holder/modules/post/post.dart';

class MockPostRepository extends Mock implements PostRepository {}

class MockPostDatasource extends Mock implements PostDatasource {}

class MockRestClient extends Mock implements RestClient {}
