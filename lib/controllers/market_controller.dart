import 'package:get/get.dart';

import '../services/market_service.dart';

class MarketResult {
  final double startPrice;
  final double latestPrice;
  final double percentChange; // e.g., 0.32 for +32%

  MarketResult({
    required this.startPrice,
    required this.latestPrice,
    required this.percentChange,
  });
}

class MarketController extends GetxController {
  final MarketService _service;
  MarketController(this._service);

  final loading = false.obs;
  final error = RxnString();
  final result = Rxn<MarketResult>();

  Future<void> loadOneYearReturn(String symbol) async {
    loading.value = true;
    error.value = null;
    result.value = null;
    try {
      final data = await _service.fetchOneYearPrices(symbol);
      if (data == null || data.start == null || data.latest == null) {
        throw Exception('No data');
      }
      final start = data.start!;
      final latest = data.latest!;
      final pct = (latest - start) / start;
      result.value = MarketResult(
        startPrice: start,
        latestPrice: latest,
        percentChange: pct,
      );
    } catch (e) {
      error.value = 'Failed to load data';
    } finally {
      loading.value = false;
    }
  }
}
