import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oauth_json_place_holder/core/extensions/ext_scroll_controller.dart';

import '../../../../core/core.dart';
import '../../../auth/auth.dart';
import '../../post.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final ScrollController _scrollController = ScrollController();

  final _cubit = AppInject.get<PostCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.fetchPosts();

    _scrollController.onEndReached(() {
      final state = _cubit.state;
      if (state is PostLoaded && state.hasMore) {
        _cubit.fetchPosts();
      }
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LIST POSTS'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => AppNavigator.pushNamed(AuthRoutes.userDetails),
              child: PhotoUser(),
            ),
          ),
        ],
      ),
      body: BlocBuilder<PostCubit, PostState>(
        bloc: _cubit,

        builder: (context, state) {
          return switch (state) {
            PostLoading() || PostInitial() => Center(
              child: CircularProgressIndicator.adaptive(),
            ),

            PostEmpty() => _PostsPageStateEmpty(),
            PostError() => _PostsPageStateError(_cubit.fetchPosts),
            PostLoaded() => ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              controller: _scrollController,
              itemCount: state.posts.length + (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.posts.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      key: PostPageKeys.loadingMorePost,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return _PostItem(post: state.posts[index]);
              },
            ),
          };
        },
      ),
    );
  }
}

class _PostsPageStateError extends StatelessWidget {
  const _PostsPageStateError(this.onRetry);
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      key: PostPageKeys.pageErrorPost,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Ocorreu um erro'),
          TextButton(
            key: PostPageKeys.btnTryAgainPost,
            onPressed: onRetry,
            child: Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}

class _PostsPageStateEmpty extends StatelessWidget {
  const _PostsPageStateEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      key: PostPageKeys.pageEmptyPost,
      child: Text('Nenhum post encontrado'),
    );
  }
}

class _PostItem extends StatefulWidget {
  const _PostItem({required this.post});

  final PostModel post;

  @override
  State<_PostItem> createState() => __PostItemState();
}

class __PostItemState extends State<_PostItem> {
  bool isExpanded = false;
  int maxLength = 100;

  @override
  Widget build(BuildContext context) {
    final body = widget.post.body;

    final truncated = !isExpanded ? body.trunctPostBody(maxLength) : body;

    return InkWell(
      onTap: () => AppNavigator.pushNamed(
        PostRoutes.postDetails,
        arguments: widget.post,
      ),
      child: ListTile(
        title: Text(
          '${widget.post.id} - ${widget.post.title}',
          style: context.textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(truncated, textAlign: TextAlign.justify),
            if (body.length > maxLength)
              TextButton(
                key: Key("expandPost-${widget.post.id}"),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Text(isExpanded ? "Ver menos" : "Ver mais"),
              ),
          ],
        ),
      ),
    );
  }
}
