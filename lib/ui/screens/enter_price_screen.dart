import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

import '../../controllers/selection_controller.dart';
import '../../routes/app_pages.dart';
import '../icon_utils.dart';
import '../colors.dart';
import '../components/kid_friendly_app_bar.dart';

class EnterPriceScreen extends StatefulWidget {
  const EnterPriceScreen({super.key});

  @override
  State<EnterPriceScreen> createState() => _EnterPriceScreenState();
}

class _EnterPriceScreenState extends State<EnterPriceScreen> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    final defaultPrice = (Get.arguments as num?)?.toDouble() ?? 0.0;
    _controller = TextEditingController(
      text: defaultPrice > 0 ? defaultPrice.toStringAsFixed(2) : '',
    );

    // Auto-focus the text field when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _validateInput() {
    final value = double.tryParse(_controller.text.replaceAll(',', ''));
    setState(() {
      _isValid = value != null && value > 0;
    });
  }

  void _onContinue() {
    final value = double.tryParse(_controller.text.replaceAll(',', ''));
    if (value == null || value <= 0) {
      HapticFeedback.mediumImpact();
      setState(() {
        _isValid = false;
      });
      Get.snackbar(
        '💰 Invalid Amount',
        'Please enter a positive number for your purchase!',
        backgroundColor: TurfitColors.errorLight.withOpacity(0.1),
        colorText: TurfitColors.errorLight,
        borderRadius: 12,
        margin: EdgeInsets.all(2.w),
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    HapticFeedback.lightImpact();
    final selection = Get.find<SelectionController>();
    selection.setPrice(value);
    Get.toNamed(Routes.selectInvestment);
  }

  @override
  Widget build(BuildContext context) {
    final selection = Get.find<SelectionController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: SimpleKidAppBar(
        title: '💰 Enter Price',
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
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selected Item Display
              Obx(() {
                final iconName = selection.selectedItemIconName.value;
                final itemName = selection.selectedItemName.value;

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
                          iconName.isNotEmpty
                              ? iconFromName(iconName)
                              : Icons.shopping_cart_rounded,
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
                              'Selected Item',
                              style: GoogleFonts.nunito(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: TurfitColors.grey600(context),
                              ),
                            ),
                            SizedBox(height: 0.2.h),
                            Text(
                              itemName.isNotEmpty ? itemName : 'Unknown Item',
                              style: GoogleFonts.nunito(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),

              SizedBox(height: 3.h),

              // Instructions
              Text(
                '💸 How much are you spending?',
                style: GoogleFonts.nunito(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ).animate(delay: 200.ms).fadeIn().slideX(begin: -0.3),

              SizedBox(height: 0.5.h),

              Text(
                'Enter the amount you\'re planning to spend',
                style: GoogleFonts.nunito(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: TurfitColors.grey600(context),
                ),
              ).animate(delay: 400.ms).fadeIn(),

              SizedBox(height: 2.h),

              // Price Input Field
              Container(
                decoration: BoxDecoration(
                  color: TurfitColors.white(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isValid
                        ? TurfitColors.grey200(context)
                        : TurfitColors.errorLight,
                    width: _isValid ? 1 : 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (_isValid
                                  ? TurfitColors.primaryLight
                                  : TurfitColors.errorLight)
                              .withOpacity(0.05),
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  style: GoogleFonts.nunito(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      padding: EdgeInsets.all(2.w),
                      child: Text(
                        '\$',
                        style: GoogleFonts.nunito(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: _isValid
                              ? TurfitColors.primaryLight
                              : TurfitColors.errorLight,
                        ),
                      ),
                    ),
                    hintText: '0.00',
                    hintStyle: GoogleFonts.nunito(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: TurfitColors.grey400(context),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 2.h,
                    ),
                    suffixIcon: _controller.text.isNotEmpty
                        ? Bounceable(
                            onTap: () {
                              _controller.clear();
                              _validateInput();
                            },
                            child: Container(
                              margin: EdgeInsets.all(1.5.w),
                              padding: EdgeInsets.all(1.w),
                              decoration: BoxDecoration(
                                color: TurfitColors.grey200(context),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.clear,
                                size: 16.sp,
                                color: TurfitColors.grey600(context),
                              ),
                            ),
                          )
                        : null,
                  ),
                  onChanged: (_) => _validateInput(),
                ),
              ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2),

              if (!_isValid) ...[
                SizedBox(height: 1.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 0.8.h,
                  ),
                  decoration: BoxDecoration(
                    color: TurfitColors.errorLight.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: TurfitColors.errorLight.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: TurfitColors.errorLight,
                        size: 14.sp,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          'Please enter a valid amount greater than \$0.00',
                          style: GoogleFonts.nunito(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: TurfitColors.errorLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: -0.1),
              ],

              SizedBox(height: 3.h),

              // Quick Amount Suggestions
              Text(
                '💡 Quick Suggestions',
                style: GoogleFonts.nunito(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ).animate(delay: 800.ms).fadeIn(),

              SizedBox(height: 1.5.h),

              Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children: [5, 10, 25, 50, 100, 200].map((amount) {
                  return Bounceable(
                    onTap: () {
                      _controller.text = amount.toStringAsFixed(2);
                      _validateInput();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 0.8.h,
                      ),
                      decoration: BoxDecoration(
                        color: TurfitColors.grey100(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: TurfitColors.grey300(context),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '\$$amount',
                        style: GoogleFonts.nunito(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: TurfitColors.grey700(context),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ).animate(delay: 1000.ms).fadeIn().slideY(begin: 0.1),

              SizedBox(height: 3.h),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: Bounceable(
                  onTap: _isValid && _controller.text.isNotEmpty
                      ? _onContinue
                      : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    decoration: BoxDecoration(
                      gradient: _isValid && _controller.text.isNotEmpty
                          ? LinearGradient(
                              colors: [
                                TurfitColors.primaryLight,
                                TurfitColors.tertiaryLight,
                              ],
                            )
                          : null,
                      color: _isValid && _controller.text.isNotEmpty
                          ? null
                          : TurfitColors.grey300(context),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: _isValid && _controller.text.isNotEmpty
                          ? [
                              BoxShadow(
                                color: TurfitColors.primaryLight.withOpacity(
                                  0.25,
                                ),
                                offset: const Offset(0, 3),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue to Investments',
                          style: GoogleFonts.nunito(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: _isValid && _controller.text.isNotEmpty
                                ? Colors.white
                                : TurfitColors.grey600(context),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: _isValid && _controller.text.isNotEmpty
                              ? Colors.white
                              : TurfitColors.grey600(context),
                          size: 18.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate(delay: 1200.ms).fadeIn().slideY(begin: 0.3),

              SizedBox(height: 1.h),
            ],
          ),
        ),
      ),
    );
  }
}
