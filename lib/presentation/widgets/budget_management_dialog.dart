import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../controllers/budget_controller.dart';
import '../../core/theme/app_theme.dart';
import 'custom_widgets.dart';

class BudgetManagementDialog extends StatefulWidget {
  const BudgetManagementDialog({super.key});

  @override
  State<BudgetManagementDialog> createState() => _BudgetManagementDialogState();
}

class _BudgetManagementDialogState extends State<BudgetManagementDialog> {
  final TextEditingController _budgetController = TextEditingController();
  final BudgetController _controller = Get.find<BudgetController>();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadCurrentBudget();
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentBudget() async {
    final budget = await _controller.getBudgetForMonth(
      _selectedDate.year,
      _selectedDate.month,
    );
    if (budget > 0) {
      _budgetController.text = budget.toStringAsFixed(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: AppTheme.primaryBlack,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Set Monthly Budget',
                    style: TextStyle(
                      fontSize: 18.sp,
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

            // Month/Year Selector
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.greyLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.greyMedium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Month & Year',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlack,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  InkWell(
                    onTap: _showDatePicker,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryWhite,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.greyMedium),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            size: 5.w,
                            color: AppTheme.greyDark,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              '${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.primaryBlack,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 6.w,
                            color: AppTheme.greyDark,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),

            // Budget Amount Input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Budget Amount (₹)',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlack,
                  ),
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'Enter monthly budget amount',
                    prefixIcon: Icon(Icons.currency_rupee, size: 5.w),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.greyMedium),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppTheme.primaryBlack,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),

            // Action Buttons
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Clear',
                      onPressed: _controller.isLoading ? null : _clearBudget,
                      isOutlined: true,
                      backgroundColor: Colors.red,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      text: 'Set Budget',
                      onPressed: _controller.isLoading ? null : _setBudget,
                      isLoading: _controller.isLoading,
                      backgroundColor: AppTheme.primaryBlack,
                    ),
                  ),
                ],
              ),
            ),

            // Current Budget Display
            if (_budgetController.text.isNotEmpty) ...[
              SizedBox(height: 3.h),
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
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'Current budget: ₹${_budgetController.text}',
                        style: TextStyle(
                          fontSize: 12.sp,
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
      ),
    );
  }

  Future<void> _showDatePicker() async {
    final initialDate = _selectedDate;
    final firstDate = DateTime(2020);
    final lastDate = DateTime(2030);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      selectableDayPredicate: (date) =>
          date.day == 1, // Only allow first day of month
      helpText: 'Select Month & Year',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppTheme.primaryBlack),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = DateTime(pickedDate.year, pickedDate.month, 1);
      });
      await _loadCurrentBudget();
    }
  }

  Future<void> _setBudget() async {
    final budgetText = _budgetController.text.trim();
    if (budgetText.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a budget amount',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final amount = double.tryParse(budgetText);
    if (amount == null || amount <= 0) {
      Get.snackbar(
        'Error',
        'Please enter a valid budget amount',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    await _controller.setMonthlyBudgetForMonth(
      _selectedDate.year,
      _selectedDate.month,
      amount,
      context,
    );

    Navigator.of(context).pop();
  }

  Future<void> _clearBudget() async {
    await _controller.clearBudgetForMonth(
      _selectedDate.year,
      _selectedDate.month,
      context,
    );
    _budgetController.clear();
    Navigator.of(context).pop();
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
}
