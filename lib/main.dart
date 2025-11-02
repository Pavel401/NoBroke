import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'routes/app_pages.dart';
import 'ui/theme.dart';
import 'db/app_db.dart';
import 'data/default_items.dart';
import 'services/onboarding_service.dart';
import 'services/market_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Register a single AppDb instance globally to avoid multiple database creations
  final appDb = AppDb();
  Get.put<AppDb>(appDb, permanent: true);
  // Register MarketService with AppDb dependency
  Get.put<MarketService>(MarketService(appDb), permanent: true);
  // Register ThemeProvider globally for UI access (e.g., Settings toggle)
  Get.put<ThemeProvider>(ThemeProvider(), permanent: true);
  // Seed default catalog items if needed
  await ensureDefaultCatalogSeeded(appDb);
  runApp(const WhatIfApp());
}

class WhatIfApp extends StatefulWidget {
  const WhatIfApp({super.key});

  @override
  State<WhatIfApp> createState() => _WhatIfAppState();
}

class _WhatIfAppState extends State<WhatIfApp> {
  late final ThemeProvider _themeProvider;
  String _initialRoute = Routes.onboarding;

  @override
  void initState() {
    super.initState();
    _themeProvider = Get.find<ThemeProvider>();
    _checkOnboardingStatus();
  }

  void _checkOnboardingStatus() async {
    final isCompleted = await OnboardingService.isOnboardingCompleted();
    setState(() {
      _initialRoute = isCompleted ? Routes.tabs : Routes.onboarding;
    });
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
            initialRoute: _initialRoute,
            getPages: AppPages.pages,
          ),
        );
      },
    );
  }
}
