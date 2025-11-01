import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../db/app_db.dart';
import 'package:get/get.dart';
import '../icon_utils.dart';
import '../colors.dart';
import '../components/engagement_widgets.dart';
import '../components/kid_friendly_app_bar.dart';

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
    return Scaffold(
      backgroundColor: TurfitColors.surfaceLight,
      appBar: KidFriendlyAppBar(
        title: '💰 Your Smart Savings',
        subtitle: 'See how much your "what-ifs" could grow! 🌱',
        trailing: StreamBuilder<List<Saving>>(
          stream: db.watchSavings(),
          builder: (context, snapshot) {
            final savings = snapshot.data ?? [];
            final weekAgo = DateTime.now().subtract(const Duration(days: 7));
            final weeklyCount = savings
                .where((s) => s.createdAt.isAfter(weekAgo))
                .length;

            return StreakBadge(
              streakCount: weeklyCount,
              label: '',
            ).animate(delay: 500.ms).fadeIn().scale();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(4.w),
        child: StreamBuilder<List<Saving>>(
          stream: db.watchSavings(),
          builder: (context, snap) {
            final all = snap.data ?? const [];
            if (all.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('🤔', style: TextStyle(fontSize: 60.sp))
                        .animate()
                        .scale(duration: 800.ms, curve: Curves.elasticOut),
                    SizedBox(height: 3.h),
                    Text(
                      'No savings yet!',
                      style: GoogleFonts.nunito(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: TurfitColors.onSurfaceLight,
                      ),
                    ).animate(delay: 400.ms).fadeIn(),
                    SizedBox(height: 1.h),
                    Text(
                      'Tap the "New What-If" button to start exploring how your purchases could grow as investments! 🚀',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ).animate(delay: 600.ms).fadeIn(),
                  ],
                ),
              );
            }

            // Build year list from existing entries
            final years = all.map((s) => s.createdAt.year).toSet().toList()
              ..sort();
            final filtered = all.where((s) {
              final yOk =
                  selectedYear == null || s.createdAt.year == selectedYear;
              final mOk =
                  selectedMonth == null || s.createdAt.month == selectedMonth;
              return yOk && mOk;
            }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced Filters
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: TurfitColors.primaryLight.withOpacity(0.1),
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.filter_list,
                        color: TurfitColors.primaryLight,
                        size: 20.sp,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: DropdownButtonFormField<int?>(
                          isExpanded: true,
                          initialValue: selectedYear,
                          decoration: InputDecoration(
                            labelText: 'Year',
                            border: InputBorder.none,
                            labelStyle: GoogleFonts.nunito(fontSize: 12.sp),
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
                          onChanged: (v) => setState(() => selectedYear = v),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: DropdownButtonFormField<int?>(
                          isExpanded: true,
                          initialValue: selectedMonth,
                          decoration: InputDecoration(
                            labelText: 'Month',
                            border: InputBorder.none,
                            labelStyle: GoogleFonts.nunito(fontSize: 12.sp),
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
                                  DateFormat.MMM().format(DateTime(2000, m)),
                                ),
                              ),
                            ),
                          ],
                          onChanged: (v) => setState(() => selectedMonth = v),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),

                Expanded(
                  child: filtered.isEmpty
                      ? const Center(child: Text('No results for this filter'))
                      : ListView.separated(
                          itemCount: all.length,
                          separatorBuilder: (_, __) => SizedBox(height: 1.h),
                          itemBuilder: (_, i) {
                            final s = filtered[i];
                            final sign = s.returnPct >= 0 ? '+' : '';
                            final inc = s.finalValue - s.amount;
                            return Bounceable(
                              onTap: () =>
                                  Get.toNamed('/saving-detail', arguments: s),
                              child: Container(
                                margin: EdgeInsets.only(bottom: 2.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: TurfitColors.primaryLight
                                          .withValues(alpha: 0.08),
                                      offset: const Offset(0, 3),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(4.w),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(2.5.w),
                                        decoration: BoxDecoration(
                                          color: inc >= 0
                                              ? TurfitColors.successLight
                                                    .withValues(alpha: 0.2)
                                              : TurfitColors.errorLight
                                                    .withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        child: Icon(
                                          iconFromName(s.itemIconName),
                                          size: 20.sp,
                                          color: inc >= 0
                                              ? TurfitColors.successLight
                                              : TurfitColors.errorLight,
                                        ),
                                      ),
                                      SizedBox(width: 3.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${s.itemName} → ${s.investmentName}',
                                              style: GoogleFonts.nunito(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 0.8.h),
                                            Text(
                                              DateFormat(
                                                'MMM d, y',
                                              ).format(s.createdAt),
                                              style: GoogleFonts.nunito(
                                                fontSize: 9.sp,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            SizedBox(height: 1.5.h),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Base: ${_money(s.amount)}',
                                                  style: GoogleFonts.nunito(
                                                    fontSize: 11.sp,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '$sign${_money(inc)}',
                                                      style: GoogleFonts.nunito(
                                                        color: inc >= 0
                                                            ? Colors.green
                                                            : Colors.red,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13.sp,
                                                      ),
                                                    ),
                                                    Text(
                                                      '$sign${s.returnPct.toStringAsFixed(0)}%',
                                                      style: GoogleFonts.nunito(
                                                        fontSize: 10.sp,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
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
    );
  }

  String _money(double v) => '\$${v.toStringAsFixed(2)}';
}
