import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../core/theme/app_theme.dart';
import 'custom_widgets.dart';

class SmsPrivacyDialog extends StatelessWidget {
  final VoidCallback onAccept;

  const SmsPrivacyDialog({
    super.key,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(maxHeight: 80.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with gradient
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryBlack,
                    AppTheme.primaryBlack.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryWhite.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.security,
                      color: AppTheme.primaryWhite,
                      size: 6.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Privacy Matters',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                color: AppTheme.primaryWhite,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Complete data security',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: AppTheme.primaryWhite.withOpacity(0.8),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoSection(
                      context,
                      icon: Icons.message,
                      color: Colors.blue,
                      title: 'SMS Reading',
                      description:
                          'We will read banking SMS messages from your device to automatically detect and categorize your transactions.',
                    ),
                    SizedBox(height: 2.h),
                    _buildInfoSection(
                      context,
                      icon: Icons.phone_android,
                      color: Colors.green,
                      title: '100% Local Processing',
                      description:
                          'All SMS messages are processed entirely on your device. Your messages never leave your phone.',
                    ),
                    SizedBox(height: 2.h),
                    _buildInfoSection(
                      context,
                      icon: Icons.lock,
                      color: Colors.orange,
                      title: 'Secure Storage',
                      description:
                          'Only transaction details (amount, merchant, date) are stored locally in your device\'s secure database.',
                    ),
                    SizedBox(height: 2.h),
                    _buildInfoSection(
                      context,
                      icon: Icons.cloud_off,
                      color: Colors.purple,
                      title: 'No Cloud Uploads',
                      description:
                          'Your SMS content is never uploaded to any server. Everything stays private on your device.',
                    ),
                    SizedBox(height: 2.h),
                   

                    // Privacy guarantee box
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green.shade200,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green.shade700,
                            size: 24,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'Your data never leaves your device. Complete privacy guaranteed.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.green.shade900,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Actions
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.greyLight.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  CustomButton(
                    text: 'I Understand - Continue',
                    icon: Icons.arrow_forward,
                    onPressed: () {
                      Get.back();
                      onAccept();
                    },
                  ),
                  SizedBox(height: 1.h),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppTheme.greyDark,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 5.w,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.greyDark,
                      height: 1.4,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
