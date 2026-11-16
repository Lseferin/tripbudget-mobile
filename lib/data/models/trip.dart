import 'activity.dart';
import 'budget_category.dart';
import 'expense.dart';
import 'trip_status.dart';

/// Entidade principal do app: uma viagem com orçamento, despesas e roteiro.
///
/// A classe é imutável (todos os campos são `final`). Os totais são getters
/// calculados a partir das listas, então nunca ficam dessincronizados.
class Trip {
  const Trip({
    required this.id,
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.travelers,
    required this.budgetCents,
    required this.status,
    this.expenses = const [],
    this.activities = const [],
  });

  final String id;
  final String title;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final int travelers;

  /// Orçamento total planejado, em centavos.
  final int budgetCents;
  final TripStatus status;
  final List<Expense> expenses;
  final List<Activity> activities;

  /// Quantidade de dias, contando o dia de ida e o de volta.
  int get durationDays =>
      _dateOnly(endDate).difference(_dateOnly(startDate)).inDays + 1;

  /// Lista com cada dia da viagem, usada no seletor do roteiro.
  List<DateTime> get days => List.generate(
    durationDays,
    (index) => _dateOnly(startDate).add(Duration(days: index)),
  );

  /// Total já pago (despesas realizadas).
  int get spentCents => _sum(expenses.where((e) => e.isPaid));

  /// Total ainda apenas planejado.
  int get plannedCents => _sum(expenses.where((e) => !e.isPaid));

  /// Quanto do orçamento ainda está livre, considerando o que já foi pago.
  int get remainingCents => budgetCents - spentCents;

  /// Fração do orçamento já utilizada (0.0 a 1.0; acima de 1.0 = estourado).
  double get budgetUsage => budgetCents == 0 ? 0 : spentCents / budgetCents;

  int get spentPerTravelerCents => travelers == 0 ? 0 : spentCents ~/ travelers;

  int get spentPerDayCents => spentCents ~/ durationDays;

  /// Total pago agrupado por categoria, sem categorias zeradas.
  Map<BudgetCategory, int> get spentByCategory {
    final totals = <BudgetCategory, int>{};
    for (final expense in expenses.where((e) => e.isPaid)) {
      totals.update(
        expense.category,
        (value) => value + expense.amountCents,
        ifAbsent: () => expense.amountCents,
      );
    }
    return totals;
  }

  /// Atividades de um dia específico, ordenadas por horário.
  List<Activity> activitiesOn(DateTime day) {
    final target = _dateOnly(day);
    return activities
        .where((activity) => _dateOnly(activity.startsAt) == target)
        .toList()
      ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
  }

  static int _sum(Iterable<Expense> items) =>
      items.fold(0, (total, expense) => total + expense.amountCents);

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  Trip copyWith({
    List<Expense>? expenses,
  }) {
    return Trip(
      id: id,
      title: title,
      destination: destination,
      startDate: startDate,
      endDate: endDate,
      travelers: travelers,
      budgetCents: budgetCents,
      status: status,
      expenses: expenses ?? this.expenses,
      activities: activities,
    );
  }
}
