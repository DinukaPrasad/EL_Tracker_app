import 'package:flutter/material.dart';

class ExpenseCard extends StatelessWidget {

  final String cardCount;
  const ExpenseCard({super.key, required this.cardCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on_outlined),
        title: Text('This is title of expenses card $cardCount'),
        subtitle: Text('This is subtitle of expenses card'),
      ),
    );
  }
}