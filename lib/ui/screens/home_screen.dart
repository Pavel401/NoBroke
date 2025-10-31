import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../db/app_db.dart';
import 'package:get/get.dart';
import '../icon_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? selectedYear;
  int? selectedMonth;

  @override
  Widget build(BuildContext context) {
    final db = Get.find<AppDb>();
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Savings',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 1.h),
            Expanded(
              child: StreamBuilder<List<Saving>>(
                stream: db.watchSavings(),
                builder: (context, snap) {
                  final all = snap.data ?? const [];
                  if (all.isEmpty) {
                    return const Center(
                      child: Text('No savings yet. Tap + to add.'),
                    );
                  }

                  // Build year list from existing entries
                  final years =
                      all.map((s) => s.createdAt.year).toSet().toList()..sort();
                  final filtered = all.where((s) {
                    final yOk =
                        selectedYear == null ||
                        s.createdAt.year == selectedYear;
                    final mOk =
                        selectedMonth == null ||
                        s.createdAt.month == selectedMonth;
                    return yOk && mOk;
                  }).toList();

                  // final weekAgo = DateTime.now().subtract(
                  //   const Duration(days: 7),
                  // );
                  // final weeklyCount = all
                  //     .where((s) => s.createdAt.isAfter(weekAgo))
                  //     .length;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // if (weeklyCount > 0)
                      //   Padding(
                      //     padding: EdgeInsets.only(bottom: 1.h),
                      //     child: Text('🔥 You\'ve rethought $weeklyCount purchases this week!', style: TextStyle(fontSize: 12.sp)),
                      //   ),
                      // // Filters
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int?>(
                              isExpanded: true,
                              initialValue: selectedYear,
                              decoration: const InputDecoration(
                                labelText: 'Year',
                              ),
                              items: [
                                const DropdownMenuItem<int?>(
                                  value: null,
                                  child: Text('All'),
                                ),
                                ...years.map(
                                  (y) => DropdownMenuItem<int?>(
                                    value: y,
                                    child: Text('$y'),
                                  ),
                                ),
                              ],
                              onChanged: (v) =>
                                  setState(() => selectedYear = v),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: DropdownButtonFormField<int?>(
                              isExpanded: true,
                              initialValue: selectedMonth,
                              decoration: const InputDecoration(
                                labelText: 'Month',
                              ),
                              items: [
                                const DropdownMenuItem<int?>(
                                  value: null,
                                  child: Text('All'),
                                ),
                                ...List.generate(12, (i) => i + 1).map(
                                  (m) => DropdownMenuItem<int?>(
                                    value: m,
                                    child: Text(
                                      DateFormat.MMM().format(
                                        DateTime(2000, m),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (v) =>
                                  setState(() => selectedMonth = v),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Expanded(
                        child: filtered.isEmpty
                            ? const Center(
                                child: Text('No results for this filter'),
                              )
                            : ListView.separated(
                                itemCount: filtered.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 1.h),
                                itemBuilder: (_, i) {
                                  final s = filtered[i];
                                  final sign = s.returnPct >= 0 ? '+' : '';
                                  final inc = s.finalValue - s.amount;
                                  return Dismissible(
                                    key: ValueKey(s.id),
                                    background: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                      ),
                                      child: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                    secondaryBackground: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                      ),
                                      child: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                    confirmDismiss: (_) async {
                                      return await showDialog<bool>(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text(
                                                'Delete saving?',
                                              ),
                                              content: const Text(
                                                'This action cannot be undone.',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(ctx, false),
                                                  child: const Text('Cancel'),
                                                ),
                                                FilledButton(
                                                  onPressed: () =>
                                                      Navigator.pop(ctx, true),
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            ),
                                          ) ??
                                          false;
                                    },
                                    onDismissed: (_) async {
                                      await db.deleteSaving(s.id);
                                      Get.snackbar(
                                        'Deleted',
                                        'Removed from your savings',
                                      );
                                    },
                                    child: InkWell(
                                      onTap: () => Get.toNamed(
                                        '/saving-detail',
                                        arguments: s,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(4.w),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              iconFromName(s.itemIconName),
                                              size: 22.sp,
                                            ),
                                            SizedBox(width: 3.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${s.itemName} → ${s.investmentName}',
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(height: 0.5.h),
                                                  Text(
                                                    DateFormat(
                                                      'MMM d, y',
                                                    ).format(s.createdAt),
                                                    style: TextStyle(
                                                      fontSize: 9.sp,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                  SizedBox(height: 1.h),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Base: ${_money(s.amount)}',
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            '+${_money(inc)}',
                                                            style: TextStyle(
                                                              color: inc >= 0
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          Text(
                                                            '$sign${s.returnPct.toStringAsFixed(0)}%',
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                final confirm = await showDialog<bool>(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    title: const Text(
                                                      'Delete saving?',
                                                    ),
                                                    content: const Text(
                                                      'This action cannot be undone.',
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                              ctx,
                                                              false,
                                                            ),
                                                        child: const Text(
                                                          'Cancel',
                                                        ),
                                                      ),
                                                      FilledButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                              ctx,
                                                              true,
                                                            ),
                                                        child: const Text(
                                                          'Delete',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                                if (confirm == true) {
                                                  await db.deleteSaving(s.id);
                                                  Get.snackbar(
                                                    'Deleted',
                                                    'Removed from your savings',
                                                  );
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.delete_outline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _money(double v) => '\$${v.toStringAsFixed(2)}';
}
