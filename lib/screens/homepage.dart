import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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

  final ref = FirebaseDatabase.instance.ref();

  bool? _copo, _bomba1, _bomba2, _bomba3, _bomba4;

  late StreamSubscription _copoS, _bomba1S, _bomba2S, _bomba3S, _bomba4S;

  void _listener() {
    _copoS = ref.child('copo').onValue.listen((event) {
      setState(() {
        _copo = event.snapshot.value as bool;
      });
    });
    _bomba1S = ref.child('bomba1').onValue.listen((event) {
      setState(() {
        _bomba1 = event.snapshot.value as bool;
      });
    });
    _bomba2S = ref.child('bomba2').onValue.listen((event) {
      setState(() {
        _bomba2 = event.snapshot.value as bool;
      });
    });
    _bomba3S = ref.child('bomba3').onValue.listen((event) {
      setState(() {
        _bomba3 = event.snapshot.value as bool;
      });
    });
    _bomba4S = ref.child('bomba4').onValue.listen((event) {
      setState(() {
        _bomba4 = event.snapshot.value as bool;
      });
    });
  }

  Future getDrinksIs() async {
    _drinksId.clear();
    await FirebaseFirestore.instance
        .collection('drinks')
        .get()
        .then((snapshot) => snapshot.docs.forEach((drink) {
              _drinksId.add(drink.reference.id);
            }));
  }

  Future getDrinks() async {
    _drinks.clear();
    for (var element in _drinksId) {
      FirebaseFirestore.instance
          .collection('drinks')
          .doc(element)
          .get()
          .then((value) => _drinks.add(value.data() as Map<String, dynamic>));
    }
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
  void initState() {
    super.initState();
    _listener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(children: [
            Text(user!.email!),
            ElevatedButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              child: const Text("Log Out"),
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
            ),
            ElevatedButton(
              onPressed: () {
                ref.child('copo').set(true);
              },
              child: const Text("Copo"),
            ),
            Text("${_copo ?? ""}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ref.child('bomba1').set(true);
                      },
                      child: const Text("Bomba 1"),
                    ),
                    Text("${_bomba1 ?? ""}")
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ref.child('bomba2').set(true);
                      },
                      child: const Text("Bomba 2"),
                    ),
                    Text("${_bomba2 ?? ""}")
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ref.child('bomba3').set(true);
                      },
                      child: const Text("Bomba 3"),
                    ),
                    Text("${_bomba3 ?? ""}")
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ref.child('bomba4').set(true);
                      },
                      child: const Text("Bomba 4"),
                    ),
                    Text("${_bomba4 ?? ""}")
                  ],
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
