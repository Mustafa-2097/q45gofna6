import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:q45gofna6/core/network/api_service.dart';

class InventoryController extends GetxController {
  final categories = <String>[].obs;
  final selectedCategory = RxnString();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    try {
      final response = await ApiService.getCategories();
      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) && data['success'] == true) {
        final List<dynamic> items = data['data'] ?? [];
        categories.value = items.map((item) => item['name'] as String).toList();
        
        // Optionally select the first category if available
        if (categories.isNotEmpty && selectedCategory.value == null) {
          selectedCategory.value = categories.first;
        }
      } else {
        EasyLoading.showError(data['message'] ?? 'Failed to load categories');
      }
    } catch (e) {
      EasyLoading.showError('Something went wrong loading categories');
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  Future<bool> addCategory(String category) async {
    final cleanCategory = category.trim();
    if (cleanCategory.isEmpty) return false;

    if (categories.contains(cleanCategory)) {
      EasyLoading.showError('Category already exists');
      return false;
    }

    EasyLoading.show(status: 'Adding category...');
    try {
      final response = await ApiService.createCategory(name: cleanCategory);
      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) && data['success'] == true) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess(data['message'] ?? 'Category added successfully');
        categories.insert(0, cleanCategory);
        selectedCategory.value = cleanCategory;
        return true;
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(data['message'] ?? 'Failed to add category');
        return false;
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong. Please try again later.');
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }
}

