import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visa_app/theme/app_theme.dart';
import 'package:visa_app/widgets/futuristic_button.dart';
import 'package:visa_app/widgets/glass_container.dart';
import 'package:visa_app/widgets/neuro_card.dart';

class GroupMember {
  final String name;
  final String avatarUrl;
  final String role;
  final bool isActive;
  final double contribution;
  final bool isSharing;

  GroupMember({
    required this.name,
    required this.avatarUrl,
    required this.role,
    required this.isActive,
    required this.contribution,
    required this.isSharing,
  });
}

class GroupProtectionScreen extends StatefulWidget {
  const GroupProtectionScreen({super.key});

  @override
  State<GroupProtectionScreen> createState() => _GroupProtectionScreenState();
}

class _GroupProtectionScreenState extends State<GroupProtectionScreen> with SingleTickerProviderStateMixin {
  bool _isProtectionActive = true;
  bool _isEditing = false;
  late AnimationController _pulseController;
  
  // Sample group members
  final List<GroupMember> _members = [
    GroupMember(
      name: 'Ahmed K.',
      avatarUrl: 'assets/images/avatars/avatar1.jpg',
      role: 'Admin',
      isActive: true,
      contribution: 5000,
      isSharing: true,
    ),
    GroupMember(
      name: 'Fatima S.',
      avatarUrl: 'assets/images/avatars/avatar2.jpg',
      role: 'Member',
      isActive: true,
      contribution: 3500,
      isSharing: true,
    ),
    GroupMember(
      name: 'Mohammad R.',
      avatarUrl: 'assets/images/avatars/avatar3.jpg',
      role: 'Member',
      isActive: true,
      contribution: 2500,
      isSharing: false,
    ),
    GroupMember(
      name: 'Ayesha T.',
      avatarUrl: 'assets/images/avatars/avatar4.jpg',
      role: 'Member',
      isActive: false,
      contribution: 2000,
      isSharing: false,
    ),
  ];
  
  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleProtection() {
    setState(() {
      _isProtectionActive = !_isProtectionActive;
    });
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _toggleMemberSharing(int index) {
    setState(() {
      final member = _members[index];
      _members[index] = GroupMember(
        name: member.name,
        avatarUrl: member.avatarUrl,
        role: member.role,
        isActive: member.isActive,
        contribution: member.contribution,
        isSharing: !member.isSharing,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive sizing
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    
    // Calculate responsive dimensions
    final double buttonSize = screenWidth * 0.11;
    final double iconSize = screenWidth * 0.05;
    final double smallIconSize = screenWidth * 0.035;
    final double padding = screenWidth * 0.04;
    final double smallPadding = screenWidth * 0.02;
    final double titleFontSize = screenWidth * 0.055;
    final double subtitleFontSize = screenWidth * 0.045;
    final double bodyFontSize = screenWidth * 0.038;
    final double smallFontSize = screenWidth * 0.03;
    
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      AppTheme.background,
                      AppTheme.backgroundDarker,
                      const Color(0xFF132136),
                    ],
                  ),
                ),
              ),
              
              // Decorative elements
              Positioned(
                top: -screenHeight * 0.12,
                left: -screenWidth * 0.25,
                child: Container(
                  width: screenWidth * 0.5,
                  height: screenWidth * 0.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.warningNeon.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              
              Positioned(
                bottom: -screenHeight * 0.1,
                right: -screenWidth * 0.2,
                child: Container(
                  width: screenWidth * 0.5,
                  height: screenWidth * 0.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.accentNeon.withOpacity(0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              
              // Main content
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App bar
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: NeuroCard(
                              width: buttonSize,
                              height: buttonSize,
                              borderRadius: AppTheme.radiusRounded,
                              depth: 3,
                              padding: const EdgeInsets.all(0),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: AppTheme.textSecondary,
                                size: iconSize,
                              ),
                            ),
                          ),
                          SizedBox(width: padding),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Group Protection',
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _toggleEditing,
                            child: NeuroCard(
                              width: buttonSize,
                              height: buttonSize,
                              borderRadius: AppTheme.radiusRounded,
                              depth: 3,
                              padding: const EdgeInsets.all(0),
                              child: Icon(
                                _isEditing ? Icons.close : Icons.edit,
                                color: AppTheme.textSecondary,
                                size: iconSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Group Protection Status Card
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return GlassContainer(
                          margin: EdgeInsets.symmetric(
                            horizontal: padding,
                            vertical: smallPadding,
                          ),
                          borderRadius: AppTheme.radiusLarge,
                          opacity: AppTheme.glassOpacityMedium,
                          blur: AppTheme.blurStrong,
                          border: Border.all(
                            color: _isProtectionActive
                                ? AppTheme.primaryNeon.withOpacity(0.3 + 0.1 * _pulseController.value)
                                : AppTheme.backgroundLighter.withOpacity(0.2),
                            width: 1.5,
                          ),
                          child: Column(
                            children: [
                              // Status header
                              Padding(
                                padding: EdgeInsets.all(padding),
                                child: Row(
                                  children: [
                                    Container(
                                      width: buttonSize * 1.1,
                                      height: buttonSize * 1.1,
                                      decoration: BoxDecoration(
                                        color: _isProtectionActive
                                            ? AppTheme.primaryNeon.withOpacity(0.1 + 0.05 * _pulseController.value)
                                            : AppTheme.backgroundLighter.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                        boxShadow: _isProtectionActive
                                            ? [
                                                BoxShadow(
                                                  color: AppTheme.primaryNeon.withOpacity(0.2 + 0.1 * _pulseController.value),
                                                  blurRadius: 10,
                                                  spreadRadius: 2 * _pulseController.value,
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Icon(
                                        Icons.shield,
                                        color: _isProtectionActive
                                            ? AppTheme.primaryNeon
                                            : AppTheme.textMuted,
                                        size: iconSize * 1.2,
                                      ),
                                    ),
                                    SizedBox(width: padding),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              _isProtectionActive
                                                  ? 'Protection Active'
                                                  : 'Protection Inactive',
                                              style: TextStyle(
                                                color: _isProtectionActive
                                                    ? AppTheme.primaryNeon
                                                    : AppTheme.textMuted,
                                                fontSize: subtitleFontSize,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: smallPadding * 0.5),
                                          Text(
                                            _isProtectionActive
                                                ? 'Your group is protected against fraud'
                                                : 'Your group is not protected',
                                            style: TextStyle(
                                              color: AppTheme.textSecondary,
                                              fontSize: smallFontSize,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: smallPadding),
                                    Switch(
                                      value: _isProtectionActive,
                                      onChanged: (value) => _toggleProtection(),
                                      activeColor: AppTheme.primaryNeon,
                                      activeTrackColor: AppTheme.primaryNeon.withOpacity(0.3),
                                      inactiveThumbColor: AppTheme.textMuted,
                                      inactiveTrackColor: AppTheme.backgroundLighter,
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Protection stats
                              if (_isProtectionActive) ...[
                                Divider(
                                  color: AppTheme.textMuted.withOpacity(0.2),
                                  height: 1,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: padding,
                                    vertical: padding,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: _buildStatItem(
                                          label: 'Total Protection',
                                          value: '₨13,000',
                                          icon: Icons.account_balance_wallet_outlined,
                                          color: AppTheme.primaryNeon,
                                          iconSize: smallIconSize,
                                          valueFontSize: bodyFontSize,
                                          labelFontSize: smallFontSize,
                                        ),
                                      ),
                                      Container(
                                        height: screenHeight * 0.05,
                                        width: 1,
                                        color: AppTheme.textMuted.withOpacity(0.2),
                                      ),
                                      Expanded(
                                        child: _buildStatItem(
                                          label: 'Active Members',
                                          value: '3/4',
                                          icon: Icons.people_outline,
                                          color: AppTheme.warningNeon,
                                          iconSize: smallIconSize,
                                          valueFontSize: bodyFontSize,
                                          labelFontSize: smallFontSize,
                                        ),
                                      ),
                                      Container(
                                        height: screenHeight * 0.05,
                                        width: 1,
                                        color: AppTheme.textMuted.withOpacity(0.2),
                                      ),
                                      Expanded(
                                        child: _buildStatItem(
                                          label: 'Claims',
                                          value: '0',
                                          icon: Icons.history_outlined,
                                          color: AppTheme.accentNeon,
                                          iconSize: smallIconSize,
                                          valueFontSize: bodyFontSize,
                                          labelFontSize: smallFontSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    )
                        .animate()
                        .fadeIn(duration: 800.ms)
                        .slide(begin: const Offset(0, -0.2), end: Offset.zero, duration: 800.ms),
                    
                    // Members header
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: padding,
                        vertical: smallPadding,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Group Members',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: subtitleFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (_isEditing)
                            FuturisticButton(
                              text: 'Add Member',
                              onPressed: () {},
                              prefixIcon: Icons.person_add_alt_1_rounded,
                              height: buttonSize * 0.9,
                              borderRadius: AppTheme.radiusLarge,
                              padding: EdgeInsets.symmetric(
                                horizontal: padding,
                                vertical: smallPadding * 0.5,
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    // Members list
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(
                          left: padding,
                          right: padding,
                          bottom: padding * 1.5,
                        ),
                        itemCount: _members.length,
                        itemBuilder: (context, index) {
                          return _buildMemberCard(
                            _members[index], 
                            index, 
                            screenWidth,
                            buttonSize,
                            padding,
                            smallPadding,
                            bodyFontSize,
                            smallFontSize,
                            smallIconSize
                          );
                        },
                      ),
                    ),
                    
                    // Bottom action
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: FuturisticButton(
                        text: _isEditing ? 'Save Changes' : 'Group Settings',
                        onPressed: _isEditing ? _toggleEditing : () {},
                        color: _isEditing ? AppTheme.primaryNeon : AppTheme.accentNeon,
                        prefixIcon: _isEditing ? Icons.check : Icons.settings,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 800.ms),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }
  
  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required double iconSize,
    required double valueFontSize,
    required double labelFontSize,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: iconSize,
        ),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: valueFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: labelFontSize,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildMemberCard(
    GroupMember member, 
    int index, 
    double screenWidth,
    double buttonSize,
    double padding,
    double smallPadding,
    double bodyFontSize,
    double smallFontSize,
    double iconSize,
  ) {
    final isAdmin = member.role == 'Admin';
    final avatarSize = buttonSize * 1.1;
    
    return NeuroCard(
      margin: EdgeInsets.only(bottom: padding),
      borderRadius: AppTheme.radiusMedium,
      depth: 3,
      gradient: isAdmin
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryNeon.withOpacity(0.15),
                AppTheme.backgroundLighter.withOpacity(0.05),
              ],
            )
          : null,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Row(
          children: [
            // Avatar and status indicator
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: member.isActive
                          ? AppTheme.primaryNeon.withOpacity(0.3)
                          : AppTheme.backgroundLighter.withOpacity(0.3),
                      width: 2,
                    ),
                    image: DecorationImage(
                      image: AssetImage(member.avatarUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (member.isActive)
                  Positioned(
                    bottom: -avatarSize * 0.1,
                    right: -avatarSize * 0.1,
                    child: Container(
                      width: avatarSize * 0.35,
                      height: avatarSize * 0.35,
                      decoration: BoxDecoration(
                        color: AppTheme.accentNeon,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accentNeon.withOpacity(0.4),
                            blurRadius: 4,
                            spreadRadius: 0,
                          ),
                        ],
                        border: Border.all(
                          color: AppTheme.backgroundDarker,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            SizedBox(width: padding),
            
            // Member info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          member.name,
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: bodyFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: smallPadding * 0.5),
                      if (isAdmin)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: smallPadding * 0.8,
                            vertical: smallPadding * 0.3,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryNeon.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Admin',
                            style: TextStyle(
                              color: AppTheme.primaryNeon,
                              fontSize: smallFontSize * 0.85,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: smallPadding * 0.5),
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        color: AppTheme.textMuted,
                        size: iconSize * 0.9,
                      ),
                      SizedBox(width: smallPadding * 0.5),
                      Text(
                        '₨${member.contribution.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: smallFontSize,
                        ),
                      ),
                      SizedBox(width: padding),
                      Icon(
                        Icons.shield_outlined,
                        color: member.isSharing ? AppTheme.primaryNeon : AppTheme.textMuted,
                        size: iconSize * 0.9,
                      ),
                      SizedBox(width: smallPadding * 0.5),
                      Flexible(
                        child: Text(
                          member.isSharing ? 'Sharing' : 'Not sharing',
                          style: TextStyle(
                            color: member.isSharing
                                ? AppTheme.textSecondary
                                : AppTheme.textMuted,
                            fontSize: smallFontSize,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Action
            if (_isEditing && !isAdmin)
              Switch(
                value: member.isSharing,
                onChanged: (_) => _toggleMemberSharing(index),
                activeColor: AppTheme.primaryNeon,
                activeTrackColor: AppTheme.primaryNeon.withOpacity(0.3),
                inactiveThumbColor: AppTheme.textMuted,
                inactiveTrackColor: AppTheme.backgroundLighter,
              ),
          ],
        ),
      )
          .animate()
          .fadeIn(delay: 200.ms * index.toDouble(), duration: 600.ms)
          .slide(
            begin: const Offset(0.2, 0),
            end: Offset.zero,
            delay: 200.ms * index.toDouble(),
            duration: 600.ms,
          ),
    );
  }
} 