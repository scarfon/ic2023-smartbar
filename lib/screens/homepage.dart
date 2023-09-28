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

  final List<String> _possiveisCombinacoes = [
    //only colors Verde, Amarelo, Vermelho, Laranja
    "Verde 1 oz, Amarelo 3 oz",
    "Verde 2 oz, Vermelho 1 oz",
    "Verde 2 oz, Laranja 1 oz, Vermelho 1 oz",
    "Verde 3 oz, Vermelho 2 oz",
    "Amarelo 1 oz, Vermelho 1 oz",
    "Amarelo 1 oz, Laranja 1 oz, Vermelho 2 oz",
    "Laanra 1 oz, Vermelho 1 oz",
    "Laranja 1 oz, Vermelho 2 oz",
  ];

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
      appBar: AppBar(
        title: const Text("SmartBar"),
        actions: [
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                height: 75,
              ),
              const Text(
                "Teste de Funcionalidade SmartBar (Beta)",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  ref.child('copo').set(true);
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                  primary: Colors.blue,
                ),
                child: Column(
                  children: const [
                    Icon(
                      Icons.local_drink,
                      size: 50,
                      color: Colors.white,
                    ),
                    Text(
                      "Copo",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Text("${_copo ?? ""}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ref.child('bomba1').set(true);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      primary: Colors.green,
                    ),
                    child: Column(
                      children: const [
                        Icon(
                          Icons.water,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          "1",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref.child('bomba2').set(true);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      primary: Colors.yellow,
                    ),
                    child: Column(
                      children: const [
                        Icon(
                          Icons.water,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          "2",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref.child('bomba3').set(true);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      primary: Colors.red,
                    ),
                    child: Column(
                      children: const [
                        Icon(
                          Icons.water,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          "3",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref.child('bomba4').set(true);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      primary: Colors.orange,
                    ),
                    child: Column(
                      children: const [
                        Icon(
                          Icons.water,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          "4",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Status do Firebase",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(
                        height: 20,
                        thickness: 3,
                      ),
                      Text(
                        _copo != null ? "Copo $_copo" : "",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        _bomba1 != null ? "Bomba 1 $_bomba1" : "",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        _bomba2 != null ? "Bomba 2 $_bomba2" : "",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        _bomba3 != null ? "Bomba 3 $_bomba3" : "",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        _bomba4 != null ? "Bomba 4 $_bomba4" : "",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(
                        height: 20,
                        thickness: 3,
                      ),
                      const Text(
                        "Possíveis combinações:",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(
                        height: 20,
                        thickness: 3,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _possiveisCombinacoes.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: Text(
                                _possiveisCombinacoes[index],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

 // Expanded(
              //   child: FutureBuilder(
              //     future: getDrinksIs(),
              //     builder: (context, snapshot) {
              //       return ListView.builder(
              //         itemCount: _drinksId.length,
              //         itemBuilder: (context, index) {
              //           return GetDrinks(drinkId: _drinksId[index]);
              //         },
              //       );
              //     },
              //   ),
              // ),
