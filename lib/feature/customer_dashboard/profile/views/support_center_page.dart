import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q45gofna6/core/constant/app_colors.dart';

class SupportCenterPage extends StatelessWidget {
  const SupportCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 48.w, // Made the circle bigger
              height: 48.w,
              decoration: const BoxDecoration(
                color: AppColors.whiteColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back, color: AppColors.textColor, size: 20.sp),
            ),
          ),
        ),
        title: Text(
          'Support Center',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              _buildFAQTile('Lorem ipsum dolor sit amet', isExpanded: false),
              _buildDivider(),
              _buildFAQTile('Lorem ipsum dolor sit amet', isExpanded: false),
              _buildDivider(),
              _buildFAQTile(
                'Lorem ipsum dolor sit amet',
                isExpanded: true,
                content:
                    'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.',
              ),
              _buildDivider(),
              _buildFAQTile('Lorem ipsum dolor sit amet', isExpanded: false),
              _buildDivider(),
              _buildFAQTile('Lorem ipsum dolor sit amet', isExpanded: false),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQTile(
    String title, {
    bool isExpanded = false,
    String? content,
  }) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: isExpanded,
        tilePadding: EdgeInsets.zero,
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: isExpanded ? FontWeight.w700 : FontWeight.w500,
            color: isExpanded ? const Color(0xFF063D8F) : AppColors.textColor,
          ),
        ),
        trailing: Icon(
          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: isExpanded ? const Color(0xFF063D8F) : AppColors.textColor,
        ),
        children: [
          if (content != null)
            Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Text(
                content,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.subTextColor,
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: AppColors.textColor.withOpacity(0.2), height: 1);
  }
}
