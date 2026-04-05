import 'dart:convert';
import 'package:get/get.dart';
import 'package:q45gofna6/core/network/api_service.dart';
import 'package:q45gofna6/feature/customer_dashboard/profile/models/profile_model.dart';
import 'package:q45gofna6/feature/customer_dashboard/subscription/models/subscription_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var isSubscriptionLoading = false.obs;
  var userProfile = Rxn<ProfileModel>();

  final nameController = TextEditingController();
  final companyController = TextEditingController();
  var selectedImagePath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    fetchOnlySubscription();
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
        final profileModel = ProfileModel.fromJson(data['data']);
        // Keep existing subscription if we already have it
        userProfile.value = ProfileModel(
          id: profileModel.id,
          email: profileModel.email,
          role: profileModel.role,
          status: profileModel.status,
          profile: profileModel.profile,
          subscription: userProfile.value?.subscription ?? profileModel.subscription,
        );
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

  Future<void> fetchOnlySubscription() async {
    isSubscriptionLoading.value = true;
    try {
      final subResponse = await ApiService.getSubscription();
      final subData = jsonDecode(subResponse.body);
      if (subResponse.statusCode == 200 && subData['success'] == true && subData['data'] != null) {
          final newSub = UserSubscription.fromJson(subData['data']);
          if (userProfile.value != null) {
             userProfile.value = ProfileModel(
               id: userProfile.value!.id,
               email: userProfile.value!.email,
               role: userProfile.value!.role,
               status: userProfile.value!.status,
               profile: userProfile.value!.profile,
               subscription: newSub,
             );
          } else {
             userProfile.value = ProfileModel(
               id: '',
               email: '',
               role: '',
               status: '',
               profile: ProfileData(name: ''),
               subscription: newSub,
             );
          }
      } else {
        // Explicitly clear subscription if backend returns success: false or null data
        if (userProfile.value != null) {
          userProfile.value = ProfileModel(
            id: userProfile.value!.id,
            email: userProfile.value!.email,
            role: userProfile.value!.role,
            status: userProfile.value!.status,
            profile: userProfile.value!.profile,
            subscription: null, // Clear the subscription
          );
        }
      }
    } catch (e) {
      debugPrint('Error fetching subscription in profile: $e');
      // Clear subscription if there's an error (e.g., 404 No Subscription)
      if (userProfile.value != null) {
        userProfile.value = ProfileModel(
          id: userProfile.value!.id,
          email: userProfile.value!.email,
          role: userProfile.value!.role,
          status: userProfile.value!.status,
          profile: userProfile.value!.profile,
          subscription: null,
        );
      }
    } finally {
      isSubscriptionLoading.value = false;
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

  Future<void> cancelSubscription() async {
    final subId = userProfile.value?.subscription?.id;
    if (subId == null) {
      EasyLoading.showError('No active subscription found');
      return;
    }

    EasyLoading.show(status: 'Canceling subscription...');
    try {
      final response = await ApiService.cancelSubscription(subId);
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        EasyLoading.showSuccess('Subscription canceled successfully');
        await fetchProfile();
        await fetchOnlySubscription();
      } else {
        EasyLoading.showError(data['message'] ?? 'Failed to cancel subscription');
      }
    } catch (e) {
      EasyLoading.showError('Something went wrong');
    } finally {
      EasyLoading.dismiss();
    }
  }
}
