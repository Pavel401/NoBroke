import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growthapp/ui/components/kid_friendly_app_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/selection_controller.dart';
import '../../controllers/items_controller.dart';
import '../../services/audio_service.dart';
import '../../routes/app_pages.dart';
import '../../db/app_db.dart';
import '../colors.dart';
import '../animated_icons.dart';

class SelectItemScreen extends StatelessWidget {
  const SelectItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selection = Get.put(SelectionController());
    final itemsCtrl = Get.put(ItemsController());
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: SimpleKidAppBar(
        title: '🛍️ Pick an Item',
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: TurfitColors.whiteDark,
            size: 20.sp,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          Bounceable(
            onTap: () => Get.toNamed(Routes.addItem),
            child: Container(
              margin: EdgeInsets.only(right: 4.w),
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: TurfitColors.primaryLight.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: TurfitColors.primaryLight.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.add_circle_outline,
                color: TurfitColors.whiteDark,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colorScheme.surface, colorScheme.surface.withOpacity(0.8)],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              // Enhanced search bar with filter button
              Container(
                decoration: BoxDecoration(
                  color: TurfitColors.white(context),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: TurfitColors.grey200(context),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: TurfitColors.primaryLight.withOpacity(0.08),
                      offset: const Offset(0, 4),
                      blurRadius: 16,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Search field
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            padding: EdgeInsets.all(3.w),
                            child: Icon(
                              Icons.search_rounded,
                              color: TurfitColors.primaryLight,
                              size: 22.sp,
                            ),
                          ),
                          hintText: 'Search your next purchase...',
                          hintStyle: GoogleFonts.nunito(
                            color: TurfitColors.grey500(context),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                        ),
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        onChanged: (v) => itemsCtrl.query.value = v,
                      ),
                    ),

                    // Vertical divider
                    Container(
                      height: 5.h,
                      width: 1,
                      color: TurfitColors.grey200(context),
                    ),

                    // Filter button
                    Bounceable(
                      onTap: () => _showFilterBottomSheet(context, itemsCtrl),
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.tune_rounded,
                              color: TurfitColors.primaryLight,
                              size: 20.sp,
                            ),
                            SizedBox(width: 1.w),
                            Obx(() {
                              final hasFilter =
                                  itemsCtrl.selectedCategory.value.isNotEmpty;
                              return Text(
                                hasFilter ? 'Filtered' : 'Filter',
                                style: GoogleFonts.nunito(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: hasFilter
                                      ? TurfitColors.primaryLight
                                      : TurfitColors.grey600(context),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),

              SizedBox(height: 2.h),

              // Filter Status Display
              Obx(() {
                final selectedCat = itemsCtrl.selectedCategory.value;
                final query = itemsCtrl.query.value;

                if (selectedCat.isEmpty && query.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  child: Row(
                    children: [
                      if (query.isNotEmpty) ...[
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: TurfitColors.tertiaryLight.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: TurfitColors.tertiaryLight.withOpacity(
                                0.3,
                              ),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search,
                                size: 14.sp,
                                color: TurfitColors.tertiaryLight,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                '"$query"',
                                style: GoogleFonts.nunito(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: TurfitColors.tertiaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (selectedCat.isNotEmpty) SizedBox(width: 2.w),
                      ],

                      if (selectedCat.isNotEmpty) ...[
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: TurfitColors.primaryLight.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: TurfitColors.primaryLight.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CategoryIcons.getAnimatedCategoryIcon(
                                selectedCat,
                                size: 14,
                                color: TurfitColors.primaryLight,
                                animate: false,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                selectedCat,
                                style: GoogleFonts.nunito(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: TurfitColors.primaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const Spacer(),

                      // Clear filters button
                      if (selectedCat.isNotEmpty || query.isNotEmpty)
                        Bounceable(
                          onTap: () {
                            itemsCtrl.selectedCategory.value = '';
                            itemsCtrl.query.value = '';
                          },
                          child: Container(
                            padding: EdgeInsets.all(1.5.w),
                            decoration: BoxDecoration(
                              color: TurfitColors.grey200(context),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.clear,
                              size: 16.sp,
                              color: TurfitColors.grey600(context),
                            ),
                          ),
                        ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: -0.1);
              }),

              // Items list
              Expanded(
                child: Obx(() {
                  final data = itemsCtrl.filteredItems;
                  if (data.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '🤷‍♀️',
                            style: TextStyle(fontSize: 50.sp),
                          ).animate().scale(
                            duration: 600.ms,
                            curve: Curves.elasticOut,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'No items found!',
                            style: GoogleFonts.nunito(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                          ).animate(delay: 200.ms).fadeIn(),
                          SizedBox(height: 1.h),
                          Text(
                            'Try adjusting your search or add a new item',
                            style: GoogleFonts.nunito(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: TurfitColors.grey600(context),
                            ),
                            textAlign: TextAlign.center,
                          ).animate(delay: 400.ms).fadeIn(),
                          SizedBox(height: 3.h),
                          Bounceable(
                            onTap: () => Get.toNamed(Routes.addItem),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    TurfitColors.primaryLight,
                                    TurfitColors.tertiaryLight,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: TurfitColors.primaryLight
                                        .withOpacity(0.3),
                                    offset: const Offset(0, 4),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    'Add New Item',
                                    style: GoogleFonts.nunito(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).animate(delay: 600.ms).fadeIn().scale(),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: data.length,
                    separatorBuilder: (_, __) => SizedBox(height: 1.h),
                    itemBuilder: (context, index) {
                      final it = data[index];
                      final hasIcon = (it.iconName ?? '').isNotEmpty;

                      return Dismissible(
                            key: ValueKey('catalog_${it.id}'),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.red[300]!, Colors.red[400]!],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 6.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete_outline,
                                    color: Colors.white,
                                    size: 24.sp,
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    'Delete',
                                    style: GoogleFonts.nunito(
                                      color: Colors.white,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            confirmDismiss: (_) =>
                                _showDeleteDialog(context, it),
                            onDismissed: (_) async {
                              await itemsCtrl.deleteItem(it.id);
                              Get.snackbar(
                                '✅ Deleted',
                                'Removed "${it.name}" from your catalog',
                                backgroundColor: TurfitColors.successLight
                                    .withOpacity(0.1),
                                colorText: TurfitColors.successLight,
                                borderRadius: 12,
                                margin: EdgeInsets.all(4.w),
                              );
                            },
                            child: Bounceable(
                              onTap: () {
                                // Play button click sound
                                AudioService().playButtonClick();

                                HapticFeedback.lightImpact();
                                selection.pickItemFull(
                                  it.name,
                                  iconName: it.iconName,
                                );
                                Get.toNamed(
                                  Routes.enterPrice,
                                  arguments: it.defaultPrice ?? 0,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  color: TurfitColors.white(context),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: TurfitColors.grey200(context),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: TurfitColors.primaryLight
                                          .withOpacity(0.05),
                                      offset: const Offset(0, 2),
                                      blurRadius: 12,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // Icon container
                                    Container(
                                      padding: EdgeInsets.all(3.w),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            TurfitColors.primaryLight
                                                .withOpacity(0.1),
                                            TurfitColors.tertiaryLight
                                                .withOpacity(0.1),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: TurfitColors.primaryLight
                                              .withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                      child: hasIcon
                                          ? KidFriendlyIcons.getAnimatedIcon(
                                              it.iconName,
                                              size: 24.sp,
                                              color: TurfitColors.primaryLight,
                                              delay: Duration(
                                                milliseconds: index * 20,
                                              ), // Faster animation
                                            )
                                          : Icon(
                                              Icons.category_rounded,
                                              size: 24.sp,
                                              color: TurfitColors.primaryLight,
                                            ),
                                    ),
                                    SizedBox(width: 4.w),

                                    // Content
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            it.name,
                                            style: GoogleFonts.nunito(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w700,
                                              color: colorScheme.onSurface,
                                            ),
                                          ),
                                          SizedBox(height: 0.5.h),
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 2.w,
                                                  vertical: 0.5.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: TurfitColors.grey100(
                                                    context,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  it.category,
                                                  style: GoogleFonts.nunito(
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: TurfitColors.grey600(
                                                      context,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              if ((it.description ?? '')
                                                  .isNotEmpty) ...[
                                                SizedBox(width: 2.w),
                                                Expanded(
                                                  child: Text(
                                                    it.description!,
                                                    style: GoogleFonts.nunito(
                                                      fontSize: 11.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          TurfitColors.grey600(
                                                            context,
                                                          ),
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Arrow
                                    Container(
                                      padding: EdgeInsets.all(1.w),
                                      decoration: BoxDecoration(
                                        color: TurfitColors.primaryLight
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: TurfitColors.primaryLight,
                                        size: 16.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .animate(
                            delay: Duration(milliseconds: index * 20),
                          ) // Much faster stagger
                          .fadeIn(duration: 200.ms) // Faster fade
                          .slideX(begin: 0.1, duration: 250.ms); // Faster slide
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showDeleteDialog(BuildContext context, CatalogItem item) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Text('🗑️', style: TextStyle(fontSize: 24.sp)),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Remove Item?',
                    style: GoogleFonts.nunito(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              'Delete "${item.name}" from your catalog? This action cannot be undone.',
              style: GoogleFonts.nunito(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [
              Bounceable(
                onTap: () => Navigator.pop(ctx, false),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 1.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: TurfitColors.grey200(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.nunito(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: TurfitColors.grey700(context),
                    ),
                  ),
                ),
              ),
              Bounceable(
                onTap: () => Navigator.pop(ctx, true),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 1.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: TurfitColors.errorLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Delete',
                    style: GoogleFonts.nunito(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showFilterBottomSheet(BuildContext context, ItemsController itemsCtrl) {
    final colorScheme = Theme.of(context).colorScheme;

    // Create local variable to track state within the bottom sheet
    String tempSelectedCategory = itemsCtrl.selectedCategory.value;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setBottomSheetState) => Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 3.h),

              // Title
              Text(
                '🏷️ Filter by Category',
                style: GoogleFonts.nunito(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 1.h),

              Text(
                'Choose a category to narrow down your search',
                style: GoogleFonts.nunito(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: TurfitColors.grey600(context),
                ),
              ),
              SizedBox(height: 3.h),

              // Category Filter
              Obx(() {
                final categories = ['All Categories', ...itemsCtrl.categories];
                return _buildFilterChipsInBottomSheet(
                  context,
                  options: categories,
                  selectedValue: tempSelectedCategory.isEmpty
                      ? 'All Categories'
                      : tempSelectedCategory,
                  onChanged: (value) {
                    setBottomSheetState(() {
                      tempSelectedCategory = value == 'All Categories'
                          ? ''
                          : value;
                    });
                  },
                  getLabel: (value) => value,
                );
              }),

              SizedBox(height: 4.h),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: Bounceable(
                      onTap: () {
                        setBottomSheetState(() {
                          tempSelectedCategory = '';
                        });
                        itemsCtrl.selectedCategory.value = '';
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Clear Filter',
                            style: GoogleFonts.nunito(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Bounceable(
                      onTap: () {
                        itemsCtrl.selectedCategory.value = tempSelectedCategory;
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              TurfitColors.primaryLight,
                              TurfitColors.tertiaryLight,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Apply Filter',
                            style: GoogleFonts.nunito(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChipsInBottomSheet(
    BuildContext context, {
    required List<String> options,
    required String selectedValue,
    required Function(String) onChanged,
    required String Function(String) getLabel,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: options.map((option) {
        final isSelected = option == selectedValue;
        return Bounceable(
          onTap: () => onChanged(option),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? TurfitColors.primaryLight.withOpacity(0.1)
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? TurfitColors.primaryLight
                    : TurfitColors.grey300(context),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (option != 'All Categories') ...[
                  CategoryIcons.getAnimatedCategoryIcon(
                    option,
                    size: 14,
                    color: isSelected
                        ? TurfitColors.primaryLight
                        : TurfitColors.grey600(context),
                    animate: false,
                  ),
                  SizedBox(width: 1.w),
                ],
                Text(
                  getLabel(option),
                  style: GoogleFonts.nunito(
                    fontSize: 12.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? TurfitColors.primaryLight
                        : colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
