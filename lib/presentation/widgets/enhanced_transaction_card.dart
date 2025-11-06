import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../core/theme/app_theme.dart';

class EnhancedTransactionCard extends StatefulWidget {
  final TransactionEntity transaction;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const EnhancedTransactionCard({
    super.key,
    required this.transaction,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<EnhancedTransactionCard> createState() =>
      _EnhancedTransactionCardState();
}

class _EnhancedTransactionCardState extends State<EnhancedTransactionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  double _dragDistance = 0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    _isDragging = true;
    _dragDistance = 0;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    setState(() {
      _dragDistance += details.delta.dx;
      _dragDistance = _dragDistance.clamp(-100.w, 100.w);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (!_isDragging) return;

    _isDragging = false;

    const threshold = 60.0;

    if (_dragDistance > threshold && widget.onEdit != null) {
      // Swipe right to edit
      _triggerEdit();
    } else if (_dragDistance < -threshold && widget.onDelete != null) {
      // Swipe left to delete
      _triggerDelete();
    }

    // Reset position
    setState(() {
      _dragDistance = 0;
    });
  }

  void _triggerEdit() {
    _animationController.forward().then((_) {
      widget.onEdit?.call();
      _animationController.reverse();
    });
  }

  void _triggerDelete() {
    _showDeleteConfirmation();
  }

  Future<void> _showDeleteConfirmation() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppTheme.errorRed,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            const Text('Delete Transaction'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${widget.transaction.title}"?\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: TextStyle(color: AppTheme.greyDark)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              foregroundColor: AppTheme.primaryWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (result == true) {
      widget.onDelete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Stack(
        children: [
          // Background actions
          if (widget.onEdit != null || widget.onDelete != null) ...[
            // Edit action background (left swipe reveals)
            if (widget.onEdit != null)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 6.w),
                      AnimatedOpacity(
                        opacity: _dragDistance > 20 ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 150),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit_rounded,
                              color: AppTheme.primaryWhite,
                              size: 6.w,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              'Edit',
                              style: TextStyle(
                                color: AppTheme.primaryWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Delete action background (right swipe reveals)
            if (widget.onDelete != null)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.errorRed,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedOpacity(
                        opacity: _dragDistance < -20 ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 150),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_rounded,
                              color: AppTheme.primaryWhite,
                              size: 6.w,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: AppTheme.primaryWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 6.w),
                    ],
                  ),
                ),
              ),
          ],

          // Main card content
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_isDragging ? _dragDistance * 0.8 : 0, 0),
                child: child,
              );
            },
            child: GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: Card(
                elevation: _isDragging ? 8 : 2,
                shadowColor: _isDragging
                    ? AppTheme.primaryBlue.withOpacity(0.3)
                    : AppTheme.primaryBlack.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: _isDragging
                      ? BorderSide(
                          color: AppTheme.primaryBlue.withOpacity(0.3),
                          width: 1,
                        )
                      : BorderSide.none,
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: widget.onTap,
                    borderRadius: BorderRadius.circular(12),
                    child: _buildCardContent(context),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Transaction type icon with enhanced styling
              Container(
                padding: EdgeInsets.all(2.5.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.transaction.type == TransactionType.credit
                        ? [
                            AppTheme.successGreen,
                            AppTheme.successGreen.withOpacity(0.8),
                          ]
                        : widget.transaction.type == TransactionType.transfer
                        ? [
                            AppTheme.primaryBlue,
                            AppTheme.primaryBlue.withOpacity(0.8),
                          ]
                        : [
                            AppTheme.errorRed,
                            AppTheme.errorRed.withOpacity(0.8),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (widget.transaction.type == TransactionType.credit
                                  ? AppTheme.successGreen
                                  : widget.transaction.type ==
                                        TransactionType.transfer
                                  ? AppTheme.primaryBlue
                                  : AppTheme.errorRed)
                              .withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  widget.transaction.type == TransactionType.credit
                      ? Icons.arrow_downward_rounded
                      : widget.transaction.type == TransactionType.transfer
                      ? Icons.swap_horiz_rounded
                      : Icons.arrow_upward_rounded,
                  color: AppTheme.primaryWhite,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 4.w),

              // Transaction details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.transaction.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      widget.transaction.description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppTheme.greyDark),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Amount with enhanced styling
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color:
                          (widget.transaction.type == TransactionType.credit
                                  ? AppTheme.successGreen
                                  : widget.transaction.type ==
                                        TransactionType.transfer
                                  ? AppTheme.primaryBlue
                                  : AppTheme.errorRed)
                              .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${widget.transaction.type == TransactionType.credit
                          ? '+'
                          : widget.transaction.type == TransactionType.transfer
                          ? ''
                          : '-'}₹${_formatAmount(widget.transaction.amount)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: widget.transaction.type == TransactionType.credit
                            ? AppTheme.successGreen
                            : widget.transaction.type ==
                                  TransactionType.transfer
                            ? AppTheme.primaryBlue
                            : AppTheme.errorRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    DateFormat('MMM dd, yyyy').format(widget.transaction.date),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppTheme.greyDark),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 2.5.h),

          // Enhanced bottom section
          Row(
            children: [
              // Category chip with improved design
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.greyLight,
                      AppTheme.greyLight.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.greyMedium.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  _getCategoryDisplayName(widget.transaction.category),
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),

              if (widget.transaction.location != null) ...[
                SizedBox(width: 2.w),
                Icon(
                  Icons.location_on_rounded,
                  size: 4.w,
                  color: AppTheme.greyDark,
                ),
                SizedBox(width: 1.w),
                Expanded(
                  child: Text(
                    widget.transaction.location!,
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: AppTheme.greyDark),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ] else
                const Spacer(),

              // Swipe hint with animation
              if (widget.onEdit != null || widget.onDelete != null)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 0.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: _isDragging
                        ? AppTheme.primaryBlue.withOpacity(0.2)
                        : AppTheme.greyMedium.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.swipe_rounded,
                        size: 3.w,
                        color: _isDragging
                            ? AppTheme.primaryBlue
                            : AppTheme.greyDark,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Swipe',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: _isDragging
                              ? AppTheme.primaryBlue
                              : AppTheme.greyDark,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          // Photos indicator with improved styling
          if (widget.transaction.photos.isNotEmpty) ...[
            SizedBox(height: 1.5.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.photo_library_rounded,
                    size: 4.w,
                    color: AppTheme.primaryBlue,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '${widget.transaction.photos.length} photo${widget.transaction.photos.length > 1 ? 's' : ''}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
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
