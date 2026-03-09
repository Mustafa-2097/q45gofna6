import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constant/app_colors.dart';

class AddInventoryItemPage extends StatelessWidget {
  const AddInventoryItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFEEF2F9,
      ), // Light blue background matching the design
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: Container(
          color: AppColors.primaryColor,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10.h,
            left: 20.w,
            right: 20.w,
            bottom: 15.h,
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () => Get.back(),
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.textColor,
                    size: 24.w,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Text(
                'Add Inventory Item',
                style: GoogleFonts.inter(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Item',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.boxTextColor,
              ),
            ),
            SizedBox(height: 16.h),
            _buildInputField(
              label: 'Item Name',
              hintText: 'Enter Name',
              subtitle: 'Identify the item clearly for tracing',
            ),
            SizedBox(height: 16.h),
            _buildInputField(
              label: 'Category',
              hintText: 'Select Category',
              subtitle: 'Example. Audio, Lighting, Stage, Other',
              suffixIcon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textColor,
                size: 24.w,
              ),
            ),
            SizedBox(height: 16.h),
            _buildInputField(
              label: 'Replacement Cost',
              hintText: 'Enter Amount',
              subtitle: 'For Internal Reference only',
            ),
            SizedBox(height: 24.h),
            Text(
              'Item Photo',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.boxTextColor,
              ),
            ),
            SizedBox(height: 16.h),
            _buildPhotoUpload(),
            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
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
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required String subtitle,
    Widget? suffixIcon,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.stockColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hintText,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: AppColors.boxTextColor.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                if (suffixIcon != null) suffixIcon,
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.boxTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoUpload() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
                    color: const Color(
                      0xFF6B9BF8,
                    ), // Light blue text matching design
                  ),
                ),
                SizedBox(height: 6.h),
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
    );
  }
}
