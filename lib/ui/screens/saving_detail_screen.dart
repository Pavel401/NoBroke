import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../db/app_db.dart';
import '../icon_utils.dart';

class SavingDetailScreen extends StatelessWidget {
  const SavingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Saving saving = Get.arguments as Saving;
    final db = Get.find<AppDb>();
    final df = DateFormat('MMM d, y');

    final base = saving.amount;
    final growthFactor = 1 + (saving.returnPct / 100.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete saving?'),
                  content: const Text('This action cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await db.deleteSaving(saving.id);
                Get.back();
                Get.snackbar('Deleted', 'Removed from your savings');
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(iconFromName(saving.itemIconName), size: 26.sp),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${saving.itemName} → ${saving.investmentName}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        df.format(saving.createdAt),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              'Base amount: ${_money(base)}',
              style: TextStyle(fontSize: 12.sp),
            ),
            Text(
              '1-year return: ${saving.returnPct.toStringAsFixed(0)}%',
              style: TextStyle(fontSize: 12.sp),
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Projected Value (compounded)',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  ...List.generate(5, (i) {
                    final years = i + 1;
                    final value = base * MathUtils.pow(growthFactor, years);
                    final inc = value - base;
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$years year${years > 1 ? 's' : ''}'),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _money(value),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '+${_money(inc)} (+${saving.returnPct.toStringAsFixed(0)}%)',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _money(double v) => '\$${v.toStringAsFixed(2)}';
}

class MathUtils {
  static double pow(double base, int exponent) {
    double result = 1.0;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }
}
