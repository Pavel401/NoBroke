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
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(2.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analytics',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 1.h),
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
                      monthlyTotals[key] = (monthlyTotals[key] ?? 0) + s.amount;
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(4.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'This Month',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Text(
                                      _money(currentMonthTotal),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(Icons.insights, size: 22.sp),
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
                        SizedBox(height: 2.h),
                        Text(
                          'Monthly Totals (last 12 months)',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        AspectRatio(
                          aspectRatio: 1.7,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(2.w, 2.w, 2.w, 1.w),
                              child: BarChart(
                                BarChartData(
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                  ),
                                  borderData: FlBorderData(show: false),
                                  barTouchData: BarTouchData(enabled: true),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 36,
                                        getTitlesWidget: (value, meta) {
                                          // Show compact values
                                          return Text(
                                            _shortMoney(value.toDouble()),
                                            style: TextStyle(fontSize: 8.sp),
                                          );
                                        },
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          final i = value.toInt();
                                          if (i < 0 || i >= months.length) {
                                            return const SizedBox.shrink();
                                          }
                                          final m = months[i];
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              top: 0.8.h,
                                            ),
                                            child: Text(
                                              DateFormat.MMM().format(m),
                                              style: TextStyle(fontSize: 8.sp),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  barGroups: [
                                    for (var i = 0; i < months.length; i++)
                                      BarChartGroupData(
                                        x: i,
                                        barRods: [
                                          BarChartRodData(
                                            toY:
                                                (monthlyTotals[months[i]] ?? 0),
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            width: 12,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Based on this month’s savings pace and last-year trends.',
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
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
    return SizedBox(
      width: 42.w,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 10.sp, color: Colors.grey[700]),
              ),
              SizedBox(height: 0.5.h),
              Text(
                AnalyticsScreen._money(value),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
