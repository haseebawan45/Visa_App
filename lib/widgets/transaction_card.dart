import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:visa_app/models/transaction.dart';
import 'package:visa_app/theme/app_theme.dart';
import 'package:visa_app/widgets/glass_container.dart';

class TransactionCard extends StatefulWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  final bool animate;
  final int index;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.onTap,
    this.animate = true,
    this.index = 0,
  });

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final transaction = widget.transaction;
    
    // Format date
    final dateFormat = DateFormat('dd MMM, h:mm a');
    final formattedDate = dateFormat.format(transaction.date);
    
    // Build the card content
    Widget cardContent = Padding(
      padding: const EdgeInsets.only(
        left: AppTheme.spacingS,
        right: AppTheme.spacingS,
        top: AppTheme.spacingS,
        bottom: AppTheme.spacingS,
      ),
      child: Row(
        children: [
          // Transaction type icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: transaction.typeColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Center(
              child: Icon(
                transaction.typeIcon,
                color: transaction.typeColor,
                size: 22,
              ),
            ),
          ),
          
          const SizedBox(width: AppTheme.spacingM),
          
          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        transaction.title,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      transaction.formattedAmount,
                      style: TextStyle(
                        color: transaction.amountColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppTheme.spacingXS),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          if (transaction.merchantName != null) ...[
                            Text(
                              transaction.merchantName!,
                              style: const TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '•',
                              style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Security verification indicator
                    if (!transaction.isSecurityVerified)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingXS,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.dangerNeon.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: AppTheme.dangerNeon,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              'BLOCKED',
                              style: TextStyle(
                                color: AppTheme.dangerNeon,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // Apply glassmorphism container
    cardContent = GlassContainer(
      height: 80,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(
        left: AppTheme.spacingM,
        right: AppTheme.spacingM,
        bottom: AppTheme.spacingM,
      ),
      color: _isPressed
          ? AppTheme.backgroundLighter.withOpacity(0.3)
          : AppTheme.backgroundLighter,
      opacity: AppTheme.glassOpacityMedium,
      borderRadius: AppTheme.radiusMedium,
      border: Border.all(
        color: transaction.status == TransactionStatus.flagged
            ? AppTheme.dangerNeon.withOpacity(0.3)
            : Colors.white.withOpacity(0.05),
        width: 1.0,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: widget.onTap,
          onHighlightChanged: (isHighlighted) {
            setState(() {
              _isPressed = isHighlighted;
            });
          },
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          highlightColor: transaction.typeColor.withOpacity(0.05),
          splashColor: transaction.typeColor.withOpacity(0.05),
          child: cardContent,
        ),
      ),
    );

    // Apply animations if needed
    if (widget.animate) {
      return cardContent
          .animate()
          .fadeIn(
            duration: 350.ms,
            delay: (50 * widget.index).ms,
            curve: Curves.easeOutQuad,
          )
          .slideY(
            begin: 0.1,
            end: 0,
            duration: 350.ms,
            delay: (50 * widget.index).ms,
            curve: Curves.easeOutQuad,
          );
    }

    return cardContent;
  }
} 