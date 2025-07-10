import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visa_app/models/onboarding_data.dart';
import 'package:visa_app/screens/dashboard_screen.dart';
import 'package:visa_app/theme/app_theme.dart';
import 'package:visa_app/widgets/futuristic_button.dart';
import 'package:visa_app/widgets/glass_container.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<OnboardingData> _pages = OnboardingData.getOnboardingPages();
  final SwiperController _swiperController = SwiperController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  void _onIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: AppTheme.animSlow,
        pageBuilder: (context, animation, secondaryAnimation) => 
          FadeTransition(
            opacity: animation,
            child: const DashboardScreen(),
          ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Background animated gradient
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.backgroundDarker,
                    _pages[_currentIndex].accentColor?.withOpacity(0.1) ?? 
                        AppTheme.primaryNeon.withOpacity(0.1),
                    AppTheme.backgroundDarker,
                  ],
                ),
              ),
            ),
          ),
          
          // Decorative elements
          Positioned(
            top: -screenHeight * 0.05,
            right: -screenWidth * 0.2,
            child: Container(
              width: screenWidth * 0.5,
              height: screenWidth * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _pages[_currentIndex].accentColor?.withOpacity(0.2) ?? 
                        AppTheme.primaryNeon.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          Positioned(
            bottom: screenHeight * 0.05,
            left: -screenWidth * 0.3,
            child: Container(
              width: screenWidth * 0.6,
              height: screenWidth * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _pages[_currentIndex].accentColor?.withOpacity(0.15) ?? 
                        AppTheme.primaryNeon.withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: Column(
              children: [
                // App logo
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppTheme.spacingL,
                    horizontal: AppTheme.spacingM,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shield,
                        color: AppTheme.primaryNeon,
                        size: 28,
                      ),
                      const SizedBox(width: AppTheme.spacingS),
                      Text(
                        "BEE NETWORK",
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 800.ms, curve: Curves.easeOutQuad)
                      .slideY(begin: -0.2, end: 0, duration: 800.ms, curve: Curves.easeOutQuad),
                ),
                
                // Swiper
                Expanded(
                  child: Swiper(
                    itemBuilder: (context, index) {
                      final page = _pages[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animation
                          SizedBox(
                            height: screenHeight * 0.3,
                            child: Lottie.asset(
                              page.assetPath,
                              animate: true,
                              repeat: true,
                            ),
                          )
                              .animate(
                                target: _currentIndex == index ? 1 : 0,
                                delay: 200.ms,
                              )
                              .fadeIn(duration: 800.ms, curve: Curves.easeOut)
                              .scaleXY(begin: 0.9, end: 1.0, duration: 800.ms, curve: Curves.easeOut),
                          
                          const SizedBox(height: AppTheme.spacingXL),
                          
                          // Title
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
                            child: Text(
                              page.title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                                .animate(
                                  target: _currentIndex == index ? 1 : 0,
                                  delay: 300.ms,
                                )
                                .fadeIn(duration: 800.ms, curve: Curves.easeOut)
                                .slideY(begin: 0.2, end: 0, duration: 800.ms, curve: Curves.easeOut),
                          ),
                          
                          const SizedBox(height: AppTheme.spacingM),
                          
                          // Description - Fixed with ConstrainedBox to prevent infinite height
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXL),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: screenHeight * 0.2,
                              ),
                              child: GlassContainer(
                                color: AppTheme.backgroundLighter,
                                borderRadius: AppTheme.radiusMedium,
                                padding: const EdgeInsets.all(AppTheme.spacingM),
                                child: Text(
                                  page.description,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppTheme.textSecondary,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            )
                                .animate(
                                  target: _currentIndex == index ? 1 : 0,
                                  delay: 400.ms,
                                )
                                .fadeIn(duration: 800.ms, curve: Curves.easeOut)
                                .slideY(begin: 0.3, end: 0, duration: 800.ms, curve: Curves.easeOut),
                          ),
                        ],
                      );
                    },
                    itemCount: _pages.length,
                    controller: _swiperController,
                    onIndexChanged: _onIndexChanged,
                    pagination: SwiperPagination(
                      margin: const EdgeInsets.only(bottom: AppTheme.spacingL),
                      builder: DotSwiperPaginationBuilder(
                        size: 8.0,
                        activeSize: 10.0,
                        color: AppTheme.textMuted,
                        activeColor: _pages[_currentIndex].accentColor ?? AppTheme.primaryNeon,
                      ),
                    ),
                    curve: Curves.easeInOutCubic,
                    duration: 800,
                  ),
                ),
                
                // Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingL, 
                    vertical: AppTheme.spacingXL,
                  ),
                  child: Column(
                    children: [
                      FuturisticButton(
                        text: _currentIndex == _pages.length - 1
                            ? "Get Started"
                            : "Next",
                        color: _pages[_currentIndex].accentColor ?? AppTheme.primaryNeon,
                        onPressed: () {
                          if (_currentIndex < _pages.length - 1) {
                            _swiperController.next();
                          } else {
                            _navigateToDashboard();
                          }
                        },
                      ),
                      
                      if (_currentIndex < _pages.length - 1) ...[
                        const SizedBox(height: AppTheme.spacingM),
                        FuturisticButton(
                          text: "Skip",
                          isOutlined: true,
                          color: _pages[_currentIndex].accentColor ?? AppTheme.primaryNeon,
                          onPressed: _navigateToDashboard,
                        ),
                      ],
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 600.ms, curve: Curves.easeOut),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 