import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:q45gofna6/core/network/api_service.dart';
import 'package:q45gofna6/feature/customer_dashboard/event/models/event_model.dart';

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
  final selectedItemQuantities =
      <String, int>{}.obs; // Quantities of selected items
  String? editEventId;
  String? existingImageUrl;

  final events = <EventModel>[].obs;
  var isEventsLoading = false.obs;

  // Audit State
  final audits = <AuditModel>[].obs;
  final isAudisLoading = false.obs;
  final auditReport = Rxn<AuditReport>();

  final eventMissings = <EventMissingResponse>[].obs;
  final isMissingsLoading = false.obs;

  Future<void> fetchMissingItems(String eventId) async {
    isMissingsLoading.value = true;
    try {
      final response = await ApiService.getMissingItems(eventId);
      final data = jsonDecode(response.body);
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data['success'] == true) {
        final List list = data['data'] ?? [];
        eventMissings.assignAll(
          list.map((e) => EventMissingResponse.fromJson(e)).toList(),
        );
      } else {
        eventMissings.clear();
      }
    } catch (e) {
      debugPrint('Error fetching missing items: $e');
      eventMissings.clear();
    } finally {
      isMissingsLoading.value = false;
    }
  }

  Future<bool> revokeMissingItem(String auditId, String itemId) async {
    EasyLoading.show(status: 'Marking item as found...');
    try {
      final response = await ApiService.revokeMissingItem(
        auditId: auditId,
        itemId: itemId,
      );
      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data['success'] == true) {
        EasyLoading.showSuccess('Item marked as found');
        return true;
      } else {
        EasyLoading.showError(data['message'] ?? 'Failed to mark item');
        return false;
      }
    } catch (e) {
      debugPrint('Error revoking missing item: $e');
      EasyLoading.showError('Something went wrong');
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> fetchEventAudits(String eventId) async {
    isAudisLoading.value = true;
    try {
      final response = await ApiService.getAudits(eventId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          // Parse audits list
          if (data['data']['audits'] != null) {
            final List auditsData = data['data']['audits'];
            audits.assignAll(
              auditsData.map((e) => AuditModel.fromJson(e)).toList(),
            );
          } else {
            audits.clear();
          }
          // Parse report
          if (data['data']['report'] != null) {
            auditReport.value = AuditReport.fromJson(
              data['data']['report'] as Map<String, dynamic>,
            );
          } else {
            auditReport.value = null;
          }
        } else {
          audits.clear();
          auditReport.value = null;
        }
      }
    } catch (e) {
      debugPrint('Error fetching audits: $e');
    } finally {
      isAudisLoading.value = false;
    }
  }

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
      isEventsLoading.value = true;
      currentPage = 1;
      hasMore.value = true;
      events.clear();
    }

    try {
      final response = await ApiService.getEvents(
        page: currentPage,
        limit: limit,
      );
      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data['success'] == true) {
        final List<dynamic> eventsJson = data['data'] ?? [];
        if (eventsJson.length < limit) {
          hasMore.value = false;
        }

        final newEvents = eventsJson
            .map((e) => EventModel.fromJson(e))
            .toList();

        if (isLoadMore) {
          events.addAll(newEvents);
        } else {
          events.assignAll(newEvents);
        }
      }
    } catch (e) {
      debugPrint('Error fetching events: $e');
    } finally {
      isLoading.value = false;
      isEventsLoading.value = false;
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

    EasyLoading.show(
      status: editEventId != null ? 'Updating event...' : 'Creating event...',
    );
    try {
      // Combine every possible ID key to ensure the backend picks one up
      final formattedItems = selectedItems
          .map(
            (id) => {
              'id': id,
              'itemId': id,
              'item': id,
              'quantity': selectedItemQuantities[id] ?? 1,
            },
          )
          .toList();

      final rawData = {
        'name': nameController.text.trim(),
        'date': dateController.text.trim(),
        'note': noteController.text.trim(),
        'status': selectedStatus.value,
        'items': formattedItems,
      };

      debugPrint('--- EVENT SUBMISSION START ---');
      debugPrint('Payload JSON: ${jsonEncode(rawData)}');

      String responseBody;
      int statusCode;

      if (editEventId != null) {
        // Force Multipart even if no image is picked for updates, to match Postman precisely
        final streamedResponse = await ApiService.updateEventWithImage(
          id: editEventId!,
          data: rawData,
          imagePath: selectedImagePath.value,
        );
        statusCode = streamedResponse.statusCode;
        responseBody = await streamedResponse.stream.bytesToString();
      } else {
        // Create path
        final streamedResponse = await ApiService.createEventWithImage(
          data: rawData,
          imagePath: selectedImagePath.value,
        );
        statusCode = streamedResponse.statusCode;
        responseBody = await streamedResponse.stream.bytesToString();
      }

      debugPrint('Final Response Status: $statusCode');
      debugPrint('Final Response Body: $responseBody');

      final data = jsonDecode(responseBody);

      if ((statusCode == 200 || statusCode == 201) && data['success'] == true) {
        EasyLoading.showSuccess(
          editEventId != null
              ? 'Event updated successfully'
              : 'Event created successfully',
        );

        // Re-fetch logic
        final savedEventId =
            data['data']?['_id'] ?? data['data']?['id'] ?? editEventId ?? '';
        debugPrint('Extracted ID for re-fetch: $savedEventId');

        EventModel? fullEvent;
        if (savedEventId.isNotEmpty) {
          try {
            final detailResponse = await ApiService.getEventById(savedEventId);
            final detailData = jsonDecode(detailResponse.body);
            debugPrint('Re-fetch Details Response: ${detailResponse.body}');

            if (detailResponse.statusCode == 200 &&
                detailData['success'] == true) {
              fullEvent = EventModel.fromJson(detailData['data']);
              debugPrint(
                'Re-fetch successful. Item description: ${fullEvent.items}',
              );
            }
          } catch (e) {
            debugPrint('Re-fetch Exception: $e');
          }
        }

        resetForm();
        fetchEvents();

        if (fullEvent != null) {
          debugPrint('Returning full re-fetched model');
          return fullEvent;
        } else {
          debugPrint(
            'Re-fetch failed or incomplete, returning raw response data',
          );
          return data['data'] != null
              ? EventModel.fromJson(data['data'])
              : null;
        }
      } else {
        final errorMsg =
            data['message'] ?? data['error'] ?? 'Failed to save event';
        debugPrint('Submission Error: $errorMsg');
        EasyLoading.showError(errorMsg);
        return null;
      }
    } catch (e, stack) {
      debugPrint('Event controller Exception: $e\n$stack');
      EasyLoading.showError('Something went wrong');
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> setEditEvent(EventModel event) async {
    debugPrint('--- PREPARING EDIT MODE FOR: ${event.id} ---');
    editEventId = event.id;
    existingImageUrl = event.imageUrl;
    nameController.text = event.title;
    dateController.text = event.date.contains('T')
        ? event.date.split('T')[0]
        : event.date;
    noteController.text = event.note;
    selectedStatus.value = event.status.toUpperCase() == 'ACTIVE'
        ? 'ACTIVE'
        : 'COMPLETED';
    selectedImagePath.value = '';
    selectedItems.clear();
    selectedItemQuantities.clear();

    EasyLoading.show(status: 'Loading elements...');
    try {
      final response = await ApiService.getEventById(event.id);
      final data = jsonDecode(response.body);
      debugPrint(
        'Raw Detail Items to extract: ${jsonEncode(data['data']?['items'])}',
      );

      if (response.statusCode == 200 && data['success'] == true) {
        final detailData = data['data'];
        final itemsList = detailData['items'] as List?;
        if (itemsList != null) {
          for (var item in itemsList) {
            if (item is Map) {
              String? iId;

              if (item['itemId'] is Map) {
                final idMap = item['itemId'] as Map;
                iId = (idMap['_id'] ?? idMap['id'])?.toString();
              } else if (item['itemId'] is String &&
                  (item['itemId'] as String).isNotEmpty) {
                iId = item['itemId'] as String;
              } else if (item['item'] is Map) {
                final idMap = item['item'] as Map;
                iId = (idMap['_id'] ?? idMap['id'])?.toString();
              } else if (item['item'] is String &&
                  (item['item'] as String).isNotEmpty) {
                iId = item['item'] as String;
              } else if (item['id'] is String &&
                  (item['id'] as String).isNotEmpty) {
                iId = item['id'] as String;
              }

              debugPrint('  Extracted ID: $iId from raw: ${jsonEncode(item)}');

              if (iId != null && iId.isNotEmpty) {
                selectedItems.add(iId);
                selectedItemQuantities[iId] =
                    (item['quantity'] as num?)?.toInt() ?? 1;
              }
            } else if (item is String) {
              selectedItems.add(item);
              selectedItemQuantities[item] = 1;
            }
          }
        }
        debugPrint('Final selectedItems for Edit: $selectedItems');
      }
    } catch (e) {
      debugPrint('Error in setEditEvent: $e');
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
    if (tab == 'All') return events;
    // Tab labels: 'Active', 'Completed' — match normalized model status
    return events.where((e) => e.status == tab).toList();
  }

  int get totalCount => events.length;
  int get activeCount => events.where((e) => e.status == 'Active').length;
  int get doneCount => events.where((e) => e.status == 'Completed').length;

  void selectTab(String tab) {
    selectedTab.value = tab;
  }

  Future<bool> updateAuditAfterImage({
    required String auditId,
    required String imagePath,
    required String eventId,
  }) async {
    EasyLoading.show(status: 'Uploading after image...');
    try {
      final response = await ApiService.updateAuditAfterImage(
        auditId: auditId,
        afterImagePath: imagePath,
      );

      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data['success'] == true) {
        EasyLoading.showSuccess('After image updated successfully');
        await fetchEventAudits(eventId); // Refresh audits
        return true;
      } else {
        EasyLoading.showError(
          data['message'] ?? 'Failed to update after image',
        );
        return false;
      }
    } catch (e) {
      debugPrint('Error updating audit after image: $e');
      EasyLoading.showError('Something went wrong');
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<bool> runAiAudit(String auditId, String eventId) async {
    EasyLoading.show(status: 'Running AI audit comparison...');
    try {
      final response = await ApiService.runAiAudit(auditId);
      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data['success'] == true) {
        EasyLoading.showSuccess('AI audit completed successfully');
        await fetchEventAudits(eventId); // Refresh audits
        return true;
      } else {
        EasyLoading.showError(data['message'] ?? 'Failed to run AI audit');
        return false;
      }
    } catch (e) {
      debugPrint('Error running AI audit: $e');
      EasyLoading.showError('Something went wrong');
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }
}
