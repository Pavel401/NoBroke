import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../controllers/transaction_controller.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../core/theme/app_theme.dart';
import 'custom_widgets.dart';

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({super.key});

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final TransactionController controller = Get.find<TransactionController>();

  @override
  void initState() {
    super.initState();
    _searchController.text = controller.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with close button
                  Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: AppTheme.primaryBlack,
                        size: 6.w,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          'Search & Filter',
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

                  // Search Field
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.greyLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.greyMedium),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) =>
                          controller.searchTransactions(value),
                      decoration: InputDecoration(
                        hintText: 'Search by title or description...',
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppTheme.greyDark,
                          size: 5.w,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: AppTheme.greyDark,
                                  size: 5.w,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  controller.searchTransactions('');
                                  setState(() {});
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 2.h,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Quick Actions
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionButton(
                          'Clear All',
                          Icons.clear_all,
                          () {
                            _searchController.clear();
                            controller.clearAllFilters();
                            setState(() {});
                          },
                          isDestructive: true,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: _buildQuickActionButton(
                          'Apply',
                          Icons.check,
                          () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Filter by Type Section
                  Text(
                    'Transaction Type',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlack,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: CategoryChip(
                            label: 'All',
                            isSelected: controller.selectedType == null,
                            onTap: () =>
                                controller.filterTransactionsByType(null),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: CategoryChip(
                            label: 'Credit',
                            isSelected:
                                controller.selectedType ==
                                TransactionType.credit,
                            selectedColor: AppTheme.successGreen,
                            onTap: () => controller.filterTransactionsByType(
                              TransactionType.credit,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: CategoryChip(
                            label: 'Debit',
                            isSelected:
                                controller.selectedType ==
                                TransactionType.debit,
                            selectedColor: AppTheme.errorRed,
                            onTap: () => controller.filterTransactionsByType(
                              TransactionType.debit,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: CategoryChip(
                            label: 'Transfer',
                            isSelected:
                                controller.selectedType ==
                                TransactionType.transfer,
                            selectedColor: AppTheme.primaryBlue,
                            onTap: () => controller.filterTransactionsByType(
                              TransactionType.transfer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Filter by Category Section
                  Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlack,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  Expanded(
                    child: Obx(
                      () => GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2.w,
                        mainAxisSpacing: 1.h,
                        childAspectRatio: 2.5,
                        children: [
                          CategoryChip(
                            label: 'All',
                            isSelected: controller.selectedCategory == null,
                            onTap: () =>
                                controller.filterTransactionsByCategory(null),
                          ),
                          ...TransactionCategory.values.map(
                            (category) => CategoryChip(
                              label: _getCategoryDisplayName(category),
                              isSelected:
                                  controller.selectedCategory == category,
                              onTap: () => controller
                                  .filterTransactionsByCategory(category),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Results count
                  Obx(
                    () => Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.greyLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppTheme.primaryBlue,
                            size: 5.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            '${controller.filteredTransactions.length} transaction(s) found',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppTheme.greyDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    String text,
    IconData icon,
    VoidCallback onPressed, {
    bool isDestructive = false,
  }) {
    return SizedBox(
      height: 5.h,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 4.w,
          color: isDestructive ? Colors.red : AppTheme.primaryWhite,
        ),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red : AppTheme.primaryWhite,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDestructive
              ? Colors.red.withOpacity(0.1)
              : AppTheme.primaryBlack,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: isDestructive
                ? BorderSide(color: Colors.red.withOpacity(0.3))
                : BorderSide.none,
          ),
        ),
      ),
    );
  }

  String _getCategoryDisplayName(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.food:
        return 'Food';
      case TransactionCategory.grocery:
        return 'Grocery';
      case TransactionCategory.transport:
        return 'Transport';
      case TransactionCategory.entertainment:
        return 'Entertainment';
      case TransactionCategory.shopping:
        return 'Shopping';
      case TransactionCategory.healthcare:
        return 'Healthcare';
      case TransactionCategory.education:
        return 'Education';
      case TransactionCategory.utilities:
        return 'Utilities';
      case TransactionCategory.fuel:
        return 'Fuel';
      case TransactionCategory.transfer:
        return 'Transfer';
      case TransactionCategory.other:
        return 'Other';
    }
  }
}
