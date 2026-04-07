import 'dart:io';
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
  XFile? selectedImage;
  final InventoryController controller = Get.find<InventoryController>();
  String? formCategory;

  @override
  void initState() {
    super.initState();
    final editItem = widget.editItem;
    if (editItem != null) {
      // Pre-fill the form
      nameController.text = editItem.name;
      costController.text = editItem.cost.toString();
      stockController.text = editItem.stock.toString();
      formCategory = editItem.category;
    } else if (controller.selectedCategory.value != 'All') {
      formCategory = controller.selectedCategory.value;
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

    final categoryName = formCategory;
    if (categoryName == null) {
      EasyLoading.showError('Please select a category');
      return;
    }

    final categoryId = controller.categoryMap[categoryName];
    if (categoryId == null) {
      EasyLoading.showError('Category ID not found. Please try adding it again.');
      return;
    }

    bool success;
    if (widget.editItem != null) {
      final editItem = widget.editItem!;
      
      // Check if anything has changed
      final isNameChanged = name != editItem.name;
      final isCostChanged = cost != editItem.cost;
      final isStockChanged = stock != editItem.stock;
      final isCategoryChanged = categoryName != editItem.category;
      final isImageChanged = selectedImage != null;

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
        categoryId: categoryId,
        imagePath: selectedImage?.path,
      );
    } else {
      success = await controller.createInventoryItem(
        name: name,
        cost: cost,
        stock: stock,
        categoryId: categoryId,
        imagePath: selectedImage?.path,
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
          _buildCategoryDropdown(controller),
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

  Widget _buildCategoryDropdown(InventoryController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category*',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.subTextColor,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(() {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.stockColor, width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: formCategory,
                hint: Text(
                  'Select Category',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: AppColors.boxTextColor.withValues(alpha: 0.7),
                  ),
                ),
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textColor,
                  size: 24.w,
                ),
                items: () {
                  final List<String> dropdownItems = controller.categories.where((c) => c != 'All').toList();
                  // Ensure current formCategory is in the list to avoid crash
                  if (formCategory != null && !dropdownItems.contains(formCategory)) {
                    dropdownItems.add(formCategory!);
                  }
                  return dropdownItems.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(
                        category,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppColors.textColor,
                        ),
                      ),
                    );
                  }).toList();
                }(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      formCategory = newValue;
                    });
                  }
                },
              ),
            ),
          );
        }),
      ],
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
    final image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  Widget _buildPhotoUpload() {
    final hasNewImage = selectedImage != null;
    final existingImageUrl = widget.editItem?.cleanedImageUrl;
    final hasExistingImage = existingImageUrl != null && existingImageUrl.isNotEmpty;
    final hasAnyImage = hasNewImage || hasExistingImage;

    return GestureDetector(
      onTap: _showImageSourceActionSheet,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.stockColor),
        ),
        padding: hasAnyImage ? EdgeInsets.symmetric(vertical: 16.h) : EdgeInsets.all(16.w),
        child: hasAnyImage
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 160.w,
                    height: 140.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      image: hasNewImage
                          ? DecorationImage(
                              image: FileImage(File(selectedImage!.path)),
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
                              image: NetworkImage(existingImageUrl!),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined, color: const Color(0xFF6B9BF8), size: 18.w),
                      SizedBox(width: 8.w),
                      Text(
                        'Change Photo',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6B9BF8),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                children: [
                  Icon(Icons.center_focus_weak_outlined, color: AppColors.textColor, size: 24.w),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Upload / Capture Photo',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF6B9BF8),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Helps with visual Identification during audits',
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
    );
  }
}
