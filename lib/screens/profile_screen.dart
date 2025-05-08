import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visa_app/theme/app_theme.dart';
import 'package:visa_app/widgets/glass_container.dart';
import 'package:visa_app/widgets/neuro_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final bool _biometricsEnabled = true;
  final bool _darkModeEnabled = true;
  final bool _notificationsEnabled = true;
  
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive sizing
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    
    // Calculate responsive spacings based on screen size
    final double horizontalPadding = screenWidth * 0.05;
    
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
          
          // Decorative elements
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
                    AppTheme.primaryNeon.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                              'My Profile',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Manage your account',
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
                          onTap: () {
                            // Edit profile
                          },
                          child: const Icon(
                            Icons.edit,
                            color: AppTheme.textSecondary,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Profile header
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: AppTheme.spacingL,
                    ),
                    child: Row(
                      children: [
                        // Profile image
                        NeuroCard(
                          width: screenWidth * 0.22,
                          height: screenWidth * 0.22,
                          borderRadius: AppTheme.radiusRounded,
                          depth: 4,
                          padding: const EdgeInsets.all(0),
                          glow: AppTheme.primaryNeon,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppTheme.radiusRounded),
                            child: Container(
                              color: AppTheme.primaryNeon.withOpacity(0.1),
                              child: Icon(
                                Icons.person,
                                color: AppTheme.primaryNeon,
                                size: screenWidth * 0.12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingL),
                        
                        // User details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Asad Khan',
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'asad.khan@gmail.com',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryNeon.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.verified,
                                          color: AppTheme.primaryNeon,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Verified',
                                          style: TextStyle(
                                            color: AppTheme.primaryNeon,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.secondaryNeon.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: AppTheme.secondaryNeon,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Premium',
                                          style: TextStyle(
                                            color: AppTheme.secondaryNeon,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
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
                  ),
                  
                  // Main sections
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Security section
                        _buildSectionHeader('Security', Icons.security),
                        _buildSettingItem(
                          title: 'Biometric Authentication',
                          subtitle: 'Use fingerprint or face ID to authenticate',
                          icon: Icons.fingerprint,
                          color: AppTheme.primaryNeon,
                          hasToggle: true,
                          isToggled: _biometricsEnabled,
                          onToggle: (value) {
                            // Handle toggle
                          },
                        ),
                        _buildSettingItem(
                          title: 'Change PIN',
                          subtitle: 'Update your 6-digit secure PIN',
                          icon: Icons.pin,
                          color: AppTheme.accentNeon,
                          hasArrow: true,
                          onTap: () {
                            // Navigate to change PIN
                          },
                        ),
                        _buildSettingItem(
                          title: 'Privacy & Security',
                          subtitle: 'Manage permissions and security settings',
                          icon: Icons.shield,
                          color: AppTheme.dangerNeon,
                          hasArrow: true,
                          onTap: () {
                            // Navigate to privacy settings
                          },
                        ),
                        
                        const SizedBox(height: AppTheme.spacingL),
                        
                        // Preferences section
                        _buildSectionHeader('Preferences', Icons.settings),
                        _buildSettingItem(
                          title: 'Dark Mode',
                          subtitle: 'Enable or disable dark theme',
                          icon: Icons.dark_mode,
                          color: AppTheme.secondaryNeon,
                          hasToggle: true,
                          isToggled: _darkModeEnabled,
                          onToggle: (value) {
                            // Handle toggle
                          },
                        ),
                        _buildSettingItem(
                          title: 'Notifications',
                          subtitle: 'Manage your notification preferences',
                          icon: Icons.notifications,
                          color: AppTheme.warningNeon,
                          hasToggle: true,
                          isToggled: _notificationsEnabled,
                          onToggle: (value) {
                            // Handle toggle
                          },
                        ),
                        _buildSettingItem(
                          title: 'Language',
                          subtitle: 'Select your preferred language',
                          icon: Icons.language,
                          color: AppTheme.accentNeon,
                          hasArrow: true,
                          trailingText: 'English',
                          onTap: () {
                            // Navigate to language selection
                          },
                        ),
                        
                        const SizedBox(height: AppTheme.spacingL),
                        
                        // Help & Support section
                        _buildSectionHeader('Help & Support', Icons.help_outline),
                        _buildSettingItem(
                          title: 'Help Center',
                          subtitle: 'Get help with your account and queries',
                          icon: Icons.live_help,
                          color: AppTheme.primaryNeon,
                          hasArrow: true,
                          onTap: () {
                            // Navigate to help center
                          },
                        ),
                        _buildSettingItem(
                          title: 'Report an Issue',
                          subtitle: 'Let us know about any problems',
                          icon: Icons.report_problem,
                          color: AppTheme.dangerNeon,
                          hasArrow: true,
                          onTap: () {
                            // Navigate to report issue
                          },
                        ),
                        _buildSettingItem(
                          title: 'About NEUPAY',
                          subtitle: 'App version, legal info, and more',
                          icon: Icons.info_outline,
                          color: AppTheme.textMuted,
                          hasArrow: true,
                          onTap: () {
                            // Navigate to about page
                          },
                        ),
                        
                        const SizedBox(height: AppTheme.spacingL),
                        
                        // Logout button
                        GestureDetector(
                          onTap: () {
                            // Handle logout
                          },
                          child: NeuroCard(
                            width: double.infinity,
                            depth: 3,
                            borderRadius: AppTheme.radiusMedium,
                            padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
                            glow: AppTheme.dangerNeon.withOpacity(0.5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: AppTheme.dangerNeon,
                                  size: 20,
                                ),
                                const SizedBox(width: AppTheme.spacingS),
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: AppTheme.dangerNeon,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: AppTheme.spacingL),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.textMuted,
            size: 18,
          ),
          const SizedBox(width: AppTheme.spacingS),
          Text(
            title,
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 100.ms)
        .slideX(begin: -0.1, end: 0, duration: 400.ms, delay: 100.ms, curve: Curves.easeOutQuad);
  }
  
  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    bool hasToggle = false,
    bool isToggled = false,
    bool hasArrow = false,
    String? trailingText,
    VoidCallback? onTap,
    Function(bool)? onToggle,
  }) {
    return GestureDetector(
      onTap: hasToggle ? null : onTap,
      child: GlassContainer(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
        borderRadius: AppTheme.radiusMedium,
        opacity: AppTheme.glassOpacityMedium,
        blur: AppTheme.blurLight,
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Row(
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Toggle or arrow
              if (hasToggle)
                Switch(
                  value: isToggled,
                  onChanged: onToggle,
                  activeColor: AppTheme.primaryNeon,
                  inactiveTrackColor: AppTheme.textMuted.withOpacity(0.2),
                  thumbColor: MaterialStateProperty.resolveWith((states) {
                    return isToggled ? AppTheme.primaryNeon : Colors.white;
                  }),
                  trackOutlineColor: MaterialStateProperty.resolveWith((states) {
                    return Colors.transparent;
                  }),
                ),
              if (hasArrow && trailingText != null) ...[
                Text(
                  trailingText,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingS),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppTheme.textMuted,
                  size: 14,
                ),
              ] else if (hasArrow) ...[
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppTheme.textMuted,
                  size: 14,
                ),
              ],
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 200.ms)
        .slideX(begin: 0.1, end: 0, duration: 400.ms, delay: 200.ms, curve: Curves.easeOutQuad);
  }
} 