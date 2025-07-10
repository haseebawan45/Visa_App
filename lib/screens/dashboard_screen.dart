import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visa_app/models/transaction.dart';
import 'package:visa_app/theme/app_theme.dart';
import 'package:visa_app/widgets/balance_card.dart';
import 'package:visa_app/widgets/glass_container.dart';
import 'package:visa_app/widgets/neuro_card.dart';
import 'package:visa_app/widgets/transaction_card.dart';
import 'package:visa_app/screens/ghost_payment_screen.dart';
import 'package:visa_app/screens/refund_assistant_screen.dart';
import 'package:visa_app/screens/group_protection_screen.dart';
import 'package:visa_app/screens/travel_mode_screen.dart';
import 'package:visa_app/screens/add_money_screen.dart';
import 'package:visa_app/screens/send_money_screen.dart';
import 'package:visa_app/screens/budget_screen.dart';
import 'package:visa_app/screens/transaction_history_screen.dart';
import 'package:visa_app/screens/notification_screen.dart';
import 'package:visa_app/screens/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  final List<Transaction> _transactions = Transaction.getMockTransactions();
  bool _isBalanceLocked = true;
  bool _showScamAlert = false;
  bool _isCardFrozen = false;
  late AnimationController _alertController;
  
  @override
  void initState() {
    super.initState();
    _alertController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    
    // Show scam alert after a delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _showScamAlert = true);
      }
    });
  }
  
  @override
  void dispose() {
    _alertController.dispose();
    super.dispose();
  }

  // Securely toggle the balance visibility
  void _onLockChanged(bool value) {
    // Debug information
    print("Balance visibility toggle: ${_isBalanceLocked} -> $value");
    
    // Ensure we run in the next frame to avoid potential build issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isBalanceLocked = value;
        });
        
        // Show confirmation to user
        ScaffoldMessenger.of(context).clearSnackBars(); // Clear any existing snackbars
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: value ? AppTheme.primaryNeon : AppTheme.warningNeon,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(AppTheme.spacingM),
            content: Row(
              children: [
                Icon(
                  value ? Icons.lock_outline : Icons.lock_open_outlined, 
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.spacingS),
                Expanded(
                  child: Text(
                    value ? 'Balance hidden - Secure mode activated' : 'Balance visible - Quick access mode',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _dismissScamAlert() {
    setState(() {
      _showScamAlert = false;
    });
  }

  void _toggleCardFreeze() {
    setState(() {
      _isCardFrozen = !_isCardFrozen;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _isCardFrozen ? AppTheme.dangerNeon : AppTheme.accentNeon,
        content: Text(
          _isCardFrozen ? 'Card frozen successfully. Transactions blocked.' : 'Card unfrozen. Transactions enabled.',
          style: TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToScreen(Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: AppTheme.animMedium,
        pageBuilder: (context, animation, secondaryAnimation) => 
          FadeTransition(
            opacity: animation,
            child: screen,
          ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive sizing
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    final EdgeInsets padding = MediaQuery.of(context).padding;
    
    // Calculate responsive spacings based on screen size
    final double horizontalPadding = screenWidth * 0.05;
    final double verticalSpacing = screenHeight * 0.02;
    
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive layout based on available constraints
          return Stack(
            children: [
              // Background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.backgroundLighter,
                      AppTheme.background,
                      AppTheme.backgroundDarker,
                    ],
                  ),
                ),
              ),
              
              // Main content
              SafeArea(
                child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App Bar
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: verticalSpacing,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Logo
                          Row(
                            children: [
                              Container(
                                width: screenWidth * 0.1,
                                height: screenWidth * 0.1,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryNeon.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.shield,
                                  color: AppTheme.primaryNeon,
                                  size: screenWidth * 0.05,
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'BEE NETWORK',
                                  style: TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          // Action buttons
                          Row(
                            children: [
                              _buildActionButton(
                                icon: Icons.notifications_outlined,
                                badge: 2,
                                  onTap: () => _navigateToScreen(const NotificationScreen()),
                                buttonSize: screenWidth * 0.1,
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              _buildActionButton(
                                icon: Icons.person_outline,
                                  onTap: () => _navigateToScreen(const ProfileScreen()),
                                buttonSize: screenWidth * 0.1,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 0.5),
                    
                    // Balance Card with visibility toggle button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: AspectRatio(
                        aspectRatio: 1.7,
                        child: Stack(
                          children: [
                            BalanceCard(
                              balance: 275850.75,
                              isLocked: _isBalanceLocked,
                              onLockChanged: _onLockChanged,
                              onTap: () {},
                              expenditurePercentage: 0.65,
                              gradientColors: const [
                                AppTheme.primaryNeon,
                                AppTheme.secondaryNeon,
                              ],
                            ),
                            
                            // Visibility toggle button positioned over the card
                            Positioned(
                              top: constraints.maxHeight * 0.03,
                              right: constraints.maxWidth * 0.08,
                              child: NeuroCard(
                                width: screenWidth * 0.11,
                                height: screenWidth * 0.11,
                                borderRadius: AppTheme.radiusRounded,
                                depth: 3,
                                padding: const EdgeInsets.all(0),
                                onTap: () => _onLockChanged(!_isBalanceLocked),
                                glow: _isBalanceLocked ? AppTheme.warningNeon : AppTheme.primaryNeon,
                                child: Icon(
                                  _isBalanceLocked ? Icons.visibility : Icons.visibility_off,
                                  color: _isBalanceLocked ? AppTheme.warningNeon : AppTheme.primaryNeon,
                                  size: screenWidth * 0.06,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 1.5),
                    
                      // Actions row - replaced scrollview with grid
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quick Actions',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: verticalSpacing * 0.8),
                            
                            // First row of actions
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildQuickActionCompact(
                              icon: Icons.add_rounded,
                                  label: 'Add',
                              color: AppTheme.primaryNeon,
                              onTap: () => _navigateToScreen(const AddMoneyScreen()),
                                  screenWidth: screenWidth,
                            ),
                                _buildQuickActionCompact(
                              icon: Icons.send_rounded,
                              label: 'Send',
                              color: AppTheme.accentNeon,
                              onTap: () => _navigateToScreen(const SendMoneyScreen()),
                                  screenWidth: screenWidth,
                                ),
                                _buildQuickActionCompact(
                                  icon: Icons.account_balance_wallet,
                                  label: 'Budget',
                                  color: Colors.green,
                                  onTap: () => _navigateToScreen(const BudgetScreen()),
                                  screenWidth: screenWidth,
                            ),
                                _buildQuickActionCompact(
                              icon: Icons.flash_on_rounded,
                                  label: 'Ghost',
                              color: AppTheme.secondaryNeon,
                              onTap: () => _navigateToScreen(const GhostPaymentScreen()),
                                  screenWidth: screenWidth,
                                ),
                              ],
                            ),
                            
                            SizedBox(height: verticalSpacing * 1.2),
                            
                            // Second row of actions
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildQuickActionCompact(
                              icon: Icons.credit_card_off_rounded,
                                  label: 'Freeze',
                              color: AppTheme.dangerNeon,
                              onTap: _toggleCardFreeze,
                                  isActive: _isCardFrozen,
                                  screenWidth: screenWidth,
                            ),
                                _buildQuickActionCompact(
                              icon: Icons.group_rounded,
                                  label: 'Group',
                              color: AppTheme.warningNeon,
                              onTap: () => _navigateToScreen(const GroupProtectionScreen()),
                                  screenWidth: screenWidth,
                            ),
                                _buildQuickActionCompact(
                              icon: Icons.travel_explore,
                                  label: 'Travel',
                              color: AppTheme.accentNeon,
                              onTap: () => _navigateToScreen(const TravelModeScreen()),
                                  screenWidth: screenWidth,
                            ),
                                _buildQuickActionCompact(
                              icon: Icons.support_agent,
                                  label: 'Refund',
                              color: AppTheme.primaryNeon,
                              onTap: () => _navigateToScreen(const RefundAssistantScreen()),
                                  screenWidth: screenWidth,
                                ),
                              ],
                            ),
                          ],
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 1.5),
                    
                    // Transactions header
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Recent Transactions',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: () => _navigateToScreen(const TransactionHistoryScreen()),
                            child: Row(
                              children: [
                                Text(
                                  'View All',
                                  style: TextStyle(
                                    color: AppTheme.primaryNeon,
                                    fontWeight: FontWeight.w600,
                                    fontSize: screenWidth * 0.035,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.01),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: AppTheme.primaryNeon,
                                  size: screenWidth * 0.03,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 0.5),
                    
                      // Transactions list - now using Column instead of ListView.builder
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: screenHeight * 0.15, // Add extra padding at bottom for better UX
                        ),
                        child: Column(
                          children: List.generate(_transactions.length, (index) {
                          return TransactionCard(
                            transaction: _transactions[index],
                            index: index,
                            onTap: () {},
                          );
                          }),
                        ),
                      ),
                    ],
                    ),
                ),
              ),
              
              // Scam Alert Overlay
              if (_showScamAlert)
                _buildScamAlert(screenWidth, screenHeight),
            ],
          );
        }
      ),
    );
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    int? badge,
    required double buttonSize,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        NeuroCard(
          width: buttonSize,
          height: buttonSize,
          borderRadius: AppTheme.radiusRounded,
          depth: 3,
          padding: const EdgeInsets.all(0),
          onTap: onTap,
          child: Icon(
            icon,
            color: AppTheme.textSecondary,
            size: buttonSize * 0.5,
          ),
        ),
        if (badge != null)
          Positioned(
            top: -buttonSize * 0.1,
            right: -buttonSize * 0.1,
            child: Container(
              padding: EdgeInsets.all(buttonSize * 0.1),
              decoration: BoxDecoration(
                color: AppTheme.dangerNeon,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.dangerNeon.withOpacity(0.4),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  badge.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: buttonSize * 0.25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // New compact quick action widget
  Widget _buildQuickActionCompact({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required double screenWidth,
    bool isActive = false,
  }) {
    final double size = screenWidth * 0.18;
    
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NeuroCard(
          width: size,
          height: size,
            borderRadius: AppTheme.radiusMedium,
          depth: 3,
            onTap: onTap,
            padding: const EdgeInsets.all(0),
            glow: isActive ? color : null,
            child: Icon(
              icon,
              color: isActive ? Colors.white : color,
            size: size * 0.45,
            ),
          ),
        SizedBox(height: 6),
        Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isActive ? color : AppTheme.textSecondary,
            fontSize: 12,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
    );
  }

  Widget _buildScamAlert(double screenWidth, double screenHeight) {
    final fraudTransaction = _transactions.firstWhere(
      (t) => t.status == TransactionStatus.flagged,
      orElse: () => _transactions.first,
    );

    return Positioned(
      bottom: screenHeight * 0.03,
      left: screenWidth * 0.05,
      right: screenWidth * 0.05,
      child: GestureDetector(
        onTap: _dismissScamAlert,
        child: GlassContainer(
          height: screenHeight * 0.15,
          margin: EdgeInsets.zero,
          borderRadius: AppTheme.radiusLarge,
          blur: AppTheme.blurStrong,
          opacity: AppTheme.glassOpacityMedium,
          color: AppTheme.cardDark,
          border: Border.all(
            color: AppTheme.dangerNeon.withOpacity(0.3),
            width: 1.5,
          ),
          child: Row(
            children: [
              // Alert icon
              AnimatedBuilder(
                animation: _alertController,
                builder: (context, child) {
                  return Container(
                    width: screenWidth * 0.13,
                    height: screenWidth * 0.13,
                    margin: EdgeInsets.all(screenWidth * 0.04),
                    decoration: BoxDecoration(
                      color: AppTheme.dangerNeon.withOpacity(0.1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.dangerNeon.withOpacity(0.2 + 0.1 * _alertController.value),
                          blurRadius: 8,
                          spreadRadius: 1 + _alertController.value * 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: AppTheme.dangerNeon,
                      size: screenWidth * 0.07,
                    ),
                  );
                },
              ),
              
              // Alert text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'SCAM RADAR ALERT',
                        style: TextStyle(
                          color: AppTheme.dangerNeon,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Suspicious transaction blocked: ${fraudTransaction.title}',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: screenWidth * 0.032,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      'Tap to review',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: screenWidth * 0.03,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Close button
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: IconButton(
                  onPressed: _dismissScamAlert,
                  icon: Icon(
                    Icons.close_rounded,
                    color: AppTheme.textMuted,
                    size: screenWidth * 0.05,
                  ),
                ),
              ),
            ],
          ),
        )
            .animate()
            .slideY(
              begin: 1.0,
              end: 0.0,
              duration: 500.ms,
              curve: Curves.easeOutQuad,
            )
            .fadeIn(
              duration: 400.ms,
              curve: Curves.easeOut,
            ),
      ),
    );
  }
} 