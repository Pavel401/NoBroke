import 'dart:convert';
import 'dart:io';
import 'package:moneyapp/data/models/database.dart';
import 'package:moneyapp/domain/entities/bank_account_entity.dart';
import 'package:moneyapp/domain/entities/transaction_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class ExportService {
  static Future<String> exportAllDataToJson({
    required List<TransactionEntity> transactions,
    required List<BankAccountEntity> accounts,
    required List<Budget> budgets,
  }) async {
    try {
      // Create the data structure
      final Map<String, dynamic> exportData = {
        'exportInfo': {
          'exportDate': DateTime.now().toIso8601String(),
          'appVersion': '1.0.0',
          'dataFormat': 'json',
          'totalTransactions': transactions.length,
          'totalAccounts': accounts.length,
          'totalBudgets': budgets.length,
        },
        'transactions': transactions
            .map(
              (transaction) => {
                'id': transaction.id,
                'date': transaction.date.toIso8601String(),
                'type': transaction.type.name,
                'title': transaction.title,
                'description': transaction.description,
                'amount': transaction.amount,
                'category': transaction.category.name,
                'location': transaction.location,
                'photos': transaction.photos,
                'smsContent': transaction.smsContent,
                'accountId': transaction.accountId,
              },
            )
            .toList(),
        'accounts': accounts
            .map(
              (account) => {
                'id': account.id,
                'accountName': account.accountName,
                'accountNumber': account.accountNumber,
                'bankName': account.bankName,
                'accountType': account.accountType.name,
                'balance': account.balance,
                'isActive': account.isActive,
                'createdAt': account.createdAt.toIso8601String(),
                'updatedAt': account.updatedAt.toIso8601String(),
                'ifscCode': account.ifscCode,
                'branchName': account.branchName,
                'description': account.description,
              },
            )
            .toList(),
        'budgets': budgets
            .map(
              (budget) => {
                'id': budget.id,
                'year': budget.year,
                'month': budget.month,
                'amount': budget.amount,
                'createdAt': budget.createdAt.toIso8601String(),
                'updatedAt': budget.updatedAt.toIso8601String(),
              },
            )
            .toList(),
      };

      // Convert to JSON string with pretty formatting
      const encoder = JsonEncoder.withIndent('  ');
      final jsonString = encoder.convert(exportData);

      // Create filename with timestamp
      final timestamp = DateFormat(
        'yyyy-MM-dd_HH-mm-ss',
      ).format(DateTime.now());
      final filename = 'moneyapp_export_$timestamp.json';

      // Get temp directory and create file
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$filename');
      await file.writeAsString(jsonString);

      return file.path;
    } catch (e) {
      throw Exception('Failed to export data: $e');
    }
  }

  static Future<void> shareExportedFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await Share.shareXFiles(
          [XFile(filePath)],
          text: 'Money App Data Export',
          subject: 'Export from Money Tracker App',
        );
      } else {
        throw Exception('Export file not found');
      }
    } catch (e) {
      throw Exception('Failed to share export file: $e');
    }
  }

  static Future<String> exportDataToString({
    required List<TransactionEntity> transactions,
    required List<BankAccountEntity> accounts,
    required List<Budget> budgets,
  }) async {
    try {
      // Create the data structure
      final Map<String, dynamic> exportData = {
        'exportInfo': {
          'exportDate': DateTime.now().toIso8601String(),
          'appVersion': '1.0.0',
          'dataFormat': 'json',
          'totalTransactions': transactions.length,
          'totalAccounts': accounts.length,
          'totalBudgets': budgets.length,
        },
        'transactions': transactions
            .map(
              (transaction) => {
                'id': transaction.id,
                'date': transaction.date.toIso8601String(),
                'type': transaction.type.name,
                'title': transaction.title,
                'description': transaction.description,
                'amount': transaction.amount,
                'category': transaction.category.name,
                'location': transaction.location,
                'photos': transaction.photos,
                'smsContent': transaction.smsContent,
                'accountId': transaction.accountId,
              },
            )
            .toList(),
        'accounts': accounts
            .map(
              (account) => {
                'id': account.id,
                'accountName': account.accountName,
                'accountNumber': account.accountNumber,
                'bankName': account.bankName,
                'accountType': account.accountType.name,
                'balance': account.balance,
                'isActive': account.isActive,
                'createdAt': account.createdAt.toIso8601String(),
                'updatedAt': account.updatedAt.toIso8601String(),
                'ifscCode': account.ifscCode,
                'branchName': account.branchName,
                'description': account.description,
              },
            )
            .toList(),
        'budgets': budgets
            .map(
              (budget) => {
                'id': budget.id,
                'year': budget.year,
                'month': budget.month,
                'amount': budget.amount,
                'createdAt': budget.createdAt.toIso8601String(),
                'updatedAt': budget.updatedAt.toIso8601String(),
              },
            )
            .toList(),
      };

      // Convert to JSON string with pretty formatting
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(exportData);
    } catch (e) {
      throw Exception('Failed to export data: $e');
    }
  }

  static String getExportSummary({
    required List<TransactionEntity> transactions,
    required List<BankAccountEntity> accounts,
    required List<Budget> budgets,
  }) {
    final totalCredit = transactions
        .where((t) => t.type == TransactionType.credit)
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalDebit = transactions
        .where((t) => t.type == TransactionType.debit)
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalTransfer = transactions
        .where((t) => t.type == TransactionType.transfer)
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalBudgetAmount = budgets.fold(0.0, (sum, b) => sum + b.amount);

    return '''
Export Summary:
• ${transactions.length} transactions
• ${accounts.length} bank accounts
• ${budgets.length} monthly budgets

Transaction Summary:
• Total Credits: ₹${totalCredit.toStringAsFixed(2)}
• Total Debits: ₹${totalDebit.toStringAsFixed(2)}
• Total Transfers: ₹${totalTransfer.toStringAsFixed(2)}

Total Budget Amount: ₹${totalBudgetAmount.toStringAsFixed(2)}

Exported on: ${DateFormat('MMM dd, yyyy \'at\' hh:mm a').format(DateTime.now())}
    ''';
  }
}
