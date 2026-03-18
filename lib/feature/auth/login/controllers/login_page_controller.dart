import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:q45gofna6/core/network/api_service.dart';
import 'package:q45gofna6/core/offline_storage/shared_pref.dart';
import '../../../customer_dashboard/dashboard/dashboard.dart';

class LoginPageController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _loadRememberedData();
  }

  Future<void> _loadRememberedData() async {
    rememberMe.value = await SharedPreferencesHelper.isRememberMe();
    if (rememberMe.value) {
      emailController.text = await SharedPreferencesHelper.getRememberedEmail() ?? "";
    }
  }

  static LoginPageController get instance => Get.find();

  /// Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// Observables
  var isPasswordHidden = true.obs;
  var rememberMe = false.obs;

  /// Validation
  String? validateEmail() {
    if (emailController.text.trim().isEmpty) return "Email is required";
    if (!GetUtils.isEmail(emailController.text.trim())) return "Enter a valid email";
    return null;
  }

  String? validatePassword() {
    if (passwordController.text.trim().isEmpty) return "Password is required";
    return null;
  }

  /// MAIN LOGIN FUNCTION
  Future<void> login() async {
    final emailError = validateEmail();
    final passError = validatePassword();

    if (emailError != null || passError != null) {
      EasyLoading.showError(emailError ?? passError!);
      return;
    }

    try {
      EasyLoading.show(status: 'Logging in...');
      final response = await ApiService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = data['data']?['accessToken'] ?? data['token'];
        if (token != null) {
          await SharedPreferencesHelper.saveToken(token);
          
          if (rememberMe.value) {
            await SharedPreferencesHelper.saveRememberMe(true);
            await SharedPreferencesHelper.saveRememberedEmail(emailController.text.trim());
          } else {
            await SharedPreferencesHelper.clearRememberMe();
          }

          EasyLoading.showSuccess('Login Successful');
          Get.offAll(() => CustomerDashboard());
        } else {
          EasyLoading.showError('Token not found in response');
        }
      } else {
        EasyLoading.showError(data['message'] ?? 'Login failed');
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
