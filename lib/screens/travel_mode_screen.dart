import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:visa_app/theme/app_theme.dart';
import 'package:visa_app/widgets/futuristic_button.dart';
import 'package:visa_app/widgets/glass_container.dart';
import 'package:visa_app/widgets/neuro_card.dart';

class TravelModeScreen extends StatefulWidget {
  const TravelModeScreen({super.key});

  @override
  State<TravelModeScreen> createState() => _TravelModeScreenState();
}

class _TravelModeScreenState extends State<TravelModeScreen> with SingleTickerProviderStateMixin {
  bool _isTravelModeActive = false;
  String _selectedCountry = 'United Arab Emirates';
  DateTime _startDate = DateTime.now().add(const Duration(days: 7));
  DateTime _endDate = DateTime.now().add(const Duration(days: 14));
  bool _isAutoExchangeEnabled = true;
  bool _isLocationTrackingEnabled = true;
  bool _isScamBlockingEnabled = true;
  bool _isActivating = false;
  
  late AnimationController _mapAnimationController;
  
  final List<String> _countriesList = [
    'United Arab Emirates',
    'United Kingdom',
    'United States',
    'Qatar',
    'Saudi Arabia',
    'Turkey',
    'Malaysia',
    'Singapore',
  ];
  
  @override
  void initState() {
    super.initState();
    _mapAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    
    // Auto-play the map animation once
    _mapAnimationController.forward();
  }
  
  @override
  void dispose() {
    _mapAnimationController.dispose();
    super.dispose();
  }
  
  void _toggleTravelMode() {
    if (!_isTravelModeActive) {
      setState(() {
        _isActivating = true;
      });
      
      // Simulate activation process
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isTravelModeActive = true;
            _isActivating = false;
          });
        }
      });
    } else {
      setState(() {
        _isTravelModeActive = false;
      });
    }
  }
  
  void _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: _startDate,
        end: _endDate,
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.primaryNeon,
              onPrimary: AppTheme.backgroundDarker,
              surface: AppTheme.backgroundLighter,
              onSurface: AppTheme.textPrimary,
            ),
            dialogBackgroundColor: AppTheme.backgroundLighter,
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }
  
  String get _formattedDateRange {
    return '${_formatDate(_startDate)} - ${_formatDate(_endDate)}';
  }
  
  String _formatDate(DateTime date) {
    final List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}';
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
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.backgroundDarker,
                  AppTheme.background,
                  const Color(0xFF0F1A2A),
                ],
              ),
            ),
          ),
          
          // Map visualization in background
          if (_isTravelModeActive) ...[
            Positioned.fill(
              child: Opacity(
                opacity: 0.2,
                child: _buildAnimatedMap(),
              ),
            ),
          ],
          
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Travel Mode',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _isTravelModeActive
                                ? 'Active Protection Enabled'
                                : 'Currently Inactive',
                            style: TextStyle(
                              color: _isTravelModeActive
                                  ? AppTheme.accentNeon
                                  : AppTheme.textMuted,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Map visualization & Toggle container
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: _isTravelModeActive ? 250 : 200,
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingM,
                    vertical: AppTheme.spacingS,
                  ),
                  child: GlassContainer(
                    borderRadius: AppTheme.radiusLarge,
                    opacity: _isTravelModeActive
                        ? AppTheme.glassOpacityLow
                        : AppTheme.glassOpacityMedium,
                    blur: AppTheme.blurStrong,
                    border: Border.all(
                      color: _isTravelModeActive
                          ? AppTheme.accentNeon.withOpacity(0.3)
                          : Colors.transparent,
                      width: 1.5,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: _isTravelModeActive
                              ? _buildAnimatedMap()
                              : _buildTravelModePrompt(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(AppTheme.spacingM),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _isTravelModeActive
                                          ? 'Travel Mode Active'
                                          : 'Enable Travel Mode',
                                      style: TextStyle(
                                        color: AppTheme.textPrimary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _isTravelModeActive
                                          ? 'Travel protection for $_selectedCountry'
                                          : 'Secure your account while traveling',
                                      style: TextStyle(
                                        color: AppTheme.textSecondary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _isActivating
                                  ? SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          AppTheme.accentNeon,
                                        ),
                                      ),
                                    )
                                  : Switch(
                                      value: _isTravelModeActive,
                                      onChanged: (_) => _toggleTravelMode(),
                                      activeColor: AppTheme.accentNeon,
                                      activeTrackColor: AppTheme.accentNeon.withOpacity(0.3),
                                      inactiveThumbColor: AppTheme.textMuted,
                                      inactiveTrackColor: AppTheme.backgroundLighter,
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .slide(begin: const Offset(0, -0.1), end: Offset.zero, duration: 800.ms),
                
                // Travel details
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingM,
                      vertical: AppTheme.spacingS,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Destination
                        _buildSectionTitle('Destination'),
                        NeuroCard(
                          margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                          borderRadius: AppTheme.radiusMedium,
                          padding: const EdgeInsets.all(AppTheme.spacingM),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCountry,
                              isExpanded: true,
                              dropdownColor: AppTheme.backgroundLighter,
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 16,
                              ),
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppTheme.textSecondary,
                              ),
                              items: _countriesList.map((String country) {
                                return DropdownMenuItem<String>(
                                  value: country,
                                  child: Text(country),
                                );
                              }).toList(),
                              onChanged: _isTravelModeActive
                                  ? null
                                  : (String? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          _selectedCountry = newValue;
                                        });
                                      }
                                    },
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 100.ms, duration: 800.ms)
                            .slide(begin: const Offset(0.05, 0), end: Offset.zero, delay: 100.ms, duration: 800.ms),
                        
                        // Date range
                        _buildSectionTitle('Travel Dates'),
                        GestureDetector(
                          onTap: _isTravelModeActive ? null : _showDateRangePicker,
                          child: NeuroCard(
                            margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                            borderRadius: AppTheme.radiusMedium,
                            padding: const EdgeInsets.all(AppTheme.spacingM),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  color: _isTravelModeActive
                                      ? AppTheme.textMuted
                                      : AppTheme.accentNeon,
                                  size: 20,
                                ),
                                const SizedBox(width: AppTheme.spacingM),
                                Text(
                                  _formattedDateRange,
                                  style: TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: _isTravelModeActive
                                      ? AppTheme.textMuted
                                      : AppTheme.textSecondary,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 200.ms, duration: 800.ms)
                            .slide(begin: const Offset(0.05, 0), end: Offset.zero, delay: 200.ms, duration: 800.ms),
                        
                        // Settings
                        _buildSectionTitle('Settings'),
                        
                        // Auto Currency Exchange
                        _buildSettingToggle(
                          title: 'Auto Currency Exchange',
                          subtitle: 'Automatically use local currency',
                          icon: Icons.currency_exchange_rounded,
                          value: _isAutoExchangeEnabled,
                          onChanged: (value) {
                            if (!_isTravelModeActive) {
                              setState(() {
                                _isAutoExchangeEnabled = value;
                              });
                            }
                          },
                          delay: 300,
                        ),
                        
                        // Location Tracking
                        _buildSettingToggle(
                          title: 'Location Tracking',
                          subtitle: 'Track spending patterns by location',
                          icon: Icons.location_on_outlined,
                          value: _isLocationTrackingEnabled,
                          onChanged: (value) {
                            if (!_isTravelModeActive) {
                              setState(() {
                                _isLocationTrackingEnabled = value;
                              });
                            }
                          },
                          delay: 400,
                        ),
                        
                        // Scam Blocking
                        _buildSettingToggle(
                          title: 'Enhanced Scam Blocking',
                          subtitle: 'Extra protection against tourist scams',
                          icon: Icons.security_rounded,
                          value: _isScamBlockingEnabled,
                          onChanged: (value) {
                            if (!_isTravelModeActive) {
                              setState(() {
                                _isScamBlockingEnabled = value;
                              });
                            }
                          },
                          delay: 500,
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Bottom actions
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: FuturisticButton(
                    text: _isTravelModeActive
                        ? 'Deactivate Travel Mode'
                        : 'Activate Travel Mode',
                    onPressed: _isActivating ? () {} : _toggleTravelMode,
                    color: _isTravelModeActive
                        ? AppTheme.dangerNeon
                        : AppTheme.accentNeon,
                    isLoading: _isActivating,
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
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppTheme.spacingS,
        bottom: AppTheme.spacingS,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildSettingToggle({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required void Function(bool) onChanged,
    required int delay,
  }) {
    return NeuroCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      borderRadius: AppTheme.radiusMedium,
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.backgroundLighter,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Icon(
              icon,
              color: _isTravelModeActive && value
                  ? AppTheme.accentNeon
                  : AppTheme.textMuted,
              size: 20,
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
          Switch(
            value: value,
            onChanged: _isTravelModeActive ? null : onChanged,
            activeColor: AppTheme.accentNeon,
            activeTrackColor: AppTheme.accentNeon.withOpacity(0.3),
            inactiveThumbColor: AppTheme.textMuted,
            inactiveTrackColor: AppTheme.backgroundLighter,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: delay.ms, duration: 800.ms)
        .slide(begin: const Offset(0.05, 0), end: Offset.zero, delay: delay.ms, duration: 800.ms);
  }
  
  Widget _buildTravelModePrompt() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flight_takeoff_rounded,
            color: AppTheme.accentNeon,
            size: 48,
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            'Set up Travel Mode for Your Trip',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXS),
          Text(
            'Protect your account and enable location-based features while traveling',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAnimatedMap() {
    // This is a simplified map animation
    // In a real app, you'd integrate with a mapping library
    return Stack(
      children: [
        // Background map
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _mapAnimationController,
            builder: (context, child) {
              return CustomPaint(
                painter: MapBackgroundPainter(
                  progress: _mapAnimationController.value,
                ),
                size: Size.infinite,
              );
            },
          ),
        ),
        
        // Location indicator
        Positioned(
          top: 80,
          left: MediaQuery.of(context).size.width * 0.4,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppTheme.accentNeon,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentNeon.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          )
              .animate(
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.2, 1.2),
                duration: 1500.ms,
              ),
        ),
        
        // Destination text
        Positioned(
          top: 70,
          right: 20,
          child: GlassContainer(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingM,
              vertical: AppTheme.spacingS,
            ),
            borderRadius: AppTheme.radiusMedium,
            opacity: 0.1,
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppTheme.accentNeon,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  _selectedCountry,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MapBackgroundPainter extends CustomPainter {
  final double progress;
  
  MapBackgroundPainter({required this.progress});
  
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    
    // Background
    final Paint backgroundPaint = Paint()
      ..color = AppTheme.backgroundDarker.withOpacity(0.8);
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), backgroundPaint);
    
    // Grid lines
    final Paint gridPaint = Paint()
      ..color = AppTheme.accentNeon.withOpacity(0.15)
      ..strokeWidth = 1;
    
    // Horizontal lines
    final int horizontalLines = 10;
    final double horizontalSpacing = height / horizontalLines;
    for (int i = 0; i <= horizontalLines; i++) {
      final y = i * horizontalSpacing;
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }
    
    // Vertical lines
    final int verticalLines = 15;
    final double verticalSpacing = width / verticalLines;
    for (int i = 0; i <= verticalLines; i++) {
      final x = i * verticalSpacing;
      canvas.drawLine(Offset(x, 0), Offset(x, height), gridPaint);
    }
    
    // Draw animated connection paths
    final Paint pathPaint = Paint()
      ..color = AppTheme.accentNeon
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    final Path path1 = Path()
      ..moveTo(width * 0.2, height * 0.7)
      ..quadraticBezierTo(
        width * 0.3, 
        height * 0.4, 
        width * 0.4, 
        height * 0.4
      );
    
    final Path path2 = Path()
      ..moveTo(width * 0.6, height * 0.6)
      ..quadraticBezierTo(
        width * 0.75, 
        height * 0.3, 
        width * 0.9, 
        height * 0.2
      );
    
    // Create path metrics to animate drawing
    final PathMetrics pathMetrics1 = path1.computeMetrics();
    final PathMetric pathMetric1 = pathMetrics1.first;
    final Path drawPath1 = Path();
    
    drawPath1.addPath(
      pathMetric1.extractPath(0, pathMetric1.length * progress),
      Offset.zero,
    );
    
    final PathMetrics pathMetrics2 = path2.computeMetrics();
    final PathMetric pathMetric2 = pathMetrics2.first;
    final Path drawPath2 = Path();
    
    drawPath2.addPath(
      pathMetric2.extractPath(0, pathMetric2.length * max(0, progress - 0.3) * 1.4),
      Offset.zero,
    );
    
    canvas.drawPath(drawPath1, pathPaint);
    if (progress > 0.3) {
      canvas.drawPath(drawPath2, pathPaint);
    }
    
    // Draw connection points
    final Paint pointPaint = Paint()
      ..color = AppTheme.accentNeon;
    
    // Start point
    canvas.drawCircle(Offset(width * 0.2, height * 0.7), 4, pointPaint);
    
    // Intermediate points
    if (progress >= 0.5) {
      canvas.drawCircle(Offset(width * 0.4, height * 0.4), 4, pointPaint);
    }
    
    if (progress >= 0.7) {
      canvas.drawCircle(Offset(width * 0.6, height * 0.6), 4, pointPaint);
    }
    
    // End point
    if (progress >= 0.9) {
      canvas.drawCircle(Offset(width * 0.9, height * 0.2), 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(MapBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
} 