import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

import '../../db/app_db.dart';
import '../../services/share_service.dart';
import '../../services/audio_service.dart';
import '../components/achievement_share_widget.dart';
import '../colors.dart';

class AchievementSharePreviewScreen extends StatefulWidget {
  final Saving saving;

  const AchievementSharePreviewScreen({super.key, required this.saving});

  @override
  State<AchievementSharePreviewScreen> createState() =>
      _AchievementSharePreviewScreenState();
}

class _AchievementSharePreviewScreenState
    extends State<AchievementSharePreviewScreen> {
  final GlobalKey _shareWidgetKey = GlobalKey();
  bool _isSharing = false;

  Future<void> _shareAchievement() async {
    if (_isSharing) return;

    setState(() {
      _isSharing = true;
    });

    try {
      AudioService().playButtonClick();
      HapticFeedback.mediumImpact();

      // Find the render box to get position
      final RenderBox? renderBox =
          _shareWidgetKey.currentContext?.findRenderObject() as RenderBox?;

      Rect? sharePositionOrigin;
      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);
        final size = renderBox.size;
        sharePositionOrigin = Rect.fromLTWH(
          position.dx,
          position.dy,
          size.width,
          size.height,
        );
      }

      await ShareService().shareAchievement(
        context,
        widget.saving,
        sharePositionOrigin: sharePositionOrigin,
      );
    } catch (e) {
      // Show error if sharing fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to share: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Share Achievement',
          style: GoogleFonts.nunito(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Preview Section
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // // Preview Title
                      // Text(
                      //   '✨ Achievement Preview',
                      //   style: GoogleFonts.nunito(
                      //     fontSize: 20.sp,
                      //     fontWeight: FontWeight.bold,
                      //     color: colorScheme.onSurface,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      // SizedBox(height: 2.h),

                      // Text(
                      //   'This is how your achievement will look when shared:',
                      //   style: GoogleFonts.nunito(
                      //     fontSize: 14.sp,
                      //     fontWeight: FontWeight.w500,
                      //     color: TurfitColors.grey600(context),
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      // SizedBox(height: 4.h),

                      // Achievement Widget Preview
                      Container(
                        key: _shareWidgetKey,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: AchievementShareWidget(saving: widget.saving),
                      ),
                      SizedBox(height: 4.h),

                      // Share Description
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: TurfitColors.card(context),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.primary.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: colorScheme.primary,
                              size: 24.sp,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Share your investment achievement with friends and family!',
                              style: GoogleFonts.nunito(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              'They\'ll see how much your investment could have grown.',
                              style: GoogleFonts.nunito(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: TurfitColors.grey600(context),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Share Button Section
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: TurfitColors.card(context),
                border: Border(
                  top: BorderSide(
                    color: TurfitColors.grey200(context),
                    width: 1,
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Share Button
                    Bounceable(
                      onTap: _isSharing ? null : _shareAchievement,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isSharing
                                ? [
                                    TurfitColors.grey400(context),
                                    TurfitColors.grey500(context),
                                  ]
                                : [
                                    colorScheme.primary,
                                    colorScheme.primary.withOpacity(0.8),
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: _isSharing
                                  ? Colors.transparent
                                  : colorScheme.primary.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isSharing) ...[
                              SizedBox(
                                width: 20.sp,
                                height: 20.sp,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                            ] else ...[
                              Icon(
                                Icons.share,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                              SizedBox(width: 3.w),
                            ],
                            Text(
                              _isSharing ? 'Sharing...' : 'Share Achievement',
                              style: GoogleFonts.nunito(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // Cancel Button
                    Bounceable(
                      onTap: () {
                        AudioService().playButtonClick();
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: TurfitColors.grey300(context),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.nunito(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: TurfitColors.grey600(context),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
