import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find();

  /// Text Controller
  final emailController = TextEditingController();


  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
