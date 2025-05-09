import 'package:cloud_firestore/cloud_firestore.dart';

class LoanModal {
  final bool isPaid;
  final int amount;
  final int interest;
  final String clientId;
  final String reason;
  final DateTime receiveDate;
  final DateTime gotDate;

  LoanModal({
    required this.amount,
    required this.interest,
    required this.clientId,
    required this.reason,
    required this.receiveDate,
    DateTime? gotDate,
    bool? isPaid,
  }) : gotDate = gotDate ?? DateTime.now(),
       isPaid = isPaid ?? false;

  // Convert to Firestore JSON
  Map<String, dynamic> toJson() {
    return {
      'isPaid': isPaid,
      'amount': amount,
      'interest': interest,
      'clientId': clientId,
      'reason': reason,
      'receiveDate': Timestamp.fromDate(receiveDate),
      'gotDate': Timestamp.fromDate(gotDate),
    };
  }

  // Create from Firestore JSON
  factory LoanModal.fromJson(Map<String, dynamic> json) {
    return LoanModal(
      isPaid: json['isPaid'] as bool? ?? false,
      amount: json['amount'] as int,
      interest: json['interest'] as int,
      clientId: json['clientId'] as String,
      reason: json['reason'] as String,
      receiveDate: (json['receiveDate'] as Timestamp).toDate(),
      gotDate: (json['gotDate'] as Timestamp).toDate(),
    );
  }

  // Copy with method for immutable updates
  LoanModal copyWith({
    bool? isPaid,
    int? amount,
    int? interest,
    String? clientId,
    String? reason,
    DateTime? receiveDate,
    DateTime? gotDate,
  }) {
    return LoanModal(
      isPaid: isPaid ?? this.isPaid,
      amount: amount ?? this.amount,
      interest: interest ?? this.interest,
      clientId: clientId ?? this.clientId,
      reason: reason ?? this.reason,
      receiveDate: receiveDate ?? this.receiveDate,
      gotDate: gotDate ?? this.gotDate,
    );
  }

  // For equality comparison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoanModal &&
          runtimeType == other.runtimeType &&
          isPaid == other.isPaid &&
          amount == other.amount &&
          interest == other.interest &&
          clientId == other.clientId &&
          reason == other.reason &&
          receiveDate == other.receiveDate &&
          gotDate == other.gotDate;

  @override
  int get hashCode =>
      isPaid.hashCode ^
      amount.hashCode ^
      interest.hashCode ^
      clientId.hashCode ^
      reason.hashCode ^
      receiveDate.hashCode ^
      gotDate.hashCode;

  @override
  String toString() {
    return 'LoanModal{isPaid: $isPaid, amount: $amount, interest: $interest, '
        'clientId: $clientId, reason: $reason, receiveDate: $receiveDate, '
        'gotDate: $gotDate}';
  }
}
