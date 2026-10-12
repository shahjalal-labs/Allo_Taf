import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/constants/app_colors.dart';
import 'custom_text.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final AppFont font;
  final TextStyle? textStyle;
  final bool isPassword;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final int? minLines;

  // Icons & Design customization
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color fillColor;
  final bool filled;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.font = AppFont.inter,
    this.textStyle,
    this.isPassword = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor = AppColors.whiteColor,
    this.filled = true,
    this.borderRadius =
        15.0, // Default changed to 15.0 to match design screenshots
    this.contentPadding,
    this.maxLines,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedTextStyle =
        textStyle ?? const TextStyle(fontSize: 14, color: Colors.black87);

    // Subtle tint border colors derived from app theme colors
    final Color defaultBorderColor = AppColors.primaryColor.withValues(
      alpha: 0.15,
    );
    final Color focusBorderColor = AppColors.primaryColor;

    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      minLines: minLines,
      style: _getFontWithStyle(font, resolvedTextStyle),
      decoration: InputDecoration(
        filled: filled,
        fillColor: fillColor,

        label: labelText != null
            ? CustomText(
                labelText!,
                font: font,
                color: Colors.grey[600],
                fontSize: 14,
              )
            : null,

        hintText: hintText,
        hintStyle: _getFontWithStyle(
          font,
          TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),

        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: defaultBorderColor, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: defaultBorderColor, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: focusBorderColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: AppColors.redColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: AppColors.redColor, width: 1.5),
        ),
      ),
    );
  }

  TextStyle _getFontWithStyle(AppFont appFont, TextStyle baseStyle) {
    switch (appFont) {
      case AppFont.impact:
        return baseStyle.copyWith(fontFamily: 'Impact');
      case AppFont.roboto:
        return GoogleFonts.roboto(textStyle: baseStyle);
      case AppFont.poppins:
        return GoogleFonts.poppins(textStyle: baseStyle);
      case AppFont.inter:
        return GoogleFonts.inter(textStyle: baseStyle);
    }
  }
}
