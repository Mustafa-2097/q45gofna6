import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_colors.dart';

class ItemCardWidget extends StatelessWidget {
  final String name;
  final String category;
  final String price;
  final String imageUrl;
  final int stock;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final bool showQuantityControls;
  final int quantity;

  const ItemCardWidget({
    super.key,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    this.stock = 0,
    this.onDelete,
    this.onEdit,
    this.onIncrease,
    this.onDecrease,
    this.showQuantityControls = true,
    this.quantity = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
          Expanded(
            child: Stack(
              children: [
                // Image
                Container(
                  margin: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F1CF),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 40.w,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // 3-dot menu top right
                if (onEdit != null || onDelete != null)
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: _ThreeDotMenu(onEdit: onEdit, onDelete: onDelete),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 6.h, 12.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  category,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: AppColors.boxTextColor,
                  ),
                ),
                SizedBox(height: 8.h),
                if (showQuantityControls)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2E61E6),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: onDecrease,
                            child: Icon(Icons.remove_circle_outline,
                                color: AppColors.redColor, size: 18.w),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            quantity.toString(),
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          GestureDetector(
                            onTap: onIncrease,
                            child: Icon(Icons.add_circle_outline,
                                color: const Color(0xFF1B4E9B), size: 18.w),
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  // Inventory card style: price + stock side by side
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2E61E6),
                        ),
                      ),
                      Text(
                        stock.toString(),
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThreeDotMenu extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _ThreeDotMenu({this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') onEdit?.call();
        if (value == 'delete') onDelete?.call();
      },
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(minWidth: 130.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 4,
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(Icons.more_vert, size: 16.w, color: AppColors.textColor),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 16.w, color: AppColors.buttonColor),
              SizedBox(width: 8.w),
              Text(
                'Edit',
                style: TextStyle(fontSize: 13.sp, color: AppColors.textColor),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 16.w, color: AppColors.redColor),
              SizedBox(width: 8.w),
              Text(
                'Delete',
                style: TextStyle(fontSize: 13.sp, color: AppColors.redColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
