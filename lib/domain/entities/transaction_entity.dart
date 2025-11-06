import 'package:equatable/equatable.dart';

enum TransactionType { credit, debit, transfer }

enum TransactionCategory {
  food,
  grocery,
  transport,
  entertainment,
  shopping,
  healthcare,
  education,
  utilities,
  fuel,
  transfer,
  other,
}

class TransactionEntity extends Equatable {
  final String id;
  final DateTime date;
  final TransactionType type;
  final String title;
  final String description;
  final double amount;
  final String? location;
  final TransactionCategory category;
  final List<String> photos;
  final String? smsContent;
  final String? accountId;

  const TransactionEntity({
    required this.id,
    required this.date,
    required this.type,
    required this.title,
    required this.description,
    required this.amount,
    this.location,
    required this.category,
    this.photos = const [],
    this.smsContent,
    this.accountId,
  });

  @override
  List<Object?> get props => [
    id,
    date,
    type,
    title,
    description,
    amount,
    location,
    category,
    photos,
    smsContent,
    accountId,
  ];

  TransactionEntity copyWith({
    String? id,
    DateTime? date,
    TransactionType? type,
    String? title,
    String? description,
    double? amount,
    String? location,
    TransactionCategory? category,
    List<String>? photos,
    String? smsContent,
    String? accountId,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      location: location ?? this.location,
      category: category ?? this.category,
      photos: photos ?? this.photos,
      smsContent: smsContent ?? this.smsContent,
      accountId: accountId ?? this.accountId,
    );
  }
}
