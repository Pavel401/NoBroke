import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../db/app_db.dart';
import '../../services/audio_service.dart';
import 'package:get/get.dart';
import '../icon_utils.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: const KidFriendlyAppBar(
        title: '💰 Your Smart Savings',
        // trailing: StreamBuilder<List<Saving>>(
        //   stream: db.watchSavings(),
        //   builder: (context, snapshot) {
        //     final savings = snapshot.data ?? [];
        //     final weekAgo = DateTime.now().subtract(const Duration(days: 7));
        //     final weeklyCount = savings
        //         .where((s) => s.createdAt.isAfter(weekAgo))
        //         .length;

        //     return StreakBadge(
        //       streakCount: weeklyCount,
        //       label: '',
        //     ).animate(delay: 500.ms).fadeIn().scale();
        //   },
        // ),
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
                        color: colorScheme.onSurface,
                      ),
                    ).animate(delay: 400.ms).fadeIn(),
                    SizedBox(height: 1.h),
                    Text(
                      'Tap the "New What-If" button to start exploring how your purchases could grow as investments! 🚀',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
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
                // Filter Button
                Bounceable(
                  onTap: () {
                    AudioService().playButtonClick();
                    _showFilterBottomSheet(context, years);
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          offset: const Offset(0, 4),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_list,
                          color: colorScheme.primary,
                          size: 20.sp,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            _getFilterText(),
                            style: GoogleFonts.nunito(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: colorScheme.primary,
                          size: 18.sp,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                Expanded(
                  child: filtered.isEmpty
                      ? const Center(child: Text('No results for this filter'))
                      : ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => SizedBox(height: 1.h),
                          itemBuilder: (_, i) {
                            final s = filtered[i];
                            final sign = s.returnPct >= 0 ? '+' : '';
                            final inc = s.finalValue - s.amount;
                            return Bounceable(
                              onTap: () {
                                AudioService().playButtonClick();
                                Get.toNamed('/saving-detail', arguments: s);
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 2.h),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorScheme.primary.withValues(
                                        alpha: 0.08,
                                      ),
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
                                              ? colorScheme.primary.withValues(
                                                  alpha: 0.2,
                                                )
                                              : colorScheme.error.withValues(
                                                  alpha: 0.2,
                                                ),
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        child: Icon(
                                          iconFromName(s.itemIconName),
                                          size: 20.sp,
                                          color: inc >= 0
                                              ? colorScheme.primary
                                              : colorScheme.error,
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
                                                color: colorScheme.onSurface
                                                    .withValues(alpha: 0.6),
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
                                                    color: colorScheme.onSurface
                                                        .withValues(alpha: 0.6),
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
                                                            ? colorScheme
                                                                  .primary
                                                            : colorScheme.error,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13.sp,
                                                      ),
                                                    ),
                                                    Text(
                                                      '$sign${s.returnPct.toStringAsFixed(0)}%',
                                                      style: GoogleFonts.nunito(
                                                        fontSize: 10.sp,
                                                        color: colorScheme
                                                            .onSurface
                                                            .withValues(
                                                              alpha: 0.6,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      // SizedBox(width: 1.w),
                                      // // Share button
                                      // Bounceable(
                                      //   onTap: () {
                                      //     AudioService().playButtonClick();
                                      //     _shareAchievement(context, s);
                                      //   },
                                      //   child: Container(
                                      //     padding: EdgeInsets.all(2.w),
                                      //     decoration: BoxDecoration(
                                      //       color: colorScheme.primary
                                      //           .withValues(alpha: 0.1),
                                      //       borderRadius: BorderRadius.circular(
                                      //         8,
                                      //       ),
                                      //     ),
                                      //     child: Icon(
                                      //       Icons.share,
                                      //       size: 16.sp,
                                      //       color: TurfitColors.green(context),
                                      //     ),
                                      //   ),
                                      // ),
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

  String _getFilterText() {
    if (selectedYear == null && selectedMonth == null) {
      return 'Filter by time period';
    }

    final yearText = selectedYear?.toString() ?? 'All years';
    final monthText = selectedMonth != null
        ? DateFormat.MMM().format(DateTime(2000, selectedMonth!))
        : 'All months';

    if (selectedYear != null && selectedMonth != null) {
      return '$monthText $yearText';
    } else if (selectedYear != null) {
      return yearText;
    } else {
      return monthText;
    }
  }

  void _showFilterBottomSheet(BuildContext context, List<int> years) {
    final colorScheme = Theme.of(context).colorScheme;

    // Create local variables to track state within the bottom sheet
    int? tempSelectedYear = selectedYear;
    int? tempSelectedMonth = selectedMonth;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setBottomSheetState) => Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 3.h),

              // Title
              Text(
                '🔍 Filter Your Savings',
                style: GoogleFonts.nunito(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 3.h),

              // Year Filter
              Text(
                'Year',
                style: GoogleFonts.nunito(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 1.h),
              _buildFilterChipsInBottomSheet(
                context,
                options: [null, ...years],
                selectedValue: tempSelectedYear,
                onChanged: (value) {
                  setBottomSheetState(() => tempSelectedYear = value);
                },
                getLabel: (value) => value?.toString() ?? 'All Years',
              ),
              SizedBox(height: 3.h),

              // Month Filter
              Text(
                'Month',
                style: GoogleFonts.nunito(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 1.h),
              _buildFilterChipsInBottomSheet(
                context,
                options: [null, ...List.generate(12, (i) => i + 1)],
                selectedValue: tempSelectedMonth,
                onChanged: (value) {
                  setBottomSheetState(() => tempSelectedMonth = value);
                },
                getLabel: (value) => value != null
                    ? DateFormat.MMM().format(DateTime(2000, value))
                    : 'All Months',
              ),
              SizedBox(height: 4.h),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: Bounceable(
                      onTap: () {
                        AudioService().playButtonClick();
                        setBottomSheetState(() {
                          tempSelectedYear = null;
                          tempSelectedMonth = null;
                        });
                        setState(() {
                          selectedYear = null;
                          selectedMonth = null;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Clear All',
                            style: GoogleFonts.nunito(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Bounceable(
                      onTap: () {
                        AudioService().playButtonClick();
                        setState(() {
                          selectedYear = tempSelectedYear;
                          selectedMonth = tempSelectedMonth;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Apply Filters',
                            style: GoogleFonts.nunito(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChipsInBottomSheet<T>(
    BuildContext context, {
    required List<T> options,
    required T selectedValue,
    required Function(T) onChanged,
    required String Function(T) getLabel,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: options.map((option) {
        final isSelected = option == selectedValue;
        return Bounceable(
          onTap: () {
            AudioService().playButtonClick();
            onChanged(option);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.1)
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.outline.withValues(alpha: 0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Text(
              getLabel(option),
              style: GoogleFonts.nunito(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _shareAchievement(BuildContext context, Saving saving) async {
    try {
      // Navigate to achievement share preview screen
      Get.toNamed('/achievement-share-preview', arguments: saving);
    } catch (e) {
      // Handle error silently or show a simple message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not share achievement')),
      );
    }
  }

  String _money(double v) => '\$${v.toStringAsFixed(2)}';
}
