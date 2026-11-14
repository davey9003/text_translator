import 'package:flutter/material.dart';

class AppThemeExtensions extends ThemeExtension<AppThemeExtensions> {
  final Color cardBackground;
  final Color dividerColor;
  
  const AppThemeExtensions({
    required this.cardBackground,
    required this.dividerColor,
  });
  
  @override
  AppThemeExtensions copyWith({
    Color? cardBackground,
    Color? dividerColor,
  }) {
    return AppThemeExtensions(
      cardBackground: cardBackground ?? this.cardBackground,
      dividerColor: dividerColor ?? this.dividerColor,
    );
  }
  
  @override
  AppThemeExtensions lerp(AppThemeExtensions? other, double t) {
    if (other is! AppThemeExtensions) {
      return this;
    }
    return AppThemeExtensions(
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
    );
  }
}


