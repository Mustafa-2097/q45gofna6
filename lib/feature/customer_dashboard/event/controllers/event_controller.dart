import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:q45gofna6/core/network/api_service.dart';

class EventModel {
  final String id;
  final String imageUrl;
  final String status;
  final String title;
  final String date;
  final String note;
  final String items;
  final String price;
  final String footerText;
  final bool hasIssue;

  EventModel({
    required this.id,
    required this.imageUrl,
    required this.status,
    required this.title,
    required this.date,
    required this.note,
    required this.items,
    required this.price,
    required this.footerText,
    required this.hasIssue,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    String imageUrl = json['image'] ?? '';
    if (imageUrl.isNotEmpty) {
      if (imageUrl.contains('localhost')) {
        imageUrl = imageUrl.replaceFirst('localhost:5000', '206.162.244.189:5005');
      } else if (imageUrl.contains('127.0.0.1')) {
        imageUrl = imageUrl.replaceFirst('127.0.0.1:5000', '206.162.244.189:5005');
      }
      if (!imageUrl.startsWith('http')) {
        imageUrl = imageUrl.startsWith('/') 
          ? 'http://206.162.244.189:5005$imageUrl' 
          : 'http://206.162.244.189:5005/$imageUrl';
      }
    }

    // Normalize status: API returns 'ACTIVE'/'COMPLETED', UI compares 'Active'/'Completed'
    final rawStatus = (json['status'] as String? ?? 'ACTIVE').toUpperCase();
    final normalizedStatus = rawStatus == 'COMPLETED' ? 'Completed' : 'Active';

    // The API returns 'items' as a count number in the list endpoint
    final itemsCount = json['itemsCount'] ?? json['items'];
    final itemCountStr = itemsCount is List
        ? '${itemsCount.length} items'
        : '${itemsCount ?? 0} items';

    // The API returns 'cost' as the total event cost, not 'totalPrice'
    final costValue = json['cost'] ?? json['totalPrice'] ?? 0;

    return EventModel(
      id: json['_id'] ?? json['id'] ?? '',
      imageUrl: imageUrl,
      status: normalizedStatus,
      title: json['name'] ?? '',
      date: json['date'] ?? '',
      note: json['note'] ?? '',
      items: itemCountStr,
      price: '\$$costValue',
      footerText: json['footerText'] ?? 'Baseline captured',
      hasIssue: json['hasIssue'] ?? false,
    );
  }
}

class EventController extends GetxController {
  final tabs = ['All', 'Active', 'Completed'].obs;
  final selectedTab = 'All'.obs;
  var isLoading = false.obs;

  // New Event State
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final noteController = TextEditingController();
  final selectedStatus = 'ACTIVE'.obs;
  final selectedImagePath = ''.obs;
  final selectedItems = <String>[].obs; // IDs of selected inventory items
  final selectedItemQuantities = <String, int>{}.obs; // Quantities of selected items
  String? editEventId;
  String? existingImageUrl;

  final allEvents = <EventModel>[].obs;

  // Pagination state
  var currentPage = 1;
  final limit = 10;
  var isMoreLoading = false.obs;
  var hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  Future<void> fetchEvents({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (!hasMore.value || isMoreLoading.value) return;
      isMoreLoading.value = true;
      currentPage++;
    } else {
      isLoading.value = true;
      currentPage = 1;
      hasMore.value = true;
      allEvents.clear();
    }

    try {
      final response = await ApiService.getEvents(page: currentPage, limit: limit);
      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) && data['success'] == true) {
        final List<dynamic> eventsJson = data['data'] ?? [];
        if (eventsJson.length < limit) {
          hasMore.value = false;
        }

        final newEvents = eventsJson.map((e) => EventModel.fromJson(e)).toList();

        if (isLoadMore) {
          allEvents.addAll(newEvents);
        } else {
          allEvents.assignAll(newEvents);
        }
      }
    } catch (e) {
      debugPrint('Error fetching events: $e');
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImagePath.value = image.path;
    }
  }

  Future<EventModel?> createEvent() async {
    if (nameController.text.isEmpty || dateController.text.isEmpty) {
      EasyLoading.showError('Please fill all required fields');
      return null;
    }

      EasyLoading.show(status: editEventId != null ? 'Updating event...' : 'Creating event...');
      try {
        final formattedItems = selectedItems.map((id) => {
          'id': id,
          'quantity': selectedItemQuantities[id] ?? 1,
        }).toList();

        final eventData = {
          'name': nameController.text.trim(),
          'date': dateController.text.trim(),
          'note': noteController.text.trim(),
          'status': selectedStatus.value,
          'items': formattedItems,
        };

        final response = editEventId != null
            ? await ApiService.updateEventWithImage(
                id: editEventId!,
                data: eventData,
                imagePath: selectedImagePath.value,
              )
            : await ApiService.createEventWithImage(
                data: eventData,
                imagePath: selectedImagePath.value,
              );

        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);

        if ((response.statusCode == 200 || response.statusCode == 201) && data['success'] == true) {
          EasyLoading.showSuccess(editEventId != null ? 'Event updated successfully' : 'Event created successfully');
          final event = EventModel.fromJson(data['data']);
          resetForm();
          fetchEvents();
          return event;
        } else {
          EasyLoading.showError(data['message'] ?? 'Failed to save event');
          return null;
        }
    } catch (e) {
      EasyLoading.showError('Something went wrong');
      return null;
    }
  }

  Future<void> setEditEvent(EventModel event) async {
    editEventId = event.id;
    existingImageUrl = event.imageUrl;
    nameController.text = event.title;
    dateController.text = event.date.contains('T') ? event.date.split('T')[0] : event.date;
    noteController.text = event.note;
    selectedStatus.value = event.status.toUpperCase() == 'ACTIVE' ? 'ACTIVE' : 'COMPLETED';
    selectedImagePath.value = '';
    selectedItems.clear();
    selectedItemQuantities.clear();

    // Fetch details to prepopulate items
    EasyLoading.show(status: 'Loading elements...');
    try {
      final response = await ApiService.getEventById(event.id);
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        final detailData = data['data'];
        final itemsList = detailData['items'] as List?;
        if (itemsList != null) {
          for (var item in itemsList) {
            if (item is Map) {
              String? iId;
              // API returns items with a flat 'id' field
              if (item['id'] is String && (item['id'] as String).isNotEmpty) {
                iId = item['id'] as String;
              } else if (item['_id'] is String && (item['_id'] as String).isNotEmpty) {
                iId = item['_id'] as String;
              } else if (item['itemId'] is Map) {
                iId = item['itemId']['_id'] ?? item['itemId']['id'] ?? item['itemId']['_id'];
              } else if (item['itemId'] is String) {
                iId = item['itemId'] as String;
              } else if (item['_id'] is String) {
                iId = item['_id'] as String;
              } else if (item['id'] is String) {
                iId = item['id'] as String;
              }
              if (iId != null && iId.isNotEmpty) {
                selectedItems.add(iId);
                selectedItemQuantities[iId] = (item['quantity'] as num?)?.toInt() ?? 1;
              }
            } else if (item is String) {
              selectedItems.add(item);
              selectedItemQuantities[item] = 1;
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching event details: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void resetForm() {
    editEventId = null;
    existingImageUrl = null;
    nameController.clear();
    dateController.clear();
    noteController.clear();
    selectedStatus.value = 'ACTIVE';
    selectedImagePath.value = '';
    selectedItems.clear();
    selectedItemQuantities.clear();
  }

  void toggleItemSelection(String id) {
    if (selectedItems.contains(id)) {
      selectedItems.remove(id);
      selectedItemQuantities.remove(id);
    } else {
      selectedItems.add(id);
      selectedItemQuantities[id] = 1;
    }
  }

  void increaseQuantity(String id, int maxStock) {
    if (!selectedItems.contains(id)) return;
    int current = selectedItemQuantities[id] ?? 1;
    if (current < maxStock) {
      selectedItemQuantities[id] = current + 1;
    } else {
      EasyLoading.showToast('Maximum stock reached');
    }
  }

  void decreaseQuantity(String id) {
    if (!selectedItems.contains(id)) return;
    int current = selectedItemQuantities[id] ?? 1;
    if (current > 1) {
      selectedItemQuantities[id] = current - 1;
    } else {
      // Deselect if it reaches 0
      toggleItemSelection(id);
    }
  }

  List<EventModel> get filteredEvents {
    final tab = selectedTab.value;
    if (tab == 'All') return allEvents;
    // Tab labels: 'Active', 'Completed' — match normalized model status
    return allEvents.where((e) => e.status == tab).toList();
  }

  int get totalCount => allEvents.length;
  int get activeCount => allEvents.where((e) => e.status == 'Active').length;
  int get doneCount => allEvents.where((e) => e.status == 'Completed').length;

  void selectTab(String tab) {
    selectedTab.value = tab;
  }
}
