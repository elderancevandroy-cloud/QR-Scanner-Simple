import 'package:flutter/material.dart';

/// Konstanta aplikasi QR Scanner
class AppConstants {
  // App Info
  static const String appName = 'QR Scanner Pro';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Simple & Powerful QR Code Scanner';

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 350);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Scanner Settings
  static const int scannerDetectionTimeout = 10; // seconds
  static const double scannerOverlayRatio = 0.7;

  // Storage Keys (untuk SharedPreferences jika diperlukan)
  static const String keyScanHistory = 'scan_history';
  static const String keyFavorites = 'favorites';
  static const String keySettings = 'settings';
  static const String keyFirstLaunch = 'first_launch';

  // Limits
  static const int maxHistoryItems = 1000;
  static const int maxSearchResults = 50;
}

/// Warna aplikasi
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF5A52D5);
  static const Color primaryLight = Color(0xFF8B85FF);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF00BFA6);
  static const Color secondaryDark = Color(0xFF00A693);
  static const Color secondaryLight = Color(0xFF33CCB8);

  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textHint = Color(0xFFB2BEC3);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color error = Color(0xFFFF7675);
  static const Color info = Color(0xFF74B9FF);

  // Type-specific Colors (untuk QR Type)
  static const Color urlColor = Color(0xFF3498DB);
  static const Color wifiColor = Color(0xFF27AE60);
  static const Color contactColor = Color(0xFF9B59B6);
  static const Color emailColor = Color(0xFFE67E22);
  static const Color smsColor = Color(0xFF1ABC9C);
  static const Color locationColor = Color(0xFFE91E63);
  static const Color textColor = Color(0xFF607D8B);
  static const Color unknownColor = Color(0xFF95A5A6);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF6C63FF),
    Color(0xFF5A52D5),
  ];

  static const List<Color> scannerGradient = [
    Color(0xFF00BFA6),
    Color(0xFF00A693),
  ];

  // Overlay Colors
  static const Color scannerOverlay = Color(0x80000000);
  static const Color scannerCorner = Color(0xFF00BFA6);
}

/// Typography aplikasi
class AppTypography {
  // Font Family - menggunakan system default
  static const String fontFamily = 'Roboto';

  // Heading Styles
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // Special Styles
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
    height: 1.0,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textHint,
    height: 1.4,
    letterSpacing: 0.5,
  );
}

/// Spacing dan sizing
class AppSpacing {
  // Padding
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // Border Radius
  static const double radiusSm = 4;
  static const double radiusMd = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 16;
  static const double radiusXXl = 24;
  static const double radiusFull = 999;

  // Icon Sizes
  static const double iconSm = 16;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 48;

  // Button Heights
  static const double buttonHeightSm = 36;
  static const double buttonHeightMd = 48;
  static const double buttonHeightLg = 56;
}

/// Shadows
class AppShadows {
  static const BoxShadow small = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 4,
    offset: Offset(0, 2),
  );

  static const BoxShadow medium = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 8,
    offset: Offset(0, 4),
  );

  static const BoxShadow large = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 16,
    offset: Offset(0, 8),
  );

  static const BoxShadow card = BoxShadow(
    color: Color(0x0D000000),
    blurRadius: 10,
    offset: Offset(0, 4),
  );
}

/// QR Type Colors Helper
class QRTypeColors {
  static Color getColor(String typeName) {
    switch (typeName) {
      case 'url':
        return AppColors.urlColor;
      case 'wifi':
        return AppColors.wifiColor;
      case 'contact':
        return AppColors.contactColor;
      case 'email':
        return AppColors.emailColor;
      case 'sms':
        return AppColors.smsColor;
      case 'location':
        return AppColors.locationColor;
      case 'text':
        return AppColors.textColor;
      default:
        return AppColors.unknownColor;
    }
  }

  static IconData getIcon(String typeName) {
    switch (typeName) {
      case 'url':
        return Icons.link;
      case 'wifi':
        return Icons.wifi;
      case 'contact':
        return Icons.contact_page;
      case 'email':
        return Icons.email;
      case 'sms':
        return Icons.sms;
      case 'location':
        return Icons.location_on;
      case 'text':
        return Icons.text_fields;
      default:
        return Icons.qr_code;
    }
  }
}
