import 'package:flutter/material.dart';
import 'package:visa_app/theme/app_theme.dart';

class FuturisticToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final double width;
  final double height;
  final double? borderRadius;
  final Duration animationDuration;
  final Widget? activeIcon;
  final Widget? inactiveIcon;
  final String? activeText;
  final String? inactiveText;

  const FuturisticToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = AppTheme.primaryNeon,
    this.inactiveColor = AppTheme.textMuted,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.width = 60.0,
    this.height = 30.0,
    this.borderRadius,
    this.animationDuration = AppTheme.animFast,
    this.activeIcon,
    this.inactiveIcon,
    this.activeText,
    this.inactiveText,
  });

  @override
  State<FuturisticToggle> createState() => _FuturisticToggleState();
}

class _FuturisticToggleState extends State<FuturisticToggle> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late final double _effectiveBorderRadius;

  @override
  void initState() {
    super.initState();
    _effectiveBorderRadius = widget.borderRadius ?? widget.height / 2;
    
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      value: widget.value ? 1.0 : 0.0,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(FuturisticToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color activeTrackColor = widget.activeTrackColor ?? widget.activeColor.withOpacity(0.3);
    final Color inactiveTrackColor = widget.inactiveTrackColor ?? AppTheme.cardDark;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(_effectiveBorderRadius),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          // Call the callback directly
          widget.onChanged(!widget.value);
        },
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final double thumbPosition = Tween<double>(
              begin: 2.0,
              end: widget.width - widget.height + 2.0,
            ).evaluate(_animation);
            
            return Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_effectiveBorderRadius),
                color: widget.value ? activeTrackColor : inactiveTrackColor,
                boxShadow: [
                  BoxShadow(
                    color: widget.value 
                        ? widget.activeColor.withOpacity(0.5) 
                        : Colors.transparent,
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Track
                  Container(
                    width: widget.width,
                    height: widget.height,
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Active text/icon
                        if (widget.value && (widget.activeText != null || widget.activeIcon != null))
                          Opacity(
                            opacity: _animation.value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: widget.activeIcon ?? 
                                  Text(
                                    widget.activeText ?? '',
                                    style: TextStyle(
                                      color: widget.activeColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            ),
                          ),
                        
                        // Inactive text/icon
                        if (!widget.value && (widget.inactiveText != null || widget.inactiveIcon != null))
                          Opacity(
                            opacity: 1 - _animation.value,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: widget.inactiveIcon ?? 
                                  Text(
                                    widget.inactiveText ?? '',
                                    style: TextStyle(
                                      color: widget.inactiveColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  // Thumb
                  Positioned(
                    left: thumbPosition,
                    top: 2.0,
                    child: Container(
                      width: widget.height - 4.0,
                      height: widget.height - 4.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.lerp(AppTheme.textPrimary, widget.activeColor, _animation.value),
                        boxShadow: [
                          BoxShadow(
                            color: widget.value 
                                ? widget.activeColor.withOpacity(0.8) 
                                : Colors.black.withOpacity(0.2),
                            blurRadius: 8.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: (widget.height - 4.0) * 0.6,
                          height: (widget.height - 4.0) * 0.6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.7),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.9),
                                Colors.white.withOpacity(0.1),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
} 