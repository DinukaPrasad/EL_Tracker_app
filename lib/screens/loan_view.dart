import 'package:flutter/material.dart';

class LoanView extends StatefulWidget {
  const LoanView({super.key});

  @override
  State<LoanView> createState() => _LoanViewState();
}

class _LoanViewState extends State<LoanView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        //* Headline   
        Text('Add Loan'),

        // todo: implements other components here

      ],
    );
  }
}