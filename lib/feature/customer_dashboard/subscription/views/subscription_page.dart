import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q45gofna6/core/constant/app_colors.dart';
import '../models/subscription_model.dart';
import '../controllers/subscription_controller.dart';

class SubscriptionPage extends StatelessWidget {
  SubscriptionPage({super.key});

  final SubscriptionController controller = Get.put(SubscriptionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPricingBadge(),
              SizedBox(height: 24.h),
              _buildTitleAndSubtitle(),
              SizedBox(height: 32.h),
              _buildFeatureIcons(),
              SizedBox(height: 48.h),
              _buildToggle(context),
              SizedBox(height: 32.h),
              Obx(() {
                if (controller.isPlansLoading.value && controller.plans.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: const CircularProgressIndicator(color: Colors.white),
                    ),
                  );
                }
                if (controller.plans.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: Text(
                        'No subscription plans available.',
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                    ),
                  );
                }
                return Column(
                  children: controller.plans.map((plan) => Padding(
                    padding: EdgeInsets.only(bottom: 32.h),
                    child: _buildPricingCard(context, plan),
                  )).toList(),
                );
              }),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPricingBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        'Pricing Plans',
        style: GoogleFonts.inter(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textColor,
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle() {
    return Text(
      'Access Premium Features on\nEvery Plan',
      style: GoogleFonts.inter(
        fontSize: 18.sp,
        fontWeight: FontWeight.w400,
        color: Colors.white,
        height: 1.4,
      ),
    );
  }

  Widget _buildFeatureIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildFeatureIconItem(
          icon: Icons.camera_alt,
          title: 'Capture After\nEvent Photo',
        ),
        _buildFeatureIconItem(
          icon: Icons.flashlight_on,
          title: 'Detect Missing\nItems',
        ),
        _buildFeatureIconItem(
          icon: Icons.trending_down,
          title: 'Calculate Total\nLoss Value',
        ),
      ],
    );
  }

  Widget _buildFeatureIconItem({
    required IconData icon,
    required String title,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 40.w,
              width: 40.w,
              decoration: BoxDecoration(
                color: const Color(0xFFD6E4FF),
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    AppColors.buttonColor.withOpacity(0.5),
                  ],
                ),
              ),
              child: Icon(icon, color: Colors.white, size: 20.w),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.boxTextColor,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(BuildContext context) {
    return Center(
      child: Container(
        height: 48.h,
        width: 260.w,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Obx(() {
          final isYearly = controller.isYearly.value;
          return Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.togglePeriod(false),
                  child: Container(
                    decoration: BoxDecoration(
                      color: !isYearly ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Monthly',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: !isYearly ? AppColors.textColor : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.togglePeriod(true),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isYearly ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Yearly',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isYearly ? AppColors.textColor : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildPricingCard(BuildContext context, SubscriptionPlan plan) {
    return Obx(() {
      final isYearly = controller.isYearly.value;
      final price = isYearly ? plan.priceYearly : plan.priceMonthly;
      final duration = isYearly ? 'yearly' : 'month';

      return Stack(
        children: [
          // Background large container for features
          Container(
            margin: EdgeInsets.only(top: 80.h),
            padding: EdgeInsets.only(
              top: 140.h,
              left: 24.w,
              right: 24.w,
              bottom: 24.h,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE4EBFF),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeatureList('Capture unlimited photos'),
                _buildFeatureList('Inventory limit: ${plan.maxItems ?? 'Unlimited'} items'),
                if (plan.features.isEmpty)
                  _buildFeatureList('Advanced audit reporting'),
                ...plan.features.map((feature) => _buildFeatureList(feature)).toList(),
              ],
            ),
          ),
          if (controller.userSubscription.value?.plan?.type == plan.type)
            Positioned(
              top: 70.h,
              right: 24.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Current Plan',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          // Solid white pricing card
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12.w),
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        plan.title,
                        style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                      if (isYearly && plan.yearlyOff > 0)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            '${plan.yearlyOff}% OFF',
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Perfect for ${plan.title.toLowerCase()} needs.',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.boxTextColor,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor,
                          height: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 6.h, left: 4.w),
                        child: Text(
                          '/$duration',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          if (controller.userSubscription.value?.plan?.type != plan.type) {
                            controller.subscribeToPlan(plan);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: controller.userSubscription.value?.plan?.type == plan.type 
                                ? Colors.grey 
                                : AppColors.buttonColor,
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: Text(
                            controller.userSubscription.value?.plan?.type == plan.type 
                                ? 'Current Plan' 
                                : 'Get Started',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Instant activation',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.boxTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildFeatureList(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Container(
              height: 6.w,
              width: 6.w,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.boxTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
