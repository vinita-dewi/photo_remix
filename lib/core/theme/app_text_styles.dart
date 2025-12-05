import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Predefined text styles using Nunito.
class AppTextStyles {
  AppTextStyles._();

  static TextTheme textTheme = TextTheme(
    displayLarge: _nunito(32, FontWeight.w700),
    displayMedium: _nunito(28, FontWeight.w700),
    displaySmall: _nunito(24, FontWeight.w700),
    headlineMedium: _nunito(22, FontWeight.w600),
    headlineSmall: _nunito(20, FontWeight.w600),
    titleLarge: _nunito(18, FontWeight.w600),
    titleMedium: _nunito(16, FontWeight.w600),
    titleSmall: _nunito(15, FontWeight.w600),
    bodyLarge: _nunito(16, FontWeight.w500, color: AppColors.textPrimary),
    bodyMedium: _nunito(14, FontWeight.w500, color: AppColors.textSecondary),
    bodySmall: _nunito(12, FontWeight.w500, color: AppColors.textSecondary),
    labelLarge: _nunito(14, FontWeight.w700),
    labelMedium: _nunito(12, FontWeight.w700),
    labelSmall: _nunito(11, FontWeight.w700),
  );

  static TextStyle _nunito(double size, FontWeight weight, {Color? color}) {
    return GoogleFonts.nunito(
      fontSize: size,
      fontWeight: weight,
      color: color ?? AppColors.textPrimary,
      height: 1.25,
      letterSpacing: 0.1,
    );
  }
}
