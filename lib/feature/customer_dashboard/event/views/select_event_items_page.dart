import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/widgets/primary_button.dart';
import '../../../../core/constant/widgets/item_card_widget.dart';
import 'event_details_page.dart';

class SelectEventItemsPage extends StatefulWidget {
  const SelectEventItemsPage({super.key});

  @override
  State<SelectEventItemsPage> createState() => _SelectEventItemsPageState();
}

class _SelectEventItemsPageState extends State<SelectEventItemsPage> {
  final List<String> categories = ['Table', 'Camera', 'Flower', 'Stage'];
  String selectedCategory = 'Camera';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    _buildSummaryCard(),
                    SizedBox(height: 16.h),
                    _buildSelectItemsHeader(),
                    SizedBox(height: 16.h),
                    _buildSearchBar(),
                    SizedBox(height: 16.h),
                    _buildCategories(),
                    SizedBox(height: 20.h),
                    _buildItemsGrid(),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: PrimaryButton(
                text: "Create Event",
                onPressed: () {
                  Get.to(() => const EventDetailsPage());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Row(
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                color: AppColors.textColor,
                size: 20.w,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            'New Event',
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF4579D6),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Items',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '2',
                    style: GoogleFonts.inter(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 24.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Divider(color: Colors.white.withOpacity(0.2)),
          SizedBox(height: 16.h),
          Text(
            'Total Kit Value',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '\$2,950',
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectItemsHeader() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Items',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '4 items available',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: AppColors.boxTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey, size: 20.w),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: '',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final isSelected = selectedCategory == category;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.buttonColor : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                category,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textColor,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildItemsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16.w,
      crossAxisSpacing: 16.w,
      childAspectRatio: 0.75,
      children: [
        _buildItemCard(
          name: 'Professional Camera',
          category: 'Photography',
          price: '\$2,500',
          imageUrl:
              'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=800&auto=format&fit=crop',
        ),
        _buildItemCard(
          name: 'Wireless Microphone',
          category: 'Audio',
          price: '\$450',
          imageUrl:
              'https://images.unsplash.com/photo-1598653222000-6b7b7a552625?q=80&w=800&auto=format&fit=crop',
        ),
        _buildItemCard(
          name: 'Wireless Microphone',
          category: 'Audio',
          price: '\$450',
          imageUrl:
              'https://images.unsplash.com/photo-1598653222000-6b7b7a552625?q=80&w=800&auto=format&fit=crop',
        ),
        _buildItemCard(
          name: 'Wireless Microphone',
          category: 'Audio',
          price: '\$450',
          imageUrl:
              'https://images.unsplash.com/photo-1598653222000-6b7b7a552625?q=80&w=800&auto=format&fit=crop',
        ),
      ],
    );
  }

  Widget _buildItemCard({
    required String name,
    required String category,
    required String price,
    required String imageUrl,
  }) {
    return ItemCardWidget(
      name: name,
      category: category,
      price: price,
      imageUrl: imageUrl,
      quantity: 1, // Example static quantity for UI representation
      onDecrease: () {},
      onIncrease: () {},
      onDelete: () {},
      showQuantityControls: true,
    );
  }
}
