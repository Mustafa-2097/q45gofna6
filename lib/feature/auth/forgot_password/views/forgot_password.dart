import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});
  final ForgotPasswordController controller = Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    // final sh = MediaQuery.of(context).size.height;
    // final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(),
    );
  }
}


