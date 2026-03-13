import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q45gofna6/core/constant/widgets/primary_button.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/widgets/global_form_layout.dart';
import 'select_event_items_page.dart';

class NewEventPage extends StatelessWidget {
  const NewEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalFormLayout(
      title: 'New Event',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Event Details',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: 20.h),
          _buildInput(label: 'Event Date *', hintText: ''),
          SizedBox(height: 16.h),
          _buildInput(label: 'Event Name *', hintText: 'e.g., Conference 2026'),
          SizedBox(height: 16.h),
          _buildInput(label: 'Event Note *', hintText: ''),
          SizedBox(height: 16.h),
          _buildDropdown(label: 'Event Status*'),
          SizedBox(height: 16.h),
          Text(
            'Item Photo',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.subTextColor,
            ),
          ),
          SizedBox(height: 8.h),
          _buildPhotoUpload(),
        ],
      ),
      bottomButton: PrimaryButton(
        text: "Next",
        onPressed: () {
          Get.to(() => const SelectEventItemsPage());
        },
      ),
    );
  }

  Widget _buildInput({required String label, required String hintText}) {
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
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: AppColors.textColor,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppColors.boxTextColor.withOpacity(0.7),
            ),
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
      ],
    );
  }

  Widget _buildDropdown({required String label}) {
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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.stockColor, width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: null,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textColor,
                size: 24.w,
              ),
              onChanged: (String? newValue) {},
              items: const [],
            ),
          ),
        ),
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
                    color: const Color(0xFF6B9BF8),
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
