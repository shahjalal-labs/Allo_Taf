import 'package:flutter/material.dart';

import '../../../../core/global/custom_text.dart';
import '../../../../core/utils/constants/app_colors.dart';

class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    required this.context,
    required this.hintText,
    this.displayDate, // This will now receive a String from the controller
    required this.onTap,
  });

  final BuildContext context;
  final String hintText;
  final String? displayDate; // Changed from DateTime? to String?
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryColor.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomText(
                // If displayDate is null or empty, show the hintText
                (displayDate == null || displayDate!.isEmpty)
                    ? hintText
                    : displayDate!,
                font: AppFont.inter,
                fontSize: 14,
                color: (displayDate == null || displayDate!.isEmpty)
                    ? Colors.grey[400]
                    : Colors.black87,
              ),
            ),
            Icon(
              Icons.calendar_today_outlined,
              color: Colors.grey[500],
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
