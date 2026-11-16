import 'package:flutter_test/flutter_test.dart';
import 'package:tripbudget_mobile/data/models/activity.dart';
import 'package:tripbudget_mobile/data/models/budget_category.dart';
import 'package:tripbudget_mobile/data/models/expense.dart';
import 'package:tripbudget_mobile/data/models/trip.dart';
import 'package:tripbudget_mobile/data/models/trip_status.dart';

void main() {
  final trip = Trip(
    id: 't1',
    title: 'Teste',
    destination: 'Lisboa',
    startDate: DateTime(2026, 12, 12),
    endDate: DateTime(2026, 12, 15),
    travelers: 2,
    budgetCents: 100000,
    status: TripStatus.planning,
    expenses: [
      Expense(
        id: 'e1',
        description: 'Hotel',
        category: BudgetCategory.lodging,
        amountCents: 40000,
        date: DateTime(2026, 12, 12),
        status: ExpenseStatus.paid,
      ),
      Expense(
        id: 'e2',
        description: 'Jantar',
        category: BudgetCategory.food,
        amountCents: 8000,
        date: DateTime(2026, 12, 12),
        status: ExpenseStatus.paid,
      ),
      Expense(
        id: 'e3',
        description: 'Tour',
        category: BudgetCategory.activities,
        amountCents: 15000,
        date: DateTime(2026, 12, 13),
        status: ExpenseStatus.planned,
      ),
    ],
    activities: [
      Activity(
        id: 'a2',
        title: 'Jantar',
        place: 'Centro',
        startsAt: DateTime(2026, 12, 12, 20),
        category: BudgetCategory.food,
      ),
      Activity(
        id: 'a1',
        title: 'Chegada',
        place: 'Aeroporto',
        startsAt: DateTime(2026, 12, 12, 9),
        category: BudgetCategory.transport,
      ),
    ],
  );

  test('calcula duração e dias da viagem incluindo ida e volta', () {
    expect(trip.durationDays, 4);
    expect(trip.days.first, DateTime(2026, 12, 12));
    expect(trip.days.last, DateTime(2026, 12, 15));
  });

  test('separa gasto realizado do planejado', () {
    expect(trip.spentCents, 48000);
    expect(trip.plannedCents, 15000);
    expect(trip.remainingCents, 52000);
    expect(trip.budgetUsage, closeTo(0.48, 0.0001));
    expect(trip.spentPerTravelerCents, 24000);
  });

  test('agrupa gastos realizados por categoria', () {
    expect(trip.spentByCategory, {
      BudgetCategory.lodging: 40000,
      BudgetCategory.food: 8000,
    });
  });

  test('lista atividades do dia ordenadas por horário', () {
    final day = trip.activitiesOn(DateTime(2026, 12, 12));
    expect(day.map((a) => a.id), ['a1', 'a2']);
    expect(trip.activitiesOn(DateTime(2026, 12, 14)), isEmpty);
  });
}
