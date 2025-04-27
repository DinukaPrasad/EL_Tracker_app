import 'package:eltracker_app/widgets/payment_card.dart';
import 'package:flutter/material.dart';

class LoanView extends StatefulWidget {
  const LoanView({super.key});

  @override
  State<LoanView> createState() => _LoanViewState();
}

class _LoanViewState extends State<LoanView> {

  //* controller for text fields 
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();


  String? _selectedClient;
  bool _pendingChecked = true;
  bool _paidChecked = true;
  DateTime? _receiveDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _receiveDate ?? DateTime.now(),
      firstDate: DateTime.now(), 
      lastDate: DateTime(2100),
      );

      if(picked != null && picked != _receiveDate){
        setState(() {
          _receiveDate = picked;
        });
      }
  }

  //* loan list

  final List loanList = ['1','2','3','4','5','6','7'];


  @override
  void dispose() {
    _amountController.dispose();
    _interestController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20 , right: 20),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            //* Headline   
            Text('Add Loan'),
        
            //* Input area
            Column(
              children: [
                Row(
                  children: [
                    Text('Clint Name :'),
        
                    DropdownMenu(
                      label: const Text('Select client'),
                      leadingIcon: Icon(Icons.search),
                      width: 250,
                      menuHeight: 100.00,   //! set menu hight
                      enableFilter: true,
        
                      dropdownMenuEntries: <DropdownMenuEntry<String>>[
                        DropdownMenuEntry(value: 'Dinuka', label: 'Dinuka'),
                        DropdownMenuEntry(value: 'Shaki', label: 'Shaki'),
                        DropdownMenuEntry(value: 'Henzer', label: 'Henzer'),
                      ],
        
                      onSelected: (String? value){
                        _selectedClient = value;
        
                        // ignore: avoid_print
                        print(_selectedClient);
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Amount :'),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Enter Amount',
                          hintText: '1000',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Interest :'),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Enter Interest',
                          hintText: '10',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Receive Date :'),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: ()=>  _selectDate(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          alignment: Alignment.centerLeft,
                        ),
                        child: Text(
                          _receiveDate == null
                          ? 'Select Date'
                          : '${_receiveDate!.day}/${_receiveDate!.month}/${_receiveDate!.year}',
                        )
                        ),
                    )
                  ],
                ),
                
                Row(
                  children: [
                    Text('Reason :'),
                    Expanded(
                      child: TextField( 
                        decoration: InputDecoration(
                          labelText: 'Enter Reason',
                          hintText: 'For Emergency',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ],
                ),
        
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: (){}, 
                      child: Text('Clear')
                    ),
                    ElevatedButton(
                      onPressed: (){}, 
                      child: Text('Submit')
                    ),         
                  ],
                ),
              ],
            ),
        
            //*Loan list headline
            Text('Loan List'),
        
            //* checkbox List area
            Row(
              children: [
                // todo: add 2 check box for filter loans by loan status (named pending and paid) 
                //! use checkboxListTile for this
        
                // Expanded(
                //   child: TextField( 
                //     decoration: InputDecoration(
                //         labelText: 'Search',
                //         border: OutlineInputBorder(),
                //         contentPadding: EdgeInsets.symmetric(horizontal: 10),
                //       ),
                //     keyboardType: TextInputType.text,    
                //   ),
                // ),
            
                Expanded(
                  child: CheckboxListTile(
                    title: Text('Pending'),
                    value: _pendingChecked,
                    onChanged: (bool? value){
                      setState(() {
                        _pendingChecked = value!;
                      });
                    },
                            
                  ),
                ),
        
                Expanded(
                  child: CheckboxListTile(
                    title: Text('paid'),
                    value: _paidChecked,
                    onChanged: (bool? value){
                      setState(() {
                        _paidChecked = value!;
                      });
                    },
                            
                  ),
                ),
              ],
            ),
        
            //*list view
            SizedBox(
              height: 250,
              child: ListView.builder(
                itemCount: loanList.length,
                itemBuilder: (context , index){
                  return DeuPaymentCard(cardCount: loanList[index],); 
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}