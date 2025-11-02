import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_confetti/flutter_confetti.dart';

import '../../controllers/selection_controller.dart';
import '../../controllers/market_controller.dart';
import '../../services/market_service.dart';
import '../../db/app_db.dart';
import '../colors.dart';
import '../components/kid_friendly_app_bar.dart';
import '../components/awesome_snackbar_helper.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: SimpleKidAppBar(
        title: '🎉 Your What-If Result',
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: TurfitColors.whiteDark,
            size: 20.sp,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colorScheme.surface, colorScheme.surface.withOpacity(0.8)],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Obx(() {
            if (market.loading.value) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: TurfitColors.primaryLight.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          TurfitColors.primaryLight,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Calculating your investment...',
                      style: GoogleFonts.nunito(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: TurfitColors.grey600(context),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (market.error.value != null) {
              return Center(
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: TurfitColors.errorLight.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: TurfitColors.errorLight.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 32.sp,
                        color: TurfitColors.errorLight,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Could not load data',
                        style: GoogleFonts.nunito(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: TurfitColors.errorLight,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Please try again later',
                        style: GoogleFonts.nunito(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: TurfitColors.grey600(context),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final res = market.result.value;
            if (res == null || res.startPrice == 0 || res.latestPrice == 0) {
              return Center(
                child: Text(
                  'No data available.',
                  style: GoogleFonts.nunito(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: TurfitColors.grey600(context),
                  ),
                ),
              );
            }

            final amount = selection.enteredPrice.value;
            final growthRatio = (res.startPrice > 0)
                ? (res.latestPrice / res.startPrice)
                : 0.0;
            final grown = amount * growthRatio;
            final returnPct = (growthRatio - 1) * 100;
            final pctText = returnPct.toStringAsFixed(0);
            final sign = returnPct >= 0 ? '+' : '';
            final isPositive = returnPct >= 0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Text
                Text(
                  'If you had invested ${_money(amount)} in ${selection.selectedInvestmentName.value} one year ago…',
                  style: GoogleFonts.nunito(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                    height: 1.4,
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3),

                SizedBox(height: 3.h),

                // Results Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isPositive
                          ? [
                              Colors.green.withOpacity(0.1),
                              Colors.teal.withOpacity(0.1),
                            ]
                          : [
                              Colors.red.withOpacity(0.1),
                              Colors.orange.withOpacity(0.1),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isPositive
                          ? Colors.green.withOpacity(0.3)
                          : Colors.red.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isPositive
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: isPositive
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              isPositive
                                  ? Icons.trending_up_rounded
                                  : Icons.trending_down_rounded,
                              size: 20.sp,
                              color: isPositive ? Colors.green : Colors.red,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your investment would be worth',
                                  style: GoogleFonts.nunito(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                    color: TurfitColors.grey600(context),
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  _money(grown),
                                  style: GoogleFonts.nunito(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w800,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color: isPositive
                              ? Colors.green.withOpacity(0.15)
                              : Colors.red.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$sign$pctText% ${isPositive ? 'growth' : 'loss'}',
                          style: GoogleFonts.nunito(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: isPositive ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.2),

                SizedBox(height: 3.h),

                // Educational Info
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: TurfitColors.grey100(context),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // Row(
                      //   children: [
                      //     Icon(
                      //       Icons.lightbulb_outline,
                      //       size: 16.sp,
                      //       color: TurfitColors.primaryLight,
                      //     ),
                      //     SizedBox(width: 2.w),
                      //     Expanded(
                      //       child: Text(
                      //         'Past performance is not an indicator of future results.',
                      //         style: GoogleFonts.nunito(
                      //           fontSize: 9.sp,
                      //           fontWeight: FontWeight.w600,
                      //           color: TurfitColors.grey600(context),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(height: 1.h),
                      Row(
                        children: [
                          Icon(
                            Icons.school_outlined,
                            size: 16.sp,
                            color: TurfitColors.tertiaryLight,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              'Fun fact: Teens who invest early benefit from the power of compounding.',
                              style: GoogleFonts.nunito(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w500,
                                color: TurfitColors.grey600(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate(delay: 800.ms).fadeIn(),

                const Spacer(),

                // Action Buttons
                Row(
                  children: [
                    // Expanded(
                    //   child: Bounceable(
                    //     onTap: () {
                    //       HapticFeedback.lightImpact();
                    //       Get.offAllNamed('/');
                    //     },
                    //     child: Container(
                    //       padding: EdgeInsets.symmetric(vertical: 2.h),
                    //       decoration: BoxDecoration(
                    //         color: TurfitColors.white(context),
                    //         borderRadius: BorderRadius.circular(14),
                    //         border: Border.all(
                    //           color: TurfitColors.grey300(context),
                    //           width: 1,
                    //         ),
                    //       ),
                    //       child: Center(
                    //         child: Text(
                    //           'Try Another Item',
                    //           style: GoogleFonts.nunito(
                    //             fontSize: 13.sp,
                    //             fontWeight: FontWeight.w700,
                    //             color: TurfitColors.grey700(context),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(width: 3.w),
                    Expanded(
                      child: Bounceable(
                        onTap: () async {
                          HapticFeedback.lightImpact();
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

                          // Launch confetti animation
                          Confetti.launch(
                            context,
                            options: const ConfettiOptions(
                              particleCount: 100,
                              spread: 70,
                              y: 0.6,
                            ),
                          );

                          AwesomeSnackbarHelper.showSuccess(
                            context,
                            'Saved!',
                            'Added to your savings tracker',
                          );
                          Get.offAllNamed('/tabs');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                TurfitColors.primaryLight,
                                TurfitColors.tertiaryLight,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: TurfitColors.primaryLight.withOpacity(
                                  0.25,
                                ),
                                offset: const Offset(0, 3),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Save to Home',
                              style: GoogleFonts.nunito(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ).animate(delay: 1200.ms).fadeIn().slideY(begin: 0.3),

                SizedBox(height: 1.h),
              ],
            );
          }),
        ),
      ),
    );
  }

  String _money(double v) => '\$${v.toStringAsFixed(2)}';
}
