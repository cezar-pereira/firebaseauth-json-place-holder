import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../modules/auth/auth.dart';
import '../../core.dart';

class PhotoUser extends StatefulWidget {
  const PhotoUser({super.key, this.radius = 20});
  final double radius;

  @override
  State<PhotoUser> createState() => PhotoUserState();
}

class PhotoUserState extends State<PhotoUser> {
  final _cubit = AppInject.get<AuthNotifier>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthNotifier, AuthState>(
      bloc: _cubit,
      builder: (context, state) {
        return switch (state) {
          AuthAuthenticated(:final user) => CircleAvatar(
            radius: widget.radius,
            backgroundImage: NetworkImage(
              user.photoUrl ?? 'https://randomuser.me/api/portraits/men/1.jpg',
            ),
          ),
          _ => SizedBox.shrink(),
        };
      },
    );
  }
}
