import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';

class SelectionSelectorField extends StatelessWidget {
  const SelectionSelectorField({
    super.key,
    required this.hintText,
    this.displayValue,
    this.onTap,
  });

  final String hintText;
  final String? displayValue;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryColor.withValues(alpha: 0.4),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                displayValue ?? hintText,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: displayValue == null
                      ? Colors.grey[400]
                      : Colors.black87,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey[500], size: 22),
          ],
        ),
      ),
    );
  }
}
