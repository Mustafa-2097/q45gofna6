// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../feature/auth/sign_in/controllers/sign_in_controller.dart';
// import '../../../feature/auth/sign_in/views/sign_in_page.dart';
// import '../../../feature/user_flow/profile/controllers/personal_info_controller.dart';
// import '../../../feature/user_flow/profile/controllers/profile_controller.dart';
// import '../../offline_storage/shared_pref.dart';
// import '../app_colors.dart';
// import '../image_path.dart';
//
// class LogoutButton extends StatelessWidget {
//   const LogoutButton({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     //final controller = ProfileController.instance;
//     return Center(
//       child: TextButton(
//         onPressed: () {
//           Get.dialog(
//             Dialog(
//               backgroundColor: AppColors.whiteColor,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16.r),
//               ),
//               insetPadding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 100.h),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 40.h),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     ///Image
//                     Image.asset(ImagePath.logoutIcon, height: 120.h),
//                     SizedBox(height: 6.h),
//
//                     /// Title
//                     Text(
//                       'Are You Sure?',
//                       style: GoogleFonts.plusJakartaSans(color: AppColors.blackColor, fontSize: 18.sp, fontWeight: FontWeight.w600),
//                     ),
//                     SizedBox(height: 8.h),
//
//                     /// Subtitle
//                     Text(
//                       "Do you want to log out ?",
//                       textAlign: TextAlign.center,
//                       style: GoogleFonts.plusJakartaSans(color: AppColors.subTextColor, fontSize: 14.sp, fontWeight: FontWeight.w400),
//                     ),
//                     SizedBox(height: 20.h),
//
//                     /// Buttons
//                     Row(
//                       children: [
//                         Expanded(
//                           child: OutlinedButton(
//                             style: ElevatedButton.styleFrom(
//                               minimumSize: Size(double.infinity, 40.h),
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(24.r),
//                                   side: BorderSide(width: 1.5.w, color: AppColors.redColor)
//                               ),
//                               backgroundColor: AppColors.whiteColor,
//                             ),
//                             onPressed: () async {
//                               await SharedPreferencesHelper.clearToken();
//
//                               Get.delete<ProfileController>(force: true);
//                               Get.delete<PersonalInfoController>(force: true);
//                               Get.delete<SignInController>(force: true);
//
//                               Get.offAll(() => SignInPage());
//                             },
//
//                             child: Text(
//                               "Log Out",
//                               style: GoogleFonts.plusJakartaSans(color: AppColors.redColor, fontSize: 16.sp, fontWeight: FontWeight.w600),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 12.w),
//                         Expanded(
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               minimumSize: Size(double.infinity, 40.h),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(24.r),
//                               ),
//                               backgroundColor: AppColors.primaryColor,
//                             ),
//                             onPressed: () => Get.back(),
//                             child: Text(
//                               "Cancel",
//                               style: GoogleFonts.plusJakartaSans(color: AppColors.whiteColor, fontSize: 16.sp, fontWeight: FontWeight.w600),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             barrierDismissible: true,
//           );
//         },
//         child: Text(
//           "Logout",
//           style: GoogleFonts.plusJakartaSans(fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColors.redColor),
//         ),
//       ),
//     );
//   }
// }
