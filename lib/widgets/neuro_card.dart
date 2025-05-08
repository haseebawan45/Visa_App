import 'package:flutter/material.dart';
import 'package:visa_app/theme/app_theme.dart';

class NeuroCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color color;
  final double borderRadius;
  final bool isPressed;
  final GestureTapCallback? onTap;
  final double depth;
  final BoxShape shape;
  final Gradient? gradient;
  final LinearGradient? highlightGradient;
  final Color? glow;

  const NeuroCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(AppTheme.spacingM),
    this.margin = EdgeInsets.zero,
    this.color = AppTheme.cardDark,
    this.borderRadius = AppTheme.radiusMedium,
    this.isPressed = false,
    this.onTap,
    this.depth = AppTheme.neumorphDepth,
    this.shape = BoxShape.rectangle,
    this.gradient,
    this.highlightGradient,
    this.glow,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRectangle = shape == BoxShape.rectangle;
    final BorderRadius? borderRadiusObj = isRectangle 
        ? BorderRadius.circular(borderRadius) 
        : null;

    final LinearGradient defaultHighlightGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpacity(0.05), 
        Colors.transparent,
      ],
      stops: const [0.0, 0.5],
    );

    final effectiveHightlightGradient = highlightGradient ?? defaultHighlightGradient;

    final Offset distantShadowOffset = isPressed 
        ? const Offset(0, 0) 
        : Offset(depth / 2, depth / 2);
    
    final Offset closeShadowOffset = isPressed 
        ? const Offset(0, 0) 
        : Offset(-depth / 2, -depth / 2);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppTheme.animFast,
        curve: Curves.easeOut,
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: color,
          shape: shape,
          borderRadius: borderRadiusObj,
          gradient: gradient,
          boxShadow: [
            // Glow effect if specified
            if (glow != null)
              BoxShadow(
                color: glow!.withOpacity(0.6),
                blurRadius: depth * 2.5,
                spreadRadius: depth * 0.8,
              ),
            // Distant shadow (bottom-right)
            BoxShadow(
              color: AppTheme.neumorphDarkShadow,
              offset: distantShadowOffset,
              blurRadius: depth * 1.5,
              spreadRadius: depth * 0.2,
            ),
            // Close shadow (top-left)
            BoxShadow(
              color: AppTheme.neumorphLightShadow,
              offset: closeShadowOffset,
              blurRadius: depth * 1.5,
              spreadRadius: depth * 0.2,
            ),
          ],
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            shape: shape,
            borderRadius: borderRadiusObj,
            gradient: isPressed ? null : effectiveHightlightGradient,
          ),
          child: child,
        ),
      ),
    );
  }
} 