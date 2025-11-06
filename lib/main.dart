import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneyapp/presentation/views/home_screen.dart';
import 'package:sizer/sizer.dart';
import 'core/theme/app_theme.dart';
import 'core/dependencies/dependency_injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyInjection.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: 'Money Tracker',
          theme: AppTheme.lightTheme,
          home: HomeScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
