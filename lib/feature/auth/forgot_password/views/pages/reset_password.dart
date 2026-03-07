import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/reset_password_controller.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});
  final ResetPasswordController controller = Get.put(ResetPasswordController());

  @override
  Widget build(BuildContext context) {
    // final sh = MediaQuery.of(context).size.height;
    // final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(),
    );
  }
}
