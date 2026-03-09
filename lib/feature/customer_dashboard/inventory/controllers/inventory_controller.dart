import 'package:get/get.dart';

class InventoryController extends GetxController {
  final categories = ['Table', 'Camera', 'Flower', 'Stage', 'Audio'].obs;
  final selectedCategory = 'Camera'.obs;

  void selectCategory(String category) {
    selectedCategory.value = category;
  }
}
