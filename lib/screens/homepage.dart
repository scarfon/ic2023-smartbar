import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartbar/services/auth.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = Auth().currentuser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text("SMART BAR HOME");
  }

  Widget _userid() {
    return Text(user?.email ?? "user email");
  }

  Widget _logoutButton() {
    return ElevatedButton(
      onPressed: () {
        signOut();
      },
      child: const Text("Logout"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Center(
        child: Column(
          children: [
            _userid(),
            _logoutButton(),
          ],
        ),
      ),
    );
  }
}
