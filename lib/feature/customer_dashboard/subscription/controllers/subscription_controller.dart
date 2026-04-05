import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:q45gofna6/core/network/api_service.dart';
import 'package:q45gofna6/feature/customer_dashboard/profile/controllers/profile_controller.dart';
import 'package:q45gofna6/feature/customer_dashboard/subscription/views/payment_webview_page.dart';
import '../models/subscription_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SubscriptionController extends GetxController {
  final isYearly = false.obs;
  final selectedPlanType = 'BASIC'.obs; // BASIC, PREMIUM, ULTRA
  final isPlansLoading = false.obs;
  final isUserSubLoading = false.obs;
  final plans = <SubscriptionPlan>[].obs;
  final userSubscription = Rxn<UserSubscription>();

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  Future<void> refreshData() async {
    await Future.wait([
      fetchSubscriptionPlans(),
      fetchUserSubscription(),
    ]);
  }

  Future<void> fetchUserSubscription() async {
    isUserSubLoading.value = true;
    try {
      final response = await ApiService.getSubscription();
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        userSubscription.value = UserSubscription.fromJson(data['data']);
      }
    } catch (e) {
      debugPrint('Error fetching user subscription: $e');
    } finally {
      isUserSubLoading.value = false;
    }
  }

  Future<void> fetchSubscriptionPlans() async {
    isPlansLoading.value = true;
    try {
      final response = await ApiService.getSubscriptionPlans();
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        final List list = data['data'] ?? [];
        plans.assignAll(list.map((e) => SubscriptionPlan.fromJson(e)).toList());
        
        // Match default selected type if possible
        if (plans.isNotEmpty && !plans.any((p) => p.type == selectedPlanType.value)) {
           selectedPlanType.value = plans.first.type;
        }
      }
    } catch (e) {
      debugPrint('Error fetching subscription plans: $e');
    } finally {
      isPlansLoading.value = false;
    }
  }

  void togglePeriod(bool yearly) {
    isYearly.value = yearly;
  }

  Future<void> subscribeToPlan(SubscriptionPlan plan) async {
    if (userSubscription.value?.plan?.id == plan.id) {
       Get.snackbar('Already Subscribed', 'You are already on this plan');
       return;
    }

    try {
      EasyLoading.show(status: 'Initializing checkout...');
      final response = await ApiService.createCheckoutSession(
        planId: plan.id,
        type: isYearly.value ? 'YEARLY' : 'MONTHLY',
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        final String? checkoutUrl = data['data']['url'];
        if (checkoutUrl != null) {
          EasyLoading.dismiss();
          Get.to(() => PaymentWebViewPage(
            url: checkoutUrl,
            onSuccess: () {
              refreshData();
              // Also refresh profile if visible
              try { Get.find<ProfileController>().fetchProfile(); } catch (_) {}
            },
          ));
        } else {
          EasyLoading.showError('Invalid checkout URL');
        }
      } else {
        EasyLoading.showError(data['message'] ?? 'Failed to create checkout session');
      }
    } catch (e) {
      debugPrint('Checkout error: $e');
      EasyLoading.showError('Something went wrong');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void selectPlanType(String type) {
    selectedPlanType.value = type;
  }
  
  SubscriptionPlan? get activePlan {
    return plans.firstWhereOrNull((p) => p.type == selectedPlanType.value) ?? (plans.isNotEmpty ? plans.first : null);
  }
}
