import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthapp/ui/components/tap_tile.dart';
import 'package:growthapp/ui/screens/profile_screen.dart';
import 'package:growthapp/ui/screens/admin_db_viewer_screen.dart';
import 'package:sizer/sizer.dart';
import 'dart:math';

import '../../data/investments.dart';
import '../../data/default_items.dart';
import '../../services/market_service.dart';
import '../../services/onboarding_service.dart';
import '../../services/audio_service.dart';
import '../../db/app_db.dart';
import 'package:drift/drift.dart' as d;
import 'package:growthapp/ui/theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../components/awesome_snackbar_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _service = Get.find<MarketService>();
  bool _syncing = false;
  bool _generatingDummyData = false;
  double _progress = 0;
  final _nameCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  DateTime? _dob;
  final bool _loadingProfile = true;
  String _appVersion = '';

  // Dummy item data for generating test entries
  final List<Map<String, dynamic>> _dummyItems = [
    {'name': 'Coffee', 'price': 5.50},
    {'name': 'Burger Meal', 'price': 12.99},
    {'name': 'Pizza Slice', 'price': 3.75},
    {'name': 'Bubble Tea', 'price': 6.25},
    {'name': 'Sneakers', 'price': 89.99},
    {'name': 'Hoodie', 'price': 45.00},
    {'name': 'Wireless Earbuds', 'price': 129.99},
    {'name': 'Phone Case', 'price': 25.99},
    {'name': 'Movie Ticket', 'price': 15.50},
    {'name': 'Video Game', 'price': 59.99},
    {'name': 'Smoothie', 'price': 7.50},
    {'name': 'Graphic Tee', 'price': 19.99},
    {'name': 'Lunch', 'price': 14.25},
    {'name': 'Energy Drink', 'price': 3.99},
    {'name': 'Notebook', 'price': 8.50},
    {'name': 'Snack Pack', 'price': 4.75},
    {'name': 'Sunglasses', 'price': 35.99},
    {'name': 'Gym Membership', 'price': 29.99},
    {'name': 'Concert Ticket', 'price': 85.00},
    {'name': 'Art Supplies', 'price': 22.50},
  ];

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() => _appVersion = '${info.version}+${info.buildNumber}');
    } catch (_) {
      // Fallback to empty to avoid UI crash
      setState(() => _appVersion = '');
    }
  }

  Future<void> _generateDummyData() async {
    setState(() => _generatingDummyData = true);

    try {
      final db = Get.find<AppDb>();
      final random = Random();

      // Fixed date range: Nov 2, 2023 to Nov 1, 2025 (today is Nov 2, 2025)
      final startDate = DateTime(2023, 11, 2);
      final endDate = DateTime(2025, 11, 1); // Up to yesterday

      // Calculate the number of months in the range
      int totalMonths = 0;
      DateTime currentMonth = DateTime(startDate.year, startDate.month, 1);
      final endMonth = DateTime(endDate.year, endDate.month, 1);

      while (currentMonth.isBefore(endMonth) ||
          currentMonth.isAtSameMomentAs(endMonth)) {
        totalMonths++;
        currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
      }

      // Generate data for each month in the range
      for (int monthIndex = 0; monthIndex < totalMonths; monthIndex++) {
        final monthDate = DateTime(
          startDate.year,
          startDate.month + monthIndex,
          1,
        );

        // Skip if this month is beyond our end date
        if (monthDate.isAfter(DateTime(endDate.year, endDate.month, 1))) {
          break;
        }

        // Generate 2-6 random entries per month for older data, 4-8 for recent months
        final isRecentMonth = monthIndex >= (totalMonths - 6);
        final entriesCount = isRecentMonth
            ? 4 +
                  random.nextInt(5) // 4-8 entries for recent months
            : 2 + random.nextInt(5); // 2-6 entries for older months

        for (int i = 0; i < entriesCount; i++) {
          // Pick random item and investment
          final item = _dummyItems[random.nextInt(_dummyItems.length)];
          final investment = investments[random.nextInt(investments.length)];

          // Add some price variation (±25%)
          final basePrice = item['price'] as double;
          final priceVariation =
              0.75 + (random.nextDouble() * 0.5); // 0.75 to 1.25
          final finalPrice = basePrice * priceVariation;

          // Generate random return (can be positive or negative)
          // More volatile returns for older data
          final maxReturn = isRecentMonth ? 80.0 : 120.0;
          final minReturn = isRecentMonth ? -25.0 : -40.0;
          final returnPct =
              minReturn + (random.nextDouble() * (maxReturn - minReturn));
          final finalValue = finalPrice * (1 + (returnPct / 100));

          // Random day within the month (avoid invalid dates and future dates)
          final daysInMonth = DateTime(
            monthDate.year,
            monthDate.month + 1,
            0,
          ).day;

          int dayInMonth;
          DateTime entryDate;

          // For the current month (November 2025), only generate dates up to Nov 1
          if (monthDate.year == 2025 && monthDate.month == 11) {
            dayInMonth = 1; // Only Nov 1 is allowed
            entryDate = DateTime(2025, 11, 1);
          } else {
            // For other months, use random days but ensure we don't exceed end date
            dayInMonth = 1 + random.nextInt(daysInMonth);
            entryDate = DateTime(monthDate.year, monthDate.month, dayInMonth);

            // Ensure we don't generate dates beyond our end date
            if (entryDate.isAfter(endDate)) {
              continue; // Skip this entry
            }
          }

          await db.addSaving(
            SavingsCompanion(
              itemName: d.Value(item['name'] as String),
              amount: d.Value(finalPrice),
              symbol: d.Value(investment.symbol),
              investmentName: d.Value(investment.name),
              finalValue: d.Value(finalValue),
              returnPct: d.Value(returnPct),
              createdAt: d.Value(entryDate),
            ),
          );
        }
      }

      AwesomeSnackbarHelper.showSuccess(
        context,
        'Demo Data Created! 🎉',
        'Generated test data from Nov 2023 to Nov 2025',
      );
    } catch (e) {
      AwesomeSnackbarHelper.showError(
        context,
        'Error',
        'Failed to generate dummy data: $e',
      );
    } finally {
      setState(() => _generatingDummyData = false);
    }
  }

  Future<void> _clearAllData() async {
    // Show confirmation dialog first
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will delete ALL your savings data. This action cannot be undone. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final db = Get.find<AppDb>();
        await db.clearSavings();

        AwesomeSnackbarHelper.showSuccess(
          context,
          'Data Cleared',
          'All savings data has been deleted',
        );
      } catch (e) {
        AwesomeSnackbarHelper.showError(
          context,
          'Error',
          'Failed to clear data: $e',
        );
      }
    }
  }

  Future<void> _sync() async {
    setState(() {
      _syncing = true;
      _progress = 0;
    });
    final syms = investments.map((e) => e.symbol).toList();
    for (var i = 0; i < syms.length; i++) {
      await _service.fetchOneYearPrices(syms[i], forceRefresh: true);
      setState(() => _progress = (i + 1) / syms.length);
    }
    if (mounted) {
      setState(() => _syncing = false);
      AwesomeSnackbarHelper.showSuccess(
        context,
        'Sync complete',
        'Market data updated',
      );
    }
  }

  Future<void> _saveProfile() async {
    final db = Get.find<AppDb>();
    final name = _nameCtrl.text.trim();
    final img = _imageCtrl.text.trim();
    await db.upsertProfile(
      ProfilesCompanion(
        id: d.Value(1),
        name: d.Value<String?>(name.isEmpty ? null : name),
        imagePath: d.Value<String?>(img.isEmpty ? null : img),
        dob: d.Value<DateTime?>(_dob),
      ),
    );
    AwesomeSnackbarHelper.showSuccess(context, 'Saved', 'Profile updated');
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Get.find<ThemeProvider>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // Let the Scaffold adjust for the keyboard to avoid overflow
      resizeToAvoidBottomInset: true,
      backgroundColor: colorScheme.surface,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(6.w, 6.w, 6.w, 6.w + bottomInset),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: 1.h),
                    // AnimatedBuilder(
                    //   animation: themeProvider,
                    //   builder: (context, _) => TapTile(
                    //     title: 'Dark Mode',
                    //     subtitle: 'Reduce eye strain with a darker theme',
                    //     leadingIcon: Icons.dark_mode_outlined,
                    //     trailing: Switch.adaptive(
                    //       value: themeProvider.isDarkMode,
                    //       onChanged: (_) => themeProvider.toggleTheme(),
                    //     ),
                    //     onTap: null,
                    //   ),
                    // ),
                    // SizedBox(height: 2.h),
                    TapTile(
                      title: 'Profile',
                      subtitle: 'Set your name, image, and date of birth',
                      leadingIcon: Icons.person_outline,
                      onTap: () async {
                        AudioService().playButtonClick();
                        await Get.to(() => ProfileScreen());
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 2.h),

                    TapTile(
                      title: 'Sync Market Data',
                      subtitle:
                          'Pull and cache 1-year prices for all investments',
                      leadingIcon: Icons.sync_outlined,
                      trailing: _syncing
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.primary,
                              ),
                            )
                          : null,
                      onTap: _syncing
                          ? null
                          : () {
                              AudioService().playButtonClick();
                              _sync();
                            },
                    ),

                    if (_syncing) ...[
                      SizedBox(height: 2.h),
                      LinearProgressIndicator(
                        value: _progress,
                        color: colorScheme.primary,
                        backgroundColor: colorScheme.primary.withOpacity(0.2),
                      ),
                    ],

                    SizedBox(height: 2.h),
                    TapTile(
                      title: 'App Version',
                      subtitle: 'Build and version information',
                      leadingIcon: Icons.info_outline,
                      trailing: Text(
                        _appVersion.isEmpty ? '-' : _appVersion,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      onTap: null,
                    ),

                    // Debug-only Admin tile
                    if (kDebugMode) ...[
                      SizedBox(height: 2.h),
                      TapTile(
                        title: 'Generate Demo Data',
                        subtitle:
                            'Create test data from Nov 2, 2023 to Nov 1, 2025',
                        leadingIcon: Icons.auto_awesome,
                        trailing: _generatingDummyData
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorScheme.primary,
                                ),
                              )
                            : null,
                        onTap: _generatingDummyData
                            ? null
                            : () {
                                AudioService().playButtonClick();
                                _generateDummyData();
                              },
                      ),
                      SizedBox(height: 2.h),
                      TapTile(
                        title: 'Clear All Data',
                        subtitle: 'Delete all savings data (cannot be undone)',
                        leadingIcon: Icons.delete_forever,
                        onTap: () {
                          AudioService().playButtonClick();
                          _clearAllData();
                        },
                      ),
                      SizedBox(height: 2.h),
                      TapTile(
                        title: 'Reset Onboarding',
                        subtitle:
                            'Show onboarding screens again on next launch',
                        leadingIcon: Icons.refresh_outlined,
                        onTap: () async {
                          AudioService().playButtonClick();
                          await OnboardingService.resetOnboarding();
                          AwesomeSnackbarHelper.showSuccess(
                            context,
                            'Reset Complete',
                            'Onboarding will show on next app restart',
                          );
                        },
                      ),
                      SizedBox(height: 2.h),
                      TapTile(
                        title: 'Admin DB Viewer',
                        subtitle:
                            'View raw database tables and export data (Debug Only)',
                        leadingIcon: Icons.admin_panel_settings_outlined,
                        onTap: () {
                          AudioService().playButtonClick();
                          Get.to(() => const AdminDbViewerScreen());
                        },
                      ),
                      SizedBox(height: 2.h),
                      TapTile(
                        title: 'Show SnackBar ',
                        subtitle: 'Click to show a sample Awesome Snackbar',
                        leadingIcon: Icons.snapchat,
                        onTap: () {
                          AudioService().playButtonClick();
                          AwesomeSnackbarHelper.showError(
                            context,
                            'Hello!',
                            'This is a sample Awesome Snackbar.',
                          );
                        },
                      ),
                    ],
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
