import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oauth_json_place_holder/app_module.dart';
import 'package:oauth_json_place_holder/core/extensions/ext_string.dart';
import 'package:oauth_json_place_holder/modules/modules.dart';
import 'package:oauth_json_place_holder/shared_module.dart';

import '../../mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late MockPostRepository mockPostRepository;
  final firstPagePosts = List.generate(
    10,
    (index) => PostModel(
      userId: index + 1,
      id: index + 1,
      title: 'Título do Post',
      body: index == 0
          ? 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.'
          : 'Corpo do post.',
    ),
  );

  final secondPagePosts = List.generate(
    10,
    (index) => PostModel(
      userId: index + 11,
      id: index + 11,
      title: 'Título do Post',
      body: 'Corpo do post.',
    ),
  );

  setUp(() {
    mockPostRepository = MockPostRepository();
    final MockFirebaseAuth mockAuth = MockFirebaseAuth();
    Modular.bindModule(AppModule(authFirebase: mockAuth));
    Modular.bindModule(SharedModule(authFirebase: mockAuth));
    Modular.bindModule(AuthModule(authFirebase: mockAuth));
    Modular.replaceInstance<PostRepository>(mockPostRepository);
  });

  tearDown(() async {
    reset(mockPostRepository);
  });

  Future<void> pumpPostsPageWithCubit(WidgetTester tester) async {
    final postCubit = PostCubit(mockPostRepository);
    Modular.replaceInstance<PostCubit>(postCubit);
    await tester.pumpWidget(const MaterialApp(home: PostsPage()));
    await tester.pumpAndSettle();
  }

  testWidgets('Should load first page of posts successfully', (
    WidgetTester tester,
  ) async {
    when(
      () => mockPostRepository.fetchPosts(start: 0, limit: 10),
    ).thenAnswer((_) async => Right(firstPagePosts));

    await pumpPostsPageWithCubit(tester);

    expect(find.text('1 - ${firstPagePosts[0].title}'), findsOneWidget);
    expect(find.text('2 - ${firstPagePosts[1].title}'), findsOneWidget);
    expect(find.text('LIST POSTS'), findsOneWidget);
  });

  testWidgets('Should load more posts when performing infinite scroll', (
    WidgetTester tester,
  ) async {
    when(
      () => mockPostRepository.fetchPosts(start: 0, limit: 10),
    ).thenAnswer((_) async => Right(firstPagePosts));

    when(() => mockPostRepository.fetchPosts(start: 10, limit: 10)).thenAnswer((
      _,
    ) async {
      await Future.delayed(const Duration(seconds: 1));
      return Right(secondPagePosts);
    });

    await pumpPostsPageWithCubit(tester);

    expect(find.text('1 - ${firstPagePosts[0].title}'), findsOneWidget);

    final listView = find.byType(ListView);
    expect(listView, findsOneWidget);

    await tester.dragUntilVisible(
      find.byKey(PostPageKeys.btnLoadingMorePost),
      listView,
      Offset(0, -300),
    );
    await tester.pumpAndSettle();

    expect(find.text('11 - ${secondPagePosts[0].title}'), findsOneWidget);

    verify(() => mockPostRepository.fetchPosts(start: 0, limit: 10)).called(1);
    verify(() => mockPostRepository.fetchPosts(start: 10, limit: 10)).called(1);
  });

  testWidgets('Should expand and collapse long post when clicking "Ver mais"', (
    WidgetTester tester,
  ) async {
    when(
      () => mockPostRepository.fetchPosts(start: 0, limit: 10),
    ).thenAnswer((_) async => Right(firstPagePosts));

    await pumpPostsPageWithCubit(tester);

    final truncated = find.text(firstPagePosts[0].body.trunctPostBody(100));
    expect(truncated, findsOneWidget);
    expect(find.text('Ver mais'), findsOneWidget);

    final btnExpanded = find.byKey(Key("expandPost-1"));
    expect(btnExpanded, findsOneWidget);

    await tester.tap(btnExpanded);
    await tester.pumpAndSettle();

    expect(find.text('Ver menos'), findsOneWidget);
    final normalBody = find.text(firstPagePosts[0].body);
    expect(normalBody, findsOneWidget);

    expect(find.text('LIST POSTS'), findsOneWidget);
  });

  testWidgets('Should show message when there are no posts', (
    WidgetTester tester,
  ) async {
    when(
      () => mockPostRepository.fetchPosts(start: 0, limit: 10),
    ).thenAnswer((_) async => Right([]));

    await pumpPostsPageWithCubit(tester);

    expect(find.byKey(PostPageKeys.pageEmptyPost), findsOneWidget);
  });

  testWidgets('Should show error message when failing to load posts', (
    WidgetTester tester,
  ) async {
    when(
      () => mockPostRepository.fetchPosts(start: 0, limit: 10),
    ).thenAnswer((_) async => Left(PostErrorFailure('Erro ao carregar posts')));

    await pumpPostsPageWithCubit(tester);

    expect(find.byKey(PostPageKeys.pageErrorPost), findsOneWidget);
    expect(find.byKey(PostPageKeys.btnTryAgainPost), findsOneWidget);
  });

  testWidgets(
    'Should call fetchPosts again when clicking PostPageKeys.btnTryAgainPost',
    (WidgetTester tester) async {
      when(() => mockPostRepository.fetchPosts(start: 0, limit: 10)).thenAnswer(
        (_) async => Left(PostErrorFailure('Erro ao carregar posts')),
      );

      await pumpPostsPageWithCubit(tester);

      expect(find.byKey(PostPageKeys.pageErrorPost), findsOneWidget);
      expect(find.byKey(PostPageKeys.btnTryAgainPost), findsOneWidget);

      await tester.tap(find.byKey(PostPageKeys.btnTryAgainPost));

      when(
        () => mockPostRepository.fetchPosts(start: 0, limit: 10),
      ).thenAnswer((_) async => Right(firstPagePosts));

      verify(
        () => mockPostRepository.fetchPosts(start: 0, limit: 10),
      ).called(2);
    },
  );
}
