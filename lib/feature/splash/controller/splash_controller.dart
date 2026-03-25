import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/offline_storage/shared_pref.dart';
import '../../onboarding/view/onboarding_screen.dart';
import '../../auth/login/views/login_page.dart';
import '../../customer_dashboard/dashboard/dashboard.dart';

class SplashController extends GetxController {
  static SplashController get instance => Get.find();

  @override
  void onInit() {
    super.onInit();
    _startSplash();
  }

  Future<void> _startSplash() async {
    await Future.delayed(const Duration(seconds: 3));

    try {
      final onboardingDone = await SharedPreferencesHelper.isOnboardingCompleted();
      final token = await SharedPreferencesHelper.getToken();
      debugPrint('Onboarding Completed: $onboardingDone');
      debugPrint('Token: $token');

      /// Run navigation after frame renders
      Future.microtask(() {
        if (!onboardingDone) {
          /// First launch → onboarding
          Get.offAll(() => OnboardingScreen());
        }
        else if (token == null || token.isEmpty) {
          /// Not logged in → login
          Get.offAll(() => LoginPage());
        }
        else {
          /// Logged in → dashboard
          Get.offAll(() => CustomerDashboard());
        }

      });

    } catch (e) {
      debugPrint('Error in splash logic: $e');

      /// Fallback navigation
      Future.microtask(() {
        Get.offAll(() => LoginPage());
      });

    }
  }
}
