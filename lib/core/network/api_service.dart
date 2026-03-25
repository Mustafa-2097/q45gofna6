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
}
