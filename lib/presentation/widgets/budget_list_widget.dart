import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../controllers/budget_controller.dart';
import '../../core/theme/app_theme.dart';

class BudgetListWidget extends StatelessWidget {
  const BudgetListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final BudgetController controller = Get.find<BudgetController>();

    return Obx(() {
      if (controller.monthlyBudgets.isEmpty) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 12.w,
                color: AppTheme.greyDark,
              ),
              SizedBox(height: 2.h),
              Text(
                'No budgets set yet',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.greyDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Set your first monthly budget to start tracking your spending',
                style: TextStyle(fontSize: 11.sp, color: AppTheme.greyDark),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.monthlyBudgets.length,
        separatorBuilder: (context, index) => SizedBox(height: 2.h),
        itemBuilder: (context, index) {
          final budget = controller.monthlyBudgets[index];
          final year = budget['year'] as int;
          final month = budget['month'] as int;
          final amount = (budget['amount'] as num).toDouble();
          final monthName = _getMonthName(month);
          final isCurrentMonth = _isCurrentMonth(year, month);

          return Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: isCurrentMonth
                  ? AppTheme.primaryBlack.withOpacity(0.05)
                  : AppTheme.primaryWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isCurrentMonth
                    ? AppTheme.primaryBlack.withOpacity(0.2)
                    : AppTheme.greyMedium,
                width: isCurrentMonth ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: isCurrentMonth
                            ? AppTheme.primaryBlack
                            : AppTheme.greyLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$monthName $year',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: isCurrentMonth
                              ? AppTheme.primaryWhite
                              : AppTheme.primaryBlack,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (isCurrentMonth)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.successGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Current',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryWhite,
                          ),
                        ),
                      ),
                    SizedBox(width: 2.w),
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'edit') {
                          // TODO: Open edit dialog
                        } else if (value == 'delete') {
                          await _showDeleteConfirmation(
                            context,
                            controller,
                            year,
                            month,
                            monthName,
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 16),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 16, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                      icon: Icon(
                        Icons.more_vert,
                        color: AppTheme.greyDark,
                        size: 5.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      color: AppTheme.primaryBlack,
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Budget Amount',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppTheme.greyDark,
                            ),
                          ),
                          Text(
                            '₹${amount.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (isCurrentMonth) ...[
                  SizedBox(height: 2.h),
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.greyLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppTheme.primaryBlack,
                          size: 4.w,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            'This is your current month\'s budget',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppTheme.greyDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      );
    });
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

  bool _isCurrentMonth(int year, int month) {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    BudgetController controller,
    int year,
    int month,
    String monthName,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 6.w),
              SizedBox(width: 2.w),
              const Text('Delete Budget'),
            ],
          ),
          content: Text(
            'Are you sure you want to delete the budget for $monthName $year?',
            style: TextStyle(fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppTheme.greyDark, fontSize: 14.sp),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await controller.clearBudgetForMonth(year, month, context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Delete', style: TextStyle(fontSize: 14.sp)),
            ),
          ],
        );
      },
    );
  }
}
