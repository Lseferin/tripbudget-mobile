import 'package:flutter_test/flutter_test.dart';
import 'package:tripbudget_mobile/core/utils/formatters.dart';

void main() {
  group('Formatters.currency', () {
    test('formata centavos no padrão brasileiro', () {
      expect(Formatters.currency(0), 'R\$ 0,00');
      expect(Formatters.currency(5), 'R\$ 0,05');
      expect(Formatters.currency(99900), 'R\$ 999,00');
      expect(Formatters.currency(1200000), 'R\$ 12.000,00');
      expect(Formatters.currency(123456789), 'R\$ 1.234.567,89');
      expect(Formatters.currency(-32000), '-R\$ 320,00');
    });
  });

  group('Formatters.parseCurrency', () {
    test('interpreta valores digitados em pt-BR', () {
      expect(Formatters.parseCurrency('12000'), 1200000);
      expect(Formatters.parseCurrency('12.000'), 1200000);
      expect(Formatters.parseCurrency('12.000,50'), 1200050);
      expect(Formatters.parseCurrency('R\$ 45,90'), 4590);
    });

    test('retorna null para valores inválidos', () {
      expect(Formatters.parseCurrency(''), isNull);
      expect(Formatters.parseCurrency('abc'), isNull);
    });
  });

  test('dateRange abrevia quando o mês é o mesmo', () {
    expect(
      Formatters.dateRange(DateTime(2026, 12, 12), DateTime(2026, 12, 19)),
      '12 — 19 dez 2026',
    );
    expect(
      Formatters.dateRange(DateTime(2026, 11, 27), DateTime(2026, 12, 2)),
      '27 nov — 02 dez 2026',
    );
  });
}
