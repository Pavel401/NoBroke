import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthapp/ui/components/tap_tile.dart';
import 'package:growthapp/ui/screens/profile_screen.dart';
import 'package:sizer/sizer.dart';

import '../../data/investments.dart';
import '../../services/market_service.dart';
import '../../db/app_db.dart';
import 'package:drift/drift.dart' as d;
import 'package:growthapp/ui/theme.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _service = MarketService();
  bool _syncing = false;
  double _progress = 0;
  final _nameCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  DateTime? _dob;
  final bool _loadingProfile = true;
  String _appVersion = '';

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
      Get.snackbar('Sync complete', 'Market data updated');
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
    Get.snackbar('Saved', 'Profile updated');
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Get.find<ThemeProvider>();
    return Scaffold(
      // Let the Scaffold adjust for the keyboard to avoid overflow
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Settings')),
      body: LayoutBuilder(
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
                  Text(
                    'Appearance',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  AnimatedBuilder(
                    animation: themeProvider,
                    builder: (context, _) => TapTile(
                      title: 'Dark Mode',
                      subtitle: 'Reduce eye strain with a darker theme',
                      leadingIcon: Icons.dark_mode_outlined,
                      trailing: Switch.adaptive(
                        value: themeProvider.isDarkMode,
                        onChanged: (_) => themeProvider.toggleTheme(),
                      ),
                      onTap: null,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Account',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  TapTile(
                    title: 'Profile',
                    subtitle: 'Set your name, image, and date of birth',
                    leadingIcon: Icons.person_outline,
                    onTap: () async {
                      await Get.to(() => ProfileScreen());
                      setState(() {});
                    },
                  ),
                  Text(
                    'Market Data',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  TapTile(
                    title: 'Sync Market Data',
                    subtitle:
                        'Pull and cache 1-year prices for all investments',
                    leadingIcon: Icons.sync_outlined,
                    trailing: _syncing
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : null,
                    onTap: _syncing ? null : _sync,
                  ),
                  if (_syncing) ...[
                    SizedBox(height: 2.h),
                    LinearProgressIndicator(value: _progress),
                  ],
                  SizedBox(height: 2.h),
                  Text(
                    'About',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  TapTile(
                    title: 'App Version',
                    subtitle: 'Build and version information',
                    leadingIcon: Icons.info_outline,
                    trailing: Text(
                      _appVersion.isEmpty ? '-' : _appVersion,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    onTap: null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
