import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final int age;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.name,
    required this.age,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  UserModel.fromJson(Map<String, Object?> json)
    : this(
        name: json['name']! as String,
        age: json['age']! as int,
        createdAt: (json['createdAt'] as Timestamp).toDate(),
        updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      );

  UserModel copyWith({String? name, int? age, DateTime? updatedAt}) {
    return UserModel(
      name: name ?? this.name,
      age: age ?? this.age,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'age': age,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
