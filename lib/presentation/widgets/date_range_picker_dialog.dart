import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:moneyapp/core/theme/app_theme.dart';
import 'package:moneyapp/presentation/widgets/custom_widgets.dart';

class DateRangePickerDialog extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(DateTime startDate, DateTime endDate) onDateRangeSelected;

  const DateRangePickerDialog({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    required this.onDateRangeSelected,
  });

  @override
  State<DateRangePickerDialog> createState() => _DateRangePickerDialogState();
}

class _DateRangePickerDialogState extends State<DateRangePickerDialog> {
  late DateTime _startDate;
  late DateTime _endDate;
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _endDate = widget.initialEndDate ?? DateTime.now();
    _startDate =
        widget.initialStartDate ?? _endDate.subtract(const Duration(days: 30));
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: _endDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryBlack,
              onPrimary: AppTheme.primaryWhite,
              surface: AppTheme.primaryWhite,
              onSurface: AppTheme.primaryBlack,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        // Ensure end date is not before start date
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate;
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryBlack,
              onPrimary: AppTheme.primaryWhite,
              surface: AppTheme.primaryWhite,
              onSurface: AppTheme.primaryBlack,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _setPresetRange(int days) {
    setState(() {
      _endDate = DateTime.now();
      _startDate = _endDate.subtract(Duration(days: days));
    });
  }

  @override
  Widget build(BuildContext context) {
    final daysDifference = _endDate.difference(_startDate).inDays + 1;

    return AlertDialog(
      title: const Text('Select Date Range'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose the date range for SMS scanning:',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.greyDark),
            ),
            SizedBox(height: 3.h),

            // Preset buttons
            Text(
              'Quick Select:',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: [
                _buildPresetChip('Last 7 days', 7),
                _buildPresetChip('Last 30 days', 30),
                _buildPresetChip('Last 90 days', 90),
                _buildPresetChip('Last 6 months', 180),
              ],
            ),

            SizedBox(height: 3.h),
            const Divider(),
            SizedBox(height: 2.h),

            // Custom date selection
            Text(
              'Custom Range:',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2.h),

            // Start date
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From:',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: 1.h),
                      GestureDetector(
                        onTap: _selectStartDate,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 1.w,
                            vertical: 1.5.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.greyLight),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 18),
                              SizedBox(width: 2.w),
                              Text(_dateFormat.format(_startDate)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('To:', style: Theme.of(context).textTheme.bodySmall),
                      SizedBox(height: 1.h),
                      GestureDetector(
                        onTap: _selectEndDate,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 1.w,
                            vertical: 1.5.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.greyLight),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 18),
                              SizedBox(width: 2.w),
                              Text(_dateFormat.format(_endDate)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Summary
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlack.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 16),
                  SizedBox(width: 2.w),
                  Text(
                    'Scanning $daysDifference days of SMS messages',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        CustomButton(
          text: 'Scan SMS',
          onPressed: () {
            widget.onDateRangeSelected(_startDate, _endDate);
            Get.back();
          },
          width: 30.w,
        ),
      ],
    );
  }

  Widget _buildPresetChip(String label, int days) {
    final isSelected =
        _endDate.difference(_startDate).inDays + 1 == days &&
        _endDate.day == DateTime.now().day;

    return GestureDetector(
      onTap: () => _setPresetRange(days),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlack : AppTheme.primaryWhite,
          border: Border.all(
            color: isSelected ? AppTheme.primaryBlack : AppTheme.greyLight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.primaryWhite : AppTheme.primaryBlack,
            fontSize: 10.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
