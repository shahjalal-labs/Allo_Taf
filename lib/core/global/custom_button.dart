import 'package:flutter/material.dart';

import '../utils/constants/app_colors.dart';
import 'custom_text.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  final Color backgroundColor;
  final AppFont font;
  final TextStyle? textStyle;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final bool isLoading;
  final Color? loadingIndicatorColor;

  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final double spacing;

  final Border? border;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.backgroundColor = AppColors.primaryColor,
    this.font = AppFont.inter,
    this.textStyle,
    this.width,
    this.height = 50.0,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.isLoading = false,
    this.loadingIndicatorColor = Colors.white,
    this.prefixWidget,
    this.suffixWidget,
    this.spacing = 8.0,
    this.border,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.isLoading ? null : widget.onTap,
        onTapDown: (_) {
          if (!widget.isLoading) {
            setState(() => _isPressed = true);
          }
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
        },
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: widget.padding,
          decoration: BoxDecoration(
            border: widget.border,
            color: widget.isLoading
                ? widget.backgroundColor.withValues(alpha: 0.7)
                : widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: widget.height * 0.5,
                    height: widget.height * 0.5,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.loadingIndicatorColor!,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.prefixWidget != null) ...[
                        widget.prefixWidget!,
                        SizedBox(width: widget.spacing),
                      ],
                      CustomText(
                        widget.text,
                        font: widget.font,
                        fontSize: widget.textStyle?.fontSize ?? 16,
                        fontWeight:
                            widget.textStyle?.fontWeight ?? FontWeight.bold,
                        color: widget.textStyle?.color ?? Colors.white,
                        letterSpacing: widget.textStyle?.letterSpacing,
                        height: widget.textStyle?.height,
                      ),
                      if (widget.suffixWidget != null) ...[
                        SizedBox(width: widget.spacing),
                        widget.suffixWidget!,
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
