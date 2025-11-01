import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../db/app_db.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Get.find<AppDb>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(2.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: StreamBuilder<List<Saving>>(
                  stream: db.watchSavings(),
                  builder: (context, snapshot) {
                    final items = snapshot.data ?? const [];

                    // Compute current month total (sum of base amounts)
                    final now = DateTime.now();
                    final currentMonthTotal = items
                        .where(
                          (s) =>
                              s.createdAt.year == now.year &&
                              s.createdAt.month == now.month,
                        )
                        .fold<double>(0, (sum, s) => sum + s.amount);

                    // Build last 12 months buckets
                    final months = List.generate(12, (i) {
                      final d = DateTime(now.year, now.month - (11 - i));
                      return DateTime(d.year, d.month);
                    });

                    final monthlyTotals = <DateTime, double>{
                      for (final m in months) m: 0.0,
                    };
                    for (final s in items) {
                      final key = DateTime(s.createdAt.year, s.createdAt.month);
                      if (monthlyTotals.containsKey(key)) {
                        monthlyTotals[key] =
                            (monthlyTotals[key] ?? 0) + s.amount;
                      }
                    }

                    // Projections based on each saving's base amount and its ratio (1 + returnPct/100)
                    double projYears(int years) {
                      return items.fold<double>(0.0, (sum, s) {
                        final ratio = 1 + (s.returnPct / 100.0);
                        final safeRatio = ratio < 0 ? 0.0 : ratio;
                        final ratioPow = math.pow(safeRatio, years).toDouble();
                        final projected = s.amount * ratioPow;
                        return sum + projected;
                      });
                    }

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            color: colorScheme.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(4.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'This Month',
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          color: colorScheme.onSurface
                                              .withOpacity(0.7),
                                        ),
                                      ),
                                      SizedBox(height: 0.5.h),
                                      Text(
                                        _money(currentMonthTotal),
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.insights,
                                    size: 22.sp,
                                    color: colorScheme.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 1.5.h),
                          Text(
                            'Projections',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Wrap(
                            spacing: 3.w,
                            runSpacing: 2.h,
                            children: [
                              _ProjectionCard(
                                title: '1 year',
                                value: projYears(1),
                              ),
                              _ProjectionCard(
                                title: '2 years',
                                value: projYears(2),
                              ),
                              _ProjectionCard(
                                title: '3 years',
                                value: projYears(3),
                              ),
                              _ProjectionCard(
                                title: '5 years',
                                value: projYears(5),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _money(double v) => '\$${v.toStringAsFixed(2)}';
  static String _shortMoney(double v) {
    if (v >= 1000000) return '\$${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '\$${(v / 1000).toStringAsFixed(0)}k';
    return '\$${v.toStringAsFixed(0)}';
  }
}

class _ProjectionCard extends StatelessWidget {
  final String title;
  final double value;

  const _ProjectionCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: 42.w,
      child: Card(
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                AnalyticsScreen._money(value),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
