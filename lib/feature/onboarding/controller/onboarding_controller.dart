import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q45gofna6/feature/onboarding/view/welcome_screen.dart';
import '../../../core/constant/image_path.dart';

class OnboardingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final PageController pageController = PageController();
  var currentPage = 0.obs;
  var showContent = false.obs;

  var backgroundFadeAnimation = 0.0.obs;
  var backgroundScaleAnimation = 1.2.obs;

  late AnimationController _animController;
  late Animation<double> _fade;
  late Animation<double> _scale;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Protect Your Event Assets with AI",
      "description": "Track, audit, and detect missing inventory instantly using smart AI-powered event analysis",
      "image": ImagePath.onboardingImg01,
    },
    {
      "title": "Smart Event Inventory, Zero Guesswork",
      "description": "Capture before and after photos. Let AI detect missing items and calculate losses automatically.",
      "image": ImagePath.onboardingImg02,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeIn));
    _scale = Tween<double>(
      begin: 1.2,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.addListener(() {
      backgroundFadeAnimation.value = _fade.value;
      backgroundScaleAnimation.value = _scale.value;
    });

    _startIntro();
  }

  void _startIntro() async {
    await Future.delayed(const Duration(milliseconds: 100));
    showContent.value = true;
    _animController.forward();
  }

  void changePage(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < onboardingData.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAll(() => const WelcomeScreen());
      debugPrint("End of onboarding");
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    _animController.dispose();
    super.onClose();
  }
}
