import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:q45gofna6/core/constant/app_colors.dart';
import 'package:q45gofna6/core/constant/app_text_styles.dart';
import 'package:q45gofna6/feature/customer_dashboard/profile/controllers/profile_controller.dart';

class ProfileUpdatePage extends StatelessWidget {
  const ProfileUpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// AppBar
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 48.w, // Made the circle bigger
                      height: 48.w,
                      decoration: const BoxDecoration(
                        color: AppColors.whiteColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back, color: AppColors.textColor, size: 24.sp),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    'Profile',
                    style: AppTextStyles.title32(context).copyWith(color: AppColors.textColor),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              /// Profile Information
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 40.w,
                          width: 40.w,
                          decoration: const BoxDecoration(
                            color: Color(0xFF3B7ED5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: 24.w,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Profile Information',
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textColor,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Update your details',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.boxTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    const Divider(color: Color(0xFFF0F0F0)),
                    SizedBox(height: 16.h),
                    _buildInputField(
                      label: 'Full Name',
                      hintText: 'Enter your name',
                      controller: controller.nameController,
                    ),
                    SizedBox(height: 16.h),
                    _buildInputField(
                      label: 'Email',
                      hintText: 'your@email.com',
                      value: controller.userProfile.value?.email ?? '',
                      isReadOnly: true,
                      suffixIcon: Icon(
                        Icons.lock_outline,
                        size: 20.w,
                        color: AppColors.boxTextColor,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildInputField(
                      label: 'Company',
                      hintText: 'Enter company name',
                      controller: controller.companyController,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Photo',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.subTextColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildPhotoUpload(controller),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              /// Save Changes Button
              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value ? null : () => controller.updateProfile(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00388D), // Dark blue from screenshot
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Save Changes',
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                );
              }),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    TextEditingController? controller,
    String? value,
    bool isReadOnly = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.subTextColor,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller ?? (value != null ? TextEditingController(text: value) : null),
          readOnly: isReadOnly,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: AppColors.textColor,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppColors.boxTextColor.withOpacity(0.5),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            suffixIcon: suffixIcon,
            filled: isReadOnly,
            fillColor: isReadOnly ? const Color(0xFFF9F9F9) : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: isReadOnly ? const Color(0xFFE0E0E0) : AppColors.primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoUpload(ProfileController controller) {
    return GestureDetector(
      onTap: () async {
        final picker = ImagePicker();
        final image = await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          controller.selectedImagePath.value = image.path;
        }
      },
      child: Obx(() {
        final hasNewImage = controller.selectedImagePath.value.isNotEmpty;
        final existingAvatar = controller.userProfile.value?.profile.cleanedAvatarUrl;
        final hasAnyImage = hasNewImage || (existingAvatar != null && existingAvatar.isNotEmpty);
        
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: hasAnyImage ? 160.w : double.infinity,
              height: hasAnyImage ? 140.h : 60.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE0E0E0)),
                image: hasNewImage
                    ? DecorationImage(
                        image: FileImage(File(controller.selectedImagePath.value)),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4),
                          BlendMode.darken,
                        ),
                      )
                    : (existingAvatar != null && existingAvatar.isNotEmpty)
                        ? DecorationImage(
                            image: NetworkImage(existingAvatar),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.4),
                              BlendMode.darken,
                            ),
                          )
                        : null,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  hasAnyImage ? Icons.camera_alt_outlined : Icons.center_focus_weak_outlined,
                  color: hasAnyImage ? Colors.white : AppColors.textColor,
                  size: 24.w,
                ),
                SizedBox(width: 12.w),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasAnyImage ? 'Change Photo' : 'Upload / Capture Photo',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: hasAnyImage ? Colors.white : const Color(0xFF6B9BF8),
                      ),
                    ),
                    if (hasAnyImage)
                      Text(
                        'Tap to update picture',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
