import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:q45gofna6/core/network/api_endpoints.dart';
import 'package:q45gofna6/core/offline_storage/shared_pref.dart';

class ApiService {
  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Get headers with token if available
  static Future<Map<String, String>> _getHeaders() async {
    final token = await SharedPreferencesHelper.getToken();
    if (token != null && token.isNotEmpty) {
      return {..._defaultHeaders, 'Authorization': token};
    }
    return _defaultHeaders;
  }

  /// POST Request
  static Future<http.Response> post(
    String url,
    Map<String, dynamic> body,
  ) async {
    final headers = await _getHeaders();
    debugPrint('POST URL: $url');
    debugPrint('POST Body: ${jsonEncode(body)}');

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    debugPrint('Response Status: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');
    return response;
  }

  /// GET Request
  static Future<http.Response> get(String url) async {
    final headers = await _getHeaders();
    debugPrint('GET URL: $url');

    final response = await http.get(Uri.parse(url), headers: headers);

    debugPrint('Response Status: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');
    return response;
  }

  /// PATCH Request
  static Future<http.Response> patch(
    String url,
    Map<String, dynamic> body,
  ) async {
    final headers = await _getHeaders();
    debugPrint('PATCH URL: $url');
    debugPrint('PATCH Body: ${jsonEncode(body)}');

    final response = await http.patch(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    debugPrint('Response Status: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');
    return response;
  }

  /// DELETE Request
  static Future<http.Response> delete(String url) async {
    final headers = await _getHeaders();
    debugPrint('DELETE URL: $url');
    final response = await http.delete(Uri.parse(url), headers: headers);
    debugPrint('Response Status: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');
    return response;
  }

  // ================= AUTH METHODS =================

  /// Login
  static Future<http.Response> login({
    required String email,
    required String password,
  }) async {
    final body = {'email': email, 'password': password};
    return await post(ApiEndpoints.login, body);
  }

  /// Register
  static Future<http.Response> register({
    required String name,
    required String companyName,
    required String email,
    required String password,
    required String confirmPassword,
    String role = 'USER',
  }) async {
    final body = {
      'name': name,
      'companyName': companyName,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'role': role,
    };
    return await post(ApiEndpoints.register, body);
  }

  /// Verify Sign Up OTP
  static Future<http.Response> verifySignUpOtp({
    required String email,
    required String otp,
  }) async {
    final body = {'email': email, 'otp': otp};
    return await post(ApiEndpoints.verifySigUupOtp, body);
  }

  /// Resend Sign Up OTP
  static Future<http.Response> resendSignUpOtp({required String email}) async {
    final body = {'email': email};
    return await post(ApiEndpoints.resendSignUpOtp, body);
  }

  /// Send Reset Password OTP
  static Future<http.Response> sendResetOtp({required String email}) async {
    final body = {'email': email};
    return await post(ApiEndpoints.sendResetOtp, body);
  }

  /// Verify Reset Password OTP
  static Future<http.Response> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    final body = {'email': email, 'otp': otp};
    return await post(ApiEndpoints.verifyResetOtp, body);
  }

  /// Reset Password
  static Future<http.Response> resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final body = {
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
    };
    return await post(ApiEndpoints.resetPassword, body);
  }

  // ================= PROFILE METHODS =================

  /// Change Password
  static Future<http.Response> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final body = {'oldPassword': oldPassword, 'newPassword': newPassword};
    return await post(ApiEndpoints.changePassword, body);
  }

  /// Get Profile
  static Future<http.Response> getProfile() async {
    return await get(ApiEndpoints.profile);
  }

  /// Get Statistics
  static Future<http.Response> getStatistics() async {
    return await get(ApiEndpoints.profileStatistics);
  }

  /// Update Profile
  static Future<http.StreamedResponse> updateProfile({
    required Map<String, dynamic> data,
    String? imagePath,
  }) async {
    final headers = await _getHeaders();
    final request = http.MultipartRequest(
      'PATCH',
      Uri.parse(ApiEndpoints.updateProfile),
    );

    request.headers.addAll({
      if (headers.containsKey('Authorization'))
        'Authorization': headers['Authorization']!,
    });

    request.fields['data'] = jsonEncode(data);

    if (imagePath != null && imagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('avatar', imagePath));
    }

    debugPrint('PATCH Profile URL: ${ApiEndpoints.updateProfile}');
    debugPrint('PATCH Profile Fields: ${request.fields}');

    return await request.send();
  }
  // ================= CATEGORIES METHODS =================

  /// Get Categories
  static Future<http.Response> getCategories() async {
    return await get(ApiEndpoints.categories);
  }

  /// Create Category
  static Future<http.Response> createCategory({required String name}) async {
    final body = {'name': name};
    return await post(ApiEndpoints.categories, body);
  }

  /// Update Category
  static Future<http.Response> updateCategory({
    required String id,
    required String name,
  }) async {
    final body = {'name': name};
    final url = ApiEndpoints.categoriesUpdate.replaceFirst(':id', id);
    return await patch(url, body);
  }

  /// Delete Category
  static Future<http.Response> deleteCategory(String id) async {
    final url = ApiEndpoints.categoriesDelete.replaceFirst(':id', id);
    return await delete(url);
  }

  // ================= INVENTORY METHODS =================

  /// Get Inventory Items
  static Future<http.Response> getInventoryItems({
    String? search,
    String? categoryId,
    int? page,
    int? limit,
  }) async {
    String url = ApiEndpoints.inventory;
    List<String> queryParams = [];
    if (search != null && search.isNotEmpty) {
      queryParams.add('search=${Uri.encodeComponent(search)}');
    }
    if (categoryId != null && categoryId.isNotEmpty) {
      queryParams.add('category=$categoryId');
    }
    if (page != null) {
      queryParams.add('page=$page');
    }
    if (limit != null) {
      queryParams.add('limit=$limit');
    }

    if (queryParams.isNotEmpty) {
      url += '?${queryParams.join('&')}';
    }
    return await get(url);
  }

  /// Create Inventory Item
  static Future<http.StreamedResponse> createInventoryItemWithImage({
    required Map<String, dynamic> data,
    String? imagePath,
  }) async {
    final headers = await _getHeaders();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiEndpoints.inventory),
    );

    request.headers.addAll({
      if (headers.containsKey('Authorization'))
        'Authorization': headers['Authorization']!,
    });

    request.fields['data'] = jsonEncode(data);

    if (imagePath != null && imagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    debugPrint('POST Multipart URL: ${ApiEndpoints.inventory}');
    debugPrint('POST Multipart Fields: ${request.fields}');

    return await request.send();
  }

  /// Update Inventory Item (PATCH multipart)
  static Future<http.StreamedResponse> updateInventoryItemWithImage({
    required String id,
    required Map<String, dynamic> data,
    String? imagePath,
  }) async {
    final headers = await _getHeaders();
    final url = ApiEndpoints.inventoryUpdate.replaceFirst(':id', id);
    final request = http.MultipartRequest('PATCH', Uri.parse(url));

    request.headers.addAll({
      if (headers.containsKey('Authorization'))
        'Authorization': headers['Authorization']!,
    });

    request.fields['data'] = jsonEncode(data);

    if (imagePath != null && imagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    debugPrint('PATCH Multipart URL: $url');
    debugPrint('PATCH Multipart Fields: ${request.fields}');

    return await request.send();
  }

  /// Delete Inventory Item
  static Future<http.Response> deleteInventoryItem(String id) async {
    final url = ApiEndpoints.inventoryDelete.replaceFirst(':id', id);
    return await delete(url);
  }

  /// Get Inventory Statistics
  static Future<http.Response> getInventoryStatistics() async {
    return await get(ApiEndpoints.inventoryStatistics);
  }

  // ================= EVENTS METHODS =================

  /// Get Events with Pagination
  static Future<http.Response> getEvents({int page = 1, int limit = 10}) async {
    return await get('${ApiEndpoints.events}?page=$page&limit=$limit');
  }

  /// Get Single Event Details
  static Future<http.Response> getEventById(String id) async {
    final url = ApiEndpoints.eventsUpdate.replaceFirst(':id', id);
    return await get(url);
  }

  /// Get Event Statistics
  static Future<http.Response> getEventStatistics() async {
    return await get(ApiEndpoints.eventsStatistics);
  }

  /// Create Event (Multipart)
  static Future<http.StreamedResponse> createEventWithImage({
    required Map<String, dynamic> data,
    String? imagePath,
  }) async {
    final headers = await _getHeaders();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiEndpoints.events),
    );

    request.headers.addAll({
      if (headers.containsKey('Authorization'))
        'Authorization': headers['Authorization']!,
    });

    // Backend expects entire JSON in a single 'data' field key + 'image' file separately
    request.fields['data'] = jsonEncode(data);

    if (imagePath != null && imagePath.isNotEmpty) {
      // Assuming the backend expects field name 'image' or 'itemPhoto'
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    debugPrint('POST Event URL: ${ApiEndpoints.events}');
    debugPrint('POST Event Fields: ${request.fields}');

    return await request.send();
  }

  /// Update Event (Multipart)
  static Future<http.StreamedResponse> updateEventWithImage({
    required String id,
    required Map<String, dynamic> data,
    String? imagePath,
  }) async {
    final headers = await _getHeaders();
    final url = ApiEndpoints.eventsUpdate.replaceAll(':id', id);
    final request = http.MultipartRequest('PATCH', Uri.parse(url));

    request.headers.addAll({
      if (headers.containsKey('Authorization'))
        'Authorization': headers['Authorization']!,
    });

    // Backend expects entire JSON in a single 'data' field key + 'image' file separately
    request.fields['data'] = jsonEncode(data);

    if (imagePath != null && imagePath.isNotEmpty) {
      // Assuming the backend expects field name 'image' or 'itemPhoto'
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    debugPrint('PATCH Event URL: $url');
    debugPrint('PATCH Event Headers: ${request.headers}');
    debugPrint('PATCH Event Fields: ${request.fields}');

    return await request.send();
  }

  // ================= AUDIT METHODS =================

  /// Get Audit Reports
  static Future<http.Response> getAuditReports() async {
    return await get(ApiEndpoints.auditReports);
  }

  /// Get Audits
  static Future<http.Response> getAudits(String eventId) async {
    final url = ApiEndpoints.eventAudit.replaceFirst(':eventId', eventId);
    return await get(url);
  }

  /// Create Audit (Multipart)
  static Future<http.StreamedResponse> createAudit({
    required String eventId,
    required Map<String, dynamic> data,
    String? beforeImagePath,
    String? afterImagePath,
  }) async {
    final headers = await _getHeaders();
    final url = ApiEndpoints.eventAudit.replaceFirst(':eventId', eventId);
    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.headers.addAll({
      if (headers.containsKey('Authorization'))
        'Authorization': headers['Authorization']!,
    });

    // Backend expects metadata in 'data' field
    request.fields['data'] = jsonEncode(data);

    if (beforeImagePath != null && beforeImagePath.isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath('before', beforeImagePath),
      );
    }

    if (afterImagePath != null && afterImagePath.isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath('after', afterImagePath),
      );
    }

    debugPrint('POST Audit URL: $url');
    debugPrint('POST Audit Fields: ${request.fields}');

    return await request.send();
  }

  /// Update Audit After Image (Multipart)
  static Future<http.StreamedResponse> updateAuditAfterImage({
    required String auditId,
    String? afterImagePath,
  }) async {
    final headers = await _getHeaders();
    final url = ApiEndpoints.eventAuditAfterImage.replaceFirst(':id', auditId);
    final request = http.MultipartRequest('PATCH', Uri.parse(url));

    request.headers.addAll({
      if (headers.containsKey('Authorization'))
        'Authorization': headers['Authorization']!,
    });

    // The user says just image will update
    if (afterImagePath != null && afterImagePath.isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath('after', afterImagePath),
      );
    }

    debugPrint('PATCH Audit After Image URL: $url');

    return await request.send();
  }

  /// Run AI Audit Comparison (POST)
  static Future<http.Response> runAiAudit(String auditId) async {
    final url = ApiEndpoints.runAiAudit.replaceFirst(':id', auditId);
    return await post(url, {});
  }

  /// Get event missing items
  static Future<http.Response> getMissingItems(String eventId) async {
    final url = ApiEndpoints.missingItems.replaceFirst(':id', eventId);
    return await get(url);
  }

  /// Revoke a missing item (Found)
  static Future<http.Response> revokeMissingItem({
    required String auditId,
    required String itemId,
  }) async {
    final url = ApiEndpoints.revokeMissingItem
        .replaceFirst(':id', auditId)
        .replaceFirst(':itemId', itemId);
    return await patch(url, {});
  }
}
