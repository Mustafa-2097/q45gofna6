import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q45gofna6/core/constant/widgets/primary_button.dart';

import '../../../../core/constant/app_colors.dart';
import '../controllers/event_controller.dart';
import 'new_event_page.dart';
import 'add_kit_page.dart';
import 'capture_before_image_page.dart';
import 'capture_after_image_page.dart';
import 'ai_audit_page.dart';

class EventDetailsPage extends StatelessWidget {
  final EventModel event;
  const EventDetailsPage({super.key, required this.event});

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
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    _buildSummaryCard(),
                    SizedBox(height: 20.h),
                    _buildAuditProgress(),
                    SizedBox(height: 20.h),
                    //_buildEventKit(),
                    // edit event section method will be here

                    SizedBox(height: 20.h),
                    PrimaryButton(text: "Mark as Complete", onPressed: () {}),
                    SizedBox(height: 20.h),
                  ],
                ),
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
          Expanded(
            child: Text(
              event.title,
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            onTap: () {
              final controller = Get.find<EventController>();
              controller.setEditEvent(event);
              Get.to(() => NewEventPage());
            },
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.buttonColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.edit,
                color: AppColors.buttonColor,
                size: 20.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
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
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.white.withOpacity(0.8),
                        size: 14.w,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Event Date',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    event.date.split('T')[0],
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        color: Colors.white.withOpacity(0.8),
                        size: 14.w,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Kit Items',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    event.items,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10.w), // Space filler
            ],
          ),
          SizedBox(height: 22.h),
          Row(
            children: [
              Icon(
                Icons.attach_money,
                color: Colors.white.withOpacity(0.8),
                size: 14.w,
              ),
              SizedBox(width: 4.w),
              Text(
                'Total Kit Value',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            event.price,
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

  Widget _buildAuditProgress() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
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
          _buildCaptureBaselineCard(),
          SizedBox(height: 20.h),
          _buildAuditItemCard(
            title: 'Tittle',
            hasAfterCapture: true,
          ),
          SizedBox(height: 16.h),
          _buildAuditItemCard(
            title: 'Tittle',
            hasAfterCapture: false,
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.to(() => const AiAuditPage()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                elevation: 0,
              ),
              child: Text(
                'View all',
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
    );
  }

  Widget _buildCaptureBaselineCard() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFA),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.camera_alt_outlined,
              color: const Color(0xFF64748B),
              size: 24.w,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Capture Baseline',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                Text(
                  'Photo before event',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.boxTextColor,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.to(() => const CaptureBeforeImagePage()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              elevation: 0,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Capture',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditItemCard({
    required String title,
    required bool hasAfterCapture,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1598653222000-6b7b7a552625?q=80&w=800&auto=format&fit=crop',
                        height: 120.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Before Capture',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: AppColors.boxTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  children: [
                    hasAfterCapture
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.network(
                              'https://images.unsplash.com/photo-1598653222000-6b7b7a552625?q=80&w=800&auto=format&fit=crop',
                              height: 120.h,
                              fit: BoxFit.cover,
                            ),
                          )
                        : GestureDetector(
                            onTap: () => Get.to(() => const CaptureAfterImagePage()),
                            child: Container(
                              height: 120.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0E7FF),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: const Color(0xFF6366F1),
                                  size: 32.w,
                                ),
                              ),
                            ),
                          ),
                    SizedBox(height: 8.h),
                    Text(
                      'After Capture',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: AppColors.boxTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Get.to(() => const AiAuditPage()),
              icon: Icon(Icons.auto_awesome, size: 18.w, color: Colors.white),
              label: Text(
                'Run AI Audit',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: hasAfterCapture ? AppColors.buttonColor : const Color(0xFF82B0F8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }


  // Widget _buildEventKit() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16.r),
  //     ),
  //     padding: EdgeInsets.all(16.w),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               'Event Kit (1 items)',
  //               style: GoogleFonts.inter(
  //                 fontSize: 16.sp,
  //                 fontWeight: FontWeight.w700,
  //                 color: AppColors.textColor,
  //               ),
  //             ),
  //             GestureDetector(
  //               onTap: () {
  //                 Get.to(() => const AddKitPage());
  //               },
  //               child: Container(
  //                 padding: EdgeInsets.all(8.w),
  //                 decoration: BoxDecoration(
  //                   color: AppColors.buttonColor,
  //                   borderRadius: BorderRadius.circular(12.r),
  //                 ),
  //                 child: Icon(Icons.add, color: Colors.white, size: 20.w),
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 16.h),
  //         GridView.count(
  //           crossAxisCount: 2,
  //           shrinkWrap: true,
  //           physics: const NeverScrollableScrollPhysics(),
  //           mainAxisSpacing: 16.w,
  //           crossAxisSpacing: 16.w,
  //           childAspectRatio: 0.75,
  //           children: [
  //             _buildItemCard(
  //               name: 'Wireless Microphone',
  //               category: 'Audio',
  //               price: '\$450',
  //               imageUrl:
  //                   'https://images.unsplash.com/photo-1598653222000-6b7b7a552625?q=80&w=800&auto=format&fit=crop',
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildItemCard({
    required String name,
    required String category,
    required String price,
    required String imageUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3DB),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  category,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: AppColors.boxTextColor,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  price,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2E61E6),
                  ),
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
