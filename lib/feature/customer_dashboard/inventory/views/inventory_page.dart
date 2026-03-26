import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  @override
  Widget build(BuildContext context) {
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
                padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                child: Text(
                  category,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textColor,
                  ),
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
      final selectedCategory = controller.selectedCategory.value;
      
      final query = controller.searchQuery.value;

      final displayItems = controller.inventoryItems.where((item) {
        final matchesCategory = selectedCategory == 'All' ||
            item.category.toLowerCase() == selectedCategory.toLowerCase();
        final matchesSearch = query.isEmpty ||
            item.name.toLowerCase().contains(query) ||
            item.category.toLowerCase().contains(query);
        return matchesCategory && matchesSearch;
      }).toList();

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

      return GridView.builder(
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
}
