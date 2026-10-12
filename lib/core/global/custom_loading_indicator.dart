import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../utils/constants/app_colors.dart';

class CustomLoadingIndicator extends StatefulWidget {
  final double size;
  final Color color;

  const CustomLoadingIndicator({
    super.key,
    this.size = 40.0,
    this.color = AppColors.primaryColor,
  });

  @override
  State<CustomLoadingIndicator> createState() => _CustomLoadingIndicatorState();
}

class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animationController.value * 2 * math.pi,
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _TaperedDotRingPainter(color: widget.color),
          ),
        );
      },
    );
  }
}

class _TaperedDotRingPainter extends CustomPainter {
  final Color color;
  final int dotCount = 8;

  _TaperedDotRingPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double center = size.width / 2;
    final double outerRadius = size.width / 2;
    final Paint paint = Paint();

    for (int i = 0; i < dotCount; i++) {
      final double angle = (i * 2 * math.pi) / dotCount;
      final double x = center + (outerRadius - 6) * math.cos(angle);
      final double y = center + (outerRadius - 6) * math.sin(angle);

      final double scaleFactor = (i + 1) / dotCount;
      final double dotRadius = 3.5 * scaleFactor;

      paint.color = color.withAlpha((scaleFactor * 255).round());
      canvas.drawCircle(Offset(x, y), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
