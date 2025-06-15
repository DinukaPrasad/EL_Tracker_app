import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eltracker_app/controller/client_service.dart';
import 'package:eltracker_app/controller/loan_service.dart';
import 'package:eltracker_app/models/client_modal.dart';
import 'package:eltracker_app/models/loan_modal.dart';
import 'package:eltracker_app/widgets/loan_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoanView extends StatefulWidget {
  const LoanView({super.key});

  @override
  State<LoanView> createState() => _LoanViewState();
}

class _LoanViewState extends State<LoanView> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  final LoanService _loanService = LoanService();
  final ClientService _clientService = ClientService();

  String? _selectedClient;
  bool _pendingChecked = true;
  bool _paidChecked = true;
  DateTime? _receiveDate;
  // ignore: unused_field
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _receiveDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );

    if (picked != null && picked != _receiveDate) {
      setState(() {
        _receiveDate = picked;
      });
    }
  }

  Future<void> _submitLoan() async {
    // Validate all fields before proceeding
    if (_amountController.text.isEmpty ||
        _interestController.text.isEmpty ||
        _reasonController.text.isEmpty ||
        _receiveDate == null ||
        _selectedClient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Parse numeric values with error handling
    int? amount;
    int? interest;
    try {
      amount = int.parse(_amountController.text);
      interest = int.parse(_interestController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid numbers for amount and interest'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate amount and interest values
    if (amount <= 0 || interest < 0 || interest > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Amount must be positive and interest cannot be negative',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final newLoan = LoanModal(
        amount: amount,
        interest: interest,
        clientId: _selectedClient!,
        reason: _reasonController.text,
        receiveDate: _receiveDate!,
      );

      await _loanService.addLoan(newLoan);

      // Clear form after successful submission
      _amountController.clear();
      _interestController.clear();
      _reasonController.clear();
      setState(() {
        _receiveDate = null;
        _selectedClient = null;
        _isLoading = false;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Loan added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add loan: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _interestController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and action buttons
              _buildHeader(),

              const SizedBox(height: 24),

              // Input card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildInputForm(),
                ),
              ),

              const SizedBox(height: 24),

              // Loan list section
              _buildLoanListSection(),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Add Loan',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildInputForm() {
    return Column(
      children: [
        _buildFormField(
          label: 'Client Name',
          child: StreamBuilder<QuerySnapshot<ClientModal>>(
            stream: _clientService.getClients(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final clients = snapshot.data?.docs ?? [];

              if (clients.isEmpty) {
                return const Center(child: Text('No Clients found'));
              }

              return DropdownMenu(
                initialSelection: _selectedClient,
                label: const Text('Select a client'),
                leadingIcon: Icon(Icons.search),
                width: MediaQuery.of(context).size.width - 100,
                menuHeight: 200,
                enableFilter: true,
                dropdownMenuEntries:
                    clients.map((doc) {
                      final client = doc.data();
                      return DropdownMenuEntry<String>(
                        value: doc.id,
                        label: '${client.firstName} ${client.lastName}',
                      );
                    }).toList(),
                onSelected: (String? value) {
                  setState(() {
                    _selectedClient = value;
                  });
                  debugPrint('selected client ID: $value');
                },
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // Amount and interest in a row
        Row(
          children: [
            Expanded(
              child: _buildFormField(
                label: 'Amount',
                child: TextField(
                  controller: _amountController,
                  decoration: _inputDecoration('Enter Amount', '1000'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFormField(
                label: 'Interest %',
                child: TextField(
                  controller: _interestController,
                  decoration: _inputDecoration('Enter Interest', '10'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Date and reason
        _buildFormField(
          label: 'Receive Date',
          child: GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      _receiveDate == null
                          ? Colors.grey.shade300
                          : Theme.of(context).primaryColor.withValues(),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _receiveDate == null
                        ? 'Select Date'
                        : DateFormat('dd MMM yyyy').format(_receiveDate!),
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          _receiveDate == null
                              ? Colors.grey.shade600
                              : Colors.black87,
                    ),
                  ),
                  Icon(
                    Icons.calendar_month_outlined,
                    color:
                        _receiveDate == null
                            ? Colors.grey.shade500
                            : Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        _buildFormField(
          label: 'Reason',
          child: TextField(
            controller: _reasonController,
            decoration: _inputDecoration('Enter Reason', 'For Emergency'),
            keyboardType: TextInputType.text,
            maxLines: 2,
          ),
        ),

        const SizedBox(height: 24),

        // Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {
                _amountController.clear();
                _interestController.clear();
                _reasonController.clear();
                setState(() {
                  _receiveDate = null;
                  _selectedClient = null;
                });
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              child: Text(
                'Clear',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {
                _submitLoan();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _buildLoanListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Loan List',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        // Filter options
        Row(
          children: [
            Expanded(
              child: FilterChip(
                label: const Text('Pending'),
                selected: _pendingChecked,
                onSelected: (bool value) {
                  setState(() {
                    _pendingChecked = value;
                  });
                },
              ),
            ),
            Expanded(
              child: FilterChip(
                label: const Text('Paid'),
                selected: _paidChecked,
                onSelected: (bool value) {
                  setState(() {
                    _paidChecked = value;
                  });
                },
              ),
            ),
          ],
        ),

        SizedBox(height: 250, child: _buildLoanList()),
      ],
    );
  }

  Widget _buildLoanList() {
    return StreamBuilder<QuerySnapshot<LoanModal>>(
      stream: _loanService.getAllLoans(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final loans = snapshot.data?.docs ?? [];

        if (loans.isEmpty) {
          return const Center(child: Text('No loans found'));
        }

        return ListView.builder(
          itemCount: loans.length,
          itemBuilder: (context, index) {
            final loan = loans[index].data();
            final loanID = loans[index].id;

            return LoanCard(loan: loan, loanId: loanID);
          },
        );
      },
    );
  }
}
