import 'package:get/get.dart';

import '../ui/screens/onboarding_screen.dart';
import '../ui/screens/select_item_screen.dart';
import '../ui/screens/enter_price_screen.dart';
import '../ui/screens/select_investment_screen.dart';
import '../ui/screens/result_screen.dart';
import '../ui/screens/settings_screen.dart';
import '../ui/screens/root_tabs.dart';
import '../ui/screens/add_item_screen.dart';
import '../ui/screens/saving_detail_screen.dart';
import '../ui/screens/admin_db_viewer_screen.dart';
import '../ui/screens/achievement_share_preview_screen.dart';

class Routes {
  static const onboarding = '/onboarding';
  static const selectItem = '/select-item';
  static const addItem = '/add-item';
  static const enterPrice = '/enter-price';
  static const selectInvestment = '/select-investment';
  static const result = '/result';
  static const settings = '/settings';
  static const tabs = '/tabs';
  static const savingDetail = '/saving-detail';
  static const adminDbViewer = '/admin-db-viewer';
  static const achievementSharePreview = '/achievement-share-preview';
}

class AppPages {
  static const initial = Routes.onboarding;

  static final pages = <GetPage<dynamic>>[
    GetPage(name: Routes.onboarding, page: () => const OnboardingScreen()),
    GetPage(name: Routes.tabs, page: () => const RootTabs()),
    GetPage(name: Routes.selectItem, page: () => const SelectItemScreen()),
    GetPage(name: Routes.addItem, page: () => const AddItemScreen()),
    GetPage(name: Routes.enterPrice, page: () => const EnterPriceScreen()),
    GetPage(
      name: Routes.selectInvestment,
      page: () => const SelectInvestmentScreen(),
    ),
    GetPage(name: Routes.result, page: () => const ResultScreen()),
    GetPage(name: Routes.settings, page: () => const SettingsScreen()),
    GetPage(name: Routes.savingDetail, page: () => const SavingDetailScreen()),
    GetPage(
      name: Routes.adminDbViewer,
      page: () => const AdminDbViewerScreen(),
    ),
    GetPage(
      name: Routes.achievementSharePreview,
      page: () => AchievementSharePreviewScreen(saving: Get.arguments),
    ),
  ];
}
