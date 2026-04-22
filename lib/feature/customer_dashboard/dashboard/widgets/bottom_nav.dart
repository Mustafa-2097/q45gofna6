import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constant/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                0,
                "assets/icons/home.png",
                "assets/icons/home_selected.png",
                'Home',
              ),
              _buildNavItem(
                1,
                "assets/icons/inventory.png",
                "assets/icons/inventory_selected.png",
                'Inventory',
              ),_buildNavItem(
                2,
                "assets/icons/event.png",
                "assets/icons/event_selected.png",
                'Event',
              ),
              _buildNavItem(
                3,
                "assets/icons/reports.png",
                "assets/icons/reports_selected.png",
                'Reports',
              ),
              _buildNavItem(
                4,
                "assets/icons/profile.png",
                "assets/icons/profile_selected.png",
                'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    String outlinedIcon,
    String filledIcon,
    String label,
  ) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: isSelected
            ? BoxDecoration(borderRadius: BorderRadius.circular(12.r), color: AppColors.primaryColor.withValues(alpha: 0.1),)
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              isSelected ? filledIcon : outlinedIcon,
              width: 28.w,
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.textColor,
                fontSize: 14.sp,
                fontFamily: "Roboto",
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
