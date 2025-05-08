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
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    
    // Calculate responsive dimensions
    final double iconSize = screenWidth * 0.055;
    final double cardHeight = screenWidth * 0.2;
    final double horizontalPadding = screenWidth * 0.05;
    final double elementSpacing = screenWidth * 0.02;
    
    // Format date
    final dateFormat = DateFormat('dd MMM, h:mm a');
    final formattedDate = dateFormat.format(transaction.date);
    
    // Build the card content
    Widget cardContent = Padding(
      padding: EdgeInsets.all(screenWidth * 0.025),
      child: Row(
        children: [
          // Transaction type icon
          Container(
            width: cardHeight * 0.55,
            height: cardHeight * 0.55,
            decoration: BoxDecoration(
              color: transaction.typeColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Center(
              child: Icon(
                transaction.typeIcon,
                color: transaction.typeColor,
                size: iconSize,
              ),
            ),
          ),
          
          SizedBox(width: elementSpacing),
          
          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        transaction.title,
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.038,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: elementSpacing * 0.5),
                    Text(
                      transaction.formattedAmount,
                      style: TextStyle(
                        color: transaction.amountColor,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.038,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: screenWidth * 0.01),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          if (transaction.merchantName != null) ...[
                            Flexible(
                              child: Text(
                                transaction.merchantName!,
                                style: TextStyle(
                                  color: AppTheme.textMuted,
                                  fontSize: screenWidth * 0.03,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.01),
                            Text(
                              '•',
                              style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: screenWidth * 0.03,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.01),
                          ],
                          Flexible(
                            child: Text(
                              formattedDate,
                              style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: screenWidth * 0.03,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Add spacing to prevent overlap with the warning indicator
                    SizedBox(width: !transaction.isSecurityVerified ? elementSpacing * 0.5 : 0),
                    
                    // Security verification indicator
                    if (!transaction.isSecurityVerified)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.01,
                          vertical: screenWidth * 0.005,
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
                              size: screenWidth * 0.03,
                            ),
                            SizedBox(width: screenWidth * 0.005),
                            Text(
                              'BLOCKED',
                              style: TextStyle(
                                color: AppTheme.dangerNeon,
                                fontSize: screenWidth * 0.025,
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
      height: cardHeight,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        bottom: elementSpacing,
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