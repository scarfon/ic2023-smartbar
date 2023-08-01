import 'package:flutter/material.dart';
import 'package:smartbar/screens/cadastro.dart';
import 'package:smartbar/screens/loginpage.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  void toggleScreen() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return LoginPage(
        showCadastro: toggleScreen,
      );
    } else {
      return CadastroPage(
        showLogin: toggleScreen,
      );
    }
  }
}
