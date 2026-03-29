import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:q45gofna6/core/network/api_service.dart';
import 'package:q45gofna6/feature/customer_dashboard/inventory/models/inventory_item_model.dart';

class InventoryController extends GetxController {
  final categories = <String>[].obs;
  final categoryMap = <String, String>{}.obs;
  final selectedCategory = 'All'.obs;
  final searchQuery = ''.obs;
  var isLoading = false.obs;
  
  // Inventory state
  var isInventoryLoading = false.obs;
  final inventoryItems = <InventoryItem>[].obs;
  
  // Statistics state
  final totalItems = 0.obs;
  final totalStock = 0.obs;
  final totalCost = 0.0.obs;

  // Pagination state
  var currentPage = 1;
  final limit = 10;
  var isMoreLoading = false.obs;
  var hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchInventoryItems();
    fetchInventoryStatistics();
    
    // Setup debounce for search API call
    debounce(searchQuery, (_) => fetchInventoryItems(), time: const Duration(milliseconds: 500));
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    try {
      final response = await ApiService.getCategories();
      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) && data['success'] == true) {
        final List<dynamic> items = data['data'] ?? [];
        categories.clear();
        categoryMap.clear();
        
        categories.add('All');
        
        for (var item in items) {
          final String name = item['name'] as String;
          final String? id = item['_id'] as String? ?? item['id'] as String?;
          categories.add(name);
          if (id != null) {
            categoryMap[name] = id;
          }
        }
        
        // Reset to All only if current selection is no longer in the list
        if (!categories.contains(selectedCategory.value)) {
          selectedCategory.value = 'All';
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
    fetchInventoryItems(); // Fetch filtered inventory from API
  }

  void updateSearch(String query) {
    searchQuery.value = query.toLowerCase().trim();
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
        categories.add(cleanCategory);
        if (data['data'] != null) {
          final newId = data['data']['_id'] ?? data['data']['id'];
          if (newId != null) {
            categoryMap[cleanCategory] = newId.toString();
          }
        }
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

  Future<bool> updateCategory(String id, String newName) async {
    final cleanName = newName.trim();
    if (cleanName.isEmpty) return false;

    EasyLoading.show(status: 'Updating category...');
    try {
      final response = await ApiService.updateCategory(id: id, name: cleanName);
      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) && data['success'] == true) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess(data['message'] ?? 'Category updated successfully');
        fetchCategories(); // Refresh all
        return true;
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(data['message'] ?? 'Failed to update category');
        return false;
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong. Please try again later.');
      return false;
    }
  }

  Future<bool> deleteCategory(String id) async {
    EasyLoading.show(status: 'Deleting category...');
    try {
      final response = await ApiService.deleteCategory(id);
      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) && data['success'] == true) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess(data['message'] ?? 'Category deleted successfully');
        fetchCategories(); // Refresh all
        return true;
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(data['message'] ?? 'Failed to delete category');
        return false;
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong. Please try again later.');
      return false;
    }
  }

  Future<void> fetchInventoryItems({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (isMoreLoading.value || !hasMore.value) return;
      isMoreLoading.value = true;
    } else {
      isInventoryLoading.value = true;
      currentPage = 1;
      hasMore.value = true;
      inventoryItems.clear(); // Clear existing items to show loader and avoid stale UI
    }

    try {
      String? categoryId;
      if (selectedCategory.value != 'All') {
        categoryId = categoryMap[selectedCategory.value];
      }

      final response = await ApiService.getInventoryItems(
        search: searchQuery.value,
        categoryId: categoryId,
        page: currentPage,
        limit: limit,
      );
      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) && data['success'] == true) {
        final List<dynamic> items = data['data'] ?? [];
        final newItems = items.map((item) => InventoryItem.fromJson(item)).toList();
        
        if (isLoadMore) {
          inventoryItems.addAll(newItems);
        } else {
          inventoryItems.assignAll(newItems);
        }

        // Check if there's more data
        final pagination = data['pagination'];
        if (pagination != null) {
          final totalPages = pagination['totalPage'] ?? 1;
          hasMore.value = currentPage < totalPages;
          if (hasMore.value) {
            currentPage++;
          }
        } else {
          hasMore.value = newItems.length == limit;
          if (hasMore.value) currentPage++;
        }
      } else {
        EasyLoading.showError(data['message'] ?? 'Failed to load inventory');
      }
    } catch (e) {
      EasyLoading.showError('Something went wrong loading inventory');
    } finally {
      isInventoryLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  Future<void> fetchInventoryStatistics() async {
    try {
      final response = await ApiService.getInventoryStatistics();
      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) && data['success'] == true) {
        final stats = data['data'];
        totalItems.value = (stats['totalItems'] ?? 0) as int;
        totalStock.value = (stats['totalStock'] ?? 0) as int;
        totalCost.value = (stats['totalCost'] ?? 0.0).toDouble();
      }
    } catch (e) {
      // Don't show error for stats to not annoy user, just log it
      print('Error fetching statistics: $e');
    }
  }

  Future<bool> createInventoryItem({
    required String name,
    required double cost,
    required int stock,
    required String categoryId,
    String? imagePath,
  }) async {
    EasyLoading.show(status: 'Adding inventory item...');
    try {
      final requestData = {
        'name': name,
        'cost': cost,
        'stock': stock,
        'categoryId': categoryId,
      };

      final response = await ApiService.createInventoryItemWithImage(
        data: requestData,
        imagePath: imagePath,
      );

      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

      if ((response.statusCode == 200 || response.statusCode == 201) && data['success'] == true) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess(data['message'] ?? 'Item added successfully');
        // Refresh the items list
        fetchInventoryItems();
        fetchInventoryStatistics();
        return true;
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(data['message'] ?? 'Failed to add item');
        return false;
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong adding item');
      return false;
    }
  }

  Future<bool> updateInventoryItem({
    required String id,
    required String name,
    required double cost,
    required int stock,
    required String categoryId,
    String? imagePath,
  }) async {
    EasyLoading.show(status: 'Updating inventory item...');
    try {
      final requestData = {
        'name': name,
        'cost': cost,
        'stock': stock,
        'categoryId': categoryId,
      };

      final response = await ApiService.updateInventoryItemWithImage(
        id: id,
        data: requestData,
        imagePath: imagePath,
      );

      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

      if ((response.statusCode == 200 || response.statusCode == 201) && data['success'] == true) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess(data['message'] ?? 'Item updated successfully');
        fetchInventoryItems();
        fetchInventoryStatistics();
        return true;
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(data['message'] ?? 'Failed to update item');
        return false;
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong updating item');
      return false;
    }
  }

  Future<bool> deleteInventoryItem(String id) async {
    EasyLoading.show(status: 'Deleting...');
    try {
      final response = await ApiService.deleteInventoryItem(id);
      final data = jsonDecode(response.body);
      if ((response.statusCode == 200 || response.statusCode == 201) && data['success'] == true) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess(data['message'] ?? 'Item deleted');
        inventoryItems.removeWhere((item) => item.id == id);
        fetchInventoryStatistics();
        return true;
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(data['message'] ?? 'Failed to delete');
        return false;
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong');
      return false;
    }
  }
}

