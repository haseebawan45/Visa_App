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
  'Pakistan',
  'Afghanistan',
  'Albania',
  'Algeria',
  'Andorra',
  'Angola',
  'Argentina',
  'Armenia',
  'Australia',
  'Austria',
  'Azerbaijan',
  'Bahrain',
  'Bangladesh',
  'Belarus',
  'Belgium',
  'Bhutan',
  'Bosnia and Herzegovina',
  'Brazil',
  'Brunei',
  'Bulgaria',
  'Cambodia',
  'Cameroon',
  'Canada',
  'Chile',
  'China',
  'Colombia',
  'Croatia',
  'Cyprus',
  'Czech Republic',
  'Denmark',
  'Egypt',
  'Estonia',
  'Ethiopia',
  'Finland',
  'France',
  'Georgia',
  'Germany',
  'Ghana',
  'Greece',
  'Hungary',
  'Iceland',
  'India',
  'Indonesia',
  'Iran',
  'Iraq',
  'Ireland',
  'Israel',
  'Italy',
  'Japan',
  'Jordan',
  'Kazakhstan',
  'Kenya',
  'Kuwait',
  'Kyrgyzstan',
  'Laos',
  'Latvia',
  'Lebanon',
  'Libya',
  'Lithuania',
  'Luxembourg',
  'Malaysia',
  'Maldives',
  'Malta',
  'Mauritius',
  'Mexico',
  'Moldova',
  'Monaco',
  'Mongolia',
  'Montenegro',
  'Morocco',
  'Nepal',
  'Netherlands',
  'New Zealand',
  'Nigeria',
  'North Macedonia',
  'Norway',
  'Oman',
  'Palestine',
  'Philippines',
  'Poland',
  'Portugal',
  'Qatar',
  'Romania',
  'Russia',
  'Rwanda',
  'Saudi Arabia',
  'Serbia',
  'Singapore',
  'Slovakia',
  'Slovenia',
  'South Africa',
  'South Korea',
  'Spain',
  'Sri Lanka',
  'Sudan',
  'Sweden',
  'Switzerland',
  'Syria',
  'Tajikistan',
  'Tanzania',
  'Thailand',
  'Tunisia',
  'Turkey',
  'Turkmenistan',
  'UAE',
  'Uganda',
  'Ukraine',
  'United Arab Emirates',
  'United Kingdom',
  'United States',
  'Uruguay',
  'Uzbekistan',
  'Vatican City',
  'Venezuela',
  'Vietnam',
  'Yemen',
  'Zambia',
  'Zimbabwe',
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
    // Get screen dimensions for responsive sizing
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    final EdgeInsets systemPadding = MediaQuery.of(context).padding;
    
    // Calculate responsive dimensions
    final double buttonSize = screenWidth * 0.11;
    final double iconSize = screenWidth * 0.05;
    final double smallIconSize = screenWidth * 0.04;
    final double paddingSize = screenWidth * 0.04;
    final double smallPaddingSize = screenWidth * 0.02;
    final double titleFontSize = screenWidth * 0.055;
    final double subtitleFontSize = screenWidth * 0.045;
    final double bodyFontSize = screenWidth * 0.04;
    final double smallFontSize = screenWidth * 0.03;
    
    // Calculate map container height based on screen size
    final double mapContainerHeight = _isTravelModeActive 
                                      ? screenHeight * 0.25 
                                      : screenHeight * 0.2;
    
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
                    child: _buildAnimatedMap(screenWidth, screenHeight),
                  ),
                ),
              ],
              
              // Main content
              SafeArea(
                bottom: true,
                maintainBottomViewPadding: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App bar
                    Padding(
                      padding: EdgeInsets.all(paddingSize),
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
                          SizedBox(width: paddingSize),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Travel Mode',
                                    style: TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontSize: titleFontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    _isTravelModeActive
                                        ? 'Active Protection Enabled'
                                        : 'Currently Inactive',
                                    style: TextStyle(
                                      color: _isTravelModeActive
                                          ? AppTheme.accentNeon
                                          : AppTheme.textMuted,
                                      fontSize: smallFontSize,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Map visualization & Toggle container
                    Container(
                      height: mapContainerHeight,
                      margin: EdgeInsets.symmetric(
                        horizontal: paddingSize,
                        vertical: smallPaddingSize,
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
                                  ? _buildAnimatedMap(screenWidth, screenHeight)
                                  : _buildTravelModePrompt(
                                      screenWidth, 
                                      iconSize * 2, 
                                      bodyFontSize, 
                                      smallFontSize, 
                                      paddingSize, 
                                      smallPaddingSize
                                    ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(paddingSize),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          _isTravelModeActive
                                              ? 'Travel Mode Active'
                                              : 'Enable Travel Mode',
                                          style: TextStyle(
                                            color: AppTheme.textPrimary,
                                            fontSize: subtitleFontSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: smallPaddingSize * 0.5),
                                        Text(
                                          _isTravelModeActive
                                              ? 'Travel protection for $_selectedCountry'
                                              : 'Secure your account while traveling',
                                          style: TextStyle(
                                            color: AppTheme.textSecondary,
                                            fontSize: smallFontSize,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  _isActivating
                                      ? SizedBox(
                                          width: buttonSize * 0.5,
                                          height: buttonSize * 0.5,
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
                    ),
                    
                    // Travel details
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: paddingSize,
                          vertical: smallPaddingSize,
                        ),
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Destination
                            _buildSectionTitle('Destination', bodyFontSize),
                            NeuroCard(
                              margin: EdgeInsets.only(bottom: paddingSize),
                              borderRadius: AppTheme.radiusMedium,
                              padding: EdgeInsets.all(paddingSize),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedCountry,
                                  isExpanded: true,
                                  dropdownColor: AppTheme.backgroundLighter,
                                  style: TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: bodyFontSize,
                                  ),
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: AppTheme.textSecondary,
                                    size: iconSize,
                                  ),
                                  items: _countriesList.map((String country) {
                                    return DropdownMenuItem<String>(
                                      value: country,
                                      child: Text(
                                        country,
                                        overflow: TextOverflow.ellipsis,
                                      ),
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
                            ),
                            
                            // Date range
                            _buildSectionTitle('Travel Dates', bodyFontSize),
                            GestureDetector(
                              onTap: _isTravelModeActive ? null : _showDateRangePicker,
                              child: NeuroCard(
                                margin: EdgeInsets.only(bottom: paddingSize),
                                borderRadius: AppTheme.radiusMedium,
                                padding: EdgeInsets.all(paddingSize),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      color: _isTravelModeActive
                                          ? AppTheme.textMuted
                                          : AppTheme.accentNeon,
                                      size: smallIconSize,
                                    ),
                                    SizedBox(width: paddingSize),
                                    Expanded(
                                      child: Text(
                                        _formattedDateRange,
                                        style: TextStyle(
                                          color: AppTheme.textPrimary,
                                          fontSize: bodyFontSize,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      color: _isTravelModeActive
                                          ? AppTheme.textMuted
                                          : AppTheme.textSecondary,
                                      size: smallIconSize,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            // Settings
                            _buildSectionTitle('Settings', bodyFontSize),
                            
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
                              iconSize: smallIconSize,
                              padding: paddingSize,
                              smallPadding: smallPaddingSize,
                              bodyFontSize: bodyFontSize,
                              smallFontSize: smallFontSize,
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
                              iconSize: smallIconSize,
                              padding: paddingSize,
                              smallPadding: smallPaddingSize,
                              bodyFontSize: bodyFontSize,
                              smallFontSize: smallFontSize,
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
                              iconSize: smallIconSize,
                              padding: paddingSize,
                              smallPadding: smallPaddingSize,
                              bodyFontSize: bodyFontSize,
                              smallFontSize: smallFontSize,
                            ),
                            
                            // Add extra padding at the bottom to avoid cropping
                            SizedBox(height: paddingSize * 2),
                          ],
                        ),
                      ),
                    ),
                    
                    // Bottom actions
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(paddingSize),
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
          );
        }
      ),
    );
  }
  
  Widget _buildSectionTitle(String title, double fontSize) {
    return Padding(
      padding: EdgeInsets.only(
        top: fontSize * 0.5,
        bottom: fontSize * 0.5,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: AppTheme.textPrimary,
          fontSize: fontSize,
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
    required double iconSize,
    required double padding,
    required double smallPadding,
    required double bodyFontSize,
    required double smallFontSize,
  }) {
    // Ensure icon size is never negative
    final double safeIconSize = max(16.0, iconSize);
    final double iconContainerSize = max(32.0, safeIconSize * 2.1);
    
    return NeuroCard(
      margin: EdgeInsets.only(bottom: padding),
      borderRadius: AppTheme.radiusMedium,
      padding: EdgeInsets.all(padding),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: iconContainerSize,
            height: iconContainerSize,
            decoration: BoxDecoration(
              color: AppTheme.backgroundLighter,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Icon(
              icon,
              color: _isTravelModeActive && value
                  ? AppTheme.accentNeon
                  : AppTheme.textMuted,
              size: safeIconSize,
            ),
          ),
          SizedBox(width: padding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: max(12.0, bodyFontSize),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: max(2.0, smallPadding * 0.25)),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: max(8.0, smallFontSize),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
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
    );
  }
  
  Widget _buildTravelModePrompt(
    double screenWidth, 
    double iconSize, 
    double bodyFontSize, 
    double smallFontSize, 
    double paddingSize, 
    double smallPaddingSize
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate available space and adapt layout
        final double maxHeight = constraints.maxHeight;
        final double maxWidth = constraints.maxWidth;
        
        // Ensure icon size is never negative and scales with available space
        final double adjustedIconSize = max(24.0, min(iconSize, maxHeight * 0.2));
        
        // For very small spaces, use a more compact layout
        if (maxHeight < 100) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.flight_takeoff_rounded,
                color: AppTheme.accentNeon,
                size: adjustedIconSize,
              ),
              SizedBox(width: smallPaddingSize),
              Expanded(
                child: Text(
                  'Set up Travel Mode',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: max(10.0, smallFontSize),
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        }
        
        // Normal layout for adequate space
        return Padding(
          padding: EdgeInsets.all(paddingSize * 0.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.flight_takeoff_rounded,
                color: AppTheme.accentNeon,
                size: adjustedIconSize,
              ),
              SizedBox(height: smallPaddingSize * 0.5),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Set up Travel Mode',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: bodyFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Only show this if we have enough space
              if (maxHeight > 130)
                Flexible(
                  child: Text(
                    'Protect your account while traveling',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: max(8.0, smallFontSize),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        );
      }
    );
  }
  
  Widget _buildAnimatedMap(double screenWidth, double screenHeight) {
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
          top: screenHeight * 0.1,
          left: screenWidth * 0.4,
          child: Container(
            width: max(8.0, screenWidth * 0.05),
            height: max(8.0, screenWidth * 0.05),
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
          top: screenHeight * 0.08,
          right: screenWidth * 0.05,
          child: GlassContainer(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenWidth * 0.02,
            ),
            borderRadius: AppTheme.radiusMedium,
            opacity: 0.1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on,
                  color: AppTheme.accentNeon,
                  size: max(12.0, screenWidth * 0.04),
                ),
                SizedBox(width: screenWidth * 0.01),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: screenWidth * 0.4),
                  child: Text(
                    _selectedCountry,
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: max(10.0, screenWidth * 0.035),
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
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