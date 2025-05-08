import 'package:eltracker_app/screens/client_management.dart';
import 'package:eltracker_app/screens/expenses_view.dart';
import 'package:eltracker_app/screens/dashboard_view.dart';
import 'package:eltracker_app/screens/loan_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi,${widget.username}'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ClientManagementScreen(),
                ),
              );
            },
            icon: Icon(Icons.person_add),
            tooltip: 'Client management',
          ),
          IconButton(
            onPressed: () {},
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
            selectedIcon: Icon(Icons.dashboard),
            icon: Icon(Icons.dashboard_customize_outlined),
            label: 'Dashboard',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.wallet),
            icon: Icon(Icons.wallet_giftcard),
            label: 'Expenses',
          ),
        ],
      ),

      body:
          <Widget>[
            LoanView(),
            DashboardView(),
            ExpensesView(),
          ][currentPageIndex],
    );
  }
}
