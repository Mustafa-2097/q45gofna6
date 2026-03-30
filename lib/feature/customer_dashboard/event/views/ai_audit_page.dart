import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/widgets/common_image.dart';
import '../controllers/event_controller.dart';
import 'capture_before_image_page.dart';
import 'capture_after_image_page.dart';
import 'all_missing_item_page.dart';
import '../models/event_model.dart';

class AiAuditPage extends StatefulWidget {
  final String eventId;
  const AiAuditPage({super.key, required this.eventId});

  @override
  State<AiAuditPage> createState() => _AiAuditPageState();
}

class _AiAuditPageState extends State<AiAuditPage> {
  final EventController controller = Get.find<EventController>();

  @override
  void initState() {
    super.initState();
    // Refresh audits when entering the page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchEventAudits(widget.eventId);
    });
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
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchEventAudits(widget.eventId);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 16.h),
                      _buildAuditResults(),
                      SizedBox(height: 24.h),
                      _buildAuditProgress(),
                      SizedBox(height: 24.h),
                    ],
                  ),
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
          Text(
            'AI Audit',
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

  Widget _buildAuditResults() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // AI Audit Complete Banner
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F3EA),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: const Color(0xFF4CAF50),
                  size: 24.w,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Audit Complete',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                  Text(
                    'Results ready',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: AppColors.boxTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Stats — driven by real report data
          Obx(() {
            final report = controller.auditReport.value;
            final foundCount = report?.found ?? 0;
            final missingCount = report?.missing ?? 0;
            return Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2FBF5),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFFE8F3EA)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$foundCount',
                          style: GoogleFonts.inter(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF4CAF50),
                          ),
                        ),
                        Text(
                          'Items Found',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4CAF50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFFFEE2E2)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$missingCount',
                          style: GoogleFonts.inter(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.redColor,
                          ),
                        ),
                        Text(
                          'Missing',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.redColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
          // Missing Items Card — only shown when report has actual missing items
          Obx(() {
            final report = controller.auditReport.value;
            if (report == null || report.missings.isEmpty) {
              return const SizedBox.shrink();
            }
            final firstMissing = report.missings.first;
            final totalLoss = report.totalLoss;

            return Column(
              children: [
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: const Color(0xFFFEE2E2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: AppColors.redColor,
                                size: 20.w,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Missing Items',
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.redColor,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => Get.to(
                              () => AllMissingItemPage(eventId: widget.eventId),
                            ),
                            child: Text(
                              'See all',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          children: [
                            CommonImage(
                              imageUrl: firstMissing.image ?? '',
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
                                    firstMissing.name,
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                  Text(
                                    'Equipment',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      color: AppColors.boxTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '\$${firstMissing.cost.toStringAsFixed(0)}',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.redColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      const Divider(color: Color(0xFFFEE2E2)),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Loss:',
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                          Text(
                            '\$$totalLoss',
                            style: GoogleFonts.inter(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.redColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
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
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
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
          Obx(() {
            if (controller.isAudisLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.audits.isEmpty) {
              return Text(
                'No audits found.',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: AppColors.boxTextColor,
                ),
              );
            }
            return Column(
              children: controller.audits.map((audit) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: _buildAuditItemCard(audit: audit),
                );
              }).toList(),
            );
          }),
          SizedBox(height: 20.h),
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
            onPressed: () =>
                Get.to(() => CaptureBeforeImagePage(eventId: widget.eventId)),
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

  Widget _buildAuditItemCard({required AuditModel audit}) {
    final hasAfterCapture =
        audit.afterImage != null && audit.afterImage!.isNotEmpty;
    final canRunAudit = hasAfterCapture && !audit.checked;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            audit.title,
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
                    CommonImage(
                      imageUrl: audit.beforeImage ?? '',
                      height: 120.h,
                      borderRadius: 8.r,
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
                        ? CommonImage(
                            imageUrl: audit.afterImage!,
                            height: 120.h,
                            borderRadius: 8.r,
                          )
                        : GestureDetector(
                            onTap: () => Get.to(
                              () => CaptureAfterImagePage(
                                eventId: widget.eventId,
                                auditId: audit.id,
                                beforeImage: audit.beforeImage,
                              ),
                            ),
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
              onPressed: canRunAudit
                  ? () async {
                      await controller.runAiAudit(audit.id, widget.eventId);
                    }
                  : null,
              icon: Icon(Icons.auto_awesome, size: 18.w, color: Colors.white),
              label: Text(
                audit.checked ? 'Audit Done' : 'Run AI Audit',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColor,
                disabledBackgroundColor: const Color(0xFF82B0F8),
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
}
