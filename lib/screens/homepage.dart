import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartbar/data/get_drinks.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = FirebaseAuth.instance.currentUser;

  List<String> _drinksId = [];
  List<Map<String, dynamic>> _drinks = [];

  Future getDrinksIs() async {
    await FirebaseFirestore.instance
        .collection('drinks')
        .get()
        .then((snapshot) => snapshot.docs.forEach((drink) {
              _drinksId.add(drink.reference.id);
            }));
  }

  Future getDrinks() async {
    _drinksId.forEach((element) {
      FirebaseFirestore.instance
          .collection('drinks')
          .doc(element)
          .get()
          .then((value) => _drinks.add(value.data() as Map<String, dynamic>));
    });
  }

  final CollectionReference drinks =
      FirebaseFirestore.instance.collection('drinks');
  String? title;

  Future<Widget> _title() async {
    print("object");
    final snapshot = await drinks.get();
    final data = snapshot.docs.first.data() as Map<String, dynamic>;
    title = data['desc'];
    return Text(title ?? "title");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(children: [
            Text(user!.email!),
            ElevatedButton(
              onPressed: () => print(_drinksId),
              child: Text("hols"),
            ),
            Expanded(
              child: FutureBuilder(
                future: getDrinksIs(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: _drinksId.length,
                    itemBuilder: (context, index) {
                      return GetDrinks(drinkId: _drinksId[index]);
                    },
                  );
                },
              ),
            )
          ]),
        ),
      ),
    );
  }
}
