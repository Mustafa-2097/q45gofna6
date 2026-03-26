class ApiEndpoints {
  /// Base URL
  static const String baseUrl = 'http://206.162.244.189:5005/api/v1';

  /// Auth
  static const String register = '$baseUrl/auth/register';
  static const String resendSignUpOtp = '$baseUrl/auth/send-otp';
  static const String verifySigUupOtp = '$baseUrl/auth/verify-otp';

  static const String login = '$baseUrl/auth/login';
  static const String logout = '$baseUrl/auth/logout';


  /// Forgot Password
  static const String sendResetOtp = '$baseUrl/auth/send-otp/password-reset';
  static const String verifyResetOtp = '$baseUrl/auth/verify-otp/password-reset';
  /// Reset password (NEW)
  static const String resetPassword = '$baseUrl/auth/reset-password';

  // Change Password
  static const String changePassword = '$baseUrl/auth/change-password';


  /// User / Profile
  static const String profile = '$baseUrl/profile';
  static const String updateProfile = '$baseUrl/profile';
  //static const String updateAvatar = '$baseUrl/me/avatar';
  static const String statistics = '$baseUrl/profile/statistics';
  //
  static const String contact = '$baseUrl/me/contact';
  static const String educateEmployee = '$baseUrl/me/educate-employee';


  /// Categories
  static const String categories = '$baseUrl/categories';

  /// Events
  static const String inventory = '$baseUrl/inventory-items';
  static const String inventoryUpdate= '$baseUrl/inventory-items/:id';
  static const String inventoryDelete = '$baseUrl/inventory-items/:id';
  static const String inventoryStatistics = '$baseUrl/inventory-items/statistics';


  /// Courses
  static const String courses = '$baseUrl/courses';
  static const String nextVideo = '$baseUrl/courses/:id/next-video';


  // Lesson's Review
  static const String review = '$baseUrl/lessons/:id/review';

  // Exam questions
  static const String questions = '$baseUrl/lessons/:id/questions';

}



