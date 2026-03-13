import 'package:get/get.dart';

class InventoryController extends GetxController {
  final categories = ['Table', 'Camera', 'Flower', 'Stage'].obs;
  final selectedCategory = RxnString();

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void addCategory(String category) {
    if (category.trim().isNotEmpty && !categories.contains(category.trim())) {
      categories.insert(0, category.trim());
      selectedCategory.value = category.trim();
    }
  }
}
