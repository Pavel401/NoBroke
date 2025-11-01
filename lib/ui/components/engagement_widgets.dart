import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colors.dart';

class StreakBadge extends StatelessWidget {
  final int streakCount;
  final String label;

  const StreakBadge({
    super.key,
    required this.streakCount,
    this.label = 'Day Streak',
  });

  @override
  Widget build(BuildContext context) {
    if (streakCount == 0) return const SizedBox.shrink();

    return Container(
          padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B6B).withOpacity(0.3),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lotties/streak.json',
                width: 16.sp,
                height: 16.sp,
                fit: BoxFit.contain,
                repeat: true,
              ),
              Text(
                '$streakCount',
                style: GoogleFonts.nunito(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: TurfitColors.white(context),
                ),
              ),
              SizedBox(width: 1.w),
            ],
          ),
        )
        .animate()
        .scale(duration: 400.ms, curve: Curves.elasticOut)
        .then()
        .shimmer(
          delay: 1000.ms,
          duration: 1500.ms,
          color: TurfitColors.white(context).withOpacity(0.3),
        );
  }
}

class AchievementBadge extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final bool isUnlocked;

  const AchievementBadge({
    super.key,
    required this.emoji,
    required this.title,
    required this.description,
    this.isUnlocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: isUnlocked
                ? TurfitColors.accentLight.withOpacity(0.1)
                : TurfitColors.grey200(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isUnlocked
                  ? TurfitColors.accentLight
                  : TurfitColors.grey300(context),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(
                emoji,
                style: TextStyle(
                  fontSize: 24.sp,
                  color: isUnlocked ? null : TurfitColors.grey400(context),
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                title,
                style: GoogleFonts.nunito(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: isUnlocked
                      ? TurfitColors.onSurfaceLight
                      : TurfitColors.grey500(context),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 0.5.h),
              Text(
                description,
                style: GoogleFonts.nunito(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                  color: isUnlocked
                      ? TurfitColors.grey600(context)
                      : TurfitColors.grey400(context),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        )
        .animate(target: isUnlocked ? 1 : 0)
        .scale(duration: 600.ms, curve: Curves.elasticOut)
        .then()
        .shimmer(
          duration: 2000.ms,
          color: TurfitColors.accentLight.withOpacity(0.3),
        );
  }
}

class QuickActionButton extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const QuickActionButton({
    super.key,
    required this.emoji,
    required this.label,
    required this.onTap,
    this.color = TurfitColors.primaryLight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: TextStyle(fontSize: 20.sp)),
            SizedBox(height: 1.h),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().scale(duration: 200.ms, curve: Curves.easeOut);
  }
}
