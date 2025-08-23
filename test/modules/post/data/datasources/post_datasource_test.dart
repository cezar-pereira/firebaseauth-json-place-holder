import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oauth_json_place_holder/core/core.dart';
import 'package:oauth_json_place_holder/modules/post/post.dart';

import '../../../../mocks.dart';

void main() {
  late PostDatasource datasource;
  late RestClient restClient;

  setUp(() {
    restClient = MockRestClient();
    datasource = PostDatasourceImp(restClient);
  });

  final postsJson = [
    {'userId': 1, 'id': 1, 'title': 'Test Post 1', 'body': 'Test body 1'},
    {'userId': 2, 'id': 2, 'title': 'Test Post 2', 'body': 'Test body 2'},
  ];

  final authorJson = {
    'id': 1,
    'name': 'Test Author',
    'username': 'testuser',
    'email': 'test@example.com',
  };

  final successResponse = RestClientResponseModel(
    data: postsJson,
    statusCode: 200,
    statusMessage: 'OK',
  );

  final authorResponse = RestClientResponseModel(
    data: authorJson,
    statusCode: 200,
    statusMessage: 'OK',
  );

  group('fetchPosts |', () {
    test('should return posts when API call is successful', () async {
      when(
        () => restClient.get(any()),
      ).thenAnswer((_) async => successResponse);

      final result = await datasource.fetchPosts(start: 0, limit: 10);

      expect(result, isA<List<PostModel>>());
      expect(result.length, equals(2));
      expect(result[0].title, equals('Test Post 1'));
      expect(result[1].title, equals('Test Post 2'));
      verify(() => restClient.get(any())).called(1);
    });

    test('should call correct URL with start and limit parameters', () async {
      when(
        () => restClient.get(any()),
      ).thenAnswer((_) async => successResponse);

      await datasource.fetchPosts(start: 0, limit: 10);

      verify(
        () => restClient.get(
          'https://jsonplaceholder.typicode.com/posts?_start=0&_limit=10',
        ),
      ).called(1);
    });

    test('should handle empty response correctly', () async {
      final emptyResponse = RestClientResponseModel(
        data: <dynamic>[],
        statusCode: 200,
        statusMessage: 'OK',
      );

      when(() => restClient.get(any())).thenAnswer((_) async => emptyResponse);

      final result = await datasource.fetchPosts(start: 0, limit: 10);

      expect(result, isA<List<PostModel>>());
      expect(result.length, equals(0));
      verify(() => restClient.get(any())).called(1);
    });

    test('should handle network errors correctly', () async {
      when(() => restClient.get(any())).thenThrow(Exception('Network error'));

      expect(
        () => datasource.fetchPosts(start: 0, limit: 10),
        throwsA(isA<Exception>()),
      );
      verify(() => restClient.get(any())).called(1);
    });
  });

  group('fetchAuthor |', () {
    test('should return author when API call is successful', () async {
      when(() => restClient.get(any())).thenAnswer((_) async => authorResponse);

      final result = await datasource.fetchAuthor(1);

      expect(result, isA<AuthorModel>());
      expect(result.name, equals('Test Author'));
      expect(result.username, equals('testuser'));
      expect(result.email, equals('test@example.com'));
      verify(() => restClient.get(any())).called(1);
    });

    test('should call correct URL with author ID', () async {
      when(() => restClient.get(any())).thenAnswer((_) async => authorResponse);

      await datasource.fetchAuthor(123);

      verify(
        () => restClient.get('https://jsonplaceholder.typicode.com/users/123'),
      ).called(1);
    });

    test(
      'should throw exception when API returns non-200 status code',
      () async {
        final errorResponse = RestClientResponseModel(
          data: 'User not found',
          statusCode: 404,
          statusMessage: 'Not Found',
        );

        when(
          () => restClient.get(any()),
        ).thenAnswer((_) async => errorResponse);

        expect(() => datasource.fetchAuthor(1), throwsA(isA<Exception>()));
        verify(() => restClient.get(any())).called(1);
      },
    );

    test('should handle network errors correctly', () async {
      when(() => restClient.get(any())).thenThrow(Exception('Network error'));

      expect(() => datasource.fetchAuthor(1), throwsA(isA<Exception>()));
      verify(() => restClient.get(any())).called(1);
    });

    test('should handle different author IDs correctly', () async {
      when(() => restClient.get(any())).thenAnswer((_) async => authorResponse);

      await datasource.fetchAuthor(999);

      verify(
        () => restClient.get('https://jsonplaceholder.typicode.com/users/999'),
      ).called(1);
    });
  });
}
