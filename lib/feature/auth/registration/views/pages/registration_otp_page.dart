import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:q45gofna6/core/constant/app_colors.dart';
import 'package:q45gofna6/core/constant/app_text_styles.dart';
import 'package:q45gofna6/core/constant/widgets/primary_button.dart';
import 'package:q45gofna6/core/constant/widgets/auth_app_bar.dart';
import '../../../../../core/constant/widgets/otpbox.dart';

class RegistrationOtpPage extends StatelessWidget {
  const RegistrationOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: const AuthAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30.h),
              Text("Enter OTP", style: AppTextStyles.title24(context)),
              SizedBox(height: 10.h),
              Text(
                "We have just sent you 4 digit code via your\nemail example@gmail.com",
                textAlign: TextAlign.center,
                style: AppTextStyles.regular_16(context),
              ),
              SizedBox(height: 30.h),

              // Custom OTP Box tailored to the UI (4 circles)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: OtpBox(),
              ),
              SizedBox(height: 30.h),

              PrimaryButton(
                text: "Continue",
                onPressed: () {
                  // TODO: Handle OTP Verification then go to Home Login
                },
              ),
              SizedBox(height: 20.h),

              RichText(
                text: TextSpan(
                  text: "Didn’t receive code? ",
                  style: AppTextStyles.regular_16(
                    context,
                  ).copyWith(color: AppColors.textColor),
                  children: [
                    TextSpan(
                      text: "Resend Code",
                      style: AppTextStyles.bold_16(
                        context,
                      ).copyWith(color: AppColors.buttonColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Handle Resend logic
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
