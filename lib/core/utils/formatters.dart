/// Formatação de valores para exibição em pt-BR.
///
/// Implementado sem o pacote `intl` porque o MVP só precisa de BRL e de
/// nomes de meses/dias em português. Se o app passar a suportar várias
/// moedas ou idiomas, o `intl` passa a valer a dependência.
abstract final class Formatters {
  static const _months = [
    'jan',
    'fev',
    'mar',
    'abr',
    'mai',
    'jun',
    'jul',
    'ago',
    'set',
    'out',
    'nov',
    'dez',
  ];

  static const _monthsLong = [
    'janeiro',
    'fevereiro',
    'março',
    'abril',
    'maio',
    'junho',
    'julho',
    'agosto',
    'setembro',
    'outubro',
    'novembro',
    'dezembro',
  ];

  /// Índice 0 = segunda-feira, seguindo `DateTime.weekday` (1 = segunda).
  static const _weekdaysShort = [
    'SEG',
    'TER',
    'QUA',
    'QUI',
    'SEX',
    'SÁB',
    'DOM',
  ];

  static const _weekdaysLong = [
    'segunda-feira',
    'terça-feira',
    'quarta-feira',
    'quinta-feira',
    'sexta-feira',
    'sábado',
    'domingo',
  ];

  /// Converte centavos em texto: `1234567` → `R$ 12.345,67`.
  ///
  /// Valores monetários são guardados como inteiros (centavos) para evitar
  /// erros de arredondamento de `double` (ex.: 0.1 + 0.2 != 0.3).
  static String currency(int cents) {
    final sign = cents < 0 ? '-' : '';
    final absolute = cents.abs();
    final reais = (absolute ~/ 100).toString();
    final centavos = (absolute % 100).toString().padLeft(2, '0');

    final grouped = StringBuffer();
    for (var i = 0; i < reais.length; i++) {
      final remaining = reais.length - i;
      grouped.write(reais[i]);
      if (remaining > 1 && remaining % 3 == 1) grouped.write('.');
    }
    return '${sign}R\$ $grouped,$centavos';
  }

  /// Interpreta um valor digitado no formato brasileiro e devolve centavos.
  ///
  /// Aceita `12000`, `12.000`, `12.000,50` e `R$ 12.000,50`.
  /// Retorna `null` quando o texto não é um valor válido.
  static int? parseCurrency(String input) {
    final normalized = input
        .replaceAll('R\$', '')
        .replaceAll(' ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.');
    if (normalized.isEmpty) return null;
    final value = double.tryParse(normalized);
    if (value == null) return null;
    return (value * 100).round();
  }

  /// `12 dez` — data curta.
  static String shortDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')} ${_months[date.month - 1]}';

  /// `12 — 20 dez 2026`, ou `27 nov — 02 dez 2026` quando os meses diferem.
  static String dateRange(DateTime start, DateTime end) {
    final sameMonth = start.month == end.month && start.year == end.year;
    final startText = sameMonth
        ? start.day.toString().padLeft(2, '0')
        : shortDate(start);
    return '$startText — ${shortDate(end)} ${end.year}';
  }

  /// `SEX` — dia da semana abreviado.
  static String weekdayShort(DateTime date) => _weekdaysShort[date.weekday - 1];

  /// `sábado, 14 de novembro` — usado na saudação da Home.
  static String longDate(DateTime date) =>
      '${_weekdaysLong[date.weekday - 1]}, ${date.day} de ${_monthsLong[date.month - 1]}';

  /// `09:30`
  static String time(DateTime date) =>
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}
