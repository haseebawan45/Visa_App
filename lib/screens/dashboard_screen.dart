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
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingM,
                    vertical: AppTheme.spacingM,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryNeon.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.shield,
                              color: AppTheme.primaryNeon,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          Text(
                            'NEUPAY',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
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
                            onTap: () {},
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          _buildActionButton(
                            icon: Icons.person_outline,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppTheme.spacingS),
                
                // Balance Card with visibility toggle button
                Stack(
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
                      top: 16,
                      right: 32,
                      child: NeuroCard(
                        width: 48,
                        height: 48,
                        borderRadius: AppTheme.radiusRounded,
                        depth: 3,
                        padding: const EdgeInsets.all(0),
                        onTap: () => _onLockChanged(!_isBalanceLocked),
                        glow: _isBalanceLocked ? AppTheme.warningNeon : AppTheme.primaryNeon,
                        child: Icon(
                          _isBalanceLocked ? Icons.visibility : Icons.visibility_off,
                          color: _isBalanceLocked ? AppTheme.warningNeon : AppTheme.primaryNeon,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppTheme.spacingL),
                
                // Actions row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
                  child: Row(
                    children: [
                      _buildQuickAction(
                        icon: Icons.add_rounded,
                        label: 'Add Money',
                        color: AppTheme.primaryNeon,
                        onTap: () {},
                      ),
                      _buildQuickAction(
                        icon: Icons.send_rounded,
                        label: 'Send',
                        color: AppTheme.accentNeon,
                        onTap: () {},
                      ),
                      _buildQuickAction(
                        icon: Icons.flash_on_rounded,
                        label: 'Ghost Pay',
                        color: AppTheme.secondaryNeon,
                        onTap: () => _navigateToScreen(const GhostPaymentScreen()),
                      ),
                      _buildQuickAction(
                        icon: Icons.credit_card_off_rounded,
                        label: 'Freeze Card',
                        color: AppTheme.dangerNeon,
                        onTap: _toggleCardFreeze,
                      ),
                      _buildQuickAction(
                        icon: Icons.group_rounded,
                        label: 'Group Plan',
                        color: AppTheme.warningNeon,
                        onTap: () => _navigateToScreen(const GroupProtectionScreen()),
                      ),
                      _buildQuickAction(
                        icon: Icons.travel_explore,
                        label: 'Travel Mode',
                        color: AppTheme.accentNeon,
                        onTap: () => _navigateToScreen(const TravelModeScreen()),
                      ),
                      _buildQuickAction(
                        icon: Icons.support_agent,
                        label: 'Refund Help',
                        color: AppTheme.primaryNeon,
                        onTap: () => _navigateToScreen(const RefundAssistantScreen()),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppTheme.spacingL),
                
                // Transactions header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Transactions',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Text(
                              'View All',
                              style: TextStyle(
                                color: AppTheme.primaryNeon,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: AppTheme.primaryNeon,
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppTheme.spacingS),
                
                // Transactions list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: AppTheme.spacingS, bottom: AppTheme.spacingXL),
                    itemCount: _transactions.length,
                    itemBuilder: (context, index) {
                      return TransactionCard(
                        transaction: _transactions[index],
                        index: index,
                        onTap: () {},
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Scam Alert Overlay
          if (_showScamAlert)
            _buildScamAlert(),
        ],
      ),
    );
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    int? badge,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        NeuroCard(
          width: 42,
          height: 42,
          borderRadius: AppTheme.radiusRounded,
          depth: 3,
          padding: const EdgeInsets.all(0),
          onTap: onTap,
          child: Icon(
            icon,
            color: AppTheme.textSecondary,
            size: 20,
          ),
        ),
        if (badge != null)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
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
              child: Text(
                badge.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    // Special case for Freeze Card to show active state
    final bool isActive = label == 'Freeze Card' && _isCardFrozen;
    
    return Container(
      margin: const EdgeInsets.only(right: AppTheme.spacingM),
      child: Column(
        children: [
          NeuroCard(
            width: 60,
            height: 60,
            borderRadius: AppTheme.radiusMedium,
            depth: 4,
            onTap: onTap,
            padding: const EdgeInsets.all(0),
            glow: isActive ? color : null,
            child: Icon(
              icon,
              color: isActive ? Colors.white : color,
              size: 28,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXS),
          Text(
            label,
            style: TextStyle(
              color: isActive ? color : AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScamAlert() {
    final fraudTransaction = _transactions.firstWhere(
      (t) => t.status == TransactionStatus.flagged,
      orElse: () => _transactions.first,
    );

    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: _dismissScamAlert,
        child: GlassContainer(
          height: 120,
          margin: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingM,
          ),
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
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.all(AppTheme.spacingM),
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
                      size: 28,
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
                    Text(
                      'SCAM RADAR ALERT',
                      style: TextStyle(
                        color: AppTheme.dangerNeon,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXS),
                    Text(
                      'Suspicious transaction blocked: ${fraudTransaction.title}',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXS),
                    Text(
                      'Tap to review',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Close button
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingS),
                child: IconButton(
                  onPressed: _dismissScamAlert,
                  icon: Icon(
                    Icons.close_rounded,
                    color: AppTheme.textMuted,
                    size: 20,
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