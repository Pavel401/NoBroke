import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../controllers/selection_controller.dart';
import '../../controllers/market_controller.dart';
import '../../services/market_service.dart';
import '../../db/app_db.dart';
import 'package:drift/drift.dart' as d;

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final MarketController market;

  @override
  void initState() {
    super.initState();
    market = Get.put(MarketController(MarketService()));
    final symbol =
        Get.find<SelectionController>().selectedInvestmentSymbol.value;
    if (symbol.isNotEmpty) {
      market.loadOneYearReturn(symbol);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selection = Get.find<SelectionController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Your what‑if')),
      body: Padding(
        padding: EdgeInsets.all(6.w),
        child: Obx(() {
          if (market.loading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (market.error.value != null) {
            return const Center(
              child: Text('Could not load data. Try again later.'),
            );
          }
          final res = market.result.value;
          if (res == null || res.startPrice == 0 || res.latestPrice == 0) {
            return const Center(child: Text('No data available.'));
          }

          final amount = selection.enteredPrice.value;
          final growthRatio = (res.startPrice > 0)
              ? (res.latestPrice / res.startPrice)
              : 0.0;
          final grown = amount * growthRatio;
          final returnPct = (growthRatio - 1) * 100;
          final pctText = returnPct.toStringAsFixed(0);
          final sign = returnPct >= 0 ? '+' : '';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'If you had invested ${_money(amount)} in ${selection.selectedInvestmentName.value} one year ago…',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 3.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _money(grown),
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '$sign$pctText%',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: returnPct >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                '💡 Past performance is not an indicator of future results.',
                style: TextStyle(fontSize: 10.sp),
              ),
              SizedBox(height: 1.h),
              Text(
                'Fun fact: Teens who invest early benefit from the power of compounding.',
                style: TextStyle(fontSize: 10.sp),
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.offAllNamed('/'),
                      child: const Text('Try another item'),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final db = Get.find<AppDb>();
                        await db.addSaving(
                          SavingsCompanion.insert(
                            itemName: selection.selectedItemName.value,
                            amount: amount,
                            symbol: selection.selectedInvestmentSymbol.value,
                            investmentName:
                                selection.selectedInvestmentName.value,
                            finalValue: grown,
                            returnPct: returnPct,
                            itemIconName: d.Value(
                              selection.selectedItemIconName.value.isEmpty
                                  ? null
                                  : selection.selectedItemIconName.value,
                            ),
                          ),
                        );
                        Get.snackbar('Saved', 'Added to your savings');
                        Get.offAllNamed('/tabs');
                      },
                      child: const Text('Save to Home'),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  String _money(double v) => '\u0024${v.toStringAsFixed(2)}';
}
