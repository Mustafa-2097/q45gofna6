import 'dart:convert';
import 'package:get/get.dart';
import 'package:q45gofna6/core/network/api_service.dart';
import 'package:q45gofna6/feature/customer_dashboard/profile/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var userProfile = Rxn<ProfileModel>();

  final nameController = TextEditingController();
  final companyController = TextEditingController();
  var selectedImagePath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    companyController.dispose();
    super.onClose();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final response = await ApiService.getProfile();
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        userProfile.value = ProfileModel.fromJson(data['data']);
        nameController.text = userProfile.value?.profile.name ?? '';
        companyController.text = userProfile.value?.profile.companyName ?? '';
      } else {
        Get.snackbar(
          'Error',
          data['message'] ?? 'Failed to load profile',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again later.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    if (isLoading.value) return;

    // Check if anything has changed
    final currentName = userProfile.value?.profile.name ?? '';
    final currentCompany = userProfile.value?.profile.companyName ?? '';
    final isImageChanged = selectedImagePath.value.isNotEmpty;

    if (nameController.text == currentName &&
        companyController.text == currentCompany &&
        !isImageChanged) {
      EasyLoading.showInfo('No changes made');
      return;
    }

    isLoading.value = true;
    try {
      final data = {
        'name': nameController.text,
        'companyName': companyController.text,
      };

      final response = await ApiService.updateProfile(
        data: data,
        imagePath: selectedImagePath.value,
      );

      final responseBody = await response.stream.bytesToString();
      final decodedData = jsonDecode(responseBody);

      if (response.statusCode == 200 && decodedData['success'] == true) {
        EasyLoading.showSuccess('Profile updated successfully');
        await fetchProfile();
        selectedImagePath.value = ''; // Reset after successful update
        Get.back();
      } else {
        Get.snackbar(
          'Error',
          decodedData['message'] ?? 'Failed to update profile',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again later.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
