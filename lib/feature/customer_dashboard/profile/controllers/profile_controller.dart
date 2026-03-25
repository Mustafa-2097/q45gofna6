import 'dart:convert';
import 'package:get/get.dart';
import 'package:q45gofna6/core/network/api_service.dart';
import 'package:q45gofna6/feature/customer_dashboard/profile/models/profile_model.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var userProfile = Rxn<ProfileModel>();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final response = await ApiService.getProfile();
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        userProfile.value = ProfileModel.fromJson(data['data']);
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
}
