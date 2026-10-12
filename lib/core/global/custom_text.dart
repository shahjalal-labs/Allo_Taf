import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppFont { inter, roboto, poppins, impact }

class CustomText extends StatelessWidget {
  final String text;
  final AppFont font;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextDecoration? decoration;
  final double? letterSpacing;
  final double? height;
  final FontStyle? fontStyle;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Locale? locale;
  final bool? softWrap;

  // 🚀 Fixed constructor parameter signatures:
  const CustomText(
    this.text, {
    super.key,
    this.font = AppFont.inter,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.decoration,
    this.letterSpacing,
    this.height,
    this.fontStyle,
    this.textDirection,
    this.textBaseline,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.locale,
    this.softWrap,
  });

  // Helper method to resolve the base font style
  TextStyle _getFontStyle() {
    switch (font) {
      case AppFont.impact:
        return const TextStyle(fontFamily: 'Impact');
      case AppFont.roboto:
        return GoogleFonts.roboto();
      case AppFont.poppins:
        return GoogleFonts.poppins();
      case AppFont.inter:
        return GoogleFonts.inter();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow ?? TextOverflow.ellipsis,
      maxLines: maxLines,
      textDirection: textDirection,
      textHeightBehavior: textHeightBehavior,
      textWidthBasis: textWidthBasis,
      softWrap: softWrap,
      style: _getFontStyle().copyWith(
        fontSize: fontSize?.sp,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
        letterSpacing: letterSpacing,
        height: height,
        fontStyle: fontStyle,
        textBaseline: textBaseline,
        locale: locale,
      ),
    );
  }
}
