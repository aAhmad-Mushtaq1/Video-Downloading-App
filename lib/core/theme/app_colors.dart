import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0A0E27);
  static const Color darkSurface = Color(0xFF151B3D);
  static const Color darkCard = Color(0xFF1E2749);
  
  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF0F2F5);
  
  // Primary Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Secondary Gradient
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFF093FB), Color(0xFFF5576C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Success Gradient
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Accent Colors
  static const Color accentPurple = Color(0xFF667EEA);
  static const Color accentPink = Color(0xFFF5576C);
  static const Color accentGreen = Color(0xFF38EF7D);
  static const Color accentBlue = Color(0xFF4A90E2);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B7C3);
  static const Color textTertiary = Color(0xFF6C7A8A);
  
  // Glassmorphism
  static Color glassLight = Colors.white.withOpacity(0.1);
  static Color glassDark = Colors.black.withOpacity(0.2);
  static Color glassStroke = Colors.white.withOpacity(0.2);
  
  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
  
  static List<BoxShadow> glowShadow = [
    BoxShadow(
      color: accentPurple.withOpacity(0.3),
      blurRadius: 30,
      spreadRadius: 5,
    ),
  ];
}
