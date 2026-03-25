import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:q45gofna6/core/constant/app_colors.dart';
import 'package:q45gofna6/core/constant/app_text_styles.dart';
import 'package:q45gofna6/core/constant/widgets/auth_app_bar.dart';
import 'package:q45gofna6/core/constant/widgets/input_text_field.dart';
import 'package:q45gofna6/core/constant/widgets/label_text.dart';
import 'package:q45gofna6/core/constant/widgets/primary_button.dart';
import 'package:q45gofna6/feature/customer_dashboard/profile/controllers/change_password_controller.dart';

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({super.key});

  final ChangePasswordController controller = Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: const AuthAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),

              /// Title+SubTitle Text
              Center(
                child: Text(
                  "Create new password",
                  style: AppTextStyles.title24(context),
                ),
              ),
              SizedBox(height: 12.h),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    "Your new password must be unique from those previously used.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.regular_16(context),
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              // Current Password
              LabelText(context: context, text: "Current Password"),
              Obx(
                () => InputTextField(
                  controller: controller.currentPasswordController,
                  hintText: "Enter current password",
                  obscureText: controller.isCurrentPasswordHidden.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isCurrentPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.boxTextColor,
                    ),
                    onPressed: () {
                      controller.isCurrentPasswordHidden.value =
                          !controller.isCurrentPasswordHidden.value;
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // New Password
              LabelText(context: context, text: "New Password"),
              Obx(
                () => InputTextField(
                  controller: controller.newPasswordController,
                  hintText: "Enter new password",
                  obscureText: controller.isNewPasswordHidden.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isNewPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.boxTextColor,
                    ),
                    onPressed: () {
                      controller.isNewPasswordHidden.value =
                          !controller.isNewPasswordHidden.value;
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Confirm Password
              LabelText(context: context, text: "Confirm Password"),
              Obx(
                () => InputTextField(
                  controller: controller.confirmPasswordController,
                  hintText: "Confirm your password",
                  obscureText: controller.isConfirmPasswordHidden.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isConfirmPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.boxTextColor,
                    ),
                    onPressed: () {
                      controller.isConfirmPasswordHidden.value =
                          !controller.isConfirmPasswordHidden.value;
                    },
                  ),
                ),
              ),
              SizedBox(height: 48.h),

              // Change Password Button
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: "Change Password",
                  onPressed: () {
                    controller.changePassword();
                  },
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
