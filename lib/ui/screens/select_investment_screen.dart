import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

import '../../controllers/selection_controller.dart';
import '../../routes/app_pages.dart';
import '../../data/investments.dart';
import '../colors.dart';
import '../components/kid_friendly_app_bar.dart';

class SelectInvestmentScreen extends StatelessWidget {
  const SelectInvestmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selection = Get.find<SelectionController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: SimpleKidAppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: TurfitColors.whiteDark,
            size: 20.sp,
          ),
          onPressed: () => Get.back(),
        ),
        title: '📈 Pick an Investment',
        automaticallyImplyLeading: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colorScheme.surface, colorScheme.surface.withOpacity(0.8)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Purchase Summary
                  Obx(() {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            TurfitColors.primaryLight.withOpacity(0.08),
                            TurfitColors.tertiaryLight.withOpacity(0.08),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: TurfitColors.primaryLight.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.5.w),
                            decoration: BoxDecoration(
                              color: TurfitColors.primaryLight.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.monetization_on_rounded,
                              size: 20.sp,
                              color: TurfitColors.primaryLight,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Investment Amount',
                                  style: GoogleFonts.nunito(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                    color: TurfitColors.grey600(context),
                                  ),
                                ),
                                SizedBox(height: 0.2.h),
                                Text(
                                  '\$${selection.enteredPrice.value.toStringAsFixed(2)}',
                                  style: GoogleFonts.nunito(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Text(
                              'for ${selection.selectedItemName.value}',
                              style: GoogleFonts.nunito(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: TurfitColors.grey600(context),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),

                  SizedBox(height: 3.h),

                  // Instructions
                  Text(
                    '🎯 Choose your investment',
                    style: GoogleFonts.nunito(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ).animate(delay: 200.ms).fadeIn().slideX(begin: -0.3),

                  SizedBox(height: 0.5.h),

                  Text(
                    'See how your money could have grown',
                    style: GoogleFonts.nunito(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: TurfitColors.grey600(context),
                    ),
                  ).animate(delay: 400.ms).fadeIn(),

                  SizedBox(height: 2.h),
                ],
              ),
            ),

            // Investment List
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemBuilder: (context, index) {
                  final inv = investments[index];
                  return Bounceable(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      selection.pickInvestment(inv.symbol, inv.name, inv.emoji);
                      Get.toNamed(Routes.result);
                    },
                    child:
                        Container(
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: TurfitColors.white(context),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: TurfitColors.grey200(context),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: TurfitColors.primaryLight
                                        .withOpacity(0.04),
                                    offset: const Offset(0, 2),
                                    blurRadius: 6,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Investment Icon
                                  Container(
                                    padding: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                      color: TurfitColors.grey100(context),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      inv.emoji,
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ),
                                  SizedBox(width: 3.w),

                                  // Investment Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          inv.name,
                                          style: GoogleFonts.nunito(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w700,
                                            color: colorScheme.onSurface,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 0.2.h),
                                        Text(
                                          inv.symbol,
                                          style: GoogleFonts.nunito(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w600,
                                            color: TurfitColors.grey600(
                                              context,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Arrow Icon
                                  Container(
                                    padding: EdgeInsets.all(1.5.w),
                                    decoration: BoxDecoration(
                                      color: TurfitColors.primaryLight
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 12.sp,
                                      color: TurfitColors.primaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .animate(
                              delay: Duration(
                                milliseconds: 600 + (index * 100),
                              ),
                            )
                            .fadeIn(duration: 400.ms)
                            .slideX(begin: 0.3),
                  );
                },
                separatorBuilder: (_, __) => SizedBox(height: 1.2.h),
                itemCount: investments.length,
              ),
            ),

            // Bottom Info
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: TurfitColors.grey100(context),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 14.sp,
                    color: TurfitColors.grey600(context),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Past performance doesn\'t guarantee future results',
                      style: GoogleFonts.nunito(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w500,
                        color: TurfitColors.grey600(context),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate(delay: 1200.ms).fadeIn().slideY(begin: 0.2),
          ],
        ),
      ),
    );
  }
}
