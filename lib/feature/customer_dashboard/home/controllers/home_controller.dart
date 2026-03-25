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
        userName.value = profileResponse['data']['profile']['name'] ?? 'User';
      }
    } catch (e) {
      debugPrint('Failed to load home data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
