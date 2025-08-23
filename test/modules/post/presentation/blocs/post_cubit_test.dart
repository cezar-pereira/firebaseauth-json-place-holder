import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oauth_json_place_holder/modules/post/post.dart';

import '../../../../mocks.dart';

void main() {
  late PostCubit cubit;
  late PostRepository repository;

  setUp(() {
    repository = MockPostRepository();
    cubit = PostCubit(repository);
  });

  tearDown(() {
    cubit.close();
  });

  final posts = [
    PostModel(userId: 1, id: 1, title: 'Test Post 1', body: 'Test body 1'),
    PostModel(userId: 2, id: 2, title: 'Test Post 2', body: 'Test body 2'),
  ];

  group('initial state |', () {
    test('should start with PostInitial state', () {
      expect(cubit.state, isA<PostInitial>());
    });
  });

  group('fetchPosts |', () {
    test(
      'should emit PostLoading then PostLoaded when first page is successful',
      () async {
        when(
          () => repository.fetchPosts(start: 0, limit: 10),
        ).thenAnswer((_) async => Right(posts));

        final expectedStates = [isA<PostLoading>(), isA<PostLoaded>()];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        await cubit.fetchPosts();
      },
    );

    test(
      'should emit PostLoading then PostLoaded with correct data when first page is successful',
      () async {
        when(
          () => repository.fetchPosts(start: 0, limit: 10),
        ).thenAnswer((_) async => Right(posts));

        await cubit.fetchPosts();

        final state = cubit.state;
        expect(state, isA<PostLoaded>());
        if (state is PostLoaded) {
          expect(state.posts, equals(posts));
          expect(state.hasMore, isTrue);
        }
      },
    );

    test(
      'should emit PostLoading then PostEmpty when first page returns empty list',
      () async {
        when(
          () => repository.fetchPosts(start: 0, limit: 10),
        ).thenAnswer((_) async => Right([]));

        final expectedStates = [isA<PostLoading>(), isA<PostEmpty>()];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        await cubit.fetchPosts();
      },
    );

    test(
      'should emit PostLoading then PostError when repository fails',
      () async {
        final failure = PostErrorFailure('Network error');
        when(
          () => repository.fetchPosts(start: 0, limit: 10),
        ).thenAnswer((_) async => Left(failure));

        final expectedStates = [isA<PostLoading>(), isA<PostError>()];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        await cubit.fetchPosts();
      },
    );

    test(
      'should emit PostError with correct error message when repository fails',
      () async {
        final failure = PostErrorFailure('Network error');
        when(
          () => repository.fetchPosts(start: 0, limit: 10),
        ).thenAnswer((_) async => Left(failure));

        await cubit.fetchPosts();

        final state = cubit.state;
        expect(state, isA<PostError>());
        if (state is PostError) {
          expect(state.message, equals(failure.message));
        }
      },
    );

    test('should load second page successfully and update hasMore', () async {
      // First page
      when(
        () => repository.fetchPosts(start: 0, limit: 10),
      ).thenAnswer((_) async => Right(posts));

      await cubit.fetchPosts();

      // Second page
      when(
        () => repository.fetchPosts(start: 10, limit: 10),
      ).thenAnswer((_) async => Right(posts));

      await cubit.fetchPosts();

      final state = cubit.state;
      expect(state, isA<PostLoaded>());
      if (state is PostLoaded) {
        expect(state.posts.length, 4);
        expect(state.hasMore, isTrue);
      }
    });

    test(
      'should set hasMore to false when second page returns empty',
      () async {
        // First page
        when(
          () => repository.fetchPosts(start: 0, limit: 10),
        ).thenAnswer((_) async => Right(posts));

        await cubit.fetchPosts();

        // Second page (empty)
        when(
          () => repository.fetchPosts(start: 10, limit: 10),
        ).thenAnswer((_) async => Right([]));

        await cubit.fetchPosts();

        final state = cubit.state;
        expect(state, isA<PostLoaded>());
        if (state is PostLoaded) {
          expect(state.posts.length, 2);
          expect(state.hasMore, isFalse);
        }
      },
    );

    test('should not fetch if already fetching', () async {
      when(() => repository.fetchPosts(start: 0, limit: 10)).thenAnswer((
        _,
      ) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return Right(posts);
      });

      cubit.fetchPosts();

      cubit.fetchPosts();

      await Future.delayed(const Duration(milliseconds: 150));

      verify(() => repository.fetchPosts(start: 0, limit: 10)).called(1);
    });

    test('should handle pagination correctly with different limits', () async {
      when(
        () => repository.fetchPosts(start: 0, limit: 10),
      ).thenAnswer((_) async => Right(posts));

      await cubit.fetchPosts();

      final state = cubit.state;
      expect(state, isA<PostLoaded>());
      if (state is PostLoaded) {
        expect(state.posts.length, 2);
      }
    });
  });

  group('state management |', () {
    test('should maintain posts list across multiple fetches', () async {
      when(
        () => repository.fetchPosts(start: 0, limit: 10),
      ).thenAnswer((_) async => Right(posts));

      await cubit.fetchPosts();

      when(
        () => repository.fetchPosts(start: 10, limit: 10),
      ).thenAnswer((_) async => Right(posts));

      await cubit.fetchPosts();

      final state = cubit.state;
      expect(state, isA<PostLoaded>());
      if (state is PostLoaded) {
        expect(state.posts.length, 4);
        expect(state.posts[0].id, 1);
        expect(state.posts[2].id, 1);
      }
    });

    test(
      'should maintain pagination state correctly across multiple fetches',
      () async {
        // First page
        when(
          () => repository.fetchPosts(start: 0, limit: 10),
        ).thenAnswer((_) async => Right(posts));
        await cubit.fetchPosts();

        // Second page
        when(
          () => repository.fetchPosts(start: 10, limit: 10),
        ).thenAnswer((_) async => Right(posts));
        await cubit.fetchPosts();

        // Third page
        when(
          () => repository.fetchPosts(start: 20, limit: 10),
        ).thenAnswer((_) async => Right(posts));
        await cubit.fetchPosts();

        verify(() => repository.fetchPosts(start: 0, limit: 10)).called(1);
        verify(() => repository.fetchPosts(start: 10, limit: 10)).called(1);
        verify(() => repository.fetchPosts(start: 20, limit: 10)).called(1);
      },
    );
  });
}
