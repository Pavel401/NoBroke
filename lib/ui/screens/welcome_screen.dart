import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../routes/app_pages.dart';
import '../colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [TurfitColors.gradientStart, TurfitColors.gradientEnd],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(6.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App Title with animation
                Text(
                  '💰',
                  style: TextStyle(fontSize: 60.sp),
                ).animate().scale(duration: 800.ms, curve: Curves.elasticOut),
                SizedBox(height: 2.h),
                Text(
                      'What If I Invested?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                        color: TurfitColors.white(context),
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 300.ms)
                    .slideY(begin: 0.3, duration: 600.ms),
                SizedBox(height: 2.h),

                // Animated tagline
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Turn everyday choices into what-ifs that grow! 🌱',
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: TurfitColors.white(context).withOpacity(0.9),
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                  totalRepeatCount: 1,
                ),

                SizedBox(height: 6.h),

                // Main question with animation
                Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: TurfitColors.white(context).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: TurfitColors.white(context).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '🤔 What are you about to buy today?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: TurfitColors.white(context),
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 2000.ms)
                    .slideY(begin: 0.2, duration: 500.ms),

                SizedBox(height: 6.h),

                // Start button with enhanced styling
                Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [TurfitColors.accentLight, Color(0xFFFFA726)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: TurfitColors.accentLight.withOpacity(0.4),
                            offset: const Offset(0, 4),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () => Get.toNamed(Routes.selectItem),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TurfitColors.transparent(context),
                          shadowColor: TurfitColors.transparent(context),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '🚀 Let\'s Start!',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF2D3436),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 2500.ms)
                    .slideY(begin: 0.3, duration: 600.ms)
                    .then()
                    .shimmer(delay: 1000.ms, duration: 1500.ms),

                SizedBox(height: 4.h),

                // Fun stats or encouragement
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Text(
                    '💡 Did you know? Teens who start investing early have a huge advantage!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: TurfitColors.white(context).withOpacity(0.8),
                    ),
                  ),
                ).animate().fadeIn(delay: 3000.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
