import 'package:eltracker_app/widgets/payment_card.dart';
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

  String? _selectedClient;
  bool _pendingChecked = true;
  bool _paidChecked = true;
  DateTime? _receiveDate;

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

  final List loanList = ['1', '2', '3', '4', '5', '6', '7'];

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

              // Loan list
              SizedBox(
                height: 250,
                child: ListView.builder(
                  itemCount: loanList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: DeuPaymentCard(cardCount: loanList[index]),
                    );
                  },
                ),
              ),
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
        // Client selection
        _buildFormField(
          label: 'Client Name',
          child: DropdownMenu<String>(
            initialSelection: _selectedClient,
            label: const Text('Select a client'),
            leadingIcon: const Icon(Icons.search),
            width: MediaQuery.of(context).size.width - 100,
            menuHeight: 200,
            enableFilter: true,
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: 'Dinuka', label: 'Dinuka'),
              DropdownMenuEntry(value: 'Shaki', label: 'Shaki'),
              DropdownMenuEntry(value: 'Henzer', label: 'Henzer'),
            ],
            onSelected: (String? value) {
              _selectedClient = value;
              // ignore: avoid_print
              print(_selectedClient);
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
              onPressed: () {},
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
      ],
    );
  }
}
