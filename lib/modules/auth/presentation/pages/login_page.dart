import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../post/post.dart';
import '../../auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailEC = TextEditingController(text: '');
  final _passwordEC = TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();
  final _cubit = AppInject.get<LoginCubit>();
  final _cubitAuthNotifier = AppInject.get<AuthNotifier>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    _cubit.close();
    _cubitAuthNotifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                _cubitAuthNotifier.authenticate(state.user);
                AppNavigator.navigate(PostRoutes.posts);
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          spacing: 20,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              key: LoginPageKeys.txtEmail,
                              controller: _emailEC,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hint: Text('Digite o seu E-mail'),
                                label: Text('E-mail'),
                              ),
                              validator: (value) {
                                return [
                                  RequiredValidator(),
                                  EmailValidator(),
                                ].validate(value);
                              },
                            ),
                            TextFormField(
                              key: LoginPageKeys.txtPassword,
                              controller: _passwordEC,
                              decoration: InputDecoration(
                                hint: Text('Digite a sua Senha'),
                                label: Text('Senha'),
                              ),
                              validator: (value) {
                                return [
                                  RequiredValidator(),
                                  QuantityMinimumValidator(
                                    minimum: 6,
                                    field: 'Senha',
                                  ),
                                ].validate(value);
                              },
                            ),

                            _ErrorsStateWidget(state),
                          ],
                        ),
                      ),
                    ),
                  ),
                  FilledButton.icon(
                    key: LoginPageKeys.btnLogin,
                    icon: state is LoginLoading
                        ? const CircularProgressIndicator.adaptive(
                            backgroundColor: Colors.white,
                          )
                        : null,
                    onPressed: () {
                      final valid = _formKey.currentState?.validate();
                      if (valid == true) {
                        _cubit.login(
                          email: _emailEC.text,
                          password: _passwordEC.text,
                        );
                      }
                    },
                    label: Text('Login'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ErrorsStateWidget extends StatelessWidget {
  const _ErrorsStateWidget(this.state);

  final LoginState state;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      LoginError(:final message) => Center(child: Text(message)),
      ManyFailedLoginAttempts() => Center(
        child: Text('Temporáriamente bloqueado, tente novamente mais tarde.'),
      ),
      Unauthorized() ||
      InvalidEmail() => Center(child: Text('E-mail e/ou senha incorretos')),
      UserDisabled() => Center(child: Text('Usuário desabilitado')),
      EmailNotVerified() => Center(child: Text('E-mail não verificado')),
      _ => const SizedBox.shrink(),
    };
  }
}
