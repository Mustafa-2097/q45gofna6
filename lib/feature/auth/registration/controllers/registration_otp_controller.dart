import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:q45gofna6/core/network/api_service.dart';
import 'package:q45gofna6/feature/auth/login/views/login_page.dart';
import '../../../../core/constant/widgets/success_dialog.dart';

class RegistrationOtpController extends GetxController {
  var otp = "".obs;
  final String email = Get.arguments['email'] ?? '';

  Future<void> verifyOtp(BuildContext context) async {
    if (otp.value.length < 4) {
      EasyLoading.showError("Enter a valid 4-digit OTP");
      return;
    }

    try {
      EasyLoading.show(status: 'Verifying OTP...');
      final response = await ApiService.verifySignUpOtp(
        email: email,
        otp: otp.value,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        SuccessDialog.show(
          subtitle: "Your account is successfully created",
          context: context,
          onPressed: () => Get.offAll(() => LoginPage()),
        );
      } else {
        EasyLoading.showError(data['message'] ?? 'Verification failed');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> resendOtp() async {
    try {
      EasyLoading.show(status: 'Resending OTP...');
      final response = await ApiService.resendSignUpOtp(email: email);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess('OTP resent successfully');
      } else {
        EasyLoading.showError(data['message'] ?? 'Failed to resend OTP');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
