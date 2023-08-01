import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetDrinks extends StatelessWidget {
  final String drinkId;
  const GetDrinks({super.key, required this.drinkId});

  @override
  Widget build(BuildContext context) {
    CollectionReference drinks =
        FirebaseFirestore.instance.collection('drinks');
    return FutureBuilder(
      future: drinks.doc(drinkId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            children: [
              Text(data['desc']),
              Text(data['ingrediente'][0].toString()),
              Text(data['nome']),
              Text(data['sabor']),
            ],
          );
        }
        return const Text("Carregando");
      },
    );
  }
}
