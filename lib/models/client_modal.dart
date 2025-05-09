import 'package:cloud_firestore/cloud_firestore.dart';

class ClientModal {
  final String firstName;
  final String lastName;
  final String address;
  final String phone;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClientModal({
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.phone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Create from Firestore JSON
  factory ClientModal.fromJson(Map<String, Object?> json) {
    return ClientModal(
      firstName: json['firstName']! as String,
      lastName: json['lastName']! as String,
      address: json['address']! as String,
      phone: json['phone']! as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Convert to Firestore JSON
  Map<String, Object?> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'phone': phone,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Copy with method for immutable updates
  ClientModal copyWith({
    String? firstName,
    String? lastName,
    String? address,
    String? phone,
    DateTime? updatedAt,
  }) {
    return ClientModal(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      createdAt: createdAt, // Never change created date
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
