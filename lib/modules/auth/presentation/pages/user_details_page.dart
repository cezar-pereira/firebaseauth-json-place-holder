import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../auth.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final _cubitAuthNotifier = AppInject.get<AuthNotifier>();

  @override
  void dispose() {
    _cubitAuthNotifier.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UserDetails'),
        actions: [_ButtonExit()],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: PhotoUser(radius: 50)),
          const SizedBox(height: 20),
          BlocBuilder<AuthNotifier, AuthState>(
            bloc: _cubitAuthNotifier,
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('E-mail: ${state.user.email ?? '-'}'),
                    Text('Nome: ${state.user.name ?? '-'}'),
                  ],
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ButtonExit extends StatefulWidget {
  const _ButtonExit();

  @override
  State<_ButtonExit> createState() => _ButtonExitState();
}

class _ButtonExitState extends State<_ButtonExit> {
  final logout = AppInject.get<LogoutCubit>();
  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: LoginPageKeys.btnLogout,
      onPressed: logout.logout,
      child: Text('Sair'),
    );
  }
}
