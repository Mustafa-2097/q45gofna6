import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  final isPremiumSelected = false.obs;

  void togglePlan(bool isPremium) {
    isPremiumSelected.value = isPremium;
  }
}
