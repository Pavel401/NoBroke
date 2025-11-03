import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'routes/app_pages.dart';
import 'ui/theme.dart';
import 'db/app_db.dart';
import 'data/default_items.dart';
import 'data/investments.dart';
import 'services/onboarding_service.dart';
import 'services/market_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Register a single AppDb instance globally to avoid multiple database creations
  final appDb = AppDb();
  Get.put<AppDb>(appDb, permanent: true);
  // Register MarketService with AppDb dependency
  final marketService = MarketService(appDb);
  Get.put<MarketService>(marketService, permanent: true);
  // Register ThemeProvider globally for UI access (e.g., Settings toggle)
  Get.put<ThemeProvider>(ThemeProvider(), permanent: true);
  // Seed default catalog items if needed
  await ensureDefaultCatalogSeeded(appDb);

  // Sync market data on first app load
  final isFirstLoad = !(await OnboardingService.isOnboardingCompleted());
  if (isFirstLoad) {
    await _syncMarketDataOnFirstLoad(marketService);
  }

  runApp(const WhatIfApp());
}

/// Syncs market data for all investments on first app load
Future<void> _syncMarketDataOnFirstLoad(MarketService marketService) async {
  try {
    print('First app load detected - syncing market data...');
    final symbols = investments.map((investment) => investment.symbol).toList();
    await marketService.syncSymbols(symbols);
    print('Market data sync completed successfully');
  } catch (e) {
    print('Failed to sync market data on first load: $e');
    // Don't prevent app from starting if sync fails
  }
}

class WhatIfApp extends StatefulWidget {
  const WhatIfApp({super.key});

  @override
  State<WhatIfApp> createState() => _WhatIfAppState();
}

class _WhatIfAppState extends State<WhatIfApp> {
  late final ThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    _themeProvider = Get.find<ThemeProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return AnimatedBuilder(
          animation: _themeProvider,
          builder: (context, _) => GetMaterialApp(
            title: 'What If I Invested?',
            debugShowCheckedModeBanner: false,
            theme: _themeProvider.lightTheme,
            darkTheme: _themeProvider.darkTheme,

            // themeMode: _themeProvider.isDarkMode
            //     ? ThemeMode.dark
            //     : ThemeMode.light,
            themeMode: ThemeMode.light,
            initialRoute: Routes.splash,
            getPages: AppPages.pages,
          ),
        );
      },
    );
  }
}
