import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q45gofna6/feature/customer_dashboard/event/views/ai_audit_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constant/app_colors.dart';
import '../controllers/reports_controller.dart';
import '../models/reports_model.dart';

class ReportsPage extends StatelessWidget {
  ReportsPage({super.key});
  final controller = Get.put(ReportsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.fetchReports,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reports',
                  style: GoogleFonts.inter(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 20.h),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final data = controller.reportsData.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatsGrid(data?.statistics),
                      SizedBox(height: 20.h),
                      _buildRecentAuditReports(data),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(ReportsStatistics? stats) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.bar_chart_rounded,
                iconBg: AppColors.buttonColor,
                iconColor: Colors.white,
                label: 'Total Audits',
                value: '${stats?.totalAudits ?? 0}',
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildStatCard(
                icon: Icons.trending_down,
                iconBg: AppColors.redColor,
                iconColor: Colors.white,
                label: 'Total Loss',
                value: '\$${stats?.totalLoss ?? 0}',
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.attach_money,
                iconBg: const Color(0xFFFF9800),
                iconColor: Colors.white,
                label: 'Avg Loss',
                value: '\$${stats?.totalAverage ?? 0}',
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildStatCard(
                icon: Icons.check_circle_outline,
                iconBg: const Color(0xFF10B981),
                iconColor: Colors.white,
                label: 'Success Rate',
                value: '${stats?.successRate ?? 0}%',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: iconColor, size: 24.w),
          ),
          SizedBox(height: 12.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.boxTextColor,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
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

  Widget _buildRecentAuditReports(ReportsData? data) {
    final reports = data?.recentReports;
    final pdfUrl = data?.pdf;
    final int completedCount = reports?.length ?? 0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
                    'Recent Audit Reports',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '$completedCount completed audits',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.boxTextColor,
                    ),
                  ),
                ],
              ),
              if (pdfUrl != null && pdfUrl.isNotEmpty)
                OutlinedButton.icon(
                  onPressed: () async {
                    String cleanUrl = pdfUrl;
                    if (cleanUrl.contains('localhost')) {
                      cleanUrl = cleanUrl.replaceFirst(
                        'localhost:5000',
                        '206.162.244.189:5005',
                      );
                    } else if (cleanUrl.contains('127.0.0.1')) {
                      cleanUrl = cleanUrl.replaceFirst(
                        '127.0.0.1:5000',
                        '206.162.244.189:5005',
                      );
                    }
                    if (!cleanUrl.startsWith('http')) {
                      cleanUrl = cleanUrl.startsWith('/')
                          ? 'http://206.162.244.189:5005$cleanUrl'
                          : 'http://206.162.244.189:5005/$cleanUrl';
                    }
                    final Uri url = Uri.parse(cleanUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      Get.snackbar('Error', 'Could not open PDF file.'); // this should easyloading msg
                    }
                  },
                  icon: Icon(
                    Icons.download_outlined,
                    size: 16.w,
                    color: AppColors.boxTextColor,
                  ),
                  label: Text(
                    'PDF',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.boxTextColor,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: AppColors.boxTextColor.withValues(alpha: 0.3),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 20.h),
          if (reports == null || reports.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Center(
                child: Text(
                  'No recent audits',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: AppColors.boxTextColor,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reports.length,
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                return _buildAuditReportCard(reports[index]);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildAuditReportCard(RecentReport report) {
    String formattedDate = report.date ?? '';
    if (formattedDate.length > 10) {
      try {
        final d = DateTime.parse(formattedDate);
        formattedDate = '${d.day}/${d.month}/${d.year}';
      } catch (e) {
        // keep as is
      }
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8EDF5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE8E8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  color: AppColors.redColor,
                  size: 20.w,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.eventName ?? 'Unknown Event',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      formattedDate,
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
          SizedBox(height: 20.h),
          // Stats row 1
          Row(
            children: [
              Expanded(
                child: _buildReportStat(
                  label: 'Kit Items',
                  value: '${report.itemsCount ?? 0}',
                  valueColor: AppColors.textColor,
                ),
              ),
              Expanded(
                child: _buildReportStat(
                  label: 'Kit Value',
                  value: '\$${report.itemsValue ?? 0}',
                  valueColor: AppColors.textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(height: 1, color: const Color(0xFFEEEEEE)),
          SizedBox(height: 16.h),
          // Stats row 2
          Row(
            children: [
              Expanded(
                child: _buildReportStat(
                  label: 'Missing',
                  value: '${report.missingCount ?? 0}',
                  valueColor: AppColors.textColor,
                ),
              ),
              Expanded(
                child: _buildReportStat(
                  label: 'Loss',
                  value: '\$${report.missingValue ?? 0}',
                  valueColor: AppColors.redColor,
                ),
              ),
            ],
          ),
          if (report.missingItems != null &&
              report.missingItems!.isNotEmpty) ...[
            SizedBox(height: 20.h),
            // Missing items chip section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFDE8E8).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Missing Items:',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.redColor,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: report.missingItems!.map((m) {
                      String label = 'Unknown Item';
                      if (m is Map) {
                        label = m['name'] ?? 'Unknown Item';
                      } else if (m is String) {
                        label = m;
                      }
                      return _buildItemChip(label);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 16.h),
          // Action buttons
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () =>
                  Get.to(() => AiAuditPage(eventId: report.eventId ?? '')),
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 14.w,
                color: AppColors.buttonColor,
              ),
              label: Text(
                'View Details',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.buttonColor,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppColors.buttonColor.withValues(alpha: 0.3),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportStat({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.boxTextColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildItemChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textColor,
        ),
      ),
    );
  }
}
