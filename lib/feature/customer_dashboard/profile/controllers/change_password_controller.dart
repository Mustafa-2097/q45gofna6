import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:q45gofna6/core/network/api_service.dart';

class ChangePasswordController extends GetxController {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isCurrentPasswordHidden = true.obs;
  var isNewPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  var isLoading = false.obs;

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> changePassword() async {
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      EasyLoading.showError('Please fill all fields');
      return;
    }

    if (newPassword != confirmPassword) {
      EasyLoading.showError('New password and confirm password do not match');
      return;
    }

    isLoading.value = true;
    EasyLoading.show(status: 'Changing password...');
    try {
      final response = await ApiService.changePassword(
        oldPassword: currentPassword,
        newPassword: newPassword,
      );
      
      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) && data['success'] == true) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess(data['message'] ?? 'Password changed successfully!');
        Get.back(); // Navigate back on success
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(data['message'] ?? 'Failed to change password');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong. Please try again later.');
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }
}

