/// Escalas de espaçamento e raio usadas em todo o app.
///
/// Centralizar esses valores evita "números mágicos" espalhados pelos widgets
/// e mantém o layout consistente.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  /// Margem lateral padrão das telas.
  static const double screen = 20;
}

abstract final class AppRadius {
  static const double input = 10;
  static const double button = 12;
  static const double card = 16;
  static const double pill = 999;
}
