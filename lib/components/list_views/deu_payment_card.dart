import 'package:flutter/material.dart';

class DeuPaymentCard extends StatelessWidget {

  final String cardCount;

  const DeuPaymentCard({super.key, required this.cardCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.money_rounded),
        title: Text('Deu payment card $cardCount'),
        subtitle: Text('This is subtitle is deu payment card'),
      ),
    );
  }
}