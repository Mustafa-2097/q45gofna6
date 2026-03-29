import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/widgets/item_card_widget.dart';
import '../controllers/inventory_controller.dart';
import '../models/inventory_item_model.dart';
import 'add_inventory_item_page.dart';
import 'widgets/add_category_dialog.dart';

class InventoryPage extends StatelessWidget {
  InventoryPage({super.key});
  final InventoryController controller = Get.find<InventoryController>();
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        controller.fetchInventoryItems(isLoadMore: true);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      floatingActionButton: SizedBox(
        width: 60.w,
        height: 60.w,
        child: FloatingActionButton(
          onPressed: () => Get.to(() => const AddInventoryItemPage()),
          backgroundColor: const Color(0xFF3876D6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 4,
          child: Icon(Icons.add, color: Colors.white, size: 30.w),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchCategories();
            await controller.fetchInventoryItems();
            await controller.fetchInventoryStatistics();
          },
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Master Inventory',
                    style: GoogleFonts.inter(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.dialog(
                        const AddCategoryDialog(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B4E9B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      minimumSize: Size.zero,
                      elevation: 0,
                    ),
                    child: Text(
                      'Add Category',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              _buildValueCard(),
              SizedBox(height: 24.h),
              Text(
                'Inventory',
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 16.h),
              _buildSearchBar(),
              SizedBox(height: 16.h),
              _buildCategories(),
              SizedBox(height: 20.h),
              _buildItemsGrid(),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildValueCard() {
    return Obx(() {
      final double totalValue = controller.totalCost.value;
      final int itemsCount = controller.totalItems.value;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: const Color(
            0xFF3876D6,
          ), // Matching the medium blue from the design
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Inventory Value',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '\$${totalValue.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  Icons.attach_money,
                  color: Colors.white,
                  size: 36.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Container(height: 1, color: Colors.white.withOpacity(0.3)),
          SizedBox(height: 16.h),
          RichText(
            text: TextSpan(
              text: '$itemsCount',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              children: [
                TextSpan(
                  text: ' total items (',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                TextSpan(
                  text: '${controller.totalStock.value}',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: ' in stock) across all categories',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    });
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        final hasText = controller.searchQuery.value.isNotEmpty;
        return TextField(
          controller: searchController,
          onChanged: controller.updateSearch,
          style: GoogleFonts.inter(fontSize: 14.sp, color: AppColors.textColor),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            suffixIcon: hasText
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      searchController.clear();
                      controller.updateSearch('');
                    },
                  )
                : null,
            hintText: 'Search inventory...',
            hintStyle: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCategories() {
    return Obx(() {
      final selected = controller.selectedCategory.value;
      return SizedBox(
        height: 36.h,
        child: ListView.separated(
          key: ValueKey(selected),
          scrollDirection: Axis.horizontal,
          itemCount: controller.categories.length,
          separatorBuilder: (context, index) => SizedBox(width: 8.w),
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            final isSelected = selected == category;
            return GestureDetector(
              onTap: () => controller.selectCategory(category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.buttonColor : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected ? AppColors.buttonColor : Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: AppColors.buttonColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    else
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      category,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textColor,
                      ),
                    ),
                    if (category != 'All') ...[
                      SizedBox(width: 4.w),
                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(minWidth: 100.w),
                        icon: Icon(
                          Icons.arrow_drop_down_outlined,
                          color: isSelected ? Colors.white : AppColors.textColor,
                          size: 24.w,
                        ),
                        onSelected: (value) async {
                          final categoryId = controller.categoryMap[category];
                          if (categoryId == null) return;

                          if (value == 'edit') {
                            _showEditCategoryDialog(context, categoryId, category);
                          } else if (value == 'delete') {
                            _showDeleteCategoryConfirm(context, categoryId, category);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            height: 36.h,
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 16.w, color: AppColors.textColor),
                                SizedBox(width: 8.w),
                                Text('Edit', style: GoogleFonts.inter(fontSize: 13.sp)),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            height: 36.h,
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 16.w, color: Colors.red),
                                SizedBox(width: 8.w),
                                Text('Delete', style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildItemsGrid() {
    return Obx(() {
      final displayItems = controller.inventoryItems;

      if (controller.isInventoryLoading.value && displayItems.isEmpty) {
        return Padding(
          padding: EdgeInsets.all(40.h),
          child: const Center(child: CircularProgressIndicator()),
        );
      }
      
      if (displayItems.isEmpty) {
        return Padding(
          padding: EdgeInsets.all(40.h),
          child: Center(
            child: Text(
              'No inventory items found for this category',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: AppColors.subTextColor,
              ),
            ),
          ),
        );
      }

      return Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
            ),
            itemCount: displayItems.length,
            itemBuilder: (context, index) {
              final item = displayItems[index];
              return _buildInventoryItem(context, item);
            },
          ),
          if (controller.isMoreLoading.value)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: const Center(child: CircularProgressIndicator()),
            ),
          if (!controller.hasMore.value && displayItems.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Center(
                child: Text(
                  'No more items',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.subTextColor,
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildInventoryItem(BuildContext context, InventoryItem item) {
    return ItemCardWidget(
      name: item.name,
      category: item.category,
      price: '\$${item.cost}',
      imageUrl: item.cleanedImageUrl,
      stock: item.stock,
      showQuantityControls: false,
      onEdit: () {
        Get.to(() => AddInventoryItemPage(editItem: item));
      },
      onDelete: () async {
        final confirmed = await Get.dialog<bool>(
          AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
            title: Text('Delete Item', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
            content: Text('Are you sure you want to delete "${item.name}"?',
                style: GoogleFonts.inter(fontSize: 14.sp)),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text('Cancel', style: GoogleFonts.inter(color: AppColors.boxTextColor)),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: Text('Delete', style: GoogleFonts.inter(color: AppColors.redColor, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        );
        if (confirmed == true) {
          controller.deleteInventoryItem(item.id);
        }
      },
    );
  }

  void _showEditCategoryDialog(BuildContext context, String id, String currentName) {
    final TextEditingController editController = TextEditingController(text: currentName);
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Category',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: editController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter category name',
                  hintStyle: GoogleFonts.inter(fontSize: 14.sp, color: AppColors.boxTextColor.withOpacity(0.5)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.stockColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.stockColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.buttonColor),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () async {
                    final newName = editController.text.trim();
                    if (newName.isEmpty) return;
                    
                    if (newName == currentName) {
                      Get.back(); // Just close dialog
                      EasyLoading.showInfo('No changes made');
                      return;
                    }

                    final success = await controller.updateCategory(id, newName);
                    if (success) Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    elevation: 0,
                  ),
                  child: Text('Save', style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteCategoryConfirm(BuildContext context, String id, String name) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text('Delete Category', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        content: Text('Are you sure you want to delete "$name"? This will affect all items in this category.',
          style: GoogleFonts.inter(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: GoogleFonts.inter(color: AppColors.boxTextColor)),
          ),
          TextButton(
            onPressed: () async {
              final success = await controller.deleteCategory(id);
              if (success) Get.back();
            },
            child: Text('Delete', style: GoogleFonts.inter(color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
