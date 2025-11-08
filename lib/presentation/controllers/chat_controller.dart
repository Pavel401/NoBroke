import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../../core/services/chat_service.dart';
import '../../core/services/export_service.dart';
import '../../data/models/database.dart';
import 'transaction_controller.dart';
import 'account_controller.dart';
import 'budget_controller.dart';

class ChatMessage {
  final String role; // 'user' or 'assistant'
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.role,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'role': role,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    role: json['role'],
    content: json['content'],
    timestamp: DateTime.parse(json['timestamp']),
  );

  Map<String, String> toApiFormat() => {'role': role, 'content': content};
}

class ChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final RxString errorMessage = ''.obs;

  // Configurable history limit for API calls
  final RxInt historyLimit = 8.obs;

  static const String _chatHistoryKey = 'chat_history';
  static const String _historyLimitKey = 'chat_history_limit';

  @override
  void onInit() {
    super.onInit();
    _loadChatHistory();
    _loadHistoryLimit();
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  /// Load chat history from local storage
  Future<void> _loadChatHistory() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_chatHistoryKey);

      if (historyJson != null && historyJson.isNotEmpty) {
        final List<dynamic> decoded = json.decode(historyJson);
        messages.value = decoded
            .map((msg) => ChatMessage.fromJson(msg))
            .toList();
      }
    } catch (e) {
      print('Error loading chat history: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load history limit from local storage
  Future<void> _loadHistoryLimit() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLimit = prefs.getInt(_historyLimitKey);
      if (savedLimit != null && savedLimit > 0) {
        historyLimit.value = savedLimit;
      }
    } catch (e) {
      print('Error loading history limit: $e');
    }
  }

  /// Save history limit to local storage
  Future<void> _saveHistoryLimit() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_historyLimitKey, historyLimit.value);
    } catch (e) {
      print('Error saving history limit: $e');
    }
  }

  /// Update history limit
  Future<void> updateHistoryLimit(int newLimit) async {
    if (newLimit < 1 || newLimit > 50) {
      errorMessage.value = 'History limit must be between 1 and 50';
      return;
    }
    historyLimit.value = newLimit;
    await _saveHistoryLimit();
  }

  /// Save chat history to local storage
  Future<void> _saveChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = json.encode(
        messages.map((msg) => msg.toJson()).toList(),
      );
      await prefs.setString(_chatHistoryKey, historyJson);
    } catch (e) {
      print('Error saving chat history: $e');
    }
  }

  /// Get finance info for the last 30 days
  Future<Map<String, dynamic>> _getFinanceInfo() async {
    try {
      final transactionController = Get.find<TransactionController>();

      // Get transactions from the last 30 days
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));

      final recentTransactions = transactionController.transactions
          .where((t) => t.date.isAfter(thirtyDaysAgo))
          .toList();

      // Get all accounts and budgets using the correct controllers
      final accountController = Get.find<AccountController>();
      final budgetController = Get.find<BudgetController>();

      final accounts = accountController.accounts.toList();
      final budgetMaps = budgetController.monthlyBudgets;

      // Convert budget maps to Budget objects
      final budgets = budgetMaps.map((budgetMap) {
        return Budget(
          id: const Uuid().v4(),
          year: budgetMap['year'] as int? ?? now.year,
          month: budgetMap['month'] as int? ?? now.month,
          amount: (budgetMap['amount'] as num?)?.toDouble() ?? 0.0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }).toList();

      // Generate export data string
      final exportData = await ExportService.exportDataToString(
        transactions: recentTransactions,
        accounts: accounts,
        budgets: budgets,
      );

      // Parse the export data back to Map
      return json.decode(exportData);
    } catch (e) {
      print('Error getting finance info: $e');
      return {
        'exportInfo': {
          'exportDate': DateTime.now().toIso8601String(),
          'appVersion': '1.0.0',
          'dataFormat': 'json',
          'totalTransactions': 0,
          'totalAccounts': 0,
          'totalBudgets': 0,
        },
        'transactions': [],
        'accounts': [],
        'budgets': [],
      };
    }
  }

  /// Send a message to the chat API
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Create a placeholder for the assistant's streaming response
    ChatMessage? streamingMessage;
    int streamingMessageIndex = -1;

    try {
      isSending.value = true;
      errorMessage.value = '';

      // Add user message to chat
      final userMessage = ChatMessage(
        role: 'user',
        content: message.trim(),
        timestamp: DateTime.now(),
      );
      messages.add(userMessage);
      messageController.clear();

      // Scroll to bottom
      _scrollToBottom();

      // Save chat history
      await _saveChatHistory();

      // Get finance info
      final financeInfo = await _getFinanceInfo();

      // Prepare chat history for API using configurable limit
      final apiChatHistory = messages
          .skip(
            messages.length > historyLimit.value
                ? messages.length - historyLimit.value
                : 0,
          )
          .map((msg) => msg.toApiFormat())
          .toList();

      // Add placeholder message for streaming response
      streamingMessage = ChatMessage(
        role: 'assistant',
        content: '',
        timestamp: DateTime.now(),
      );
      messages.add(streamingMessage);
      streamingMessageIndex = messages.length - 1;

      // Send to API with streaming
      await ChatService.sendMessageStream(
        userQuery: message.trim(),
        financeInfo: financeInfo,
        chatHistory: apiChatHistory,
        onChunk: (responseText) {
          // Update the streaming message with the latest chunk
          if (streamingMessageIndex >= 0 &&
              streamingMessageIndex < messages.length) {
            messages[streamingMessageIndex] = ChatMessage(
              role: 'assistant',
              content: responseText,
              timestamp: streamingMessage!.timestamp,
            );
            messages.refresh();
            _scrollToBottom();
          }
        },
        onComplete: () async {
          // Check if we actually got content
          if (streamingMessageIndex >= 0 &&
              streamingMessageIndex < messages.length) {
            final finalMessage = messages[streamingMessageIndex];
            if (finalMessage.content.isEmpty) {
              // If no content was received, show error
              messages[streamingMessageIndex] = ChatMessage(
                role: 'assistant',
                content:
                    'Sorry, I didn\'t receive a proper response. Please try again.',
                timestamp: streamingMessage!.timestamp,
              );
            }
          }

          // Save updated chat history when streaming is complete
          await _saveChatHistory();
          _scrollToBottom();
        },
        onError: (error) {
          errorMessage.value = 'Failed to send message: $error';
          print('Error sending message: $error');

          // Replace streaming message with error
          if (streamingMessageIndex >= 0 &&
              streamingMessageIndex < messages.length) {
            messages[streamingMessageIndex] = ChatMessage(
              role: 'assistant',
              content: 'Sorry, I encountered an error: $error',
              timestamp: streamingMessage!.timestamp,
            );
          }
        },
      );
    } catch (e) {
      errorMessage.value = 'Failed to send message: ${e.toString()}';
      print('Error sending message: $e');

      // Replace or add error message
      if (streamingMessageIndex >= 0 &&
          streamingMessageIndex < messages.length) {
        messages[streamingMessageIndex] = ChatMessage(
          role: 'assistant',
          content: 'Sorry, I encountered an error: ${e.toString()}',
          timestamp: streamingMessage!.timestamp,
        );
      } else {
        final errorMsg = ChatMessage(
          role: 'assistant',
          content: 'Sorry, I encountered an error: ${e.toString()}',
          timestamp: DateTime.now(),
        );
        messages.add(errorMsg);
      }
    } finally {
      isSending.value = false;
    }
  }

  /// Clear all chat history (both local UI and storage)
  Future<void> clearChat() async {
    try {
      messages.clear();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_chatHistoryKey);
      errorMessage.value = '';
    } catch (e) {
      print('Error clearing chat: $e');
    }
  }

  /// Delete only user messages from chat history
  Future<void> deleteUserHistory() async {
    try {
      // Remove all user messages, keep only assistant messages
      messages.removeWhere((msg) => msg.role == 'user');

      // Save updated chat history
      await _saveChatHistory();

      errorMessage.value = '';
    } catch (e) {
      print('Error deleting user history: $e');
      errorMessage.value = 'Failed to delete user history';
    }
  }

  /// Scroll to bottom of chat
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
