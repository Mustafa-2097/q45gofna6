import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:q45gofna6/core/constant/widgets/success_dialog.dart';
import 'package:q45gofna6/core/network/api_endpoints.dart';
import 'package:q45gofna6/core/network/api_service.dart';
import '../../login/views/login_page.dart';

class ResetPasswordController extends GetxController {
  static ResetPasswordController get instance => Get.find();

  final resetPasswordFormKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  late final String token;
  late final String email;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      token = Get.arguments['token'] ?? "";
      email = Get.arguments['email'] ?? "";
    } else {
      token = "";
      email = "";
    }
  }

  void resetPassword(BuildContext context) async {
    // Basic validation first
    if (passwordController.text.trim().isEmpty) {
      EasyLoading.showError("Password is required");
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      EasyLoading.showError("Passwords do not match");
      return;
    }

    EasyLoading.show(status: 'Resetting password...');

    try {
      final body = {"token": token, "password": passwordController.text.trim()};

      final response = await ApiService.post(
        ApiEndpoints.resetPassword,
        body,
      );

      final data = jsonDecode(response.body);
      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        SuccessDialog.show(
          subtitle: "Your password is successfully reset",
          onPressed: () => Get.offAll(() => LoginPage()), 
          context: context,
        );
      } else {
        EasyLoading.showError(data['message'] ?? 'Failed to reset password');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('An error occurred: $e');
    }
  }


}
