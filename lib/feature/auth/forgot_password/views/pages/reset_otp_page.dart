import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/reset_otp_controller.dart';

class VerificationCodePage extends StatelessWidget {
  VerificationCodePage({super.key});
  final ResetOtpController controller = Get.put(ResetOtpController());

  @override
  Widget build(BuildContext context) {
    // final sh = MediaQuery.of(context).size.height;
    // final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(),
    );
  }
}


