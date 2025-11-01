import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'home_screen.dart';
import 'analytics_screen.dart';
import 'settings_screen.dart';
import '../components/kid_friendly_nav_bar.dart';
import '../components/kid_friendly_fab.dart';
import '../colors.dart';

class RootTabs extends StatefulWidget {
  const RootTabs({super.key});

  @override
  State<RootTabs> createState() => _RootTabsState();
}

class _RootTabsState extends State<RootTabs> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = const [HomeScreen(), AnalyticsScreen(), SettingsScreen()];
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
            label: 'My Savings',
            selectedColor: TurfitColors.primaryLight,
          ),
          KidNavDestination(
            emoji: '📈',
            label: 'Growth Chart',
            selectedColor: TurfitColors.tertiaryLight,
          ),
          KidNavDestination(
            emoji: '⚙️',
            label: 'Settings',
            selectedColor: TurfitColors.secondaryLight,
            hasNotification: true, // For profile setup reminder
          ),
        ],
      ),
      floatingActionButton: _index == 0
          ? KidFriendlyFAB(
                  onPressed: () => Get.toNamed('/select-item'),
                  label: 'New What-If',
                  emoji: '💭',
                )
                .animate()
                .scale(
                  delay: 500.ms,
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                )
                .then()
                .shake(delay: 2000.ms, duration: 800.ms, hz: 2)
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
