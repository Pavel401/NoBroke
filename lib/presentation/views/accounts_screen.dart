import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../controllers/account_controller.dart';
import '../../core/theme/app_theme.dart';
import 'add_account_screen.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountController controller = Get.find<AccountController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        backgroundColor: AppTheme.primaryWhite,
        foregroundColor: AppTheme.primaryBlack,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryBlack),
          );
        }

        if (controller.accounts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  size: 20.w,
                  color: AppTheme.greyDark,
                ),
                SizedBox(height: 2.h),
                Text(
                  'No accounts yet',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Add your first account to get started',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppTheme.greyDark),
                ),
                SizedBox(height: 3.h),
                ElevatedButton.icon(
                  onPressed: () => Get.to(() => const AddAccountScreen()),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Account'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlack,
                    foregroundColor: AppTheme.primaryWhite,
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 1.5.h,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadAccounts(),
          color: AppTheme.primaryBlack,
          child: ListView.builder(
            padding: EdgeInsets.all(4.w),
            itemCount: controller.accounts.length,
            itemBuilder: (context, index) {
              final account = controller.accounts[index];
              return Card(
                margin: EdgeInsets.only(bottom: 2.h),
                child: ListTile(
                  contentPadding: EdgeInsets.all(4.w),
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryBlack,
                    child: Icon(
                      Icons.account_balance,
                      color: AppTheme.primaryWhite,
                      size: 6.w,
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          account.accountName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      if (account.isActive)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlack,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'DEFAULT',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: AppTheme.primaryWhite,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 1.h),
                      Text(
                        account.bankName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.greyDark,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '••••${account.accountNumber.substring(account.accountNumber.length - 4)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.greyDark,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        '₹${account.balance.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: account.balance >= 0
                              ? AppTheme.successGreen
                              : AppTheme.errorRed,
                        ),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        Get.to(() => AddAccountScreen(account: account));
                      } else if (value == 'delete') {
                        _showDeleteDialog(context, controller, account);
                      } else if (value == 'setDefault') {
                        controller.setDefaultAccount(account.id);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: AppTheme.primaryBlack),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      if (!account.isActive)
                        const PopupMenuItem(
                          value: 'setDefault',
                          child: Row(
                            children: [
                              Icon(Icons.star, color: AppTheme.primaryBlack),
                              SizedBox(width: 8),
                              Text('Set as Default'),
                            ],
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: AppTheme.errorRed),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddAccountScreen()),
        backgroundColor: AppTheme.primaryBlack,
        child: const Icon(Icons.add, color: AppTheme.primaryWhite),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    AccountController controller,
    dynamic account,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: Text(
          'Are you sure you want to delete "${account.accountName}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              controller.deleteAccount(account.id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              foregroundColor: AppTheme.primaryWhite,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
