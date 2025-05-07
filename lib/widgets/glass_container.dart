import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:visa_app/theme/app_theme.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color color;
  final double opacity;
  final double blur;
  final Border? border;
  final Gradient? gradient;

  const GlassContainer({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.borderRadius = AppTheme.radiusMedium,
    this.padding = const EdgeInsets.all(AppTheme.spacingM),
    this.margin = EdgeInsets.zero,
    this.color = AppTheme.backgroundLighter,
    this.opacity = AppTheme.glassOpacityMedium,
    this.blur = AppTheme.blurMedium,
    this.border,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: gradient,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              color: color.withOpacity(opacity),
              borderRadius: BorderRadius.circular(borderRadius),
              border: border ?? Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1.5,
              ),
            ),
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
} 