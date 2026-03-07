import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_text_styles.dart';
import '../../../core/constant/image_path.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          const Spacer(flex: 5),

          /// Brand Logo
          Image.asset(
            ImagePath.splashLogo,
            fit: BoxFit.contain,
            width: sw * 0.46,
          ),

          const Spacer(flex: 4),

          /// Loading Indicator
          SpinKitCircle(color: AppColors.whiteColor, size: sw * 0.23),
          SizedBox(height: 12.h),

          /// Footer Text
          Text("Preparing your inventory...", style: AppTextStyles.regular_16(context)),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }
}
