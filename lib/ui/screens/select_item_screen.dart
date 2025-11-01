import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/selection_controller.dart';
import '../../controllers/items_controller.dart';
import '../../routes/app_pages.dart';
import '../icon_utils.dart';
import '../colors.dart';
import '../animated_icons.dart';

class SelectItemScreen extends StatelessWidget {
  const SelectItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selection = Get.put(SelectionController());
    final itemsCtrl = Get.put(ItemsController());
    return Scaffold(
      backgroundColor: TurfitColors.surfaceLight,
      appBar: AppBar(
        title: Text(
          '🛍️ Pick an item',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 2.w),
            decoration: BoxDecoration(
              color: TurfitColors.primaryLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              tooltip: 'Add custom item',
              icon: Icon(
                Icons.add_circle_outline,
                color: TurfitColors.primaryLight,
                size: 24.sp,
              ),
              onPressed: () => Get.toNamed(Routes.addItem),
            ).animate().scale(duration: 300.ms, curve: Curves.elasticOut),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              TurfitColors.surfaceLight,
              TurfitColors.surfaceLight.withOpacity(0.8),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              // Enhanced search bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: TurfitColors.primaryLight.withOpacity(0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: TurfitColors.primaryLight,
                            size: 20.sp,
                          ),
                          hintText: '🔍 Search your next purchase...',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                        ),
                        onChanged: (v) => itemsCtrl.query.value = v,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Obx(() {
                      final cats = ['All', ...itemsCtrl.categories];
                      final sel = itemsCtrl.selectedCategory.value;
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: DropdownButton<String>(
                          value: sel.isEmpty ? 'All' : sel,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: TurfitColors.primaryLight,
                          ),
                          underline: const SizedBox(),
                          items: cats
                              .map(
                                (c) => DropdownMenuItem<String>(
                                  value: c,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (c != 'All') ...[
                                        CategoryIcons.getAnimatedCategoryIcon(
                                          c,
                                          size: 16,
                                          color: TurfitColors.primaryLight,
                                          animate: false,
                                        ),
                                        SizedBox(width: 1.w),
                                      ],
                                      Text(
                                        c,
                                        style: TextStyle(fontSize: 12.sp),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v == null || v == 'All') {
                              itemsCtrl.selectedCategory.value = '';
                            } else {
                              itemsCtrl.selectedCategory.value = v;
                            }
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: -0.2, duration: 500.ms),
              SizedBox(height: 2.h),
              Expanded(
                child: Obx(() {
                  final data = itemsCtrl.filteredItems;
                  if (data.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('🤷‍♀️', style: TextStyle(fontSize: 40.sp)),
                          SizedBox(height: 2.h),
                          Text(
                            'No items found!',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Add your own with the + button.',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.separated(
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
                            color: Colors.red[400],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                              Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        confirmDismiss: (_) async {
                          return await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Remove item?'),
                                  content: Text(
                                    'Delete "${it.name}" from your catalog?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              ) ??
                              false;
                        },
                        onDismissed: (_) async {
                          await itemsCtrl.deleteItem(it.id);
                          Get.snackbar('Deleted', 'Removed ${it.name}');
                        },
                        child:
                            Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: TurfitColors.primaryLight
                                            .withOpacity(0.08),
                                        offset: const Offset(0, 2),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 4.w,
                                      vertical: 1.h,
                                    ),
                                    leading: Container(
                                      padding: EdgeInsets.all(2.w),
                                      decoration: BoxDecoration(
                                        color: TurfitColors.primaryLight
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: hasIcon
                                          ? KidFriendlyIcons.getAnimatedIcon(
                                              it.iconName,
                                              size: 20.sp,
                                              color: TurfitColors.primaryLight,
                                              delay: Duration(
                                                milliseconds: index * 100,
                                              ),
                                            )
                                          : Icon(
                                              Icons.category,
                                              size: 20.sp,
                                              color: TurfitColors.primaryLight,
                                            ),
                                    ),
                                    title: Text(
                                      it.name,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Text(
                                      (it.description ?? '').isEmpty
                                          ? it.category
                                          : '${it.category} • ${it.description}',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      color: TurfitColors.primaryLight,
                                      size: 16.sp,
                                    ),
                                    onTap: () {
                                      selection.pickItemFull(
                                        it.name,
                                        iconName: it.iconName,
                                      );
                                      Get.toNamed(
                                        Routes.enterPrice,
                                        arguments: it.defaultPrice ?? 0,
                                      );
                                    },
                                  ),
                                )
                                .animate(
                                  delay: Duration(milliseconds: index * 50),
                                )
                                .fadeIn(duration: 300.ms)
                                .slideX(begin: 0.2, duration: 400.ms),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [TurfitColors.accentLight, Color(0xFFFFA726)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: TurfitColors.accentLight.withOpacity(0.4),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => Get.toNamed(Routes.addItem),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(Icons.add, color: Colors.white, size: 28.sp),
        ),
      ).animate().scale(delay: 800.ms, duration: 400.ms),
    );
  }
}
