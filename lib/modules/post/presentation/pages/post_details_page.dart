import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oauth_json_place_holder/core/core.dart';
import 'package:oauth_json_place_holder/modules/modules.dart';

class PostDetailsPage extends StatefulWidget {
  const PostDetailsPage({super.key, required this.post});
  final PostModel post;

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('POSTS DETAILS')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(widget.post.body),
            const SizedBox(height: 20),
            _PostAuthorWidget(userId: widget.post.userId),
          ],
        ),
      ),
    );
  }
}

class _PostAuthorWidget extends StatefulWidget {
  const _PostAuthorWidget({required this.userId});
  final int userId;

  @override
  State<_PostAuthorWidget> createState() => _PostAuthorWidgetState();
}

class _PostAuthorWidgetState extends State<_PostAuthorWidget> {
  final _cubit = AppInject.get<PostAuthorCubit>();

  @override
  void initState() {
    _fetchAuthor();
    super.initState();
  }

  void _fetchAuthor() {
    _cubit.fetchAuthor(widget.userId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostAuthorCubit, PostAuthorState>(
      bloc: _cubit,
      builder: (context, state) {
        switch (state) {
          case PostAuthorInitial():
            return const SizedBox();
          case PostAuthorLoading():
            return const Row(
              children: [
                SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text("Carregando autor..."),
              ],
            );

          case PostAuthorLoaded(:final author):
            return Text("Autor: ${author.name}");

          case PostAuthorError(:final message):
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Erro ao carregar autor: $message",
                    style: TextStyle(color: Colors.red),
                  ),

                  TextButton(
                    onPressed: _fetchAuthor,
                    child: Text('Tentar novamente'),
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}
