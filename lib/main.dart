import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'routes/app_pages.dart';
import 'ui/theme.dart';
import 'db/app_db.dart';
import 'data/default_items.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('marketCache');
  // Register a single AppDb instance globally to avoid multiple database creations
  Get.put<AppDb>(AppDb(), permanent: true);
  // Register ThemeProvider globally for UI access (e.g., Settings toggle)
  Get.put<ThemeProvider>(ThemeProvider(), permanent: true);
  // Seed default catalog items if needed
  await ensureDefaultCatalogSeeded(Get.find<AppDb>());
  runApp(const WhatIfApp());
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
            initialRoute: AppPages.initial,
            getPages: AppPages.pages,
          ),
        );
      },
    );
  }
}
