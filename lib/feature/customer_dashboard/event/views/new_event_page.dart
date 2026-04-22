import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:q45gofna6/core/constant/widgets/primary_button.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/widgets/global_form_layout.dart';
import '../controllers/event_controller.dart';
import 'select_event_items_page.dart';
import '../../inventory/controllers/inventory_controller.dart';

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
                controller.dateController.text = "${pickedDate.toLocal()}"
                    .split(' ')[0];
              }
            },
          ),
          SizedBox(height: 16.h),
          _buildInput(
            label: 'Event Name *',
            hintText: 'e.g., Conference 2026',
            controller: controller.nameController,
          ),
          SizedBox(height: 16.h),
          _buildInput(
            label: 'Event Note *',
            hintText: 'Enter notes',
            controller: controller.noteController,
          ),
          SizedBox(height: 16.h),
          _buildCategorySelection(context),
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
        onPressed: () async {
          if (controller.dateController.text.isEmpty) {
            EasyLoading.showError('Please select event date');
            return;
          }
          if (controller.nameController.text.isEmpty) {
            EasyLoading.showError('Please enter event name');
            return;
          }
          if (controller.selectedCategories.isEmpty) {
            EasyLoading.showError('Please select at least one category');
            return;
          }
          if (controller.noteController.text.isEmpty) {
            EasyLoading.showError('Please enter event note');
            return;
          }
          if (controller.selectedImagePath.value.isEmpty &&
              controller.existingImageUrl == null) {
            EasyLoading.showError('Please upload an item photo');
            return;
          }

          // Fetch items for selected categories and auto-select them
          await controller.fetchItemsBySelectedCategories();

          Get.to(() => const SelectEventItemsPage());
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
          style: GoogleFonts.inter(fontSize: 14.sp, color: AppColors.textColor),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppColors.boxTextColor.withOpacity(0.7),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
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
            child: Obx(
              () => DropdownButton<String>(
                isExpanded: true,
                value: controller.selectedStatus.value,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textColor,
                  size: 24.w,
                ),
                onChanged: (String? newValue) {
                  if (newValue != null)
                    controller.selectedStatus.value = newValue;
                },
                items: [
                  DropdownMenuItem(
                    value: 'ACTIVE',
                    child: Text(
                      'Active',
                      style: GoogleFonts.inter(fontSize: 14.sp),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'COMPLETED',
                    child: Text(
                      'Completed',
                      style: GoogleFonts.inter(fontSize: 14.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoUpload() {
    return GestureDetector(
      onTap: _showImageSourceActionSheet,
      child: Obx(() {
        final hasNewImage = controller.selectedImagePath.isNotEmpty;
        final existingUrl = controller.existingImageUrl;
        final hasAnyImage =
            hasNewImage || (existingUrl != null && existingUrl.isNotEmpty);

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.stockColor),
          ),
          padding: hasAnyImage
              ? EdgeInsets.symmetric(vertical: 16.h)
              : EdgeInsets.all(16.w),
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
                                image: FileImage(
                                  File(controller.selectedImagePath.value),
                                ),
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
                        Icon(
                          Icons.camera_alt_outlined,
                          color: const Color(0xFF6B9BF8),
                          size: 18.w,
                        ),
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
                    Icon(
                      Icons.center_focus_weak_outlined,
                      color: AppColors.textColor,
                      size: 24.w,
                    ),
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

  Widget _buildCategorySelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Category*',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.subTextColor,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(() {
          if (controller.selectedCategories.isEmpty) {
            return InkWell(
              onTap: () => _showCategorySelectionSheet(context),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.stockColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Categories',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: AppColors.boxTextColor.withOpacity(0.7),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, color: AppColors.textColor, size: 20.w),
                  ],
                ),
              ),
            );
          }
          return Wrap(
            spacing: 8.w,
            runSpacing: 4.h,
            children: [
              ...controller.selectedCategories.map((cat) => Chip(
                    label: Text(cat, style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.white)),
                    backgroundColor: AppColors.buttonColor,
                    deleteIcon: Icon(Icons.close, size: 14.w, color: Colors.white),
                    onDeleted: () => controller.selectedCategories.remove(cat),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                  )),
              ActionChip(
                label: Text('Add More', style: GoogleFonts.inter(fontSize: 12.sp, color: AppColors.buttonColor)),
                onPressed: () => _showCategorySelectionSheet(context),
                avatar: Icon(Icons.add, size: 14.w, color: AppColors.buttonColor),
                backgroundColor: AppColors.buttonColor.withOpacity(0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
              ),
            ],
          );
        }),
      ],
    );
  }

  void _showCategorySelectionSheet(BuildContext context) {
    final invController = Get.find<InventoryController>();
    final sh = MediaQuery.of(context).size.height;
    Get.bottomSheet(
      Container(
        height: sh * 0.9,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Categories',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Flexible(
              child: Obx(() {
                final availableCategories = invController.categories.where((c) => c != 'All').toList();
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: availableCategories.length,
                  itemBuilder: (context, index) {
                    final category = availableCategories[index];
                    return Obx(() {
                      final isSelected = controller.selectedCategories.contains(category);
                      return CheckboxListTile(
                        title: Text(
                          category,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: AppColors.textColor,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        value: isSelected,
                        activeColor: AppColors.buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        onChanged: (bool? value) {
                          if (value == true) {
                            controller.selectedCategories.add(category);
                          } else {
                            controller.selectedCategories.remove(category);
                          }
                        },
                      );
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(
                  'Done',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showImageSourceActionSheet() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Image Source',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 20.h),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.buttonColor),
              title: Text('Gallery', style: GoogleFonts.inter(fontSize: 16.sp, color: AppColors.textColor)),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.buttonColor),
              title: Text('Camera', style: GoogleFonts.inter(fontSize: 16.sp, color: AppColors.textColor)),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }
}
