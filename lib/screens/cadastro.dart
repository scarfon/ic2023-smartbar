import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CadastroPage extends StatefulWidget {
  final VoidCallback showLogin;
  const CadastroPage({super.key, required this.showLogin});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  String? errorMessage = '';
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _dataController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _sobrenomeController.dispose();
    _dataController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future signUp() async {
    try {
      if (validarUsuario()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        await agregarUsuario();
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  bool validarUsuario() {
    if (_nomeController.text.trim().isEmpty) {
      setState(() {
        errorMessage = 'Nome não pode ser vazio';
      });
      return false;
    }
    if (_sobrenomeController.text.trim().isEmpty) {
      setState(() {
        errorMessage = 'Sobrenome não pode ser vazio';
      });
      return false;
    }
    if (_dataController.text.trim().isEmpty) {
      setState(() {
        errorMessage = 'Data de Nascimento não pode ser vazio';
      });
      return false;
    }
    // tem que ser maior de 18 anos
    if (DateTime.now()
            .difference(DateTime.parse(_dataController.text.trim()))
            .inDays <
        6570) {
      setState(() {
        errorMessage = 'Você tem que ser maior de 18 anos';
      });
      return false;
    }
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        errorMessage = 'Email não pode ser vazio';
      });
      return false;
    }
    if (_passwordController.text.trim().isEmpty) {
      setState(() {
        errorMessage = 'Senha não pode ser vazio';
      });
      return false;
    }
    return true;
  }

  Future agregarUsuario() async {
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'nome': _nomeController.text.trim(),
      'sobrenome': _sobrenomeController.text.trim(),
      'data': _dataController.text.trim(),
      'email': _emailController.text.trim(),
    });
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
                const Text('Faça seu cadastro para continuar:'),
                Container(
                  child: TextField(
                    controller: _nomeController,
                    decoration: const InputDecoration(hintText: 'Nome'),
                  ),
                ),
                Container(
                  child: TextField(
                    controller: _sobrenomeController,
                    decoration: const InputDecoration(hintText: 'Sobrenome'),
                  ),
                ),
                Container(
                  child: TextField(
                    controller: _dataController,
                    decoration:
                        const InputDecoration(hintText: 'Data de Nascimento'),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now());
                      if (pickedDate != null) {
                        print(pickedDate);
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        _dataController.text = formattedDate;
                      } else {
                        print("Date is not selected");
                      }
                    },
                  ),
                ),
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
                    onTap: signUp, child: Container(child: Text('Login'))),
                GestureDetector(
                    onTap: widget.showLogin,
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
