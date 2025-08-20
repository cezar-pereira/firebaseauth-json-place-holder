import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hint: Text('Digite o seu E-mail'),
                label: Text('E-mail'),
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                hint: Text('Digite a sua Senha'),
                label: Text('Senha'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
