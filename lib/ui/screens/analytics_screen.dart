import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../db/app_db.dart';
import '../../services/audio_service.dart';
import '../colors.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _countController;

  // Year filter state
  int? selectedYear;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _countController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Start animations
    _slideController.forward();
    _fadeController.forward();
    _countController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = Get.find<AppDb>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: StreamBuilder<List<Saving>>(
          stream: db.watchSavings(),
          builder: (context, snapshot) {
            final allItems = snapshot.data ?? const [];
            final now = DateTime.now();

            // Build year list from existing entries
            final years = allItems.map((s) => s.createdAt.year).toSet().toList()
              ..sort();

            // Filter items by selected year (show all if no year selected)
            final items = allItems.where((s) {
              if (selectedYear == null) return true;
              return s.createdAt.year == selectedYear;
            }).toList();

            // Calculate yearly total (for selected year or all years)
            final yearlyTotal = selectedYear == null
                ? allItems.fold<double>(0, (sum, s) => sum + s.amount)
                : allItems
                      .where((s) => s.createdAt.year == selectedYear)
                      .fold<double>(0, (sum, s) => sum + s.amount);

            // Calculate monthly total for current month of selected year (or current year if no selection)
            final targetYear = selectedYear ?? now.year;
            final currentMonthTotal = allItems
                .where(
                  (s) =>
                      s.createdAt.year == targetYear &&
                      s.createdAt.month == now.month,
                )
                .fold<double>(0, (sum, s) => sum + s.amount);

            // Monthly data for chart
            // final monthlyData = _getMonthlyData(items, now);

            // Projections based on each saving's base amount and its ratio
            double projYears(int years) {
              return items.fold<double>(0.0, (sum, s) {
                final ratio = 1 + (s.returnPct / 100.0);
                final safeRatio = ratio < 0 ? 0.0 : ratio;
                final ratioPow = math.pow(safeRatio, years).toDouble();
                final projected = s.amount * ratioPow;
                return sum + projected;
              });
            }

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [TurfitColors.surfaceDark, TurfitColors.cardDark]
                      : [
                          TurfitColors.surfaceLight,
                          TurfitColors.searchBarLight,
                        ],
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Year Filter
                    if (allItems.isNotEmpty) _buildYearFilter(years),

                    if (allItems.isNotEmpty) SizedBox(height: 3.h),
                    // // Header with celebration
                    // SlideTransition(
                    //   position:
                    //       Tween<Offset>(
                    //         begin: const Offset(0, -1),
                    //         end: Offset.zero,
                    //       ).animate(
                    //         CurvedAnimation(
                    //           parent: _slideController,
                    //           curve: const Interval(
                    //             0.0,
                    //             0.6,
                    //             curve: Curves.elasticOut,
                    //           ),
                    //         ),
                    //       ),
                    //   child: _buildHeader(yearlyTotal, items.length),
                    // ),

                    // SizedBox(height: 3.h),

                    // Yearly Progress Card
                    FadeTransition(
                      opacity: _fadeController,
                      child: SlideTransition(
                        position:
                            Tween<Offset>(
                              begin: const Offset(-1, 0),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: _slideController,
                                curve: const Interval(
                                  0.2,
                                  0.8,
                                  curve: Curves.easeOut,
                                ),
                              ),
                            ),
                        child: _buildYearlyProgressCard(
                          yearlyTotal,
                          currentMonthTotal,
                        ),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Growth Projections Bar Chart
                    FadeTransition(
                      opacity: _fadeController,
                      child: SlideTransition(
                        position:
                            Tween<Offset>(
                              begin: const Offset(1, 0),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: _slideController,
                                curve: const Interval(
                                  0.3,
                                  0.9,
                                  curve: Curves.easeOut,
                                ),
                              ),
                            ),
                        child: _buildGrowthProjectionsBarChart(items),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // // Future Projections Cards
                    // SlideTransition(
                    //   position:
                    //       Tween<Offset>(
                    //         begin: const Offset(0, 1),
                    //         end: Offset.zero,
                    //       ).animate(
                    //         CurvedAnimation(
                    //           parent: _slideController,
                    //           curve: const Interval(
                    //             0.4,
                    //             1.0,
                    //             curve: Curves.elasticOut,
                    //           ),
                    //         ),
                    //       ),
                    //   child: _buildProjectionsSection(projYears),
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildYearFilter(List<int> years) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: TurfitColors.card(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.date_range, color: colorScheme.primary, size: 20.sp),
              SizedBox(width: 3.w),
              Text(
                'Select Year',
                style: GoogleFonts.nunito(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: TurfitColors.onSurface(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: [null, ...years].map((year) {
              final isSelected = year == selectedYear;
              return GestureDetector(
                onTap: () {
                  AudioService().playButtonClick();
                  setState(() => selectedYear = year);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary.withOpacity(0.1)
                        : TurfitColors.card(context),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline.withOpacity(0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    year?.toString() ?? 'All Years',
                    style: GoogleFonts.nunito(
                      fontSize: 12.sp,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
                          ? colorScheme.primary
                          : TurfitColors.onSurface(context),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double yearlyTotal, int totalSavings) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [TurfitColors.primaryLight, TurfitColors.secondaryLight],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: TurfitColors.primaryLight.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.analytics, color: Colors.white, size: 6.w),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Savings Journey 🚀',
                      style: GoogleFonts.nunito(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Amazing progress this year!',
                      style: GoogleFonts.nunito(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatBubble('💰', totalSavings.toString(), 'Smart Choices'),
              _buildStatBubble('📅', '${DateTime.now().year}', 'This Year'),
              _buildStatBubble(
                '⭐',
                yearlyTotal > 0 ? 'YES!' : 'START NOW',
                'Saving',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBubble(String emoji, String value, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Text(emoji, style: TextStyle(fontSize: 16.sp)),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: GoogleFonts.nunito(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 8.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearlyProgressCard(double yearlyTotal, double monthlyTotal) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [TurfitColors.tertiaryLight, TurfitColors.accentLight],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: TurfitColors.tertiaryLight.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('💎', style: TextStyle(fontSize: 20.sp)),
              SizedBox(width: 3.w),
              Text(
                selectedYear == null
                    ? 'Total Saved (All Years)'
                    : 'Total Saved in $selectedYear',
                style: GoogleFonts.nunito(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          AnimatedBuilder(
            animation: _countController,
            builder: (context, child) {
              final animatedValue = yearlyTotal * _countController.value;
              return Text(
                _money(animatedValue),
                style: GoogleFonts.nunito(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: Colors.white.withOpacity(0.9),
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'This month: ${_money(monthlyTotal)}',
                style: GoogleFonts.nunito(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthProjectionsBarChart(List<Saving> items) {
    // Calculate growth projections for 1-5 years based on stock returns
    final projectionData = <BarChartGroupData>[];
    final colors = [
      TurfitColors.successLight,
      TurfitColors.tertiaryLight,
      TurfitColors.primaryLight,
      TurfitColors.accentLight,
      TurfitColors.secondaryLight,
    ];

    // Get total invested amount
    final totalInvested = items.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );

    for (int year = 1; year <= 5; year++) {
      double totalProjectedValue = 0;

      // Calculate compound growth for each saving item
      for (final item in items) {
        final growthFactor = 1 + (item.returnPct / 100.0);
        final safeGrowthFactor = growthFactor < 0 ? 0.0 : growthFactor;
        final projectedValue = item.amount * _pow(safeGrowthFactor, year);
        totalProjectedValue += projectedValue;
      }

      projectionData.add(
        BarChartGroupData(
          x: year - 1,
          barRods: [
            BarChartRodData(
              toY: totalProjectedValue,
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [colors[year - 1].withOpacity(0.7), colors[year - 1]],
              ),
              width: 8.w,
              borderRadius: BorderRadius.circular(8),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: totalProjectedValue * 1.1, // Show potential
                color: TurfitColors.grey200(context),
              ),
            ),
          ],
        ),
      );
    }

    final maxY = projectionData.isNotEmpty
        ? projectionData.map((e) => e.barRods.first.toY).reduce(math.max) * 1.2
        : totalInvested * 2;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: TurfitColors.card(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: TurfitColors.primaryLight.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              LottieBuilder.asset(
                'assets/lotties/analytics.json',
                width: 6.w,
                height: 6.w,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Growth Projections',
                  style: GoogleFonts.nunito(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: TurfitColors.onSurface(context),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: TurfitColors.primaryLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Based on 1-year returns',
                  style: GoogleFonts.nunito(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: TurfitColors.primaryLight,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'See how your savings could grow with compound returns! 🚀',
            style: GoogleFonts.nunito(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: TurfitColors.grey600(context),
            ),
          ),
          SizedBox(height: 3.h),
          SizedBox(
            height: 30.h,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                minY: 0,
                groupsSpace: 4.w,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => TurfitColors.card(context),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final year = group.x + 1;
                      final value = rod.toY;
                      final growth = value - totalInvested;
                      return BarTooltipItem(
                        'Year $year\n',
                        GoogleFonts.nunito(
                          color: TurfitColors.onSurface(context),
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                        ),
                        children: [
                          TextSpan(
                            text: 'Total: ${_money(value)}\n',
                            style: GoogleFonts.nunito(
                              color: TurfitColors.primaryLight,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.sp,
                            ),
                          ),
                          TextSpan(
                            text: 'Growth: +${_money(growth)}',
                            style: GoogleFonts.nunito(
                              color: TurfitColors.successLight,
                              fontWeight: FontWeight.w600,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const years = ['1Y', '2Y', '3Y', '4Y', '5Y'];
                        if (value.toInt() >= 0 &&
                            value.toInt() < years.length) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: colors[value.toInt()].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              years[value.toInt()],
                              style: GoogleFonts.nunito(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: colors[value.toInt()],
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: math.max(
                        maxY / 4,
                        10,
                      ), // Ensure interval is never zero
                      getTitlesWidget: (value, meta) {
                        return Text(
                          _shortMoney(value),
                          style: GoogleFonts.nunito(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600,
                            color: TurfitColors.grey600(context),
                          ),
                        );
                      },
                      reservedSize: 12.w,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: math.max(
                    maxY / 4,
                    10,
                  ), // Ensure interval is never zero
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: TurfitColors.grey300(context),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
                barGroups: projectionData,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          // Legend
          Wrap(
            spacing: 2.w,
            children: List.generate(5, (index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: colors[index].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colors[index].withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 3.w,
                      height: 1.5.h,
                      decoration: BoxDecoration(
                        color: colors[index],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Year ${index + 1}',
                      style: GoogleFonts.nunito(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                        color: colors[index],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectionsSection(double Function(int) projYears) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('🔮', style: TextStyle(fontSize: 18.sp)),
            SizedBox(width: 3.w),
            Text(
              'Future Growth Projections',
              style: GoogleFonts.nunito(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: TurfitColors.onSurface(context),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 3.w,
          mainAxisSpacing: 2.h,
          childAspectRatio: 1.3,
          children: [
            _ProjectionCard(
              title: '1 Year',
              value: projYears(1),
              emoji: '🌱',
              color: TurfitColors.successLight,
              delay: 0,
            ),
            _ProjectionCard(
              title: '2 Years',
              value: projYears(2),
              emoji: '🌿',
              color: TurfitColors.tertiaryLight,
              delay: 200,
            ),
            _ProjectionCard(
              title: '3 Years',
              value: projYears(3),
              emoji: '🌳',
              color: TurfitColors.primaryLight,
              delay: 400,
            ),
            _ProjectionCard(
              title: '4 Years',
              value: projYears(4),
              emoji: '🏆',
              color: TurfitColors.accentLight,
              delay: 600,
            ),
          ],
        ),
      ],
    );
  }

  static String _money(double v) => '\$${v.toStringAsFixed(2)}';

  static String _shortMoney(double v) {
    if (v >= 1000000) return '\$${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '\$${(v / 1000).toStringAsFixed(0)}k';
    return '\$${v.toStringAsFixed(0)}';
  }

  // Power function for compound growth calculation
  double _pow(double base, int exponent) {
    double result = 1.0;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }
}

class _ProjectionCard extends StatefulWidget {
  final String title;
  final double value;
  final String emoji;
  final Color color;
  final int delay;

  const _ProjectionCard({
    required this.title,
    required this.value,
    required this.emoji,
    required this.color,
    required this.delay,
  });

  @override
  State<_ProjectionCard> createState() => _ProjectionCardState();
}

class _ProjectionCardState extends State<_ProjectionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _valueAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _valueAnimation = Tween<double>(
      begin: 0.0,
      end: widget.value,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Start animation after delay
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [widget.color, widget.color.withOpacity(0.7)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.emoji, style: TextStyle(fontSize: 18.sp)),
                Icon(
                  Icons.trending_up,
                  color: Colors.white.withOpacity(0.8),
                  size: 5.w,
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              widget.title,
              style: GoogleFonts.nunito(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            SizedBox(height: 0.5.h),
            AnimatedBuilder(
              animation: _valueAnimation,
              builder: (context, child) {
                return Text(
                  _AnalyticsScreenState._money(_valueAnimation.value),
                  style: GoogleFonts.nunito(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
