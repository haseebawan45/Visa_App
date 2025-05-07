import 'package:flutter/material.dart';
import 'package:visa_app/theme/app_theme.dart';

class FuturisticButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final double height;
  final double width;
  final double borderRadius;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isLoading;
  final bool isOutlined;
  final bool isGlowing;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  const FuturisticButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.height = 56.0,
    this.width = double.infinity,
    this.borderRadius = AppTheme.radiusMedium,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.isOutlined = false,
    this.isGlowing = true,
    this.gradient,
    this.padding,
    this.textStyle,
  });

  @override
  State<FuturisticButton> createState() => _FuturisticButtonState();
}

class _FuturisticButtonState extends State<FuturisticButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppTheme.animFast,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isLoading) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isLoading) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  void _handleTapCancel() {
    if (!widget.isLoading) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ?? AppTheme.primaryNeon;
    final effectiveTextColor = widget.textColor ?? (widget.isOutlined ? effectiveColor : Colors.black);
    
    final defaultGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        effectiveColor,
        Color.lerp(effectiveColor, AppTheme.backgroundDarker, 0.3) ?? effectiveColor,
      ],
    );
    
    final effectiveGradient = widget.gradient ?? (widget.isOutlined ? null : defaultGradient);
    
    final effectiveTextStyle = widget.textStyle ?? 
      TextStyle(
        color: effectiveTextColor,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      );

    final effectivePadding = widget.padding ?? 
      EdgeInsets.symmetric(
        horizontal: AppTheme.spacingL,
        vertical: AppTheme.spacingM,
      );

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: widget.isLoading ? null : widget.onPressed,
            child: Container(
              height: widget.height,
              width: widget.width,
              decoration: BoxDecoration(
                color: widget.isOutlined ? Colors.transparent : null,
                gradient: effectiveGradient,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: widget.isOutlined ? Border.all(
                  color: effectiveColor,
                  width: 2.0,
                ) : null,
                boxShadow: widget.isGlowing && !widget.isOutlined ? [
                  BoxShadow(
                    color: effectiveColor.withOpacity(_isPressed ? 0.4 : 0.2),
                    blurRadius: 15.0,
                    spreadRadius: 1.0,
                  ),
                ] : null,
              ),
              child: Material(
                type: MaterialType.transparency,
                child: Padding(
                  padding: effectivePadding,
                  child: Center(
                    child: widget.isLoading
                    ? SizedBox(
                        height: 24.0,
                        width: 24.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: effectiveTextColor,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.prefixIcon != null) ...[
                            Icon(
                              widget.prefixIcon,
                              color: effectiveTextColor,
                              size: 18.0,
                            ),
                            SizedBox(width: AppTheme.spacingS),
                          ],
                          Text(
                            widget.text,
                            style: effectiveTextStyle,
                          ),
                          if (widget.suffixIcon != null) ...[
                            SizedBox(width: AppTheme.spacingS),
                            Icon(
                              widget.suffixIcon,
                              color: effectiveTextColor,
                              size: 18.0,
                            ),
                          ],
                        ],
                      ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 