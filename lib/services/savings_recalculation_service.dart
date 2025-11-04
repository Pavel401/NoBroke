import '../db/app_db.dart';
import '../services/market_service.dart';

class SavingsRecalculationService {
  final AppDb _db;
  final MarketService _marketService;

  SavingsRecalculationService(this._db, this._marketService);

  /// Recalculates all savings based on current market data
  /// This should be called after market data sync is complete
  Future<int> recalculateAllSavings() async {
    try {
      // Get all savings entries
      final allSavings = await _db.getAllSavings();
      int updatedCount = 0;

      for (final saving in allSavings) {
        final success = await _recalculateSaving(saving);
        if (success) {
          updatedCount++;
        }
      }

      return updatedCount;
    } catch (e) {
      print('Error recalculating savings: $e');
      return 0;
    }
  }

  /// Recalculates a single saving entry based on current market data
  Future<bool> _recalculateSaving(Saving saving) async {
    try {
      // Get current market data for this symbol
      final priceSnapshot = await _marketService.fetchOneYearPrices(
        saving.symbol,
      );

      if (priceSnapshot == null ||
          priceSnapshot.start == null ||
          priceSnapshot.latest == null) {
        print('No market data available for ${saving.symbol}');
        return false;
      }

      final startPrice = priceSnapshot.start!;
      final latestPrice = priceSnapshot.latest!;

      // Calculate new growth ratio and final value
      final growthRatio = startPrice > 0 ? (latestPrice / startPrice) : 0.0;
      final newFinalValue = saving.amount * growthRatio;
      final newReturnPct = (growthRatio - 1) * 100;

      // Update the saving in the database
      await _db.updateSaving(
        saving.id,
        finalValue: newFinalValue,
        returnPct: newReturnPct,
      );

      print(
        'Updated saving ${saving.id} (${saving.symbol}): '
        'finalValue: ${saving.finalValue} -> $newFinalValue, '
        'returnPct: ${saving.returnPct}% -> ${newReturnPct.toStringAsFixed(2)}%',
      );

      return true;
    } catch (e) {
      print('Error recalculating saving ${saving.id}: $e');
      return false;
    }
  }

  /// Recalculates savings for specific symbols only
  Future<int> recalculateSavingsForSymbols(List<String> symbols) async {
    try {
      final allSavings = await _db.getAllSavings();
      final relevantSavings = allSavings
          .where((s) => symbols.contains(s.symbol))
          .toList();
      int updatedCount = 0;

      for (final saving in relevantSavings) {
        final success = await _recalculateSaving(saving);
        if (success) {
          updatedCount++;
        }
      }

      return updatedCount;
    } catch (e) {
      print('Error recalculating savings for symbols: $e');
      return 0;
    }
  }
}
