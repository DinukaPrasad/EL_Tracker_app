import 'package:flutter/material.dart';
import 'package:eltracker_app/models/loan_modal.dart';

class LoanCard extends StatelessWidget {
  final LoanModal loan;

  const LoanCard({super.key, required this.loan});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        title: Text('${loan.clientId}'),
        subtitle: Row(
          children: [
            Text('${loan.amount}'),
            Text('Receive Date: ${loan.receiveDate.toString().split(' ')[0]}'),
          ],
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: Icon(Icons.delete, color: Colors.red),
        ),
      ),
    );
  }
}
