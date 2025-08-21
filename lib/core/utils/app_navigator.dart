import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

sealed class AppNavigator {
  static Listenable get observable => Modular.to;

  static void observer() {
    Modular.to.addListener(() {
      var history = Modular.to.navigateHistory;
      if (history.isEmpty) return;

      dev.log(history.last.name, name: 'Route');
    });
  }

  static List<String> get getHistory {
    return Modular.to.navigateHistory.map((e) => e.name).toList();
  }

  static bool containRoute(String route) {
    return Modular.to.navigateHistory.map((e) => e.name).contains(route);
  }

  static void navigate(String path, {dynamic arguments}) {
    return Modular.to.navigate(path, arguments: arguments);
  }

  static Future<T?> pushNamed<T extends Object?>(
    String name, {
    Object? arguments,
    bool forRoot = false,
  }) {
    return Modular.to.pushNamed(name, arguments: arguments, forRoot: forRoot);
  }

  static Future<T?> pushReplacementNamed<T extends Object?>(
    String name, {
    Object? arguments,
    bool forRoot = false,
  }) {
    return Modular.to.pushReplacementNamed(
      name,
      arguments: arguments,
      forRoot: forRoot,
    );
  }

  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String name,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
    bool forRoot = false,
  }) {
    return Modular.to.pushNamedAndRemoveUntil(
      name,
      predicate,
      arguments: arguments,
      forRoot: forRoot,
    );
  }

  static void pop([dynamic result]) {
    return Modular.to.pop(result);
  }

  static void popUntil(bool Function(Route<dynamic>) predicate) {
    return Modular.to.popUntil(predicate);
  }

  static Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>(
    String name, {
    TO? result,
    Object? arguments,
    bool forRoot = false,
  }) {
    return Modular.to.popAndPushNamed(
      name,
      result: result,
      arguments: arguments,
      forRoot: forRoot,
    );
  }

  static bool get canPop => Modular.to.canPop();
}
