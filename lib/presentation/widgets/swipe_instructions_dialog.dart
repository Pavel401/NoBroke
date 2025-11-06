import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../core/theme/app_theme.dart';

class SwipeInstructionsDialog extends StatelessWidget {
  const SwipeInstructionsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.swipe_rounded,
                  color: AppTheme.primaryBlue,
                  size: 7.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Swipe Actions',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            SizedBox(height: 4.h),

            // Swipe instructions
            _buildInstructionRow(
              context,
              Icons.arrow_forward_rounded,
              'Swipe Right',
              'Edit transaction',
              AppTheme.primaryBlue,
            ),

            SizedBox(height: 2.h),

            _buildInstructionRow(
              context,
              Icons.arrow_back_rounded,
              'Swipe Left',
              'Delete transaction',
              AppTheme.errorRed,
            ),

            SizedBox(height: 4.h),

            // Tip
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.greyLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    color: AppTheme.primaryBlue,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Swipe gently to reveal actions. A confirmation dialog will appear for delete operations.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppTheme.greyDark),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 4.h),

            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: AppTheme.primaryWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
                child: const Text('Got it!'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionRow(
    BuildContext context,
    IconData icon,
    String action,
    String description,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 6.w),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                action,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.greyDark),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
