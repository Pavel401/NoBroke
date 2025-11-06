import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../core/theme/app_theme.dart';

class TransactionCard extends StatelessWidget {
  final TransactionEntity transaction;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // If no edit or delete actions, use simple card
    if (onEdit == null && onDelete == null) {
      return _buildSimpleCard(context);
    }

    // Use swipe-to-reveal actions for edit and delete
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Dismissible(
          key: Key('transaction_${transaction.id}'),
          direction: DismissDirection.horizontal,
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart && onDelete != null) {
              // Show delete confirmation
              return await _showDeleteConfirmation(context);
            } else if (direction == DismissDirection.startToEnd &&
                onEdit != null) {
              // Trigger edit action
              onEdit!();
              return false; // Don't dismiss, just trigger edit
            }
            return false;
          },
          background: _buildEditBackground(),
          secondaryBackground: _buildDeleteBackground(),
          child: _buildTransactionCard(context),
        ),
      ),
    );
  }

  Widget _buildSimpleCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: _buildCardContent(context),
      ),
    );
  }

  Widget _buildTransactionCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: _buildCardContent(context),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Transaction type icon
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: transaction.type == TransactionType.credit
                      ? AppTheme.successGreen.withOpacity(0.1)
                      : transaction.type == TransactionType.transfer
                      ? AppTheme.primaryBlue.withOpacity(0.1)
                      : AppTheme.errorRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  transaction.type == TransactionType.credit
                      ? Icons.arrow_downward
                      : transaction.type == TransactionType.transfer
                      ? Icons.swap_horiz
                      : Icons.arrow_upward,
                  color: transaction.type == TransactionType.credit
                      ? AppTheme.successGreen
                      : transaction.type == TransactionType.transfer
                      ? AppTheme.primaryBlue
                      : AppTheme.errorRed,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              // Transaction details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      transaction.description,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${transaction.type == TransactionType.credit
                        ? '+'
                        : transaction.type == TransactionType.transfer
                        ? ''
                        : '-'}₹${_formatAmount(transaction.amount)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: transaction.type == TransactionType.credit
                          ? AppTheme.successGreen
                          : transaction.type == TransactionType.transfer
                          ? AppTheme.primaryBlue
                          : AppTheme.errorRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    DateFormat('MMM dd, yyyy').format(transaction.date),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 2.h),
          // Category and info row
          Row(
            children: [
              // Category chip
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.greyLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _getCategoryDisplayName(transaction.category),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              if (transaction.location != null) ...[
                SizedBox(width: 2.w),
                Icon(Icons.location_on, size: 4.w, color: AppTheme.greyDark),
                SizedBox(width: 1.w),
                Expanded(
                  child: Text(
                    transaction.location!,
                    style: Theme.of(context).textTheme.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ] else
                const Spacer(),
              // Swipe hint
              if (onEdit != null || onDelete != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 0.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.greyMedium.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Swipe',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.greyDark,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
            ],
          ),
          // Photos indicator
          if (transaction.photos.isNotEmpty) ...[
            SizedBox(height: 1.h),
            Row(
              children: [
                Icon(Icons.photo_library, size: 4.w, color: AppTheme.greyDark),
                SizedBox(width: 1.w),
                Text(
                  '${transaction.photos.length} photo${transaction.photos.length > 1 ? 's' : ''}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEditBackground() {
    return Container(
      color: AppTheme.primaryBlue,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.edit, color: AppTheme.primaryWhite, size: 6.w),
          SizedBox(height: 1.h),
          Text(
            'Edit',
            style: TextStyle(
              color: AppTheme.primaryWhite,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      color: AppTheme.errorRed,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete, color: AppTheme.primaryWhite, size: 6.w),
          SizedBox(height: 1.h),
          Text(
            'Delete',
            style: TextStyle(
              color: AppTheme.primaryWhite,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Transaction'),
            content: Text(
              'Are you sure you want to delete "${transaction.title}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  if (onDelete != null) onDelete!();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorRed,
                  foregroundColor: AppTheme.primaryWhite,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  String _formatAmount(double amount) {
    final formatter = NumberFormat('#,##,###.##');
    return formatter.format(amount);
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
