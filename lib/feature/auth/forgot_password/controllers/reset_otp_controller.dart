import 'dart:async';
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:q45gofna6/core/network/api_service.dart';
import '../views/pages/reset_password_page.dart';

class ResetOtpController extends GetxController {
  static ResetOtpController get instance => Get.find();

  /// OTP value
  var otp = "".obs;

  /// Timer countdown 50 seconds
  var secondsRemaining = 20.obs;
  Timer? _timer;

  /// Whether user can resend OTP
  var canResend = false.obs;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  /// Start 20-second countdown
  void startTimer() {
    secondsRemaining.value = 20;
    canResend.value = false;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  /// Validate OTP
  String? validateOtp() {
    if (otp.value.length < 4) return "Enter the 4-digit code";
    return null;
  }

  final String email = Get.arguments['email'] ?? '';

  /// Verify OTP
  Future<void> verifyOtp() async {
    final error = validateOtp();

    if (error != null) {
      EasyLoading.showError(error);
      return;
    }

    try {
      EasyLoading.show(status: 'Verifying OTP...');
      final response = await ApiService.verifyResetOtp(
        email: email,
        otp: otp.value,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = data['data']?['token'] ?? data['data']?['accessToken'] ?? data['token'] ?? "";
        EasyLoading.showSuccess('OTP Verified');
        Get.to(() => ResetPasswordPage(), arguments: {'email': email, 'token': token});
      } else {
        EasyLoading.showError(data['message'] ?? 'Verification failed');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// Resend OTP
  Future<void> resendOtp() async {
    if (!canResend.value) return;

    try {
      EasyLoading.show(status: "Sending new code...");
      final response = await ApiService.sendResetOtp(email: email);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess("New code sent");
        startTimer();
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
    _timer?.cancel();
    super.onClose();
  }
}
