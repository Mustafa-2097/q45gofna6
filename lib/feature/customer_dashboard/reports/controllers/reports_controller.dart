import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network/api_service.dart';
import '../models/reports_model.dart';

class ReportsController extends GetxController {
  var isLoading = false.obs;
  var reportsData = Rxn<ReportsData>();

  @override
  void onInit() {
    super.onInit();
    fetchReports();
  }

  Future<void> fetchReports() async {
    isLoading.value = true;
    try {
      final response = await ApiService.getAuditReports();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final reportsModel = ReportsModel.fromJson(data);
        if (reportsModel.success == true && reportsModel.data != null) {
          reportsData.value = reportsModel.data;
        }
      } else {
        debugPrint('Failed to fetch reports: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching reports: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
