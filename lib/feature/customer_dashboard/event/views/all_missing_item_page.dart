import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/widgets/common_image.dart';

class AllMissingItemPage extends StatefulWidget {
  final String eventId;
  const AllMissingItemPage({super.key, required this.eventId});

  @override
  State<AllMissingItemPage> createState() => _AllMissingItemPageState();
}

class _AllMissingItemPageState extends State<AllMissingItemPage> {
  final List<bool> _checkedItems = [true, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Audit Progress',
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E7FF).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        'If found, mark it as Found.',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Expanded(
                      child: ListView.separated(
                        itemCount: 4,
                        separatorBuilder: (context, index) => SizedBox(height: 20.h),
                        itemBuilder: (context, index) {
                          return _buildMissingItemRow(index);
                        },
                      ),
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
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          elevation: 0,
                        ),
                        child: Text(
                          'Add Found',
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
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildMissingItemRow(int index) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _checkedItems[index] = !_checkedItems[index];
            });
          },
          child: Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.textColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: _checkedItems[index]
                ? Icon(
                    Icons.check,
                    size: 18.w,
                    color: AppColors.textColor,
                  )
                : null,
          ),
        ),
        SizedBox(width: 12.w),
        CommonImage(
          imageUrl: 'https://images.unsplash.com/photo-1598653222000-6b7b7a552625?q=80&w=800&auto=format&fit=crop',
          width: 50.w,
          height: 50.w,
          borderRadius: 12.r,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wireless Microphone',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
              Text(
                'Audio',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: AppColors.boxTextColor,
                ),
              ),
            ],
          ),
        ),
        Text(
          '\$450',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.redColor,
          ),
        ),
      ],
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
            'All Missing Item',
            style: GoogleFonts.inter(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
