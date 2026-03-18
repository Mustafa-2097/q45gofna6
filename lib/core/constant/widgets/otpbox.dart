import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../app_colors.dart';
import '../app_text_styles.dart';

class OtpBox extends StatelessWidget {
  final Function(String)? onChanged;
  final TextEditingController? controller;
  const OtpBox({super.key, this.onChanged, this.controller});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      controller: controller,
      length: 4,
      keyboardType: TextInputType.number,
      cursorColor: AppColors.textColor,
      textStyle: AppTextStyles.title24(context),
      animationType: AnimationType.fade,
      enableActiveFill: true,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.circle,
        borderRadius: BorderRadius.circular(12.r),
        fieldHeight: 50.h, // using width for perfect circle
        fieldWidth: 50.w,
        activeFillColor: AppColors.whiteColor,
        inactiveFillColor: AppColors.whiteColor,
        selectedFillColor: AppColors.buttonColor,
        activeColor: Colors.transparent,
        inactiveColor: Colors.transparent,
        selectedColor: Colors.transparent,
        borderWidth: 1,
      ),
      onChanged: onChanged ?? (value) {},
    );
    // return PinCodeTextField(
    //   appContext: context,
    //   length: 6,
    //   keyboardType: TextInputType.number,
    //   cursorColor: AppColors.textColor,
    //   textStyle: AppTextStyles.title24(context),
    //   animationType: AnimationType.fade,
    //   pinTheme: PinTheme(
    //     shape: PinCodeFieldShape.box,
    //     borderRadius: BorderRadius.circular(12.r),
    //     fieldHeight: 50.h,
    //     fieldWidth: 50.w,
    //     activeColor: AppColors.whiteColor,
    //     selectedColor: AppColors.whiteColor,
    //   ),
    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //   onChanged: onChanged,
    // );
  }
}
