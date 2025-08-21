import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oauth_json_place_holder/core/core.dart';

import 'modules/modules.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final theme = AppTheme.lightTheme;

  final _authNotifier = AppInject.get<AuthNotifier>();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _authNotifier.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute(AuthRoutes.splash);

    return BlocProvider(
      create: (_) => _authNotifier,
      child: BlocListener<AuthNotifier, AuthState>(
        listener: (context, state) {
          switch (state) {
            case AuthInitial():
            case AuthLoading():
            case AuthFailure():
              dev.log('AUTH: $state');
            case AuthUnauthenticated():
              AppNavigator.navigate(AuthRoutes.login);
            case AuthAuthenticated():
              AppNavigator.navigate(PostRoutes.posts);
          }
        },
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'OAuth',
          theme: theme,
          routeInformationParser: Modular.routeInformationParser,
          routerDelegate: Modular.routerDelegate,
        ),
      ),
    );
  }
}
