import 'package:flutter/material.dart';

import 'base_colors.dart';

part './app_text_theme.dart';

final class AppTheme {
  static final appTextTheme = _AppTextTheme();

  static final baseColorLight = AppThemeLight();

  static final colorSchemeLight = _buildColorScheme(baseColorLight);

  static final lightTheme = _buildThemeData(colorSchemeLight, baseColorLight);

  static ThemeData _buildThemeData(ColorScheme scheme, BaseColors colors) {
    final defaultInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colors.outline),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      disabledColor: colors.tertiary,
      scaffoldBackgroundColor: colors.surface,
      cardTheme: CardThemeData(
        shadowColor: Colors.transparent,
        color: colors.surfaceContainer,
      ),
      iconTheme: IconThemeData(color: colors.onSurface),
      // textTheme: _AppTextTheme.textTheme.apply(fontFamily: 'Inter'),
      textTheme: _AppTextTheme.textTheme,

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        labelStyle: _AppTextTheme.labelMedium.copyWith(color: colors.onSurface),
        hintStyle: _AppTextTheme.labelMedium.copyWith(
          color: colors.onSurfaceVariant,
        ),
        errorStyle: _AppTextTheme.labelMedium.copyWith(color: colors.error),
        disabledBorder: defaultInputBorder,
        border: defaultInputBorder,
        enabledBorder: defaultInputBorder,
        focusedBorder: defaultInputBorder,
        errorBorder: defaultInputBorder.copyWith(
          borderSide: BorderSide(color: colors.error),
        ),
      ),
    );
  }

  static ColorScheme _buildColorScheme(BaseColors colors) {
    final ColorScheme colorScheme = colors.brightness == Brightness.light
        ? ColorScheme.light()
        : ColorScheme.dark();
    return colorScheme.copyWith(
      onSurfaceVariant: colors.onSurfaceVariant,
      brightness: colors.brightness,
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      inversePrimary: colors.inversePrimary,
      secondary: colors.secondary,
      onSecondary: colors.onSecondary,
      surface: colors.surface,
      onSurface: colors.onSurface,
      surfaceContainerHighest: colors.surfaceContainerHighest,
      surfaceContainer: colors.surfaceContainer,
      inverseSurface: colors.inverseSurface,
      onInverseSurface: colors.onInverseSurface,
      error: colors.error,
      onError: colors.onError,
      errorContainer: colors.errorContainer,
      onErrorContainer: colors.onErrorContainer,
      shadow: colors.shadow,
      outline: colors.outline,
      tertiary: colors.tertiary,
      onTertiary: colors.onTertiary,
    );
  }
}
