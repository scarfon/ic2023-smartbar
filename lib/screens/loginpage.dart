import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartbar/services/auth.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showCadastro;
  const LoginPage({super.key, required this.showCadastro});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Bem Vindo ao SmartBar!'),
                const Text('Faça seu login para continuar:'),
                Container(
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(hintText: 'Email'),
                  ),
                ),
                Container(
                  child: TextField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: const InputDecoration(hintText: 'Senha'),
                  ),
                ),
                GestureDetector(
                    onTap: signIn, child: Container(child: Text('Login'))),
                GestureDetector(
                    onTap: widget.showCadastro,
                    child: Container(child: Text('Cadastro'))),
                Container(child: Text(errorMessage ?? '')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
