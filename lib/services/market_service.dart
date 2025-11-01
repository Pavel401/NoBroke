import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';

class PriceSnapshot {
  final double? start; // ~1y ago close
  final double? latest; // most recent close

  PriceSnapshot({this.start, this.latest});
}

class MarketService {
  // Weekly TTL; can be overridden with manual Sync.
  static const _cacheTtlDays = 7;

  Box get _box => Hive.box('marketCache');

  Future<PriceSnapshot?> fetchOneYearPrices(
    String symbol, {
    bool forceRefresh = false,
  }) async {
    final cached = _box.get(symbol);
    if (cached is Map && !forceRefresh) {
      final ts =
          DateTime.tryParse(cached['updated'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      if (DateTime.now().difference(ts).inDays < _cacheTtlDays) {
        final closes = (cached['closes'] as List?)?.cast<num?>();
        if (closes != null && closes.isNotEmpty) {
          final first = _firstNonNull(closes)?.toDouble();
          final last = _lastNonNull(closes)?.toDouble();
          return PriceSnapshot(start: first, latest: last);
        }
      }
    }

    // Yahoo Finance chart API (unofficial). Works for mobile; CORS may block on web.
    final url = Uri.parse(
      'https://query1.finance.yahoo.com/v8/finance/chart/$symbol?range=1y&interval=1d',
    );
    final resp = await http.get(url);
    if (resp.statusCode != 200) return null;
    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    final result = data['chart']?['result'];
    if (result == null || result is! List || result.isEmpty) return null;
    final root = result[0] as Map<String, dynamic>;
    final indicators = root['indicators'] as Map<String, dynamic>?;
    final quoteList = indicators?['quote'] as List?;
    final firstQuote = (quoteList != null && quoteList.isNotEmpty)
        ? quoteList[0] as Map<String, dynamic>
        : null;
    final closesRaw = firstQuote?['close'] as List?;
    if (closesRaw == null) return null;

    final closes = closesRaw.cast<num?>();
    final first = _firstNonNull(closes)?.toDouble();
    final last = _lastNonNull(closes)?.toDouble();

    // print("The Updated Prices for $symbol are: $closes");

    await _box.put(symbol, {
      'updated': DateTime.now().toIso8601String(),
      'closes': closes,
    });

    print("The Updated Prices for $symbol are: $first to $last");

    return PriceSnapshot(start: first, latest: last);
  }

  Future<void> syncSymbols(List<String> symbols) async {
    for (final s in symbols) {
      await fetchOneYearPrices(s, forceRefresh: true);
    }
  }

  num? _firstNonNull(List<num?> values) {
    for (final v in values) {
      if (v != null) return v;
    }
    return null;
  }

  num? _lastNonNull(List<num?> values) {
    for (var i = values.length - 1; i >= 0; i--) {
      final v = values[i];
      if (v != null) return v;
    }
    return null;
  }
}
