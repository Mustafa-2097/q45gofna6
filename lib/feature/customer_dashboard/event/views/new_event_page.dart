import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q45gofna6/core/constant/widgets/primary_button.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/widgets/global_form_layout.dart';
import '../controllers/event_controller.dart';
import 'select_event_items_page.dart';

class NewEventPage extends StatelessWidget {
  NewEventPage({super.key});
  final EventController controller = Get.find<EventController>();

  @override
  Widget build(BuildContext context) {
    return GlobalFormLayout(
      title: controller.editEventId != null ? 'Edit Event' : 'New Event',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Event Details',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: 20.h),
          _buildInput(
            label: 'Event Date *', 
            hintText: 'Select date', 
            controller: controller.dateController,
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                controller.dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
              }
            },
          ),
          SizedBox(height: 16.h),
          _buildInput(label: 'Event Name *', hintText: 'e.g., Conference 2026', controller: controller.nameController),
          SizedBox(height: 16.h),
          _buildInput(label: 'Event Note *', hintText: 'Enter notes', controller: controller.noteController),
          SizedBox(height: 16.h),
          _buildDropdown(label: 'Event Status*'),
          SizedBox(height: 16.h),
          Text(
            'Item Photo*',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.subTextColor,
            ),
          ),
          SizedBox(height: 8.h),
          _buildPhotoUpload(),
        ],
      ),
      bottomButton: PrimaryButton(
        text: "Next",
        onPressed: () {
          if (controller.dateController.text.isEmpty) {
            EasyLoading.showError('Please select event date');
            return;
          }
          if (controller.nameController.text.isEmpty) {
            EasyLoading.showError('Please enter event name');
            return;
          }
          if (controller.noteController.text.isEmpty) {
            EasyLoading.showError('Please enter event note');
            return;
          }
          if (controller.selectedImagePath.value.isEmpty && controller.existingImageUrl == null) {
            EasyLoading.showError('Please upload an item photo');
            return;
          }
          Get.to(() => SelectEventItemsPage());
        },
      ),
    );
  }

  Widget _buildInput({
    required String label, 
    required String hintText, 
    required TextEditingController controller,
    bool readOnly = false,
    VoidCallback? onTap,
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
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: AppColors.textColor,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppColors.boxTextColor.withOpacity(0.7),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.stockColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.stockColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.buttonColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({required String label}) {
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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.stockColor, width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: Obx(() => DropdownButton<String>(
              isExpanded: true,
              value: controller.selectedStatus.value,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textColor,
                size: 24.w,
              ),
              onChanged: (String? newValue) {
                if (newValue != null) controller.selectedStatus.value = newValue;
              },
              items: [
                DropdownMenuItem(value: 'ACTIVE', child: Text('Active', style: GoogleFonts.inter(fontSize: 14.sp))),
                DropdownMenuItem(value: 'COMPLETED', child: Text('Completed', style: GoogleFonts.inter(fontSize: 14.sp))),
              ],
            )),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoUpload() {
    return GestureDetector(
      onTap: controller.pickImage,
      child: Obx(() {
        final hasNewImage = controller.selectedImagePath.isNotEmpty;
        final existingUrl = controller.existingImageUrl;
        final hasAnyImage = hasNewImage || (existingUrl != null && existingUrl.isNotEmpty);
        
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.stockColor),
          ),
          padding: hasAnyImage ? EdgeInsets.symmetric(vertical: 16.h) : EdgeInsets.all(16.w),
          child: hasAnyImage 
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 160.w,
                    height: 140.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      image: hasNewImage
                          ? DecorationImage(
                              image: FileImage(File(controller.selectedImagePath.value)),
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
                              image: NetworkImage(existingUrl!),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined, color: const Color(0xFF6B9BF8), size: 18.w),
                      SizedBox(width: 8.w),
                      Text(
                        'Change Photo',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6B9BF8),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                children: [
                  Icon(Icons.center_focus_weak_outlined, color: AppColors.textColor, size: 24.w),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Upload / Capture Photo',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF6B9BF8),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Helps with visual Identification during audits',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.boxTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        );
      }),
    );
  }
}

