import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/bank_account_entity.dart';
import '../../domain/usecases/transaction_usecases.dart';
import '../../domain/usecases/account_usecases.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../data/datasources/sms_service.dart';
import '../../data/datasources/gemini_service.dart';
import '../../data/models/enums.dart' as app_enums;
import '../../core/utils/ui_helpers.dart';

class TransactionController extends GetxController {
  final AddTransactionUseCase _addTransactionUseCase;
  final GetAllTransactionsUseCase _getAllTransactionsUseCase;
  final GetTransactionsByTypeUseCase _getTransactionsByTypeUseCase;
  final GetTransactionsByCategoryUseCase _getTransactionsByCategoryUseCase;
  final GetTransactionsByDateRangeUseCase _getTransactionsByDateRangeUseCase;
  final UpdateTransactionUseCase _updateTransactionUseCase;
  final DeleteTransactionUseCase _deleteTransactionUseCase;
  final GetCategoryWiseExpensesUseCase _getCategoryWiseExpensesUseCase;
  final GetTotalAmountByTypeUseCase _getTotalAmountByTypeUseCase;
  final SmsService _smsService;
  final GeminiService _geminiService;

  TransactionController(
    this._addTransactionUseCase,
    this._getAllTransactionsUseCase,
    this._getTransactionsByTypeUseCase,
    this._getTransactionsByCategoryUseCase,
    this._getTransactionsByDateRangeUseCase,
    this._updateTransactionUseCase,
    this._deleteTransactionUseCase,
    this._getCategoryWiseExpensesUseCase,
    this._getTotalAmountByTypeUseCase,
    this._smsService,
    this._geminiService,
  );

  // Observable variables
  final RxList<TransactionEntity> _transactions = <TransactionEntity>[].obs;
  final RxList<TransactionEntity> _filteredTransactions =
      <TransactionEntity>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxDouble _totalCredit = 0.0.obs;
  final RxDouble _totalDebit = 0.0.obs;
  final RxDouble _totalTransfer = 0.0.obs;
  final RxMap<TransactionCategory, double> _categoryExpenses =
      <TransactionCategory, double>{}.obs;
  final RxBool _isProcessingSms = false.obs;

  // Getters
  List<TransactionEntity> get transactions => _transactions;
  List<TransactionEntity> get filteredTransactions => _filteredTransactions;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  double get totalCredit => _totalCredit.value;
  double get totalDebit => _totalDebit.value;
  double get totalTransfer => _totalTransfer.value;
  double get balance => _totalCredit.value - _totalDebit.value;
  Map<TransactionCategory, double> get categoryExpenses => _categoryExpenses;
  bool get isProcessingSms => _isProcessingSms.value;
  SmsService get smsService => _smsService;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
    loadStatistics();
  }

  Future<void> loadTransactions() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final transactions = await _getAllTransactionsUseCase();
      _transactions.value = transactions;
      _filteredTransactions.value = transactions;
    } catch (e) {
      _errorMessage.value = 'Failed to load transactions: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadStatistics() async {
    try {
      final credit = await _getTotalAmountByTypeUseCase(TransactionType.credit);
      final debit = await _getTotalAmountByTypeUseCase(TransactionType.debit);
      final transfer = await _getTotalAmountByTypeUseCase(
        TransactionType.transfer,
      );
      final categoryExpenses = await _getCategoryWiseExpensesUseCase();

      _totalCredit.value = credit;
      _totalDebit.value = debit;
      _totalTransfer.value = transfer;
      _categoryExpenses.value = categoryExpenses;
    } catch (e) {
      print('Error loading statistics: $e');
    }
  }

  Future<void> addTransaction(
    TransactionEntity transaction, [
    BuildContext? context,
  ]) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      await _addTransactionUseCase(transaction);
      await loadTransactions();
      await loadStatistics();

      if (context != null) {
        UIHelpers.showSnackbar(
          context,
          message: 'Transaction added successfully',
          type: SnackbarType.success,
        );
      }
    } catch (e) {
      _errorMessage.value = 'Failed to add transaction: $e';
      if (context != null) {
        UIHelpers.showSnackbar(
          context,
          message: 'Failed to add transaction',
          type: SnackbarType.error,
        );
      }
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateTransaction(
    TransactionEntity transaction, [
    BuildContext? context,
  ]) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final success = await _updateTransactionUseCase(transaction);
      if (success) {
        await loadTransactions();
        await loadStatistics();
        if (context != null) {
          UIHelpers.showSnackbar(
            context,
            message: 'Transaction updated successfully',
            type: SnackbarType.success,
          );
        }
      } else {
        throw Exception('Update failed');
      }
    } catch (e) {
      _errorMessage.value = 'Failed to update transaction: $e';
      if (context != null) {
        UIHelpers.showSnackbar(
          context,
          message: 'Failed to update transaction',
          type: SnackbarType.error,
        );
      }
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> deleteTransaction(String id, [BuildContext? context]) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final success = await _deleteTransactionUseCase(id);
      if (success) {
        await loadTransactions();
        await loadStatistics();
        if (context != null) {
          UIHelpers.showSnackbar(
            context,
            message: 'Transaction deleted successfully',
            type: SnackbarType.success,
          );
        }
      } else {
        throw Exception('Delete failed');
      }
    } catch (e) {
      _errorMessage.value = 'Failed to delete transaction: $e';
      if (context != null) {
        UIHelpers.showSnackbar(
          context,
          message: 'Failed to delete transaction',
          type: SnackbarType.error,
        );
      }
    } finally {
      _isLoading.value = false;
    }
  }

  void filterTransactionsByType(TransactionType? type) {
    if (type == null) {
      _filteredTransactions.value = _transactions;
    } else {
      _filteredTransactions.value = _transactions
          .where((transaction) => transaction.type == type)
          .toList();
    }
  }

  void filterTransactionsByCategory(TransactionCategory? category) {
    if (category == null) {
      _filteredTransactions.value = _transactions;
    } else {
      _filteredTransactions.value = _transactions
          .where((transaction) => transaction.category == category)
          .toList();
    }
  }

  void filterTransactionsByDateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) {
      _filteredTransactions.value = _transactions;
    } else {
      _filteredTransactions.value = _transactions
          .where(
            (transaction) =>
                transaction.date.isAfter(
                  start.subtract(const Duration(days: 1)),
                ) &&
                transaction.date.isBefore(end.add(const Duration(days: 1))),
          )
          .toList();
    }
  }

  void searchTransactions(String query) {
    if (query.isEmpty) {
      _filteredTransactions.value = _transactions;
    } else {
      _filteredTransactions.value = _transactions
          .where(
            (transaction) =>
                transaction.title.toLowerCase().contains(query.toLowerCase()) ||
                transaction.description.toLowerCase().contains(
                  query.toLowerCase(),
                ),
          )
          .toList();
    }
  }

  Future<void> processSmsMessages({
    DateTime? startDate,
    DateTime? endDate,
    BuildContext? context,
  }) async {
    try {
      _isProcessingSms.value = true;
      _errorMessage.value = '';

      // Get banking SMS messages with custom date range
      final smsMessages = await _smsService.getBankingMessages(
        daysBack: 30,
        startDate: startDate,
        endDate: endDate,
      );

      if (smsMessages.isEmpty) {
        if (context != null) {
          UIHelpers.showSnackbar(
            context,
            message: 'No banking SMS messages found',
            type: SnackbarType.info,
          );
        }
        return;
      }

      int processedCount = 0;

      for (final smsMessage in smsMessages) {
        try {
          // Parse with transaction_sms_parser
          final transactionInfo = _smsService.parseTransactionFromSms(
            smsMessage.body ?? '',
          );

          if (transactionInfo != null) {
            // Extract transaction details
            final transaction = transactionInfo.transaction;
            final account = transactionInfo.account;
            final balance = transactionInfo.balance;

            // Determine transaction type
            TransactionType type = TransactionType.debit;
            if (transaction.type != null) {
              type = transaction.type == app_enums.TransactionType.credit
                  ? TransactionType.credit
                  : TransactionType.debit;
            }

            // Check if this is a transfer transaction
            if (_isTransferTransaction(
              transaction.merchant,
              smsMessage.body ?? '',
            )) {
              type = TransactionType.transfer;
            }

            // Parse amount
            double amount = 0.0;
            if (transaction.amount != null) {
              // Remove currency symbols and commas
              final cleanAmount = transaction.amount!.replaceAll(
                RegExp(r'[₹,\s]'),
                '',
              );
              amount = double.tryParse(cleanAmount) ?? 0.0;
            }

            // Create title from merchant or transaction type
            String title =
                transaction.merchant ??
                (type == TransactionType.credit ? 'Money Received' : 'Payment');

            // Create description
            String description = 'Transaction';
            if (account.bankName != null) {
              description += ' via ${account.bankName}';
            }
            if (account.number != null) {
              description += ' (${account.number})';
            }
            if (transaction.referenceNo != null) {
              description += '\nRef: ${transaction.referenceNo}';
            }

            // Determine category based on merchant or type
            TransactionCategory category = _inferCategory(
              transaction.merchant,
              type,
            );

            // Create transaction entity
            final transactionEntity = TransactionEntity(
              id: const Uuid().v4(),
              date: smsMessage.date ?? DateTime.now(),
              type: type,
              title: title,
              description: description,
              amount: amount,
              category: category,
              smsContent: smsMessage.body,
            );

            // Use the repository directly to save transaction with SMS data
            final repository = Get.find<TransactionRepository>();
            if (repository is TransactionRepositoryImpl) {
              if (amount == 0.0) {
                // Skip transactions with zero amount
                continue;
              }
              await repository.addTransactionWithSmsData(
                transactionEntity,
                accountType: account.type?.name,
                accountNumber: account.number,
                accountName: account.name,
                walletType: account.walletType?.name,
                cardType: account.cardType?.name,
                cardScheme: account.cardScheme?.name,
                bankName: account.bankName,
                balanceAvailable: balance?.available,
                balanceOutstanding: balance?.outstanding,
                referenceNo: transaction.referenceNo,
                merchant: transaction.merchant,
              );
            } else {
              await _addTransactionUseCase(transactionEntity);
            }
            processedCount++;
          }
        } catch (e) {
          print('Error processing SMS: $e');
        }
      }

      await loadTransactions();
      await loadStatistics();

      final dateRange = startDate != null && endDate != null
          ? 'from ${startDate.day}/${startDate.month}/${startDate.year} to ${endDate.day}/${endDate.month}/${endDate.year}'
          : 'from last 30 days';

      if (context != null) {
        UIHelpers.showSnackbar(
          context,
          message: 'Processed $processedCount transactions from SMS $dateRange',
          type: SnackbarType.success,
        );
      }
    } catch (e) {
      _errorMessage.value = 'Failed to process SMS messages: $e';
      if (context != null) {
        UIHelpers.showSnackbar(
          context,
          message: 'Failed to process SMS messages',
          type: SnackbarType.error,
        );
      }
    } finally {
      _isProcessingSms.value = false;
    }
  }

  /// Infer transaction category based on merchant name
  TransactionCategory _inferCategory(String? merchant, TransactionType type) {
    // For transfers, always return other category
    if (type == TransactionType.transfer) {
      return TransactionCategory.other;
    }

    if (merchant == null) {
      return type == TransactionType.credit
          ? TransactionCategory.other
          : TransactionCategory.other;
    }

    final merchantLower = merchant.toLowerCase();

    // Food & Dining
    if (merchantLower.contains('zomato') ||
        merchantLower.contains('swiggy') ||
        merchantLower.contains('restaurant') ||
        merchantLower.contains('food') ||
        merchantLower.contains('cafe')) {
      return TransactionCategory.food;
    }

    // Grocery
    if (merchantLower.contains('bigbasket') ||
        merchantLower.contains('grofers') ||
        merchantLower.contains('zepto') ||
        merchantLower.contains('mart') ||
        merchantLower.contains('grocery')) {
      return TransactionCategory.grocery;
    }

    // Transport
    if (merchantLower.contains('uber') ||
        merchantLower.contains('ola') ||
        merchantLower.contains('rapido') ||
        merchantLower.contains('petrol') ||
        merchantLower.contains('fuel')) {
      return TransactionCategory.transport;
    }

    // Entertainment
    if (merchantLower.contains('netflix') ||
        merchantLower.contains('amazon prime') ||
        merchantLower.contains('hotstar') ||
        merchantLower.contains('spotify') ||
        merchantLower.contains('cinema')) {
      return TransactionCategory.entertainment;
    }

    // Shopping
    if (merchantLower.contains('amazon') ||
        merchantLower.contains('flipkart') ||
        merchantLower.contains('myntra') ||
        merchantLower.contains('ajio')) {
      return TransactionCategory.shopping;
    }

    // Utilities
    if (merchantLower.contains('electricity') ||
        merchantLower.contains('water') ||
        merchantLower.contains('gas') ||
        merchantLower.contains('broadband') ||
        merchantLower.contains('mobile recharge')) {
      return TransactionCategory.utilities;
    }

    return TransactionCategory.other;
  }

  /// Detect if a transaction is a transfer based on merchant and SMS content
  bool _isTransferTransaction(String? merchant, String smsContent) {
    final contentLower = smsContent.toLowerCase();
    final merchantLower = merchant?.toLowerCase() ?? '';

    // Check for transfer keywords in SMS content
    final transferKeywords = [
      'transfer',
      'transferred',
      'fund transfer',
      'imps transfer',
      'neft transfer',
      'rtgs transfer',
      'p2p transfer',
      'upi transfer',
      'account transfer',
      'self transfer',
      'internal transfer',
      'by transfer',
      'to transfer',
      'transfer to',
      'transfer from',
    ];

    // Check SMS content for transfer keywords
    if (transferKeywords.any((keyword) => contentLower.contains(keyword))) {
      return true;
    }

    // Check merchant name for transfer indicators
    final merchantTransferKeywords = [
      'transfer',
      'p2p',
      'fund',
      'imps',
      'neft',
      'rtgs',
      'upi transfer',
    ];

    if (merchantTransferKeywords.any(
      (keyword) => merchantLower.contains(keyword),
    )) {
      return true;
    }

    // Check for UPI P2P pattern (person to person)
    if (contentLower.contains('upi/p2p/') || contentLower.contains('upi-p2p')) {
      return true;
    }

    // Check for account number patterns indicating transfers
    final accountTransferPattern = RegExp(
      r'(to|from)\s+(a/c|account)\s+\d+',
      caseSensitive: false,
    );
    if (accountTransferPattern.hasMatch(contentLower)) {
      return true;
    }

    return false;
  }

  Future<void> addManualTransaction({
    required String title,
    required String description,
    required double amount,
    required TransactionType type,
    required TransactionCategory category,
    String? location,
    List<String>? photos,
  }) async {
    final transaction = TransactionEntity(
      id: const Uuid().v4(),
      date: DateTime.now(),
      type: type,
      title: title,
      description: description,
      amount: amount,
      location: location,
      category: category,
      photos: photos ?? [],
    );

    await addTransaction(transaction);
  }

  Future<void> resetAllData() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Get the repository to perform the reset
      final repository = Get.find<TransactionRepository>();
      if (repository is TransactionRepositoryImpl) {
        await repository.resetAllData();
      }

      // Clear local data
      _transactions.clear();
      _filteredTransactions.clear();
      _totalCredit.value = 0.0;
      _totalDebit.value = 0.0;
      _totalTransfer.value = 0.0;
      _categoryExpenses.clear();

      // Reload fresh data
      await loadTransactions();
      await loadStatistics();
    } catch (e) {
      _errorMessage.value = 'Failed to reset data: $e';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }
}
