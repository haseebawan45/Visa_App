import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visa_app/theme/app_theme.dart';
import 'package:visa_app/widgets/futuristic_toggle.dart';
import 'package:visa_app/widgets/glass_container.dart';

class BalanceCard extends StatefulWidget {
  final double balance;
  final bool isLocked;
  final ValueChanged<bool> onLockChanged;
  final VoidCallback onTap;
  final List<Color> gradientColors;
  final double expenditurePercentage;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.isLocked,
    required this.onLockChanged,
    required this.onTap,
    this.gradientColors = const [
      AppTheme.primaryNeon,
      AppTheme.secondaryNeon,
    ],
    this.expenditurePercentage = 0.65,
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _formatBalance(double balance) {
    return 'PKR ${balance.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    // Create the main card
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: AppTheme.animFast,
        transform: Matrix4.identity()
          ..scale(_isPressed ? 0.98 : 1.0),
        child: Stack(
          children: [
            // Background gradient container with glassmorphism
            GlassContainer(
              height: 180,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
              borderRadius: AppTheme.radiusLarge,
              blur: AppTheme.blurStrong,
              opacity: AppTheme.glassOpacityLow,
              color: AppTheme.surfaceColor,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.gradientColors.map((color) => color.withOpacity(0.3)).toList(),
              ),
              child: Container(),
            ),

            // Card content
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Available Balance',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingXS),
                            Row(
                              children: [
                                AnimatedBuilder(
                                  animation: _pulseController,
                                  builder: (context, child) {
                                    return Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: widget.isLocked 
                                            ? AppTheme.primaryNeon 
                                            : AppTheme.warningNeon,
                                        boxShadow: [
                                          BoxShadow(
                                            color: (widget.isLocked 
                                                ? AppTheme.primaryNeon 
                                                : AppTheme.warningNeon).withOpacity(
                                                  0.1 + 0.2 * _pulseController.value,
                                                ),
                                            blurRadius: 4 + 4 * _pulseController.value,
                                            spreadRadius: 1 + 1 * _pulseController.value,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: AppTheme.spacingXS),
                                Text(
                                  widget.isLocked ? 'Secure Mode' : 'Quick Access',
                                  style: TextStyle(
                                    color: widget.isLocked 
                                        ? AppTheme.primaryNeon 
                                        : AppTheme.warningNeon,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Budget lock toggle
                        FuturisticToggle(
                          value: widget.isLocked,
                          onChanged: widget.onLockChanged,
                          width: 52,
                          height: 26,
                          activeColor: AppTheme.primaryNeon,
                          inactiveColor: AppTheme.warningNeon,
                          activeText: 'ON',
                          inactiveText: 'OFF',
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Balance amount
                    AnimatedScale(
                      scale: _isPressed ? 0.98 : 1.0,
                      duration: AppTheme.animFast,
                      child: Text(
                        _formatBalance(widget.balance),
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacingM),

                    // Expenditure progress bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Monthly Spending',
                              style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${(widget.expenditurePercentage * 100).toInt()}%',
                              style: TextStyle(
                                color: widget.expenditurePercentage > 0.8
                                    ? AppTheme.warningNeon
                                    : AppTheme.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacingXS),
                        Stack(
                          children: [
                            // Background track
                            Container(
                              height: 4,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                              ),
                            ),
                            // Progress indicator
                            Container(
                              height: 4,
                              width: MediaQuery.of(context).size.width * 
                                  widget.expenditurePercentage - (AppTheme.spacingM * 2) - (AppTheme.spacingL * 2),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    widget.gradientColors[0],
                                    widget.expenditurePercentage > 0.8
                                        ? AppTheme.warningNeon
                                        : widget.gradientColors.last,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.gradientColors[0].withOpacity(0.5),
                                    blurRadius: 4,
                                    spreadRadius: 0.5,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Decorative elements
            Positioned(
              top: -15,
              right: 5,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(
                    color: widget.gradientColors[0].withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 40,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(
                    color: widget.gradientColors[1].withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 