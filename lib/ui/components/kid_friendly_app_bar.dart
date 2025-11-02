import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/audio_service.dart';
import '../colors.dart';

class KidFriendlyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;
  final int notificationCount;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const KidFriendlyAppBar({
    super.key,
    required this.title,
    this.subtitle = '',
    this.trailing,
    this.onMenuTap,
    this.onNotificationTap,
    this.notificationCount = 0,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;

    // Adaptive sizing based on screen width
    final titleSize = screenWidth < 360 ? 14.sp : 16.sp;
    final subtitleSize = screenWidth < 360 ? 9.sp : 10.sp;
    final paddingHorizontal = screenWidth < 360 ? 4.w : 6.w;
    final paddingVertical = isLandscape ? 2.h : 3.h;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [TurfitColors.gradientStart, TurfitColors.gradientEnd],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(isLandscape ? 20 : 30),
          bottomRight: Radius.circular(isLandscape ? 20 : 30),
        ),
        boxShadow: [
          BoxShadow(
            color: TurfitColors.primaryLight.withValues(alpha: 0.2),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontal,
            vertical: paddingVertical,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Responsive layout based on available width
              if (constraints.maxWidth < 400) {
                return _buildCompactLayout(titleSize, subtitleSize);
              } else {
                return _buildStandardLayout(titleSize, subtitleSize);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStandardLayout(double titleSize, double subtitleSize) {
    return Row(
      children: [
        // Leading action
        if (showBackButton)
          _buildActionButton(
            icon: Icons.arrow_back_ios,
            onTap: () {
              AudioService().playButtonClick();
              if (onBackPressed != null) onBackPressed!();
            },
          )
        else if (onMenuTap != null)
          _buildActionButton(
            icon: Icons.menu_rounded,
            onTap: () {
              AudioService().playButtonClick();
              onMenuTap!();
            },
          ),

        if (showBackButton || onMenuTap != null) SizedBox(width: 3.w),

        // Title section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.nunito(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w800,
                  color: TurfitColors.whiteLight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ).animate().fadeIn().slideX(begin: -0.3, duration: 600.ms),
              if (subtitle.isNotEmpty) ...[
                SizedBox(height: 0.5.h),
                Text(
                      subtitle,
                      style: GoogleFonts.nunito(
                        fontSize: subtitleSize,
                        fontWeight: FontWeight.w600,
                        color: TurfitColors.whiteLight.withValues(alpha: 0.9),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                    .animate()
                    .fadeIn(delay: 300.ms)
                    .slideX(begin: -0.2, duration: 500.ms),
              ],
            ],
          ),
        ),

        // Trailing actions
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onNotificationTap != null) _buildNotificationButton(),
            if (trailing != null) ...[SizedBox(width: 2.w), trailing!],
          ],
        ),
      ],
    );
  }

  Widget _buildCompactLayout(double titleSize, double subtitleSize) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top row with actions
        Row(
          children: [
            // Leading action
            if (showBackButton)
              _buildActionButton(
                icon: Icons.arrow_back_ios,
                onTap: () {
                  AudioService().playButtonClick();
                  if (onBackPressed != null) onBackPressed!();
                },
              )
            else if (onMenuTap != null)
              _buildActionButton(
                icon: Icons.menu_rounded,
                onTap: () {
                  AudioService().playButtonClick();
                  onMenuTap!();
                },
              ),

            Expanded(
              child: Text(
                title,
                style: GoogleFonts.nunito(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w800,
                  color: TurfitColors.whiteLight,
                ),
                textAlign: (showBackButton || onMenuTap != null)
                    ? TextAlign.center
                    : TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ).animate().fadeIn().slideX(begin: -0.3, duration: 600.ms),
            ),

            // Trailing actions
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onNotificationTap != null) _buildNotificationButton(),
                if (trailing != null) ...[SizedBox(width: 1.w), trailing!],
              ],
            ),
          ],
        ),

        // Subtitle on second row for compact layout
        if (subtitle.isNotEmpty) ...[
          SizedBox(height: 1.h),
          Text(
                subtitle,
                style: GoogleFonts.nunito(
                  fontSize: subtitleSize,
                  fontWeight: FontWeight.w600,
                  color: TurfitColors.whiteLight.withValues(alpha: 0.9),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
              .animate()
              .fadeIn(delay: 300.ms)
              .slideX(begin: -0.2, duration: 500.ms),
        ],
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: TurfitColors.whiteLight.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: TurfitColors.whiteLight.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Icon(icon, color: TurfitColors.whiteLight, size: 20.sp),
      ),
    ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildNotificationButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onNotificationTap?.call();
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: TurfitColors.whiteLight.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: TurfitColors.whiteLight.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.notifications_rounded,
              color: TurfitColors.whiteLight,
              size: 20.sp,
            ),
          ),
          if (notificationCount > 0)
            Positioned(
              top: -2,
              right: -2,
              child:
                  Container(
                        padding: EdgeInsets.all(0.5.w),
                        constraints: BoxConstraints(
                          minWidth: 4.w,
                          minHeight: 4.w,
                        ),
                        decoration: BoxDecoration(
                          color: TurfitColors.secondaryLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: TurfitColors.whiteLight,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          notificationCount > 99
                              ? '99+'
                              : notificationCount.toString(),
                          style: GoogleFonts.nunito(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w700,
                            color: TurfitColors.whiteLight,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1.1, 1.1),
                        duration: 1000.ms,
                      )
                      .then()
                      .scale(
                        begin: const Offset(1.1, 1.1),
                        end: const Offset(0.8, 0.8),
                        duration: 1000.ms,
                      ),
            ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.8, 0.8));
  }

  @override
  Size get preferredSize {
    // Dynamic height based on orientation
    return Size.fromHeight(
      WidgetsBinding
                  .instance
                  .platformDispatcher
                  .views
                  .first
                  .physicalSize
                  .width >
              WidgetsBinding
                  .instance
                  .platformDispatcher
                  .views
                  .first
                  .physicalSize
                  .height
          ? 80 // Landscape
          : 120, // Portrait
    );
  }
}

// Alternative simpler app bar for when you just need basic functionality
class SimpleKidAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;

  const SimpleKidAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.nunito(
          fontSize: 18.sp,
          fontWeight: FontWeight.w800,
          color: TurfitColors.whiteLight,
        ),
      ),
      backgroundColor: TurfitColors.transparentLight,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [TurfitColors.gradientStart, TurfitColors.gradientEnd],
          ),
        ),
      ),
      elevation: 0,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: actions,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10);
}
