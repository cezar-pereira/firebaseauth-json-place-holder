import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oauth_json_place_holder/modules/post/post.dart';

import '../../../../mocks.dart';

void main() {
  late PostRepository repository;
  late PostDatasource datasource;

  setUp(() {
    datasource = MockPostDatasource();
    repository = PostRepositoryImp(datasource);
  });

  final posts = [
    PostModel(userId: 1, id: 1, title: 'Test Post 1', body: 'Test body 1'),
    PostModel(userId: 2, id: 2, title: 'Test Post 2', body: 'Test body 2'),
  ];

  final author = AuthorModel(
    id: 1,
    name: 'Test Author',
    username: 'testuser',
    email: 'test@example.com',
  );

  group('fetchPosts |', () {
    test(
      'should return a Right with posts when datasource call is successful',
      () async {
        when(
          () => datasource.fetchPosts(start: 0, limit: 10),
        ).thenAnswer((_) async => posts);

        final result = await repository.fetchPosts(start: 0, limit: 10);

        expect(result, isA<Right<PostFailure, List<PostModel>>>());
        expect(result.fold((l) => l, (r) => r), equals(posts));
        verify(() => datasource.fetchPosts(start: 0, limit: 10)).called(1);
      },
    );

    test(
      'should return a Left with PostErrorFailure when datasource throws an exception',
      () async {
        when(
          () => datasource.fetchPosts(start: 0, limit: 10),
        ).thenThrow(Exception('Network error'));

        final result = await repository.fetchPosts(start: 0, limit: 10);

        expect(result, isA<Left<PostFailure, List<PostModel>>>());
        expect(result.fold((l) => l, (r) => r), isA<PostErrorFailure>());

        verify(() => datasource.fetchPosts(start: 0, limit: 10)).called(1);
      },
    );

    test(
      'should handle different start and limit parameters correctly',
      () async {
        when(
          () => datasource.fetchPosts(start: 10, limit: 5),
        ).thenAnswer((_) async => posts);

        final result = await repository.fetchPosts(start: 10, limit: 5);

        expect(result, isA<Right<PostFailure, List<PostModel>>>());
        verify(() => datasource.fetchPosts(start: 10, limit: 5)).called(1);
      },
    );
  });

  group('fetchAuthor |', () {
    test(
      'should return a Right with author when datasource call is successful',
      () async {
        when(() => datasource.fetchAuthor(1)).thenAnswer((_) async => author);

        final result = await repository.fetchAuthor(1);

        expect(result, isA<Right<AuthorFailure, AuthorModel>>());
        expect(result.fold((l) => l, (r) => r), equals(author));
        verify(() => datasource.fetchAuthor(1)).called(1);
      },
    );

    test(
      'should return a Left with AuthorFailure when datasource throws AuthorFailure',
      () async {
        final authorFailure = AuthorNotFoundFailure('Author not found');
        when(() => datasource.fetchAuthor(1)).thenThrow(authorFailure);

        final result = await repository.fetchAuthor(1);

        expect(result, isA<Left<AuthorFailure, AuthorModel>>());
        expect(result.fold((l) => l, (r) => r), equals(authorFailure));
        verify(() => datasource.fetchAuthor(1)).called(1);
      },
    );

    test(
      'should return a Left with AuthorUnknownFailure when datasource throws generic exception',
      () async {
        when(
          () => datasource.fetchAuthor(1),
        ).thenThrow(Exception('Network error'));

        final result = await repository.fetchAuthor(1);

        expect(result, isA<Left<AuthorFailure, AuthorModel>>());
        expect(result.fold((l) => l, (r) => r), isA<AuthorUnknownFailure>());
        verify(() => datasource.fetchAuthor(1)).called(1);
      },
    );

    test('should handle different author IDs correctly', () async {
      when(() => datasource.fetchAuthor(999)).thenAnswer((_) async => author);

      final result = await repository.fetchAuthor(999);

      expect(result, isA<Right<AuthorFailure, AuthorModel>>());
      verify(() => datasource.fetchAuthor(999)).called(1);
    });
  });
}
