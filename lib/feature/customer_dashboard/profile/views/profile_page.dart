import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:q45gofna6/core/constant/widgets/logout_button.dart';
import 'package:q45gofna6/feature/customer_dashboard/subscription/views/subscription_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q45gofna6/core/constant/app_colors.dart';
import 'package:q45gofna6/core/constant/app_text_styles.dart';
import 'package:q45gofna6/feature/customer_dashboard/profile/views/change_password_page.dart';
import 'package:q45gofna6/feature/customer_dashboard/profile/views/privacy_policy_page.dart';
import 'package:q45gofna6/feature/customer_dashboard/profile/views/support_center_page.dart';
import 'package:q45gofna6/feature/customer_dashboard/profile/controllers/profile_controller.dart';
import 'package:q45gofna6/feature/customer_dashboard/profile/views/profile_update_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text(
                    'Profile',
                    style: AppTextStyles.title32(
                      context,
                    ).copyWith(color: AppColors.textColor),
                  ),
                  SizedBox(height: 24.h),
                  Obx(() {
                    if (controller.isLoading.value) {
                       return _buildProfileShimmer();
                    }
                    final userModel = controller.userProfile.value;
                    return _buildProfileInformationCard(context, controller, userModel?.profile.name ?? ' ', userModel?.email ?? ' ', userModel?.profile.companyName ?? ' ');
                  }),
                  SizedBox(height: 16.h),
                  Obx(() {
                    if (controller.isSubscriptionLoading.value) {
                       return _buildSubscriptionShimmer();
                    }
                    return _buildSubscriptionCard(context);
                  }),
                  SizedBox(height: 24.h),
                  _buildActionRow(
                    Icons.shield_outlined,
                    'Change Password',
                    context,
                    onTap: () => Get.to(() => ChangePasswordPage()),
                  ),
                  _buildActionRow(
                    Icons.help_outline,
                    'Support Center',
                    context,
                    onTap: () => Get.to(() => const SupportCenterPage()),
                  ),
                  _buildActionRow(
                    Icons.lock_outline,
                    'Privacy & Policy',
                    context,
                    onTap: () => Get.to(() => const PrivacyPolicyPage()),
                  ),
                LogoutButton(),
                SizedBox(height: 32.h),
              ],
            ),
          ),
      ),
    );
  }

  Widget _buildProfileShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: Colors.grey[200]!,
      child: Container(
        height: 100.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }

  Widget _buildSubscriptionShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: Colors.grey[200]!,
      child: Container(
        height: 180.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }

  Widget _buildProfileInformationCard(BuildContext context, ProfileController controller, String name, String email, String company) {
    return Container(
      padding: EdgeInsets.all(20.w),
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
              Row(
                children: [
                  Container(
                    height: 40.w,
                    width: 40.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B7ED5),
                      shape: BoxShape.circle,
                      image: controller.userProfile.value?.profile.cleanedAvatarUrl != null && controller.userProfile.value!.profile.cleanedAvatarUrl.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(controller.userProfile.value!.profile.cleanedAvatarUrl),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: (controller.userProfile.value?.profile.cleanedAvatarUrl == null || controller.userProfile.value!.profile.cleanedAvatarUrl.isEmpty)
                        ? Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: 24.w,
                          )
                        : null,
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        email,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.boxTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Get.to(() => const ProfileUpdatePage()),
                icon: Icon(
                  Icons.edit_outlined,
                  color: AppColors.textColor,
                  size: 24.w,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final subscription = controller.userProfile.value?.subscription;
    final plan = subscription?.plan;
    final isActive = subscription?.isActive ?? false;

    if (!isActive) {
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 40.w,
                  width: 40.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6EBE7A),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.credit_card, color: Colors.white, size: 20.w),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subscription',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'No active plan',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.boxTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await Get.to(() => SubscriptionPage());
                  // Refresh profile data when returning from subscription page
                  controller.fetchProfile();
                  controller.fetchOnlySubscription();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text('Get Subscription', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 40.w,
                width: 40.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF6EBE7A),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.credit_card, color: Colors.white, size: 20.w),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subscription',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Manage plan & billing',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.boxTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFF3B7ED5),
              borderRadius: BorderRadius.circular(12.r),
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
                          'Current Plan',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          plan?.title ?? 'Pro Plan',
                          style: GoogleFonts.inter(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 40.w,
                      width: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 20.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Audits',
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              plan?.maxItems == null ? 'Unlimited' : 'Up to ${plan!.maxItems}',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Billing Cycle',
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              subscription?.type ?? 'N/A',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Divider(color: Colors.white.withOpacity(0.3), height: 1),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Next billing date',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          subscription?.endDate != null 
                              ? "${subscription!.endDate.day}/${subscription.endDate.month}/${subscription.endDate.year}"
                              : 'April 2, 2026',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => _showCancelDialog(context, controller),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.to(() => SubscriptionPage()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5F5F5),
                foregroundColor: AppColors.textColor,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Manage Subscription',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.chevron_right,
                    size: 20.w,
                    color: AppColors.textColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, ProfileController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        contentPadding: EdgeInsets.all(24.w),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are You Sure You Want To\nCancel Subscription?',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  controller.cancelSubscription();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00388D), // Dark blue from screenshot
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text('Yes', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00388D), // Dark blue from screenshot
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text('No', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionRow(
    IconData icon,
    String title,
    BuildContext context, {
    Color? color,
    bool isLogout = false,
    VoidCallback? onTap,
  }) {
    final itemColor = color ?? AppColors.subTextColor;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
        child: Row(
          children: [
            Icon(
              isLogout ? Icons.logout_outlined : icon,
              color: itemColor,
              size: 24.w,
            ),
            SizedBox(width: 16.w),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: itemColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
