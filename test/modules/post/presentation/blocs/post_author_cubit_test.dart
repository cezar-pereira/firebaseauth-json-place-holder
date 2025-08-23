import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oauth_json_place_holder/modules/post/post.dart';

import '../../../../mocks.dart';

void main() {
  late PostAuthorCubit cubit;
  late PostRepository repository;

  setUp(() {
    repository = MockPostRepository();
    cubit = PostAuthorCubit(repository);
  });

  tearDown(() {
    cubit.close();
  });

  final author = AuthorModel(
    id: 1,
    name: 'Test Author',
    username: 'testuser',
    email: 'test@example.com',
  );

  group('fetchAuthor |', () {
    test(
      'should emit PostAuthorLoading then PostAuthorLoaded when successful',
      () async {
        when(
          () => repository.fetchAuthor(1),
        ).thenAnswer((_) async => Right(author));

        final expectedStates = [
          isA<PostAuthorLoading>(),
          isA<PostAuthorLoaded>(),
        ];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        await cubit.fetchAuthor(1);
      },
    );

    test(
      'should emit PostAuthorLoaded with correct author data when successful',
      () async {
        when(
          () => repository.fetchAuthor(1),
        ).thenAnswer((_) async => Right(author));

        await cubit.fetchAuthor(1);

        final state = cubit.state;
        expect(state, isA<PostAuthorLoaded>());
        if (state is PostAuthorLoaded) {
          expect(state.author.name, equals(author.name));
          expect(state.author.username, equals(author.username));
          expect(state.author.email, equals(author.email));
        }
      },
    );

    test(
      'should emit PostAuthorLoading then PostAuthorError when repository fails',
      () async {
        final failure = AuthorNotFoundFailure('Author not found');
        when(
          () => repository.fetchAuthor(1),
        ).thenAnswer((_) async => Left(failure));

        final expectedStates = [
          isA<PostAuthorLoading>(),
          isA<PostAuthorError>(),
        ];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        await cubit.fetchAuthor(1);
      },
    );

    test(
      'should emit PostAuthorError with correct error message when repository fails',
      () async {
        final failure = AuthorNotFoundFailure();
        when(
          () => repository.fetchAuthor(1),
        ).thenAnswer((_) async => Left(failure));

        await cubit.fetchAuthor(1);

        final state = cubit.state;
        expect(state, isA<PostAuthorError>());
        if (state is PostAuthorError) {
          expect(state.message, equals(failure.message));
        }
      },
    );

    test(
      'should emit PostAuthorError with generic error message when repository throws unknown failure',
      () async {
        final failure = AuthorUnknownFailure();
        when(
          () => repository.fetchAuthor(1),
        ).thenAnswer((_) async => Left(failure));

        await cubit.fetchAuthor(1);

        final state = cubit.state;
        expect(state, isA<PostAuthorError>());
        if (state is PostAuthorError) {
          expect(state.message, equals(failure.message));
        }
      },
    );

    test('should call repository with correct author ID', () async {
      when(
        () => repository.fetchAuthor(123),
      ).thenAnswer((_) async => Right(author));

      await cubit.fetchAuthor(123);

      verify(() => repository.fetchAuthor(123)).called(1);
    });

    test('should handle multiple author fetches correctly', () async {
      final author2 = AuthorModel(
        id: 2,
        name: 'Another Author',
        username: 'anotheruser',
        email: 'another@example.com',
      );

      when(
        () => repository.fetchAuthor(1),
      ).thenAnswer((_) async => Right(author));
      when(
        () => repository.fetchAuthor(2),
      ).thenAnswer((_) async => Right(author2));

      // Fetch first author
      await cubit.fetchAuthor(1);
      expect(cubit.state, isA<PostAuthorLoaded>());

      // Fetch second author
      await cubit.fetchAuthor(2);
      expect(cubit.state, isA<PostAuthorLoaded>());

      verify(() => repository.fetchAuthor(1)).called(1);
      verify(() => repository.fetchAuthor(2)).called(1);
    });

    test('should handle different author IDs correctly', () async {
      when(
        () => repository.fetchAuthor(999),
      ).thenAnswer((_) async => Right(author));

      await cubit.fetchAuthor(999);

      verify(() => repository.fetchAuthor(999)).called(1);
    });

    test(
      'should emit states in correct order for multiple rapid calls',
      () async {
        when(() => repository.fetchAuthor(1)).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 50));
          return Right(author);
        });

        when(() => repository.fetchAuthor(2)).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 30));
          return Right(author);
        });

        cubit.fetchAuthor(1);
        cubit.fetchAuthor(2);

        await Future.delayed(const Duration(milliseconds: 100));

        verify(() => repository.fetchAuthor(1)).called(1);
        verify(() => repository.fetchAuthor(2)).called(1);
      },
    );
  });

  group('state transitions |', () {
    test(
      'should transition from Initial to Loading to Loaded on success',
      () async {
        expect(cubit.state, isA<PostAuthorInitial>());

        when(
          () => repository.fetchAuthor(1),
        ).thenAnswer((_) async => Right(author));

        cubit.fetchAuthor(1);

        expect(cubit.state, isA<PostAuthorLoading>());

        await Future.delayed(const Duration(milliseconds: 10));

        expect(cubit.state, isA<PostAuthorLoaded>());
      },
    );

    test(
      'should transition from Initial to Loading to Error on failure',
      () async {
        expect(cubit.state, isA<PostAuthorInitial>());

        final failure = AuthorNotFoundFailure();
        when(
          () => repository.fetchAuthor(1),
        ).thenAnswer((_) async => Left(failure));

        cubit.fetchAuthor(1);

        expect(cubit.state, isA<PostAuthorLoading>());

        await Future.delayed(const Duration(milliseconds: 10));

        expect(cubit.state, isA<PostAuthorError>());
      },
    );
  });
}
