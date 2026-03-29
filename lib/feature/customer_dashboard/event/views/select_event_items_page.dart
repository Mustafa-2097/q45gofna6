import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/widgets/primary_button.dart';
import '../../../../core/constant/widgets/item_card_widget.dart';
import '../controllers/event_controller.dart';
import '../../inventory/controllers/inventory_controller.dart';
import 'event_details_page.dart';

class SelectEventItemsPage extends StatefulWidget {
  const SelectEventItemsPage({super.key});

  @override
  State<SelectEventItemsPage> createState() => _SelectEventItemsPageState();
}

class _SelectEventItemsPageState extends State<SelectEventItemsPage> {
  final EventController controller = Get.find<EventController>();
  final InventoryController inventoryController = Get.find<InventoryController>();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Reset to page 1 and fresh load every time this page is visited
    inventoryController.fetchInventoryItems();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      inventoryController.fetchInventoryItems(isLoadMore: true);
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Obx(() => _buildSummaryCard()),
                    SizedBox(height: 16.h),
                    _buildSelectItemsHeader(),
                    SizedBox(height: 16.h),
                    _buildSearchBar(),
                    SizedBox(height: 16.h),
                    Obx(() => _buildCategories()),
                    SizedBox(height: 20.h),
                    Obx(() => _buildItemsGrid()),
                    SizedBox(height: 12.h),
                    Obx(() => _buildLoadMoreIndicator()),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: PrimaryButton(
                text: controller.editEventId != null ? "Update Event" : "Create Event",
                onPressed: () async {
                  if (controller.selectedItems.isEmpty) {
                    EasyLoading.showError('Please select at least one item');
                    return;
                  }
                  final event = await controller.createEvent();
                  if (event != null) {
                    Get.off(() => EventDetailsPage(event: event));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Row(
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                color: AppColors.textColor,
                size: 20.w,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            controller.editEventId != null ? 'Edit Event' : 'New Event',
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final selectedCount = controller.selectedItems.length;
    // Calculate total value based on selected items if possible
    double totalValue = 0;
    for (var id in controller.selectedItems) {
      final item = inventoryController.inventoryItems.firstWhereOrNull((i) => i.id == id);
      if (item != null) {
        totalValue += (item.cost * (controller.selectedItemQuantities[id] ?? 1));
      }
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF4579D6),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Items',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '$selectedCount',
                    style: GoogleFonts.inter(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 24.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Divider(color: Colors.white),
          SizedBox(height: 8.h),
          Text(
            'Total Kit Value',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '\$${totalValue.toStringAsFixed(2)}',
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectItemsHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Items',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 4.h),
              Obx(() => Text(
                '${inventoryController.inventoryItems.length} items available',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: AppColors.boxTextColor,
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey, size: 20.w),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              onChanged: (v) => inventoryController.updateSearch(v),
              decoration: InputDecoration(
                hintText: 'Search items...',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: inventoryController.categories.map((category) {
          final isSelected = inventoryController.selectedCategory.value == category;
          return GestureDetector(
            onTap: () => inventoryController.selectCategory(category),
            child: Container(
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.buttonColor : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
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
        }).toList(),
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    if (inventoryController.isMoreLoading.value) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (!inventoryController.hasMore.value && inventoryController.inventoryItems.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Center(
          child: Text(
            'No more items',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppColors.subTextColor,
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildItemsGrid() {
    final items = inventoryController.inventoryItems;
    if (inventoryController.isInventoryLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text('No items found'),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.w,
        crossAxisSpacing: 16.w,
        childAspectRatio: 0.75,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            controller.toggleItemSelection(item.id);
          },
          child: Obx(() {
            final isSelected = controller.selectedItems.contains(item.id);
            final currentQuantity = controller.selectedItemQuantities[item.id] ?? 1;
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isSelected ? AppColors.buttonColor : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Stack(
                children: [
                  ItemCardWidget(
                    name: item.name,
                    category: item.category,
                    price: '\$${item.cost}',
                    imageUrl: item.cleanedImageUrl,
                    stock: item.stock,
                    showQuantityControls: isSelected,
                    quantity: currentQuantity,
                    onIncrease: () => controller.increaseQuantity(item.id, item.stock),
                    onDecrease: () => controller.decreaseQuantity(item.id),
                  ),
                  if (isSelected)
                    Positioned(
                      top: 10.w,
                      right: 10.w,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: const BoxDecoration(
                          color: AppColors.buttonColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check, color: Colors.white, size: 16.w),
                      ),
                    ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
