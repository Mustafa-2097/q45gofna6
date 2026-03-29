import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q45gofna6/core/constant/app_text_styles.dart';
import '../../../../core/constant/app_colors.dart';
import '../controllers/home_controller.dart';
import '../../event/views/new_event_page.dart';
import '../../event/controllers/event_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchHomeData();
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => _buildHeader(context, controller.userName.value, controller.userAvatar.value)),
                SizedBox(height: 24.h),
                _buildActionCards(),
                SizedBox(height: 16.h),
                Obx(() => _buildMetricCard(
                  title: 'Active Events',
                  value: controller.isLoading.value ? '...' : '${controller.statistics.value?.activeEvents ?? 0}',
                  icon: Icons.calendar_today_outlined,
                  iconBgColor: AppColors.buttonColor,
                  iconColor: Colors.white,
                )),
                SizedBox(height: 12.h),
                Obx(() => _buildMetricCard(
                  title: 'Number of Props & Equipment Amount',
                  value: controller.isLoading.value ? '...' : '\$${controller.statistics.value?.totalAmount ?? 0}',
                  icon: Icons.attach_money,
                  iconBgColor: const Color(0xFF757575),
                  iconColor: Colors.white,
                )),
                SizedBox(height: 12.h),
                Obx(() => _buildMetricCard(
                  title: 'Total Loss',
                  value: controller.isLoading.value ? '...' : '\$${controller.statistics.value?.totalLoss ?? 0}',
                  icon: Icons.trending_down,
                  iconBgColor: const Color(0xFFE93A56),
                  iconColor: Colors.white,
                )),
                SizedBox(height: 16.h),
                _buildRecentEvents(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String userName, String userAvatar) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $userName 👋',
              style: AppTextStyles.title24(context),
            ),
            SizedBox(height: 2.h),
            Text(
              "Here's your inventory today",
              style: AppTextStyles.regular_16(context),
            ),
          ],
        ),
        Container(
          height: 35.h,
          width: 35.w,
          decoration: BoxDecoration(
            color: AppColors.stockColor,
            shape: BoxShape.circle,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: userAvatar.isNotEmpty
                ? Image.network(
                    userAvatar,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.person_outline, color: AppColors.buttonColor),
                  )
                : const Icon(Icons.person_outline, color: AppColors.buttonColor),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCards() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Get.find<EventController>().resetForm();
              Get.to(() => NewEventPage());
            },
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.buttonColor,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 24.w),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'New Event',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Create new audit',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.stockColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.buttonColor,
                    size: 24.w,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Inventory',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Manage items',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.boxTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.boxTextColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: iconColor, size: 24.w),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentEvents() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
                    'Recent Events',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '3 total events',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.boxTextColor,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      'View All',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.buttonColor,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12.w,
                      color: AppColors.buttonColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          _buildEventItem(
            icon: Icons.auto_awesome,
            iconBgColor: const Color(0xFFE8F5E9),
            iconColor: Colors.green,
            title: 'Corporate Conference',
            dateAndItems: 'Feb 15 • 4 items',
            status: 'Done',
            statusBgColor: const Color(0xFFF5F5F5),
            statusTextColor: AppColors.boxTextColor,
            trailingWidget: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 14.w),
                SizedBox(width: 4.w),
                Text(
                  '1',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          _buildEventItem(
            icon: Icons.calendar_today_outlined,
            iconBgColor: AppColors.stockColor,
            iconColor: AppColors.buttonColor,
            title: 'Product Launch Event',
            dateAndItems: 'Mar 5 • 5 items',
            status: 'Active',
            statusBgColor: const Color(0xFFE8F5E9),
            statusTextColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String dateAndItems,
    required String status,
    required Color statusBgColor,
    required Color statusTextColor,
    Widget? trailingWidget,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  dateAndItems,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.boxTextColor,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: statusTextColor,
                  ),
                ),
              ),
              if (trailingWidget != null) ...[
                SizedBox(height: 4.h),
                trailingWidget,
              ],
            ],
          ),
        ],
      ),
    );
  }
}
