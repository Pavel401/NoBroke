import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../controllers/transaction_controller.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_card.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/swipe_instructions_dialog.dart';
import '../widgets/search_bottom_sheet.dart';
import '../widgets/sms_scan_bottom_sheet.dart';
import '../widgets/sms_privacy_dialog.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../core/theme/app_theme.dart';
import 'add_transaction_screen.dart';
import 'transaction_detail_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionController controller = Get.find<TransactionController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context, controller),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context, controller),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => Get.to(() => const SettingsScreen()),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryBlack),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadTransactions(),
          color: AppTheme.primaryBlack,
          child: CustomScrollView(
            slivers: [
              // Balance Card
              SliverToBoxAdapter(
                child: BalanceCard(
                  totalCredit: controller.totalCredit,
                  totalDebit: controller.totalDebit,
                  totalTransfer: controller.totalTransfer,
                  balance: controller.balance,
                ),
              ),

              // Quick Actions
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Scan SMS',
                          icon: Icons.sms,
                          onPressed: controller.isProcessingSms
                              ? null
                              : () => _showSmsScanBottomSheet(
                                  context,
                                  controller,
                                ),
                          isLoading: controller.isProcessingSms,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: CustomButton(
                          text: 'Add Manual',
                          icon: Icons.add,
                          isOutlined: true,
                          onPressed: () =>
                              Get.to(() => const AddTransactionScreen()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 2.h).toSliver(),

              // Transactions Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Recent Transactions',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(width: 2.w),
                          IconButton(
                            onPressed: () => _showSwipeInstructions(context),
                            icon: Icon(
                              Icons.help_outline_rounded,
                              size: 5.w,
                              color: AppTheme.primaryBlue,
                            ),
                            tooltip: 'Swipe instructions',
                          ),
                        ],
                      ),
                      // TextButton(
                      //   onPressed: () {
                      //     // Navigate to all transactions
                      //   },
                      //   child: const Text('View All'),
                      // ),
                    ],
                  ),
                ),
              ),

              // Transactions List
              if (controller.filteredTransactions.isEmpty)
                SliverFillRemaining(
                  child: EmptyState(
                    title: 'No transactions yet',
                    subtitle:
                        'Start by adding a transaction manually or scanning your SMS messages',
                    icon: Icons.receipt_long,
                    actionText: 'Add Transaction',
                    onAction: () => Get.to(() => const AddTransactionScreen()),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final transaction = controller.filteredTransactions[index];
                    return TransactionCard(
                      transaction: transaction,
                      onTap: () => Get.to(
                        () => TransactionDetailScreen(transaction: transaction),
                      ),
                      onEdit: () => Get.to(
                        () => AddTransactionScreen(transaction: transaction),
                      ),
                      // TransactionCard already shows a confirmation dialog
                      // when swiping to delete. So perform deletion directly
                      // here to avoid double confirmation.
                      onDelete: () =>
                          controller.deleteTransaction(transaction.id, context),
                    );
                  }, childCount: controller.filteredTransactions.length),
                ),

              // Bottom padding
              SizedBox(height: 10.h).toSliver(),
            ],
          ),
        );
      }),
    );
  }

  void _showFilterDialog(
    BuildContext context,
    TransactionController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
        decoration: const BoxDecoration(
          color: AppTheme.primaryWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Transactions',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 3.h),

              // Filter by Type
              Text(
                'Transaction Type',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 2.h),
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: CategoryChip(
                        label: 'All',
                        isSelected: controller.selectedType == null,
                        onTap: () => controller.filterTransactionsByType(null),
                      ),
                    ),
                    SizedBox(width: 1.5.w),
                    Expanded(
                      child: CategoryChip(
                        label: 'Credit',
                        isSelected:
                            controller.selectedType == TransactionType.credit,
                        selectedColor: AppTheme.successGreen,
                        onTap: () => controller.filterTransactionsByType(
                          TransactionType.credit,
                        ),
                      ),
                    ),
                    SizedBox(width: 1.5.w),
                    Expanded(
                      child: CategoryChip(
                        label: 'Debit',
                        isSelected:
                            controller.selectedType == TransactionType.debit,
                        selectedColor: AppTheme.errorRed,
                        onTap: () => controller.filterTransactionsByType(
                          TransactionType.debit,
                        ),
                      ),
                    ),
                    SizedBox(width: 1.5.w),
                    Expanded(
                      child: CategoryChip(
                        label: 'Transfer',
                        isSelected:
                            controller.selectedType == TransactionType.transfer,
                        selectedColor: AppTheme.primaryBlue,
                        onTap: () => controller.filterTransactionsByType(
                          TransactionType.transfer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              // Filter by Month
              Text('Month', style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 2.h),
              Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CategoryChip(
                        label: 'All',
                        isSelected: controller.selectedMonth == null,
                        onTap: () => controller.filterTransactionsByMonth(null),
                      ),
                      SizedBox(width: 1.5.w),
                      ..._generateMonthChips(controller),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 3.h),

              // Filter by Category
              Text('Category', style: Theme.of(context).textTheme.titleMedium),
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
                          isSelected: controller.selectedCategory == category,
                          onTap: () =>
                              controller.filterTransactionsByCategory(category),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.clearAllFilters();
                      },
                      icon: const Icon(Icons.clear_all, size: 18),
                      label: const Text('Clear'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        foregroundColor: Colors.grey[700],
                        elevation: 0,
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: CustomButton(
                      text: 'Apply Filters',
                      onPressed: () => Get.back(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSearchDialog(
    BuildContext context,
    TransactionController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SearchBottomSheet(),
    );
  }

  void _showSwipeInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const SwipeInstructionsDialog(),
    );
  }

  void _showSmsScanBottomSheet(
    BuildContext context,
    TransactionController controller,
  ) {
    // Show privacy dialog first, then SMS scan bottom sheet
    showDialog(
      context: context,
      builder: (context) => SmsPrivacyDialog(
        onAccept: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const SmsScanBottomSheet(),
          );
        },
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

  List<Widget> _generateMonthChips(TransactionController controller) {
    final now = DateTime.now();
    final List<Widget> monthChips = [];

    // Generate chips for the last 12 months
    for (int i = 0; i < 12; i++) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthName = _getMonthName(month.month);
      final displayText = month.year == now.year
          ? monthName
          : '$monthName ${month.year}';

      monthChips.add(
        CategoryChip(
          label: displayText,
          isSelected:
              controller.selectedMonth != null &&
              controller.selectedMonth!.year == month.year &&
              controller.selectedMonth!.month == month.month,
          onTap: () => controller.filterTransactionsByMonth(month),
        ),
      );

      if (i < 11) {
        monthChips.add(SizedBox(width: 1.5.w));
      }
    }

    return monthChips;
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return monthNames[month - 1];
  }
}

extension SizedBoxSliver on SizedBox {
  Widget toSliver() => SliverToBoxAdapter(child: this);
}
