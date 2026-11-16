import 'package:flutter/material.dart';

/// Paleta do TripBudget, extraída dos tokens de `index.css` do projeto Web.
///
/// `abstract final class` impede que a classe seja instanciada ou estendida:
/// ela serve apenas como "namespace" para constantes.
abstract final class AppColors {
  static const Color petrol = Color(0xFF07565C);
  static const Color petrolDark = Color(0xFF043E43);
  static const Color green = Color(0xFF0D9B83);
  static const Color greenDark = Color(0xFF087964);
  static const Color mint = Color(0xFFE9F5F2);
  static const Color mintStrong = Color(0xFFCCE9E3);
  static const Color yellow = Color(0xFFF4B95F);
  static const Color yellowPale = Color(0xFFFFF5DF);
  static const Color yellowDark = Color(0xFFD18A21);
  static const Color white = Color(0xFFFFFFFF);
  static const Color cloud = Color(0xFFF7F9FC);
  static const Color ink = Color(0xFF15363A);
  static const Color muted = Color(0xFF6F8588);
  static const Color border = Color(0xFFE3EBED);
  static const Color track = Color(0xFFE7EEEE);
  static const Color danger = Color(0xFFC94F4F);
  static const Color dangerPale = Color(0xFFFFF0F0);

  /// Cores usadas no gráfico de categorias do Web.
  static const Color seaFoam = Color(0xFFA8D8CF);
  static const Color lavender = Color(0xFF8C60A7);
  static const Color lavenderPale = Color(0xFFF7EDFB);
}
