import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_text_styles.dart';
import '../controller/onboarding_controller.dart';

class OnboardingPages extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  OnboardingPages({super.key, required this.pageController, required this.currentPage});
  final controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        /// The blurred + gradient Figma rectangle
        Positioned(
          top: sh * 0.57,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Container(
                width: sw,
                height: sh * 0.51,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryColor.withOpacity(0.0),
                      AppColors.primaryColor.withOpacity(0.8),
                      AppColors.primaryColor,
                    ],
                    stops: const [0.0, 0.3, 0.65],
                  ),
                ),
                child: _textContent(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// =========TEXT + BUTTON SECTION=========
  Widget _textContent(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title + Description
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            controller.onboardingData[currentPage]['title']!,
            style: AppTextStyles.title32(context),
          ),
        ),
        SizedBox(height: sh * 0.01),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            controller.onboardingData[currentPage]['description']!,
            style: AppTextStyles.regular_16(context),
          ),
        ),

        SizedBox(height: sh * 0.02),

        /// Button
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: GestureDetector(
            onTap: controller.nextPage,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.buttonColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currentPage < controller.onboardingData.length - 1
                        ? "Next"
                        : "Get Started",
                    style: AppTextStyles.bold_18(context),
                  ),
                  const Icon(
                    Icons.keyboard_double_arrow_right_rounded,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: sh * 0.057),
      ],
    );
  }
}
