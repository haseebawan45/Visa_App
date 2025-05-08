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
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
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
            top: -100,
            left: -100,
            child: Container(
              width: 200,
              height: 200,
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
            bottom: -80,
            right: -80,
            child: Container(
              width: 200,
              height: 200,
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
                      Text(
                        'Group Protection',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _toggleEditing,
                        child: NeuroCard(
                          width: 45,
                          height: 45,
                          borderRadius: AppTheme.radiusRounded,
                          depth: 3,
                          padding: const EdgeInsets.all(0),
                          child: Icon(
                            _isEditing ? Icons.close : Icons.edit,
                            color: AppTheme.textSecondary,
                            size: 20,
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
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingM,
                        vertical: AppTheme.spacingM,
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
                            padding: const EdgeInsets.all(AppTheme.spacingM),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
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
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: AppTheme.spacingM),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _isProtectionActive
                                          ? 'Protection Active'
                                          : 'Protection Inactive',
                                      style: TextStyle(
                                        color: _isProtectionActive
                                            ? AppTheme.primaryNeon
                                            : AppTheme.textMuted,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _isProtectionActive
                                          ? 'Your group is protected against fraud'
                                          : 'Your group is not protected',
                                      style: TextStyle(
                                        color: AppTheme.textSecondary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spacingM,
                                vertical: AppTheme.spacingM,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStatItem(
                                    label: 'Total Protection',
                                    value: '₨13,000',
                                    icon: Icons.account_balance_wallet_outlined,
                                    color: AppTheme.primaryNeon,
                                  ),
                                  Container(
                                    height: 40,
                                    width: 1,
                                    color: AppTheme.textMuted.withOpacity(0.2),
                                  ),
                                  _buildStatItem(
                                    label: 'Active Members',
                                    value: '3/4',
                                    icon: Icons.people_outline,
                                    color: AppTheme.warningNeon,
                                  ),
                                  Container(
                                    height: 40,
                                    width: 1,
                                    color: AppTheme.textMuted.withOpacity(0.2),
                                  ),
                                  _buildStatItem(
                                    label: 'Claims',
                                    value: '0',
                                    icon: Icons.history_outlined,
                                    color: AppTheme.accentNeon,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingM,
                    vertical: AppTheme.spacingM,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Group Members',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      if (_isEditing)
                        FuturisticButton(
                          text: 'Add Member',
                          onPressed: () {},
                          prefixIcon: Icons.person_add_alt_1_rounded,
                          height: 40,
                          borderRadius: AppTheme.radiusLarge,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingM,
                            vertical: AppTheme.spacingXS,
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Members list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      left: AppTheme.spacingM,
                      right: AppTheme.spacingM,
                      bottom: AppTheme.spacingL,
                    ),
                    itemCount: _members.length,
                    itemBuilder: (context, index) {
                      return _buildMemberCard(_members[index], index);
                    },
                  ),
                ),
                
                // Bottom action
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
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
      ),
    );
  }
  
  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.textMuted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  
  Widget _buildMemberCard(GroupMember member, int index) {
    final isAdmin = member.role == 'Admin';
    
    return NeuroCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
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
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Row(
          children: [
            // Avatar and status indicator
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 50,
                  height: 50,
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
                    bottom: -5,
                    right: -5,
                    child: Container(
                      width: 18,
                      height: 18,
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
            
            const SizedBox(width: AppTheme.spacingM),
            
            // Member info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        member.name,
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingXS),
                      if (isAdmin)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryNeon.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Admin',
                            style: TextStyle(
                              color: AppTheme.primaryNeon,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        color: AppTheme.textMuted,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '₨${member.contribution.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Icon(
                        Icons.shield_outlined,
                        color: member.isSharing ? AppTheme.primaryNeon : AppTheme.textMuted,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        member.isSharing ? 'Sharing' : 'Not sharing',
                        style: TextStyle(
                          color: member.isSharing
                              ? AppTheme.textSecondary
                              : AppTheme.textMuted,
                          fontSize: 14,
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