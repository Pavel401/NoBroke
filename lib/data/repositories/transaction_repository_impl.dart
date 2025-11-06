import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../models/database.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final AppDatabase _database;

  TransactionRepositoryImpl(this._database);

  @override
  Future<List<TransactionEntity>> getAllTransactions() async {
    final transactions = await _database.getAllTransactions();
    return transactions.map(_mapToEntity).toList();
  }

  @override
  Future<List<TransactionEntity>> getTransactionsByType(
    TransactionType type,
  ) async {
    final transactions = await _database.getTransactionsByType(type.name);
    return transactions.map(_mapToEntity).toList();
  }

  @override
  Future<List<TransactionEntity>> getTransactionsByCategory(
    TransactionCategory category,
  ) async {
    final transactions = await _database.getTransactionsByCategory(
      category.name,
    );
    return transactions.map(_mapToEntity).toList();
  }

  @override
  Future<List<TransactionEntity>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final transactions = await _database.getTransactionsByDateRange(start, end);
    return transactions.map(_mapToEntity).toList();
  }

  @override
  Future<TransactionEntity?> getTransactionById(String id) async {
    final transaction = await _database.getTransactionById(id);
    return transaction != null ? _mapToEntity(transaction) : null;
  }

  @override
  Future<String> addTransaction(TransactionEntity transaction) async {
    final companion = _mapToCompanion(transaction);
    await _database.insertTransaction(companion);
    return transaction.id;
  }

  @override
  Future<bool> updateTransaction(TransactionEntity transaction) async {
    final companion = _mapToCompanion(transaction);
    return await _database.updateTransaction(companion);
  }

  @override
  Future<bool> deleteTransaction(String id) async {
    final result = await _database.deleteTransaction(id);
    return result > 0;
  }

  @override
  Future<double> getTotalAmountByType(TransactionType type) async {
    return await _database.getTotalAmountByType(type.name);
  }

  @override
  Future<Map<TransactionCategory, double>> getCategoryWiseExpenses() async {
    final expenses = await _database.getCategoryWiseExpenses();
    final Map<TransactionCategory, double> result = {};

    for (final entry in expenses.entries) {
      try {
        final category = TransactionCategory.values.firstWhere(
          (c) => c.name == entry.key,
        );
        result[category] = entry.value;
      } catch (e) {
        // Skip invalid categories
      }
    }

    return result;
  }

  // Helper methods to convert between entity and database model
  TransactionEntity _mapToEntity(Transaction transaction) {
    return TransactionEntity(
      id: transaction.id,
      date: transaction.date,
      type: TransactionType.values.firstWhere(
        (e) => e.name == transaction.type,
      ),
      title: transaction.title,
      description: transaction.description,
      amount: transaction.amount,
      location: transaction.location,
      category: TransactionCategory.values.firstWhere(
        (e) => e.name == transaction.category,
      ),
      photos: transaction.photos != null
          ? List<String>.from(jsonDecode(transaction.photos!))
          : [],
      smsContent: transaction.smsContent,
      accountId: transaction.accountId,
    );
  }

  TransactionsCompanion _mapToCompanion(TransactionEntity entity) {
    return TransactionsCompanion(
      id: drift.Value(entity.id),
      date: drift.Value(entity.date),
      type: drift.Value(entity.type.name),
      title: drift.Value(entity.title),
      description: drift.Value(entity.description),
      amount: drift.Value(entity.amount),
      category: drift.Value(entity.category.name),
      location: drift.Value(entity.location),
      photos: drift.Value(
        entity.photos.isNotEmpty ? jsonEncode(entity.photos) : '[]',
      ),
      smsContent: drift.Value(entity.smsContent),
      accountId: drift.Value(entity.accountId),
      // SMS Parser fields - set to null for now if not provided
      accountType: const drift.Value(null),
      accountNumber: const drift.Value(null),
      accountName: const drift.Value(null),
      walletType: const drift.Value(null),
      cardType: const drift.Value(null),
      cardScheme: const drift.Value(null),
      bankName: const drift.Value(null),
      balanceAvailable: const drift.Value(null),
      balanceOutstanding: const drift.Value(null),
      referenceNo: const drift.Value(null),
      merchant: const drift.Value(null),
    );
  }

  /// Extended method to save transaction with SMS parser data
  Future<String> addTransactionWithSmsData(
    TransactionEntity transaction, {
    String? accountType,
    String? accountNumber,
    String? accountName,
    String? walletType,
    String? cardType,
    String? cardScheme,
    String? bankName,
    String? balanceAvailable,
    String? balanceOutstanding,
    String? referenceNo,
    String? merchant,
  }) async {
    final companion = TransactionsCompanion(
      id: drift.Value(transaction.id),
      date: drift.Value(transaction.date),
      type: drift.Value(transaction.type.name),
      title: drift.Value(transaction.title),
      description: drift.Value(transaction.description),
      amount: drift.Value(transaction.amount),
      category: drift.Value(transaction.category.name),
      location: drift.Value(transaction.location),
      photos: drift.Value(
        transaction.photos.isNotEmpty ? jsonEncode(transaction.photos) : '[]',
      ),
      smsContent: drift.Value(transaction.smsContent),
      accountId: drift.Value(transaction.accountId),
      // SMS Parser fields
      accountType: drift.Value(accountType),
      accountNumber: drift.Value(accountNumber),
      accountName: drift.Value(accountName),
      walletType: drift.Value(walletType),
      cardType: drift.Value(cardType),
      cardScheme: drift.Value(cardScheme),
      bankName: drift.Value(bankName),
      balanceAvailable: drift.Value(balanceAvailable),
      balanceOutstanding: drift.Value(balanceOutstanding),
      referenceNo: drift.Value(referenceNo),
      merchant: drift.Value(merchant),
    );

    await _database.insertTransaction(companion);
    return transaction.id;
  }

  /// Reset the entire database (delete and recreate)
  Future<void> resetDatabase() async {
    await _database.resetDatabase();
  }

  /// Reset all data in the database
  Future<void> resetAllData() async {
    await _database.deleteAllTransactions();
  }
}
