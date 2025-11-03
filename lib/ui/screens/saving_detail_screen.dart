import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:what_if/ui/colors.dart';
import 'package:what_if/ui/components/kid_friendly_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../db/app_db.dart';
import '../../services/audio_service.dart';
import '../icon_utils.dart';
import '../components/awesome_snackbar_helper.dart';

class SavingDetailScreen extends StatelessWidget {
  const SavingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Saving saving = Get.arguments as Saving;
    final db = Get.find<AppDb>();
    final df = DateFormat('MMM d, y');
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final base = saving.amount;
    final growthFactor = 1 + (saving.returnPct / 100.0);
    final inc = saving.finalValue - saving.amount;
    final isPositive = inc >= 0;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: SimpleKidAppBar(
        title: '💰 Savings Details',
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: TurfitColors.whiteDark,
            size: 24.sp,
          ),
          onPressed: () {
            AudioService().playButtonClick();
            Get.back();
          },
        ),
        actions: [
          Bounceable(
            onTap: () {
              AudioService().playButtonClick();
              _shareAchievement(context, saving);
            },

            child: Container(
              margin: EdgeInsets.only(right: 2.w),
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.share,
                color: TurfitColors.green(context),
                size: 20.sp,
              ),
            ),
          ),
          Bounceable(
            onTap: () {
              AudioService().playButtonClick();
              _showDeleteDialog(context, saving, db);
            },
            child: Container(
              margin: EdgeInsets.only(right: 4.w),
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.delete_outline,
                color: TurfitColors.errorLight,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card with Investment Overview
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isPositive
                      ? [
                          TurfitColors.successLight.withValues(alpha: 0.1),
                          TurfitColors.primaryLight.withValues(alpha: 0.05),
                        ]
                      : [
                          TurfitColors.errorLight.withValues(alpha: 0.1),
                          TurfitColors.secondaryLight.withValues(alpha: 0.05),
                        ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isPositive
                      ? TurfitColors.successLight.withValues(alpha: 0.3)
                      : TurfitColors.errorLight.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        (isPositive
                                ? TurfitColors.successLight
                                : TurfitColors.errorLight)
                            .withValues(alpha: 0.1),
                    offset: const Offset(0, 8),
                    blurRadius: 20,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: isPositive
                              ? TurfitColors.successLight.withValues(alpha: 0.2)
                              : TurfitColors.errorLight.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isPositive
                                ? TurfitColors.successLight.withValues(
                                    alpha: 0.4,
                                  )
                                : TurfitColors.errorLight.withValues(
                                    alpha: 0.4,
                                  ),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          iconFromName(saving.itemIconName),
                          size: 28.sp,
                          color: isPositive
                              ? TurfitColors.successLight
                              : TurfitColors.errorLight,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              saving.itemName,
                              style: GoogleFonts.nunito(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.trending_up_rounded,
                                  size: 14.sp,
                                  color: TurfitColors.primaryLight,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  saving.investmentName,
                                  style: GoogleFonts.nunito(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: TurfitColors.primaryLight,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 0.8.h,
                              ),
                              decoration: BoxDecoration(
                                color: TurfitColors.grey200(context),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                df.format(saving.createdAt),
                                style: GoogleFonts.nunito(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: TurfitColors.grey600(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  // Return Overview
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: TurfitColors.white(context).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: TurfitColors.grey300(context),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Original Amount',
                                style: GoogleFonts.nunito(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: TurfitColors.grey600(context),
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                _money(base),
                                style: GoogleFonts.nunito(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w800,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 5.h,
                          width: 1,
                          color: TurfitColors.grey300(context),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '1-Year Return',
                                style: GoogleFonts.nunito(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: TurfitColors.grey600(context),
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 3.w,
                                  vertical: 0.8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isPositive
                                      ? TurfitColors.successLight.withValues(
                                          alpha: 0.2,
                                        )
                                      : TurfitColors.errorLight.withValues(
                                          alpha: 0.2,
                                        ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${saving.returnPct >= 0 ? '+' : ''}${saving.returnPct.toStringAsFixed(1)}%',
                                  style: GoogleFonts.nunito(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w800,
                                    color: isPositive
                                        ? TurfitColors.successLight
                                        : TurfitColors.errorLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),

            SizedBox(height: 3.h),

            // Growth Projection Section
            Row(
              children: [
                Lottie.asset(
                  'assets/lotties/analytics.json',
                  width: 12.w,
                  height: 12.w,
                  fit: BoxFit.contain,
                  repeat: true,
                  animate: true,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Growth Projections',
                  style: GoogleFonts.nunito(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ).animate(delay: 200.ms).fadeIn().slideX(begin: -0.3),
              ],
            ),

            SizedBox(height: 1.h),

            Text(
              'See how your money could grow over time with compound returns!',
              style: GoogleFonts.nunito(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: TurfitColors.grey600(context),
              ),
            ).animate(delay: 400.ms).fadeIn(),

            SizedBox(height: 2.h),

            // Projections List
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: TurfitColors.grey200(context),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: TurfitColors.primaryLight.withValues(alpha: 0.05),
                    offset: const Offset(0, 4),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                children: List.generate(5, (i) {
                  final years = i + 1;
                  final value = base * MathUtils.pow(growthFactor, years);
                  final projectedInc = value - base;
                  final isProjectedPositive = projectedInc >= 0;

                  return Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      border: i < 4
                          ? Border(
                              bottom: BorderSide(
                                color: TurfitColors.grey200(context),
                                width: 1,
                              ),
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 12.w,
                          height: 6.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                TurfitColors.primaryLight.withValues(
                                  alpha: 0.1,
                                ),
                                TurfitColors.tertiaryLight.withValues(
                                  alpha: 0.1,
                                ),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: TurfitColors.primaryLight.withValues(
                                alpha: 0.3,
                              ),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$years',
                              style: GoogleFonts.nunito(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                color: TurfitColors.primaryLight,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$years year${years > 1 ? 's' : ''}',
                                style: GoogleFonts.nunito(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                'Total Value: ${_money(value)}',
                                style: GoogleFonts.nunito(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: TurfitColors.grey600(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: isProjectedPositive
                                    ? TurfitColors.successLight.withValues(
                                        alpha: 0.1,
                                      )
                                    : TurfitColors.errorLight.withValues(
                                        alpha: 0.1,
                                      ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isProjectedPositive
                                      ? TurfitColors.successLight.withValues(
                                          alpha: 0.3,
                                        )
                                      : TurfitColors.errorLight.withValues(
                                          alpha: 0.3,
                                        ),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                '${projectedInc >= 0 ? '+' : ''}${_money(projectedInc)}',
                                style: GoogleFonts.nunito(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w800,
                                  color: isProjectedPositive
                                      ? TurfitColors.successLight
                                      : TurfitColors.errorLight,
                                ),
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              '${projectedInc >= 0 ? '+' : ''}${(years * saving.returnPct).toStringAsFixed(0)}%',
                              style: GoogleFonts.nunito(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: TurfitColors.grey500(context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate(delay: (600 + i * 100).ms).fadeIn().slideX(begin: 0.3);
                }),
              ),
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    Saving saving,
    AppDb db,
  ) async {
    HapticFeedback.mediumImpact();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Text('🗑️', style: TextStyle(fontSize: 24.sp)),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                'Delete Saving?',
                style: GoogleFonts.nunito(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'This will permanently remove "${saving.itemName}" from your savings. This action cannot be undone.',
          style: GoogleFonts.nunito(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Bounceable(
            onTap: () {
              AudioService().playButtonClick();
              Navigator.pop(ctx, false);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: TurfitColors.grey200(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.nunito(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: TurfitColors.grey700(context),
                ),
              ),
            ),
          ),
          Bounceable(
            onTap: () {
              AudioService().playButtonClick();
              Navigator.pop(ctx, true);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: TurfitColors.errorLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Delete',
                style: GoogleFonts.nunito(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await db.deleteSaving(saving.id);
      Get.back();

      AwesomeSnackbarHelper.showSuccess(
        context,
        'Deleted!',
        'Removed "${saving.itemName}" from your savings',
      );
    }
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

class MathUtils {
  static double pow(double base, int exponent) {
    double result = 1.0;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }
}
