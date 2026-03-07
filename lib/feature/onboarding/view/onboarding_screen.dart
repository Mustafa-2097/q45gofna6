import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/image_path.dart';
import 'onboarding_pages.dart';
import '../controller/onboarding_controller.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  OnboardingScreen({super.key});
  final onboardingController = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Obx(() {
        if (!controller.showContent.value) {
          return const SizedBox.shrink();
        }

        final bgImage = controller.currentPage.value == 0
            ? ImagePath.onboardingImg01
            : ImagePath.onboardingImg02;

        return Stack(
          children: [
            Opacity(
              opacity: controller.backgroundFadeAnimation.value,
              child: Transform.scale(
                scale: controller.backgroundScaleAnimation.value,
                child: Container(
                  height: sh,
                  width: sw,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(bgImage),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),

            PageView.builder(
              controller: controller.pageController,
              itemCount: controller.onboardingData.length,
              onPageChanged: controller.changePage,
              itemBuilder: (context, index) {
                return OnboardingPages(
                  pageController: controller.pageController,
                  currentPage: controller.currentPage.value,
                );
              },
            ),
          ],
        );
      }),
    );
  }
}
