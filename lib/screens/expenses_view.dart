import 'package:eltracker_app/widgets/expense_card.dart';
import 'package:flutter/material.dart';

class ExpensesView extends StatefulWidget {
  const ExpensesView({super.key});

  @override
  State<ExpensesView> createState() => _ExpensesViewState();
}

class _ExpensesViewState extends State<ExpensesView> {

  final List expensesCards = ['1','2','3','4','5'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //* headline
            Text(
              'Expenses Summary',
            ),
            SizedBox(
              height: 20,
            ),

            //* Summary chart
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(10)
              ),
            ),
            SizedBox(
              height: 20,
            ),

            //* headline (Expenses)
            Text(
              'Top Expenses',
            ),
            SizedBox(
              height: 20,
            ),

            //* Expense list view
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: expensesCards.length,
                itemBuilder: (context , index){
                  
                  return ExpenseCard(cardCount: expensesCards[index],);
                },
                ),
            ),
          ],
        ),
      ),
      );
  }
}