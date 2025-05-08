import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visa_app/theme/app_theme.dart';
import 'package:visa_app/widgets/glass_container.dart';
import 'package:visa_app/widgets/neuro_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<NotificationItem> _notifications = _getMockNotifications();
  
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive sizing
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    
    // Calculate responsive spacings based on screen size
    final double horizontalPadding = screenWidth * 0.05;
    final double verticalSpacing = screenHeight * 0.02;
    
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
          
          // Decorative element
          Positioned(
            top: -120,
            right: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accentNeon.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: Column(
              children: [
                // App bar with back button and title
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: NeuroCard(
                          width: 45,
                          height: 45,
                          borderRadius: AppTheme.radiusRounded,
                          depth: 3,
                          padding: const EdgeInsets.all(0),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: AppTheme.textSecondary,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notifications',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_notifications.length} unread notifications',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      NeuroCard(
                        width: 45,
                        height: 45,
                        borderRadius: AppTheme.radiusRounded,
                        depth: 3,
                        padding: const EdgeInsets.all(0),
                        onTap: _markAllRead,
                        child: const Icon(
                          Icons.done_all_rounded,
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Notifications list
                Expanded(
                  child: _notifications.isEmpty 
                    ? _buildEmptyState() 
                    : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final notification = _notifications[index];
                        return _buildNotificationItem(notification, index);
                      },
                    ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNotificationItem(NotificationItem notification, int index) {
    return GlassContainer(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      borderRadius: AppTheme.radiusLarge,
      opacity: AppTheme.glassOpacityMedium,
      blur: AppTheme.blurLight,
      border: Border.all(
        color: notification.priorityColor.withOpacity(0.3),
        width: 1.5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification icon
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: notification.priorityColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                notification.icon,
                color: notification.priorityColor,
                size: 22,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            
            // Notification content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingS),
                      Text(
                        notification.timeAgo,
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    notification.message,
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  if (notification.actionLabel != null) ...[
                    const SizedBox(height: AppTheme.spacingM),
                    GestureDetector(
                      onTap: () => _onNotificationActionTap(notification),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            notification.actionLabel!,
                            style: TextStyle(
                              color: notification.priorityColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: notification.priorityColor,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    )
      .animate()
      .fade(duration: 400.ms, delay: (50 * index).ms)
      .slide(begin: const Offset(0.2, 0), duration: 400.ms, delay: (50 * index).ms, curve: Curves.easeOutQuad);
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            color: AppTheme.textMuted,
            size: 70,
          ),
          const SizedBox(height: AppTheme.spacingL),
          Text(
            'No notifications yet',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
            child: Text(
              'You\'re all caught up! We\'ll notify you when there\'s something important.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    )
      .animate()
      .fadeIn(duration: 600.ms)
      .scale(begin: const Offset(0.8, 0.8), duration: 600.ms, curve: Curves.easeOutQuad);
  }
  
  void _markAllRead() {
    setState(() {
      _notifications.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: AppTheme.primaryNeon,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  void _onNotificationActionTap(NotificationItem notification) {
    // Here you would handle the specific action for each notification
    // For now we just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Action: ${notification.actionLabel}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  static List<NotificationItem> _getMockNotifications() {
    return [
      NotificationItem(
        title: 'Security Alert',
        message: 'We detected a suspicious login attempt from a new device.',
        icon: Icons.security,
        priorityColor: AppTheme.dangerNeon,
        timeAgo: '5m ago',
        actionLabel: 'Review Activity',
      ),
      NotificationItem(
        title: 'Payment Completed',
        message: 'Your payment of PKR 3,500 to Foodpanda was successful.',
        icon: Icons.check_circle,
        priorityColor: AppTheme.primaryNeon,
        timeAgo: '30m ago',
      ),
      NotificationItem(
        title: 'Budget Alert',
        message: 'You\'ve reached 80% of your monthly Entertainment budget.',
        icon: Icons.account_balance_wallet,
        priorityColor: AppTheme.warningNeon,
        timeAgo: '2h ago',
        actionLabel: 'View Budget',
      ),
      NotificationItem(
        title: 'Card Status Update',
        message: 'Your card freeze request has been processed successfully.',
        icon: Icons.credit_card,
        priorityColor: AppTheme.accentNeon,
        timeAgo: '5h ago',
      ),
      NotificationItem(
        title: 'New Offer Available',
        message: 'Enjoy 15% cashback on your next grocery purchase.',
        icon: Icons.local_offer,
        priorityColor: AppTheme.secondaryNeon,
        timeAgo: '1d ago',
        actionLabel: 'View Offer',
      ),
      NotificationItem(
        title: 'Account Update',
        message: 'Your profile verification has been completed successfully.',
        icon: Icons.person,
        priorityColor: AppTheme.primaryNeon,
        timeAgo: '2d ago',
      ),
      NotificationItem(
        title: 'Travel Mode Alert',
        message: 'Your Travel Mode will be activated tomorrow based on your schedule.',
        icon: Icons.travel_explore,
        priorityColor: AppTheme.accentNeon,
        timeAgo: '2d ago',
        actionLabel: 'Review Settings',
      ),
    ];
  }
}

class NotificationItem {
  final String title;
  final String message;
  final IconData icon;
  final Color priorityColor;
  final String timeAgo;
  final String? actionLabel;
  
  NotificationItem({
    required this.title,
    required this.message,
    required this.icon,
    required this.priorityColor,
    required this.timeAgo,
    this.actionLabel,
  });
} 