import 'package:eltracker_app/controller/client_service.dart';
import 'package:eltracker_app/controller/loan_service.dart';
import 'package:flutter/material.dart';
import 'package:eltracker_app/models/loan_modal.dart';
import 'package:eltracker_app/models/client_modal.dart';

// CHANGED: Converted from StatelessWidget to StatefulWidget
// REASON: Needed to maintain state and check mounted status
class LoanCard extends StatefulWidget {
  final String loanId;
  final LoanModal loan;
  final VoidCallback? onDelete;

  const LoanCard({
    super.key,
    required this.loan,
    this.onDelete,
    required this.loanId,
  });

  @override
  State<LoanCard> createState() => _LoanCardState();
}

class _LoanCardState extends State<LoanCard> {
  final ClientService clientService = ClientService();
  final LoanService loanService = LoanService();

  Future<void> _deleteLoan() async {
    // CHANGED: Removed context parameter since we can access it via State
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Loan'),
            content: const Text('Are you sure you want to delete this loan?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    // CHANGED: Added mounted check before proceeding
    if (!mounted || confirmed != true) return;

    try {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Deleting loan...')));

      await loanService.deleteLoan(widget.loanId);

      // CHANGED: Added mounted check before showing success message
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Loan deleted successfully')),
      );

      // CHANGED: Using null-aware operator for cleaner callback
      widget.onDelete?.call();
    } catch (e) {
      // CHANGED: Added mounted check before showing error
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete loan: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ClientModal?>(
      // CHANGED: Access loan via widget. prefix
      future: clientService.getClientById(widget.loan.clientId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            margin: const EdgeInsets.only(bottom: 20),
            child: const ListTile(title: Text('Loading...')),
          );
        }

        if (snapshot.hasError) {
          return Card(
            margin: const EdgeInsets.only(bottom: 20),
            child: ListTile(
              // CHANGED: Access loan via widget. prefix
              title: Text('Client ID: ${widget.loan.clientId}'),
              subtitle: const Text('Error loading client details'),
            ),
          );
        }

        final client = snapshot.data;

        return Card(
          margin: const EdgeInsets.only(bottom: 20),
          child: ListTile(
            // CHANGED: Access loan via widget. prefix
            title: Text(
              client?.firstName ?? 'Client ID: ${widget.loan.clientId}',
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (client != null) Text('Phone: ${client.phone}'),
                // CHANGED: Access loan via widget. prefix
                Text('Amount: ${widget.loan.amount}'),
                Text(
                  // CHANGED: Access loan via widget. prefix
                  'Receive Date: ${widget.loan.receiveDate.toString().split(' ')[0]}',
                ),
              ],
            ),
            // CHANGED: Simplified onPressed since _deleteLoan no longer needs context
            trailing: IconButton(
              onPressed: _deleteLoan,
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ),
        );
      },
    );
  }
}
