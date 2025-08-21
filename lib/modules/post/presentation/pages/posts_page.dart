import 'package:flutter/material.dart';
import 'package:oauth_json_place_holder/core/utils/app_inject.dart';

import '../../../auth/auth.dart';
import 'keys/post_page_keys.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LIST POSTS'),

        actions: [
          TextButton(
            key: PostPageKeys.btnLogout,
            onPressed: () {
              final logout = AppInject.get<LogoutCubit>();
              logout.logout();
            },
            child: Text('Sair'),
          ),
        ],
      ),
      body: Container(),
    );
  }
}
