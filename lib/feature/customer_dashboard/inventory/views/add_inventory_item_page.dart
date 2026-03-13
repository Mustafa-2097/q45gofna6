import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/widgets/global_form_layout.dart';

import 'package:q45gofna6/feature/customer_dashboard/inventory/controllers/inventory_controller.dart';
import 'package:q45gofna6/feature/customer_dashboard/inventory/views/widgets/add_category_dialog.dart';

class AddInventoryItemPage extends StatelessWidget {
  const AddInventoryItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    final InventoryController controller = Get.find<InventoryController>();
    return GlobalFormLayout(
      title: 'Add Inventory Item',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Item',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: 16.h),
          _buildInputField(
            label: 'Item name*',
            hintText: 'Camera',
          ),
          SizedBox(height: 16.h),
          _buildInputField(
            label: 'Replacement Cost*',
            hintText: '500\$',
          ),
          SizedBox(height: 16.h),
          _buildInputField(
            label: 'Stock*',
            hintText: '15',
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16.h),
          _buildCategoryDropdown(controller),
          SizedBox(height: 24.h),
          Text(
            'Item Photo',
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
        onPressed: () => Get.back(),
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
              value: controller.selectedCategory.value,
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
                items: [
                  ...controller.categories.map((String category) {
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
                  }),
                  DropdownMenuItem<String>(
                    value: 'ADD_NEW_CATEGORY',
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B4E9B),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Add',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(Icons.add_circle_outline, color: Colors.white, size: 16.w),
                        ],
                      ),
                    ),
                  ),
                ],
                onChanged: (String? newValue) {
                  if (newValue == 'ADD_NEW_CATEGORY') {
                    Get.dialog(
                      const AddCategoryDialog(),
                    );
                  } else if (newValue != null) {
                    controller.selectCategory(newValue);
                  }
                },
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPhotoUpload() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.stockColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Icon(
              Icons.filter_center_focus_outlined,
              color: AppColors.textColor,
              size: 24.w,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload / Capture Photo',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6B9BF8), // Light blue text matching design
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Helps with visual Identification\nduring audits',
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
    );
  }
}
