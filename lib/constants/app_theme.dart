import 'package:flutter/material.dart';
import 'app_constants.dart';

// Bright Starts Academy theme configuration
class AppTheme {
  static const Color primaryColor = Color(AppConstants.primaryColor);
  static const Color secondaryColor = Color(AppConstants.secondaryColor);
  static const Color accentColor = Color(AppConstants.accentColor);
  static const Color backgroundColor = Color(AppConstants.backgroundColor);
  static const Color cardColor = Color(AppConstants.cardColor);
  static const Color textColor = Color(AppConstants.textColor);
  static const Color textSecondaryColor = Color(AppConstants.textSecondaryColor);
  
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: cardColor,
        background: backgroundColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textColor,
        onBackground: textColor,
        error: Colors.red[400]!,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLarge,
            vertical: AppConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLarge,
            vertical: AppConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.all(AppConstants.paddingMedium),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        type: BottomNavigationBarType.fixed,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: backgroundColor,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: textColor,
          fontSize: AppConstants.fontSizeXXLarge,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: textColor,
          fontSize: AppConstants.fontSizeXLarge,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: textColor,
          fontSize: AppConstants.fontSizeLarge,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: textColor,
          fontSize: AppConstants.fontSizeMedium,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: textColor,
          fontSize: AppConstants.fontSizeLarge,
        ),
        bodyMedium: TextStyle(
          color: textColor,
          fontSize: AppConstants.fontSizeMedium,
        ),
        bodySmall: TextStyle(
          color: textSecondaryColor,
          fontSize: AppConstants.fontSizeSmall,
        ),
      ),
    );
  }
  
  static InputDecoration inputDecoration({
    required String label,
    String? hint,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      suffixIcon: suffixIcon,
    );
  }
  
  static BoxDecoration cardDecoration({
    Color? color,
    double? radius,
  }) {
    return BoxDecoration(
      color: color ?? cardColor,
      borderRadius: BorderRadius.circular(radius ?? AppConstants.radiusMedium),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}