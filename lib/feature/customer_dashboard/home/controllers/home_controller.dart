import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q45gofna6/core/network/api_service.dart';
import 'package:q45gofna6/feature/customer_dashboard/home/models/statistics_model.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  var isLoading = false.obs;
  var statistics = Rxn<StatisticsModel>();
  var userName = 'User'.obs;
  var userAvatar = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        ApiService.getStatistics(),
        ApiService.getProfile(),
      ]);
      
      final statResponse = jsonDecode(results[0].body);
      if ((results[0].statusCode == 200 || results[0].statusCode == 201) && statResponse['success'] == true) {
        statistics.value = StatisticsModel.fromJson(statResponse['data']);
      }

      final profileResponse = jsonDecode(results[1].body);
      if ((results[1].statusCode == 200 || results[1].statusCode == 201) && profileResponse['success'] == true) {
        final profileData = profileResponse['data']['profile'];
        userName.value = profileData['name'] ?? 'User';
        
        // Handle avatar URL cleaning
        String avatar = profileData['avatar'] ?? '';
        if (avatar.isNotEmpty) {
          if (avatar.contains('localhost')) {
            avatar = avatar.replaceFirst('localhost:5000', '206.162.244.189:5005');
          } else if (avatar.contains('127.0.0.1')) {
            avatar = avatar.replaceFirst('127.0.0.1:5000', '206.162.244.189:5005');
          }
          if (!avatar.startsWith('http')) {
            avatar = avatar.startsWith('/') 
              ? 'http://206.162.244.189:5005$avatar' 
              : 'http://206.162.244.189:5005/$avatar';
          }
        }
        userAvatar.value = avatar;
      }
    } catch (e) {
      debugPrint('Failed to load home data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
