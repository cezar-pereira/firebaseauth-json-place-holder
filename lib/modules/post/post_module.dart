import 'package:flutter_modular/flutter_modular.dart';

import 'post.dart';

class PostModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(PostRoutes.posts, child: (_) => const PostsPage());
    r.child(PostRoutes.postDetails, child: (_) => const PostDetailsPage());
  }
}
