import 'package:flutter/material.dart';

abstract class BaseColors {
  Brightness get brightness;

  Color get navigationBarSurfaceTint;
  Color get navigationBarShadow;
  Color get navigationBarBackground;

  Color get primary;
  Color get onPrimary;
  Color get inversePrimary;

  Color get secondary;
  Color get onSecondary;

  Color get surface;
  Color get onSurface;
  Color get surfaceContainerHighest;
  Color get surfaceContainer;
  Color get onSurfaceVariant;

  Color get inverseSurface;
  Color get onInverseSurface;

  Color get error;
  Color get onError;
  Color get errorContainer;
  Color get onErrorContainer;

  Color get shadow;
  Color get outline;

  Color get tertiary;
  Color get onTertiary;
}

class AppThemeLight extends BaseColors {
  @override
  Brightness get brightness => Brightness.light;

  // NavigationBar
  @override
  Color get navigationBarSurfaceTint => Color(0xFFFFFFFF);
  @override
  Color get navigationBarShadow => Color(0xFFD6D6D6);
  @override
  Color get navigationBarBackground => Color(0xFF623CCE);

  @override
  Color get primary => Color(0xFF623CCE);
  @override
  Color get onPrimary => Color(0xFFFFFFFF);
  @override
  Color get inversePrimary => Color(0xFF494C52);

  @override
  Color get secondary => Color(0xFF494C52);
  @override
  Color get onSecondary => Color(0xFFFFFFFF);

  @override
  Color get surface => Color(0xFFFFFFFF);
  @override
  Color get onSurface => Color(0xFF1A1C1E);
  @override
  Color get onSurfaceVariant => Color(0xFFD6D6D6);
  @override
  Color get surfaceContainerHighest => Color(0xFF1A1C1E);

  @override
  Color get surfaceContainer => Color(0xFFF3F3F3);

  @override
  Color get inverseSurface => Color(0xFFF3F3F3);
  @override
  Color get onInverseSurface => Color(0xFF1A1C1E);

  @override
  Color get error => Color(0xFFC13030);
  @override
  Color get onError => Color(0xFFFFFFFF);
  @override
  Color get errorContainer => Color(0xFFFF7777);
  @override
  Color get onErrorContainer => Color(0xFFFFFFFF);

  @override
  Color get shadow => Color(0xFFAFAFAF);
  @override
  Color get outline => Color(0xFFD6D6D6);

  @override
  Color get tertiary => Color(0xFFD6D6D6);

  @override
  Color get onTertiary => Color(0xFF494C52);
}

class AppThemeDark extends BaseColors {
  @override
  Brightness get brightness => Brightness.dark;
  Color get seedColor => Color(0xFF623CCE);

  @override
  Color get navigationBarSurfaceTint => Color(0xFFFFFFFF);
  @override
  Color get navigationBarShadow => Color(0xFFBDBDBD);
  @override
  Color get navigationBarBackground => Color(0xFF8C6EFF);

  @override
  Color get primary => Color(0xFF8C6EFF);
  @override
  Color get onPrimary => Color(0xFFFFFFFF);
  @override
  Color get inversePrimary => Color(0xFFBDBDBD);

  @override
  Color get secondary => Color(0xFFBDBDBD);
  @override
  Color get onSecondary => Color(0xFF1A1C1E);

  @override
  Color get surface => Color(0xFF1A1C1E);
  @override
  Color get onSurface => Color(0xFFFFFFFF);
  @override
  @override
  Color get onSurfaceVariant => Color(0xFF494C52);
  @override
  Color get surfaceContainerHighest => Color(0xFFD6D6D6);
  @override
  Color get surfaceContainer => Color(0xFF2C2E33);
  @override
  Color get inverseSurface => Color(0xFFF3F3F3);
  @override
  Color get onInverseSurface => Color(0xFF1A1C1E);

  @override
  Color get error => Color(0xFFC13030);
  @override
  Color get onError => Color(0xFFFFFFFF);
  @override
  Color get errorContainer => Color(0xFFFF7777);
  @override
  Color get onErrorContainer => Color(0xFFFFFFFF);

  @override
  Color get shadow => Color(0xFF636363);
  @override
  Color get outline => Color(0xFF494C52);

  @override
  Color get tertiary => Color(0xFF494C52);

  @override
  Color get onTertiary => Color(0xFFFFFFFF);
}

final class AppColors {
  static const Color blue = Color(0xFF623CCE);
  static const Color green = Color(0xFF30C147);
  static const Color red = Color(0xFFC13030);
  static const Color white = Color(0xFFFFFFFF);
  static const Color colorLinks = Color(0xFF623CCE);
  static const Color lightColor = Color(0XFFD6D6D6);
  static const Color darkColor = Color(0XFF494C52);
}
