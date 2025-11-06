import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../controllers/budget_controller.dart';
import '../../core/theme/app_theme.dart';
import 'custom_widgets.dart';

class BudgetManagementBottomSheet extends StatefulWidget {
  const BudgetManagementBottomSheet({super.key});

  @override
  State<BudgetManagementBottomSheet> createState() =>
      _BudgetManagementBottomSheetState();
}

class _BudgetManagementBottomSheetState
    extends State<BudgetManagementBottomSheet> {
  final TextEditingController _budgetController = TextEditingController();
  final BudgetController _controller = Get.find<BudgetController>();
  DateTime _selectedDate = DateTime.now();

  final List<int> _years = List.generate(
    11,
    (index) => DateTime.now().year - 5 + index,
  );
  final List<String> _months = [
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
    } else {
      _budgetController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
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
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
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

                  // Month Selection with Chips
                  Text(
                    'Select Month',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlack,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _months.asMap().entries.map((entry) {
                      final monthIndex = entry.key + 1;
                      final monthName = entry.value;
                      final isSelected = _selectedDate.month == monthIndex;

                      return GestureDetector(
                        onTap: () => _selectMonth(monthIndex),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryBlack
                                : AppTheme.greyLight,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryBlack
                                  : AppTheme.greyMedium,
                            ),
                          ),
                          child: Text(
                            monthName,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? AppTheme.primaryWhite
                                  : AppTheme.primaryBlack,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 4.h),

                  // Year Selection with Chips
                  Text(
                    'Select Year',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlack,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _years.map((year) {
                      final isSelected = _selectedDate.year == year;

                      return GestureDetector(
                        onTap: () => _selectYear(year),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryBlack
                                : AppTheme.greyLight,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryBlack
                                  : AppTheme.greyMedium,
                            ),
                          ),
                          child: Text(
                            year.toString(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? AppTheme.primaryWhite
                                  : AppTheme.primaryBlack,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 4.h),

                  // Selected Date Display
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlack.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.greyMedium),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: AppTheme.primaryBlack,
                          size: 5.w,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'Selected: ${_months[_selectedDate.month - 1]} ${_selectedDate.year}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryBlack,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Budget Amount Input
                  Text(
                    'Budget Amount (₹)',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlack,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  TextFormField(
                    controller: _budgetController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(fontSize: 16.sp),
                    decoration: InputDecoration(
                      hintText: 'Enter monthly budget amount',
                      hintStyle: TextStyle(fontSize: 14.sp),
                      prefixIcon: Icon(
                        Icons.currency_rupee,
                        size: 5.w,
                        color: AppTheme.primaryBlack,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppTheme.greyMedium,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppTheme.primaryBlack,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: AppTheme.primaryWhite,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Current Budget Display
                  if (_budgetController.text.isNotEmpty) ...[
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
                    SizedBox(height: 3.h),
                  ],

                  // Action Buttons
                  Obx(
                    () => Column(
                      children: [
                        CustomButton(
                          text: 'Set Budget',
                          onPressed: _controller.isLoading ? null : _setBudget,
                          isLoading: _controller.isLoading,
                          backgroundColor: AppTheme.primaryBlack,
                          height: 6.h,
                        ),
                        SizedBox(height: 2.h),
                        CustomButton(
                          text: 'Clear Budget',
                          onPressed: _controller.isLoading
                              ? null
                              : _clearBudget,
                          isOutlined: true,
                          backgroundColor: Colors.red,
                          height: 6.h,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 6.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectMonth(int month) async {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, month, 1);
    });
    await _loadCurrentBudget();
  }

  void _selectYear(int year) async {
    setState(() {
      _selectedDate = DateTime(year, _selectedDate.month, 1);
    });
    await _loadCurrentBudget();
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
        margin: EdgeInsets.all(4.w),
        borderRadius: 12,
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
        margin: EdgeInsets.all(4.w),
        borderRadius: 12,
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
}
