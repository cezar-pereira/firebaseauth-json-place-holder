import 'package:flutter_modular/flutter_modular.dart';

import '../../shared_module.dart';
import 'post.dart';

class PostModule extends Module {
  @override
  List<Module> get imports => [SharedModule()];

  @override
  void binds(i) {
    /* DATASOURCE */
    i.addLazySingleton<PostDatasource>(PostDatasourceImp.new);
    /* REPOSITORIES */
    i.addLazySingleton<PostRepository>(PostRepositoryImp.new);
    /* SERVICES */
    /* USECASES */
    /* CUBITS */
    i.add<PostCubit>(PostCubit.new);
    i.add<PostAuthorCubit>(PostAuthorCubit.new);
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(PostRoutes.posts, child: (_) => const PostsPage());
    r.child(
      PostRoutes.postDetails,
      child: (_) => PostDetailsPage(post: r.args.data),
    );
  }
}
