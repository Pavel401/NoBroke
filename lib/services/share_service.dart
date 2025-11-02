import 'dart:io';
import 'dart:typed_data';
import 'package:davinci/core/davinci_capture.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../db/app_db.dart';
import '../ui/components/achievement_share_widget.dart';

class ShareService {
  static final ShareService _instance = ShareService._internal();
  factory ShareService() => _instance;
  ShareService._internal();

  /// Share a savings achievement with screenshot
  Future<void> shareAchievement(
    BuildContext context,
    Saving saving, {
    Rect? sharePositionOrigin,
  }) async {
    try {
      // Create the widget to capture
      final widget = AchievementShareWidget(saving: saving);

      // Capture the widget as an image using DaVinci
      final Uint8List? bytes = await DavinciCapture.offStage(
        widget,
        context: context,
        pixelRatio: 3.0, // High quality
        returnImageUint8List: true,
        saveToDevice: false,
        openFilePreview: false,
      );

      if (bytes == null) {
        throw Exception('Failed to capture widget');
      }

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/achievement_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(bytes);

      // Generate share message
      final message = _generateShareMessage(saving);

      // Share the image with message
      await Share.shareXFiles(
        [XFile(file.path)],
        text: message,
        subject: 'My Investment Achievement! 📈',
        sharePositionOrigin: sharePositionOrigin,
      );

      // Clean up temporary file after a delay
      Future.delayed(const Duration(seconds: 30), () {
        if (file.existsSync()) {
          file.deleteSync();
        }
      });
    } catch (e) {
      print('Error sharing achievement: $e');
      // Fallback to text-only share
      await _shareTextOnly(saving, sharePositionOrigin: sharePositionOrigin);
    }
  }

  /// Generate a compelling share message
  String _generateShareMessage(Saving saving) {
    final base = saving.amount;
    final finalValue = saving.finalValue;
    final inc = finalValue - base;
    final isPositive = inc >= 0;
    final returnPercent = saving.returnPct;

    if (isPositive) {
      return '''🎉 Smart money decision alert! 💰

Instead of buying a ${saving.itemName} for ${_money(base)}, I chose to invest in ${saving.investmentName}!

📈 Result: My money grew to ${_money(finalValue)}
💚 That's a ${returnPercent.toStringAsFixed(1)}% return (+${_money(inc)})!

Making smarter choices, one purchase at a time! 🚀

#SmartMoney #InvestmentWin #FinancialLiteracy #GrowthMindset #MoneyTips''';
    } else {
      return '''📚 Learning from every investment decision! 💪

I chose to invest my ${saving.itemName} money (${_money(base)}) in ${saving.investmentName} instead of spending it.

📉 While this investment is down ${returnPercent.toStringAsFixed(1)}% right now, I'm learning about market fluctuations and long-term thinking!

Every smart investor faces ups and downs - it's all part of the journey! 🎯

#SmartMoney #LearningToInvest #FinancialLiteracy #LongTermThinking #MoneyEducation''';
    }
  }

  /// Fallback to text-only sharing
  Future<void> _shareTextOnly(
    Saving saving, {
    Rect? sharePositionOrigin,
  }) async {
    final message = _generateShareMessage(saving);
    await Share.share(message, sharePositionOrigin: sharePositionOrigin);
  }

  String _money(double v) => '\$${v.toStringAsFixed(2)}';
}
