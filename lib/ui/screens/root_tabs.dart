import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthapp/ui/colors.dart';
import 'package:growthapp/ui/components/kid_friendly_nav_bar.dart';
import 'package:growthapp/services/audio_service.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';
import 'analytics_screen.dart';
import 'settings_screen.dart';

class RootTabs extends StatefulWidget {
  const RootTabs({super.key});

  @override
  State<RootTabs> createState() => _RootTabsState();
}

class _RootTabsState extends State<RootTabs> with TickerProviderStateMixin {
  int _index = 0;
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [HomeScreen(), AnalyticsScreen(), SettingsScreen()];
    return Scaffold(
      extendBody: true,
      backgroundColor: TurfitColors.surfaceLight,
      body: pages[_index],
      bottomNavigationBar: KidFriendlyNavBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          KidNavDestination(
            emoji: '🏠',
            lottieJson: "assets/lotties/savings.json",
            label: 'My Savings',
            selectedColor: TurfitColors.primaryLight,
          ),
          KidNavDestination(
            emoji: '📈',
            label: 'Growth Chart',
            lottieJson: "assets/lotties/analytics.json",

            selectedColor: TurfitColors.tertiaryLight,
          ),
          KidNavDestination(
            emoji: '⚙️',
            label: 'Settings',
            lottieJson: "assets/lotties/settings.json",

            selectedColor: TurfitColors.secondaryLight,
            hasNotification: true, // For profile setup reminder
          ),
        ],
      ),
      floatingActionButton: _index == 0 ? _buildGlowingFAB(context) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildGlowingFAB(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _fabController,
      builder: (context, child) {
        final pulseValue = _fabController.value;

        return Tooltip(
          message: 'New What-If',
          preferBelow: true,
          decoration: BoxDecoration(
            color: colorScheme.inverseSurface,
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onInverseSurface,
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                // Glowing effect
                BoxShadow(
                  color: TurfitColors.primary(
                    context,
                  ).withValues(alpha: 0.6 + (pulseValue * 0.4)),
                  offset: const Offset(0, 0),
                  blurRadius: 20 + (pulseValue * 15),
                  spreadRadius: pulseValue * 8,
                ),
                // Secondary glow
                BoxShadow(
                  color: TurfitColors.secondary(
                    context,
                  ).withValues(alpha: 0.3 + (pulseValue * 0.3)),
                  offset: const Offset(0, 0),
                  blurRadius: 30 + (pulseValue * 20),
                  spreadRadius: pulseValue * 12,
                ),
              ],
            ),
            child:
                FloatingActionButton(
                      onPressed: () {
                        // Play button click sound
                        AudioService().playButtonClick();
                        Get.toNamed('/select-item');
                      },
                      backgroundColor: TurfitColors.primary(context),
                      foregroundColor: TurfitColors.white(context),
                      elevation: 8,
                      child: Transform.scale(
                        scale: 1.0 + (pulseValue * 0.1),
                        child: Icon(Icons.add_rounded, size: 28.sp),
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scale(
                      begin: const Offset(1.0, 1.0),
                      end: const Offset(1.05, 1.05),
                      duration: 1500.ms,
                      curve: Curves.easeInOut,
                    ),
          ),
        );
      },
    );
  }
}
