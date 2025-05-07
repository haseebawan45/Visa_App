import 'package:flutter/material.dart';

class OnboardingData {
  final String title;
  final String description;
  final String assetPath;
  final Color? accentColor;
  final bool isLottieAnimation;

  const OnboardingData({
    required this.title,
    required this.description,
    required this.assetPath,
    this.accentColor,
    this.isLottieAnimation = true,
  });

  static List<OnboardingData> getOnboardingPages() {
    return [
      const OnboardingData(
        title: "Futuristic Banking",
        description: "Experience the next generation of financial security and advanced payment capabilities in Pakistan.",
        assetPath: "assets/animations/digital_wallet.json",
        accentColor: Color(0xFF00E6C3), // Teal
      ),
      const OnboardingData(
        title: "Scam Radar Protection",
        description: "Advanced AI-powered fraud detection keeps your money safe with real-time monitoring and alerts.",
        assetPath: "assets/animations/security_shield.json",
        accentColor: Color(0xFF7B42F6), // Purple
      ),
      const OnboardingData(
        title: "Ghost Payments",
        description: "Generate secure one-time payment links and QR codes that leave no digital trace after use.",
        assetPath: "assets/animations/qr_scan.json",
        accentColor: Color(0xFF00B6FF), // Electric blue
      ),
      const OnboardingData(
        title: "Group Protection",
        description: "Create secure payment circles with trusted friends and family for shared expenses with real-time monitoring.",
        assetPath: "assets/animations/group_security.json",
        accentColor: Color(0xFFE345FF), // Pink
      ),
    ];
  }
} 