import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:q45gofna6/core/network/api_service.dart';
import '../views/pages/reset_otp_page.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find();

  /// Text Controller
  final emailController = TextEditingController();

  /// Validation
  String? validateEmail() {
    if (emailController.text.trim().isEmpty) return "Email is required";
    if (!GetUtils.isEmail(emailController.text.trim())) return "Enter a valid email";
    return null;
  }

  Future<void> sendOtp() async {
    final emailError = validateEmail();
    if (emailError != null) {
      EasyLoading.showError(emailError);
      return;
    }

    try {
      EasyLoading.show(status: 'Sending OTP...');
      final response = await ApiService.sendResetOtp(email: emailController.text.trim());
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess('OTP sent successfully');
        Get.to(() => ResetOtpPage(), arguments: {'email': emailController.text.trim()});
      } else {
        EasyLoading.showError(data['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
