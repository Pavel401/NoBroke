import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colors.dart';

class KidFriendlyNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final List<KidNavDestination> destinations;

  const KidFriendlyNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  @override
  State<KidFriendlyNavBar> createState() => _KidFriendlyNavBarState();
}

class _KidFriendlyNavBarState extends State<KidFriendlyNavBar>
    with TickerProviderStateMixin {
  late List<AnimationController> _bounceControllers;
  late List<AnimationController> _pulseControllers;

  @override
  void initState() {
    super.initState();
    _bounceControllers = List.generate(
      widget.destinations.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );
    _pulseControllers = List.generate(
      widget.destinations.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      ),
    );

    // Start pulse animation for selected item
    if (widget.selectedIndex < _pulseControllers.length) {
      _pulseControllers[widget.selectedIndex].repeat();
    }
  }

  @override
  void dispose() {
    for (var controller in _bounceControllers) {
      controller.dispose();
    }
    for (var controller in _pulseControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(KidFriendlyNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Stop previous pulse and start new one
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      if (oldWidget.selectedIndex < _pulseControllers.length) {
        _pulseControllers[oldWidget.selectedIndex].stop();
        _pulseControllers[oldWidget.selectedIndex].reset();
      }
      if (widget.selectedIndex < _pulseControllers.length) {
        _pulseControllers[widget.selectedIndex].repeat();
      }
    }
  }

  void _onTap(int index) {
    HapticFeedback.lightImpact();

    // Bounce animation
    _bounceControllers[index].forward().then((_) {
      _bounceControllers[index].reverse();
    });

    widget.onDestinationSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Determine if device is tablet
    final isTablet = screenWidth > 600;

    // Responsive sizing based on device type
    final navHeight = isTablet
        ? (isLandscape ? 80.0 : 90.0) // Bigger for tablets
        : (isLandscape
              ? 60.0
              : (screenWidth < 360 ? 65.0 : 70.0)); // Smaller for phones
    final horizontalMargin = isTablet
        ? 6
              .w // More margin for tablets
        : (screenWidth < 360 ? 2.w : 3.w); // Less margin for phones
    final borderRadius = isTablet
        ? 30.0 // More rounded for tablets
        : (screenWidth < 360 ? 18.0 : 22.0); // Less rounded for phones

    return Container(
      height: navHeight,
      margin: EdgeInsets.symmetric(
        horizontal: horizontalMargin,
        vertical: isTablet
            ? (isLandscape ? 2.h : 3.h) // More vertical margin for tablets
            : (isLandscape ? 1.h : 1.5.h), // Less vertical margin for phones
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: Theme.of(context).brightness == Brightness.dark
              ? [TurfitColors.cardDark, TurfitColors.surfaceDark]
              : [const Color(0xFFFFFFFF), const Color(0xFFF8F6FF)],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: TurfitColors.primary(context).withValues(alpha: 0.15),
            offset: const Offset(0, 6),
            blurRadius: 20,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          widget.destinations.length,
          (index) => _buildNavItem(index),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final destination = widget.destinations[index];
    final isSelected = index == widget.selectedIndex;
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Determine if device is tablet (width > 600 is common tablet breakpoint)
    final isTablet = screenWidth > 600;

    // Responsive sizing based on device type
    final iconSize = isTablet
        ? (isSelected ? 28.sp : 24.sp) // Bigger for tablets
        : (screenWidth < 360 ? 14.sp : 16.sp); // Smaller for phones
    final selectedIconSize = isTablet
        ? 32
              .sp // Much bigger for tablets
        : (screenWidth < 360 ? 16.sp : 18.sp); // Smaller for phones
    final padding = isTablet
        ? 3
              .w // More padding for tablets
        : (screenWidth < 360 ? 1.w : 1.5.w); // Less padding for phones
    final selectedPadding = isTablet
        ? 4
              .w // More padding for tablets
        : (screenWidth < 360 ? 1.5.w : 2.w); // Less padding for phones

    return Expanded(
      child: GestureDetector(
        onTap: () => _onTap(index),
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _bounceControllers[index],
            _pulseControllers[index],
          ]),
          builder: (context, child) {
            final bounceValue = _bounceControllers[index].value;
            final pulseValue = _pulseControllers[index].value;

            return ClipRect(
              child: Transform.scale(
                scale:
                    1.0 -
                    (bounceValue *
                        0.06), // Reduced bounce scale to prevent overflow
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon container with animated background
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.elasticOut,
                      padding: EdgeInsets.all(
                        isSelected ? selectedPadding : padding,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  destination.selectedColor.withValues(
                                    alpha: 0.2,
                                  ),
                                  destination.selectedColor.withValues(
                                    alpha: 0.1,
                                  ),
                                ],
                              )
                            : null,
                        borderRadius: BorderRadius.circular(
                          isTablet ? 20 : 14,
                        ), // Bigger border radius for tablets
                        border: isSelected
                            ? Border.all(
                                color: destination.selectedColor.withValues(
                                  alpha: 0.3 + (pulseValue * 0.4),
                                ),
                                width: isTablet
                                    ? 3
                                    : 2, // Thicker border for tablets
                              )
                            : null,
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Emoji icon
                            Text(
                              destination.emoji,
                              style: TextStyle(
                                fontSize: isSelected
                                    ? selectedIconSize
                                    : iconSize,
                              ),
                            ),
                            if (destination.hasNotification) ...[
                              SizedBox(width: isTablet ? 2.w : 0.5.w),
                              Container(
                                    width: isTablet
                                        ? 12
                                        : 6, // Bigger for tablets, smaller for phones
                                    height: isTablet ? 12 : 6,
                                    decoration: BoxDecoration(
                                      color: TurfitColors.secondary(context),
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                  .animate(
                                    onPlay: (controller) => controller.repeat(),
                                  )
                                  .scale(
                                    begin: const Offset(0.8, 0.8),
                                    end: const Offset(1.2, 1.2),
                                    duration: 1000.ms,
                                  )
                                  .then()
                                  .scale(
                                    begin: const Offset(1.2, 1.2),
                                    end: const Offset(0.8, 0.8),
                                    duration: 1000.ms,
                                  ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: isTablet
                          ? (isLandscape
                                ? 0.5.h
                                : 0.8.h) // More space for tablets
                          : (isLandscape ? 0.1.h : 0.2.h),
                    ), // Less space for phones
                    // Label with animation - constrained to prevent overflow
                    Flexible(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: GoogleFonts.nunito(
                          fontSize: isTablet
                              ? (isSelected
                                    ? 14.sp
                                    : 12.sp) // Bigger text for tablets
                              : (screenWidth < 360
                                    ? (isSelected
                                          ? 8.sp
                                          : 7.sp) // Smaller text for small phones
                                    : (isSelected
                                          ? 9.sp
                                          : 8.sp)), // Smaller text for normal phones
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: isSelected
                              ? destination.selectedColor
                              : TurfitColors.grey600(context),
                        ),
                        child: Text(
                          destination.label,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class KidNavDestination {
  final String emoji;
  final String label;
  final Color selectedColor;
  final bool hasNotification;

  const KidNavDestination({
    required this.emoji,
    required this.label,
    required this.selectedColor,
    this.hasNotification = false,
  });
}
