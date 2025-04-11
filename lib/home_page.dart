import 'package:eltracker_app/screens/expenses_view.dart';
import 'package:eltracker_app/screens/home_view.dart';
import 'package:eltracker_app/screens/loan_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, Username'),
        actions: <Widget>[
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.person_add),
            tooltip: 'Add new client details',
           ),
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.shopping_cart),
            tooltip: 'Cart',
           ),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.monetization_on),
            icon: Icon(Icons.monetization_on_outlined),
            label: 'Loan',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.wallet),
            icon: Icon(Icons.wallet_giftcard),
            label: 'Expenses',
          ),
        ],
      ),

      body: <Widget>[
        LoanView(),
        HomePageView(),
        ExpensesView(),
      ][currentPageIndex],
    );
  }
}