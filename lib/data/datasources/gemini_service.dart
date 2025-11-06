import 'package:google_generative_ai/google_generative_ai.dart';
import '../../domain/entities/transaction_entity.dart';

class ParsedTransaction {
  final bool isTransaction;
  final TransactionType? type;
  final double? amount;
  final String? title;
  final String? description;
  final TransactionCategory? category;
  final double confidence;

  ParsedTransaction({
    required this.isTransaction,
    this.type,
    this.amount,
    this.title,
    this.description,
    this.category,
    this.confidence = 0.0,
  });
}

class GeminiService {
  final String apiKey;
  late final GenerativeModel _model;

  GeminiService(this.apiKey) {
    _model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  }

  Future<ParsedTransaction?> parseTransactionFromSms(String smsText) async {
    try {
      final prompt =
          '''
Analyze this SMS message and extract transaction information if it's a banking/financial transaction.

SMS: $smsText

Return a JSON response with the following structure:
{
  "isTransaction": true/false,
  "type": "credit" or "debit",
  "amount": numeric value only,
  "title": short title for the transaction,
  "description": brief description,
  "category": one of [food, grocery, transport, entertainment, shopping, healthcare, education, utilities, fuel, other],
  "confidence": 0.0 to 1.0
}

If it's not a transaction SMS, return: {"isTransaction": false, "confidence": 0.0}
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final text = response.text;

      if (text == null) return null;

      // Parse JSON response
      // This is a simplified version - you might want to add better JSON parsing
      return _parseGeminiResponse(text);
    } catch (e) {
      print('Error parsing with Gemini: $e');
      return null;
    }
  }

  ParsedTransaction? _parseGeminiResponse(String response) {
    try {
      // Extract JSON from response (Gemini sometimes adds markdown)
      final jsonStart = response.indexOf('{');
      final jsonEnd = response.lastIndexOf('}') + 1;
      if (jsonStart == -1 || jsonEnd == 0) return null;

      // Parse the JSON response - for now, return a basic parsed transaction
      // You should implement proper JSON parsing here using dart:convert
      return ParsedTransaction(isTransaction: false, confidence: 0.0);
    } catch (e) {
      print('Error parsing Gemini response: $e');
      return null;
    }
  }
}
