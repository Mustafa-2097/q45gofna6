import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constant/app_colors.dart';
import '../controllers/event_controller.dart';
import 'event_details_page.dart';

class EventPage extends StatefulWidget {
  EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final controller = Get.find<EventController>();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      controller.fetchEvents(isLoadMore: true);
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchEvents();
          },
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Event',
                style: GoogleFonts.inter(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 16.h),
              _buildSearchBar(),
              SizedBox(height: 20.h),
              _buildStatsRow(),
              SizedBox(height: 20.h),
              _buildFilterTabs(),
              SizedBox(height: 20.h),
              _buildEventList(),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.calendar_today_outlined,
              iconColor: const Color(0xFF6B9BF8),
              iconBg: const Color(0xFFE8F0FE),
              count: '${controller.totalCount}',
              label: 'Total',
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard(
              icon: Icons.access_time,
              iconColor: Colors.green,
              iconBg: const Color(0xFFE8F5E9),
              count: '${controller.activeCount}',
              label: 'Active',
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard(
              icon: Icons.check_circle_outline,
              iconColor: const Color(0xFF757575),
              iconBg: const Color(0xFFF5F5F5),
              count: '${controller.doneCount}',
              label: 'Done',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String count,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 24.w),
          ),
          SizedBox(height: 12.h),
          Text(
            count,
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
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

  Widget _buildFilterTabs() {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          children: controller.tabs.map((tab) {
            final isSelected = controller.selectedTab.value == tab;
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.selectTab(tab),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.buttonColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Text(
                    tab,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.textColor,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return Obx(() {
      final events = controller.filteredEvents;
      if (events.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h),
            child: Column(
              children: [
                Icon(
                  Icons.event_busy,
                  size: 48.w,
                  color: AppColors.boxTextColor.withValues(alpha: 0.4),
                ),
                SizedBox(height: 16.h),
                Text(
                  'No events found',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.boxTextColor,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return Column(
        children: events.asMap().entries.map((entry) {
          final i = entry.key;
          final event = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: i < events.length - 1 ? 16.h : 0),
            child: InkWell(
              onTap: () => Get.to(() => EventDetailsPage(event: event)),
              child: _buildEventCard(event: event),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildEventCard({required EventModel event}) {
    final isActive = event.status == 'Active';
    final statusBg = isActive
        ? const Color(0xFF10B981)
        : const Color(0xFF303030).withValues(alpha: 0.8);
    final footerBg = event.hasIssue
        ? const Color(0xFFFDE8E8)
        : const Color(0xFFEEF2F9);
    final footerColor = event.hasIssue
        ? const Color(0xFFE93A56)
        : const Color(0xFF3876D6);
    final footerIcon = event.hasIssue ? Icons.error_outline : Icons.access_time;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Header
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: Image.network(
                  event.imageUrl,
                  height: 160.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 160.h,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    event.status,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14.w,
                      color: AppColors.boxTextColor,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      event.date,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: AppColors.boxTextColor,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Text(
                        '•',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: AppColors.boxTextColor,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 14.w,
                      color: AppColors.boxTextColor,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      event.items,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: AppColors.boxTextColor,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Text(
                        '•',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: AppColors.boxTextColor,
                        ),
                      ),
                    ),
                    Text(
                      event.price,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3876D6),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: footerBg,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(footerIcon, color: footerColor, size: 16.w),
                      SizedBox(width: 8.w),
                      Text(
                        event.footerText,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: footerColor,
                        ),
                      ),
                    ],
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
