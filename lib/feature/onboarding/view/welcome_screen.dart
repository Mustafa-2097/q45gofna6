import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:q45gofna6/core/constant/widgets/primary_button.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/image_path.dart';
import '../../auth/Login/views/login_page.dart';
import '../../auth/registration/views/registration_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Brand Logo
            Image.asset(
              ImagePath.splashLogo,
              fit: BoxFit.cover,
              width: sw * 0.25,
            ),
            SizedBox(height: 30.h),

            /// Title+Subtitle
            Text("Welcome Back", style: AppTextStyles.title24(context)),
            SizedBox(height: 11.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 55.w),
              child: Text(
                "Log in to access your events and inventory.",
                style: AppTextStyles.regular_16(context),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 50.h),

            /// Login+SignUp Buttons
            PrimaryButton(text: "login", onPressed: () => Get.to(() => LoginPage())),
            SizedBox(height: 11.h),
            PrimaryButton(text: "Sign Up", onPressed: () => Get.to(() => RegistrationPage())),
          ],
        ),
      ),
    );
  }
}
