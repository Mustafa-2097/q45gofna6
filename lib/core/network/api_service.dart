import 'dart:convert';
import 'dart:developer';
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
      return {
        ..._defaultHeaders,
        'Authorization': token,
      };
    }
    return _defaultHeaders;
  }

  /// POST Request
  static Future<http.Response> post(String url, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    log('POST URL: $url');
    log('POST Body: ${jsonEncode(body)}');
    
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
    
    log('Response Status: ${response.statusCode}');
    log('Response Body: ${response.body}');
    return response;
  }

  /// GET Request
  static Future<http.Response> get(String url) async {
    final headers = await _getHeaders();
    log('GET URL: $url');
    
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    
    log('Response Status: ${response.statusCode}');
    log('Response Body: ${response.body}');
    return response;
  }

  /// DELETE Request
  static Future<http.Response> delete(String url) async {
    final headers = await _getHeaders();
    log('DELETE URL: $url');
    final response = await http.delete(Uri.parse(url), headers: headers);
    log('Response Status: ${response.statusCode}');
    log('Response Body: ${response.body}');
    return response;
  }

  // ================= AUTH METHODS =================

  /// Login
  static Future<http.Response> login({required String email, required String password}) async {
    final body = {
      'email': email,
      'password': password,
    };
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
  static Future<http.Response> verifySignUpOtp({required String email, required String otp}) async {
    final body = {
      'email': email,
      'otp': otp,
    };
    return await post(ApiEndpoints.verifySigUupOtp, body);
  }

  /// Resend Sign Up OTP
  static Future<http.Response> resendSignUpOtp({required String email}) async {
    final body = {
      'email': email,
    };
    return await post(ApiEndpoints.resendSignUpOtp, body);
  }

  /// Send Reset Password OTP
  static Future<http.Response> sendResetOtp({required String email}) async {
    final body = {
      'email': email,
    };
    return await post(ApiEndpoints.sendResetOtp, body);
  }

  /// Verify Reset Password OTP
  static Future<http.Response> verifyResetOtp({required String email, required String otp}) async {
    final body = {
      'email': email,
      'otp': otp,
    };
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
    final body = {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };
    return await post(ApiEndpoints.changePassword, body);
  }
  
  /// Get Profile
  static Future<http.Response> getProfile() async {
    return await get(ApiEndpoints.profile);
  }

  /// Get Statistics
  static Future<http.Response> getStatistics() async {
    return await get(ApiEndpoints.statistics);
  }

  /// Update Profile
  static Future<http.StreamedResponse> updateProfile({
    required Map<String, dynamic> data,
    String? imagePath,
  }) async {
    final headers = await _getHeaders();
    final request = http.MultipartRequest('PATCH', Uri.parse(ApiEndpoints.updateProfile));

    request.headers.addAll({
      if (headers.containsKey('Authorization'))
        'Authorization': headers['Authorization']!
    });
    
    request.fields['data'] = jsonEncode(data);

    if (imagePath != null && imagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('avatar', imagePath));
    }

    log('PATCH Profile URL: ${ApiEndpoints.updateProfile}');
    log('PATCH Profile Fields: ${request.fields}');
    
    return await request.send();
  }
  // ================= CATEGORIES METHODS =================
  
  /// Get Categories
  static Future<http.Response> getCategories() async {
    return await get(ApiEndpoints.categories);
  }

  /// Create Category
  static Future<http.Response> createCategory({required String name}) async {
    final body = {
      'name': name,
    };
    return await post(ApiEndpoints.categories, body);
  }

  // ================= INVENTORY METHODS =================
  
  /// Get Inventory Items
  static Future<http.Response> getInventoryItems() async {
    return await get(ApiEndpoints.inventory);
  }

  /// Create Inventory Item
  static Future<http.StreamedResponse> createInventoryItemWithImage({
    required Map<String, dynamic> data,
    String? imagePath,
  }) async {
    final headers = await _getHeaders();
    final request = http.MultipartRequest('POST', Uri.parse(ApiEndpoints.inventory));

    request.headers.addAll({
      if (headers.containsKey('Authorization'))
        'Authorization': headers['Authorization']!
    });
    
    request.fields['data'] = jsonEncode(data);

    if (imagePath != null && imagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    log('POST Multipart URL: ${ApiEndpoints.inventory}');
    log('POST Multipart Fields: ${request.fields}');
    
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
        'Authorization': headers['Authorization']!
    });

    request.fields['data'] = jsonEncode(data);

    if (imagePath != null && imagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    log('PATCH Multipart URL: $url');
    log('PATCH Multipart Fields: ${request.fields}');

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
}
