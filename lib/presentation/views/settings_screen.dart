import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../controllers/transaction_controller.dart';
import '../controllers/budget_controller.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/budget_management_bottom_sheet.dart';
import '../widgets/budget_list_widget.dart';
import '../../core/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionController controller = Get.find<TransactionController>();
    final BudgetController budgetController = Get.find<BudgetController>();

    return Scaffold(
      backgroundColor: AppTheme.greyLight,
      appBar: AppBar(
        title: const Text('Settings'),
        // backgroundColor: AppTheme.primaryBlack,
        // foregroundColor: Colors.white,
        // iconTheme: const IconThemeData(),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left_outlined,
            size: 7.w,
            color: AppTheme.primaryBlack,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Monthly Budget Section
            _buildSectionHeader('Monthly Budget', Icons.account_balance_wallet),
            SizedBox(height: 1.5.h),
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlack.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.savings,
                            color: AppTheme.primaryBlack,
                            size: 6.w,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Manage Monthly Budgets',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryBlack,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                'Set and track budgets for different months',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppTheme.greyDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),

                    // Current Month Budget Display
                    Obx(() {
                      final currentBudget = budgetController.monthlyBudget;
                      final now = DateTime.now();
                      final monthName = _getMonthName(now.month);

                      return Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: currentBudget > 0
                              ? AppTheme.successGreen.withOpacity(0.1)
                              : AppTheme.greyLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: currentBudget > 0
                                ? AppTheme.successGreen.withOpacity(0.3)
                                : AppTheme.greyMedium,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              currentBudget > 0
                                  ? Icons.check_circle
                                  : Icons.info_outline,
                              color: currentBudget > 0
                                  ? AppTheme.successGreen
                                  : AppTheme.greyDark,
                              size: 5.w,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$monthName ${now.year} Budget',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primaryBlack,
                                    ),
                                  ),
                                  Text(
                                    currentBudget > 0
                                        ? '₹${currentBudget.toStringAsFixed(0)}'
                                        : 'No budget set',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: AppTheme.greyDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    SizedBox(height: 3.h),
                    CustomButton(
                      text: 'Set Monthly Budget',
                      icon: Icons.add,
                      onPressed: () => _showBudgetDialog(context),
                      backgroundColor: AppTheme.primaryBlack,
                    ),
                  ],
                ),
              ),
            ),

            // Existing Budgets List
            SizedBox(height: 3.h),
            Obx(() {
              if (budgetController.monthlyBudgets.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Existing Budgets', Icons.history),
                    SizedBox(height: 2.h),
                    Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: const BudgetListWidget(),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),

            SizedBox(height: 4.h),

            // Data Management Section
            _buildSectionHeader('Data Management', Icons.storage),
            SizedBox(height: 2.h),
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    // Export Data Section
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.download,
                            color: AppTheme.primaryBlue,
                            size: 6.w,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Export All Data',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryBlack,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                'Export all transactions, accounts, and budgets to JSON file',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppTheme.greyDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Obx(
                      () => CustomButton(
                        text: 'Export Data',
                        icon: Icons.file_download,
                        onPressed: controller.isLoading
                            ? null
                            : () => _showExportDialog(context, controller),
                        isLoading: controller.isLoading,
                        backgroundColor: AppTheme.primaryBlue,
                      ),
                    ),

                    SizedBox(height: 4.h),
                    Divider(color: AppTheme.greyMedium),
                    SizedBox(height: 4.h),

                    // Reset Data Section
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.red,
                            size: 6.w,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reset All Data',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryBlack,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                'Permanently delete all transactions, categories, budgets, and other data',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppTheme.greyDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Obx(
                      () => CustomButton(
                        text: 'Reset All Data',
                        icon: Icons.delete_forever,
                        onPressed: controller.isLoading
                            ? null
                            : () => _showResetConfirmationDialog(
                                context,
                                controller,
                                budgetController,
                              ),
                        isLoading: controller.isLoading,
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // About Section
            _buildSectionHeader('About', Icons.info_outline),
            SizedBox(height: 2.h),
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.monetization_on,
                            color: AppTheme.primaryBlue,
                            size: 6.w,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Money Tracker',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryBlack,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                'Version 1.0.0',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppTheme.greyDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.greyLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'A simple and efficient app to track your financial transactions with monthly budget management.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppTheme.greyDark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryBlack, size: 6.w),
        SizedBox(width: 3.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlack,
          ),
        ),
      ],
    );
  }

  void _showBudgetDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const BudgetManagementBottomSheet(),
    );
  }

  void _showExportDialog(
    BuildContext context,
    TransactionController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 50.h,
          decoration: const BoxDecoration(
            color: AppTheme.primaryWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 1.h, bottom: 2.h),
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.greyMedium,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    children: [
                      // Header
                      Row(
                        children: [
                          Icon(
                            Icons.download,
                            color: AppTheme.primaryBlue,
                            size: 6.w,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'Export All Data',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryBlack,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close),
                            iconSize: 6.w,
                          ),
                        ],
                      ),

                      SizedBox(height: 3.h),

                      // Content
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'This will export all your data to a JSON file that you can share or back up.',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppTheme.greyDark,
                                ),
                              ),
                              SizedBox(height: 3.h),

                              // Export summary
                              Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppTheme.primaryBlue.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Export Summary',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.primaryBlack,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      controller.getExportSummary(),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppTheme.greyDark,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Action buttons
                      SizedBox(height: 3.h),
                      Column(
                        children: [
                          CustomButton(
                            text: 'Export & Share',
                            icon: Icons.share,
                            onPressed: () {
                              Navigator.of(context).pop();
                              _performExport(context, controller);
                            },
                            backgroundColor: AppTheme.primaryBlue,
                            height: 6.h,
                          ),
                          SizedBox(height: 2.h),
                          CustomButton(
                            text: 'Cancel',
                            onPressed: () => Navigator.of(context).pop(),
                            isOutlined: true,
                            height: 6.h,
                          ),
                        ],
                      ),

                      SizedBox(height: 3.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _performExport(
    BuildContext context,
    TransactionController controller,
  ) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Padding(
              padding: EdgeInsets.all(2.w),
              child: Row(
                children: [
                  const CircularProgressIndicator(),
                  SizedBox(width: 4.w),
                  const Text('Exporting data...'),
                ],
              ),
            ),
          );
        },
      );

      // Perform the export
      final filePath = await controller.exportAllData();

      // Close loading dialog
      Navigator.of(context).pop();

      // Share the exported file
      await controller.shareExportedData(filePath);

      // Show success message
      Get.snackbar(
        'Success',
        'Data exported and shared successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.successGreen,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: EdgeInsets.all(4.w),
        borderRadius: 12,
      );
    } catch (e) {
      // Close loading dialog if still open
      Navigator.of(context).pop();

      // Show error message
      Get.snackbar(
        'Error',
        'Failed to export data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        margin: EdgeInsets.all(4.w),
        borderRadius: 12,
      );
    }
  }

  String _getMonthName(int month) {
    const monthNames = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return monthNames[month];
  }

  void _showResetConfirmationDialog(
    BuildContext context,
    TransactionController controller,
    BudgetController budgetController,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 60.h,
          decoration: const BoxDecoration(
            color: AppTheme.primaryWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 1.h, bottom: 2.h),
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.greyMedium,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    children: [
                      // Header
                      Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.red,
                            size: 6.w,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'Confirm Reset',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryBlack,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close),
                            iconSize: 6.w,
                          ),
                        ],
                      ),

                      SizedBox(height: 4.h),

                      // Content
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Are you sure you want to reset all data?',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                'This will permanently delete:',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 2.h),

                              // Deletion list with chips
                              Wrap(
                                spacing: 2.w,
                                runSpacing: 1.h,
                                children:
                                    [
                                          'All transactions',
                                          'All categories',
                                          'All budgets',
                                          'All SMS data',
                                          'All settings',
                                        ]
                                        .map(
                                          (item) => Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 3.w,
                                              vertical: 1.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.red.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                color: Colors.red.withOpacity(
                                                  0.3,
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              item,
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                color: Colors.red[700],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),

                              SizedBox(height: 4.h),
                              Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.red[200]!),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red[700],
                                      size: 6.w,
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: Text(
                                        'This action cannot be undone!',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.red[700],
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

                      // Action buttons
                      SizedBox(height: 3.h),
                      Column(
                        children: [
                          CustomButton(
                            text: 'Reset All Data',
                            icon: Icons.delete_forever,
                            onPressed: () {
                              Navigator.of(context).pop();
                              _performReset(
                                context,
                                controller,
                                budgetController,
                              );
                            },
                            backgroundColor: Colors.red,
                            height: 6.h,
                          ),
                          SizedBox(height: 2.h),
                          CustomButton(
                            text: 'Cancel',
                            onPressed: () => Navigator.of(context).pop(),
                            isOutlined: true,
                            height: 6.h,
                          ),
                        ],
                      ),

                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _performReset(
    BuildContext context,
    TransactionController controller,
    BudgetController budgetController,
  ) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Padding(
              padding: EdgeInsets.all(2.w),
              child: Row(
                children: [
                  const CircularProgressIndicator(),
                  SizedBox(width: 4.w),
                  const Text('Resetting data...'),
                ],
              ),
            ),
          );
        },
      );

      // Perform the reset
      await controller.resetAllData();
      await budgetController.clearAllBudgets();

      // Close loading dialog
      Navigator.of(context).pop();

      // Show success message
      Get.snackbar(
        'Success',
        'All data has been reset successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.successGreen,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: EdgeInsets.all(4.w),
        borderRadius: 12,
      );

      // Navigate back to home
      Get.back();
    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();

      // Show error message
      Get.snackbar(
        'Error',
        'Failed to reset data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        margin: EdgeInsets.all(4.w),
        borderRadius: 12,
      );
    }
  }
}
