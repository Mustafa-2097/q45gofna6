import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/widgets/global_form_layout.dart';

import 'package:q45gofna6/feature/customer_dashboard/inventory/controllers/inventory_controller.dart';
import 'package:q45gofna6/feature/customer_dashboard/inventory/models/inventory_item_model.dart';

class AddInventoryItemPage extends StatefulWidget {
  final InventoryItem? editItem;
  const AddInventoryItemPage({super.key, this.editItem});

  @override
  State<AddInventoryItemPage> createState() => _AddInventoryItemPageState();
}

class _AddInventoryItemPageState extends State<AddInventoryItemPage> {
  final nameController = TextEditingController();
  final costController = TextEditingController();
  final stockController = TextEditingController();
  final selectedImages = <XFile>[].obs;
  final InventoryController controller = Get.find<InventoryController>();
  final selectedCategories = <String>[].obs;

  @override
  void initState() {
    super.initState();
    final editItem = widget.editItem;
    if (editItem != null) {
      // Pre-fill the form
      nameController.text = editItem.name;
      costController.text = editItem.cost.toString();
      stockController.text = editItem.stock.toString();
      selectedCategories.assignAll(editItem.categories);
    } else if (controller.selectedCategory.value != 'All') {
      selectedCategories.add(controller.selectedCategory.value);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    costController.dispose();
    stockController.dispose();
    super.dispose();
  }

  void _saveItem() async {
    final name = nameController.text.trim();
    final costText = costController.text.trim();
    final stockText = stockController.text.trim();

    if (name.isEmpty || costText.isEmpty || stockText.isEmpty) {
      EasyLoading.showError('Please fill in all required fields');
      return;
    }

    final cost = double.tryParse(costText);
    final stock = int.tryParse(stockText);

    if (cost == null || stock == null) {
      EasyLoading.showError('Invalid cost or stock values');
      return;
    }

    if (selectedCategories.isEmpty) {
      EasyLoading.showError('Please select at least one category');
      return;
    }

    final categoryIds = selectedCategories.map((name) => controller.categoryMap[name]).whereType<String>().toList();
    if (categoryIds.isEmpty) {
      EasyLoading.showError('Category IDs not found. Please try adding them again.');
      return;
    }

    bool success;
    if (widget.editItem != null) {
      final editItem = widget.editItem!;
      
      // Check if anything has changed
      final isNameChanged = name != editItem.name;
      final isCostChanged = cost != editItem.cost;
      final isStockChanged = stock != editItem.stock;
      final isCategoryChanged = !setEquals(selectedCategories.toSet(), editItem.categories.toSet());
      final isImageChanged = selectedImages.isNotEmpty;

      if (!isNameChanged && !isCostChanged && !isStockChanged && !isCategoryChanged && !isImageChanged) {
        EasyLoading.showInfo('No changes made');
        Get.back();
        return;
      }

      success = await controller.updateInventoryItem(
        id: editItem.id,
        name: name,
        cost: cost,
        stock: stock,
        categoryIds: categoryIds,
        imagePaths: selectedImages.map((e) => e.path).toList(),
      );
    } else {
      success = await controller.createInventoryItem(
        name: name,
        cost: cost,
        stock: stock,
        categoryIds: categoryIds,
        imagePaths: selectedImages.map((e) => e.path).toList(),
      );
    }

    if (success) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlobalFormLayout(
      title: widget.editItem != null ? 'Edit Inventory Item' : 'Add Inventory Item',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.editItem != null ? 'Edit Item' : 'Add Item',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: 16.h),
          _buildInputField(
            label: 'Item Name*',
            hintText: 'Camera',
            controller: nameController,
          ),
          SizedBox(height: 16.h),
          _buildInputField(
            label: 'Replacement Cost*',
            hintText: '500\$',
            controller: costController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          SizedBox(height: 16.h),
          _buildInputField(
            label: 'Stock*',
            hintText: '15',
            controller: stockController,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16.h),
          _buildCategorySelection(),
          SizedBox(height: 24.h),
          Text(
            'Item Photo*',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.boxTextColor,
            ),
          ),
          SizedBox(height: 12.h),
          _buildPhotoUpload(),
        ],
      ),
      bottomButton: ElevatedButton(
        onPressed: _saveItem,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          elevation: 0,
        ),
        child: Text(
          'Save Item',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    TextEditingController? controller,
    String? subtitle,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.subTextColor,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: AppColors.textColor,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppColors.boxTextColor.withValues(alpha: 0.7),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.stockColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.stockColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.buttonColor),
            ),
          ),
        ),
        if (subtitle != null) ...[
          SizedBox(height: 8.h),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.boxTextColor,
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories*',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.subTextColor,
              ),
            ),
            GestureDetector(
              onTap: _showCategorySelectionSheet,
              child: Text(
                'Select Multiple',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.buttonColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Obx(() {
          if (selectedCategories.isEmpty) {
            return GestureDetector(
              onTap: _showCategorySelectionSheet,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.stockColor, width: 1),
                ),
                child: Text(
                  'Select Categories',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: AppColors.boxTextColor.withValues(alpha: 0.7),
                  ),
                ),
              ),
            );
          }
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.stockColor, width: 1),
            ),
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: selectedCategories.map((category) {
                return Chip(
                  label: Text(
                    category,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppColors.textColor,
                    ),
                  ),
                  backgroundColor: AppColors.stockColor.withValues(alpha: 0.3),
                  deleteIcon: Icon(Icons.close, size: 14.w),
                  onDeleted: () {
                    selectedCategories.remove(category);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    side: BorderSide.none,
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  void _showCategorySelectionSheet() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Categories',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Flexible(
              child: Obx(() {
                final availableCategories = controller.categories.where((c) => c != 'All').toList();
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: availableCategories.length,
                  itemBuilder: (context, index) {
                    final category = availableCategories[index];
                    return Obx(() {
                      final isSelected = selectedCategories.contains(category);
                      return CheckboxListTile(
                        title: Text(
                          category,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: AppColors.textColor,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        value: isSelected,
                        activeColor: AppColors.buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        onChanged: (bool? value) {
                          if (value == true) {
                            selectedCategories.add(category);
                          } else {
                            selectedCategories.remove(category);
                          }
                        },
                      );
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(
                  'Done',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showImageSourceActionSheet() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Image Source',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 20.h),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.buttonColor),
              title: Text('Gallery', style: GoogleFonts.inter(fontSize: 16.sp, color: AppColors.textColor)),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.buttonColor),
              title: Text('Camera', style: GoogleFonts.inter(fontSize: 16.sp, color: AppColors.textColor)),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    if (source == ImageSource.gallery) {
      final images = await picker.pickMultiImage();
      if (images.isNotEmpty) {
        selectedImages.addAll(images);
      }
    } else {
      final image = await picker.pickImage(source: source);
      if (image != null) {
        selectedImages.add(image);
      }
    }
  }

  Widget _buildPhotoUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final hasNewImages = selectedImages.isNotEmpty;
          final existingImageUrls = widget.editItem?.cleanedImageUrls ?? [];
          final hasExistingImages = existingImageUrls.isNotEmpty;
          final hasAnyImage = hasNewImages || hasExistingImages;

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.stockColor),
            ),
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasAnyImage)
                  SizedBox(
                    height: 100.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...existingImageUrls.map((url) => _buildImageThumbnail(url: url, isNetwork: true)),
                        ...selectedImages.map((file) => _buildImageThumbnail(url: file.path, isNetwork: false)),
                        _buildAddMoreButton(),
                      ],
                    ),
                  )
                else
                  InkWell(
                    onTap: _showImageSourceActionSheet,
                    child: Row(
                      children: [
                        Icon(Icons.center_focus_weak_outlined, color: AppColors.textColor, size: 24.w),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Upload / Capture Photos',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF6B9BF8),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Helps with visual identification during audits',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.boxTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildImageThumbnail({required String url, required bool isNetwork}) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      width: 100.w,
      height: 100.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        image: DecorationImage(
          image: isNetwork ? NetworkImage(url) : FileImage(File(url)) as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 4,
            top: 4,
            child: GestureDetector(
              onTap: () {
                if (isNetwork) {
                  // For now, we don't have a way to delete existing images from the backend here
                  // But we could hide them from the UI if needed
                } else {
                  selectedImages.removeWhere((element) => element.path == url);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white, size: 16.w),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMoreButton() {
    return GestureDetector(
      onTap: _showImageSourceActionSheet,
      child: Container(
        width: 100.w,
        height: 100.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.buttonColor.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, color: AppColors.buttonColor, size: 24.w),
            SizedBox(height: 4.h),
            Text(
              'Add More',
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                color: AppColors.buttonColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
