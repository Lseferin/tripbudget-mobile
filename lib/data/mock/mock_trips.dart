import '../models/activity.dart';
import '../models/budget_category.dart';
import '../models/expense.dart';
import '../models/trip.dart';
import '../models/trip_status.dart';

/// Nome exibido na saudação enquanto não existe autenticação.
const demoUserName = 'Lívia';

/// Dados demonstrativos, inspirados nas telas do projeto Web.
///
/// Ficam isolados aqui (e só são lidos pelo repositório em memória), para
/// que nenhuma tela dependa diretamente de dados fictícios.
List<Trip> buildMockTrips() {
  return [
    Trip(
      id: 'rio-2026',
      title: 'Fim de semana no Rio',
      destination: 'Rio de Janeiro, Brasil',
      startDate: DateTime(2026, 11, 27),
      endDate: DateTime(2026, 11, 30),
      travelers: 2,
      budgetCents: 350000,
      status: TripStatus.confirmed,
      expenses: [
        Expense(
          id: 'rio-e1',
          description: 'Passagens aéreas',
          category: BudgetCategory.transport,
          amountCents: 138000,
          date: DateTime(2026, 10, 10),
          status: ExpenseStatus.paid,
        ),
        Expense(
          id: 'rio-e2',
          description: 'Pousada em Copacabana',
          category: BudgetCategory.lodging,
          amountCents: 72000,
          date: DateTime(2026, 10, 12),
          status: ExpenseStatus.paid,
        ),
        Expense(
          id: 'rio-e3',
          description: 'Bondinho do Pão de Açúcar',
          category: BudgetCategory.activities,
          amountCents: 39000,
          date: DateTime(2026, 11, 28),
          status: ExpenseStatus.planned,
        ),
      ],
      activities: [
        Activity(
          id: 'rio-a1',
          title: 'Chegada no Rio',
          place: 'Aeroporto Santos Dumont',
          startsAt: DateTime(2026, 11, 27, 10, 0),
          category: BudgetCategory.transport,
        ),
        Activity(
          id: 'rio-a2',
          title: 'Fim de tarde no Arpoador',
          place: 'Pedra do Arpoador',
          startsAt: DateTime(2026, 11, 27, 17, 0),
          category: BudgetCategory.activities,
        ),
        Activity(
          id: 'rio-a3',
          title: 'Bondinho do Pão de Açúcar',
          place: 'Urca',
          startsAt: DateTime(2026, 11, 28, 9, 30),
          category: BudgetCategory.activities,
          estimatedCostCents: 39000,
        ),
        Activity(
          id: 'rio-a4',
          title: 'Almoço na Urca',
          place: 'Bar Urca',
          startsAt: DateTime(2026, 11, 28, 13, 0),
          category: BudgetCategory.food,
          estimatedCostCents: 18000,
        ),
      ],
    ),
    Trip(
      id: 'portugal-2026',
      title: 'Eurotrip (Portugal)',
      destination: 'Lisboa, Portugal',
      startDate: DateTime(2026, 12, 12),
      endDate: DateTime(2026, 12, 19),
      travelers: 4,
      budgetCents: 1200000,
      status: TripStatus.planning,
      expenses: [
        Expense(
          id: 'pt-e1',
          description: 'Hotel Lisboa Plaza',
          category: BudgetCategory.lodging,
          amountCents: 328000,
          date: DateTime(2026, 9, 2),
          status: ExpenseStatus.paid,
        ),
        Expense(
          id: 'pt-e2',
          description: 'Passagens aéreas',
          category: BudgetCategory.transport,
          amountCents: 245000,
          date: DateTime(2026, 8, 20),
          status: ExpenseStatus.paid,
        ),
        Expense(
          id: 'pt-e3',
          description: 'Tour por Sintra',
          category: BudgetCategory.activities,
          amountCents: 68000,
          date: DateTime(2026, 12, 15),
          status: ExpenseStatus.planned,
        ),
        Expense(
          id: 'pt-e4',
          description: 'Jantar no Bairro Alto',
          category: BudgetCategory.food,
          amountCents: 32000,
          date: DateTime(2026, 12, 12),
          status: ExpenseStatus.planned,
        ),
      ],
      activities: [
        Activity(
          id: 'pt-a1',
          title: 'Chegada em Lisboa',
          place: 'Aeroporto Humberto Delgado',
          startsAt: DateTime(2026, 12, 12, 9, 30),
          category: BudgetCategory.transport,
        ),
        Activity(
          id: 'pt-a2',
          title: 'Check-in no hotel',
          place: 'Lisboa Plaza Hotel',
          startsAt: DateTime(2026, 12, 12, 12, 0),
          category: BudgetCategory.lodging,
        ),
        Activity(
          id: 'pt-a3',
          title: 'Passeio por Alfama',
          place: 'Alfama',
          startsAt: DateTime(2026, 12, 12, 15, 30),
          category: BudgetCategory.activities,
        ),
        Activity(
          id: 'pt-a4',
          title: 'Jantar no Bairro Alto',
          place: 'Taberna da Rua das Flores',
          startsAt: DateTime(2026, 12, 12, 20, 0),
          category: BudgetCategory.food,
          estimatedCostCents: 32000,
        ),
        Activity(
          id: 'pt-a5',
          title: 'Torre de Belém',
          place: 'Belém',
          startsAt: DateTime(2026, 12, 13, 10, 0),
          category: BudgetCategory.activities,
          estimatedCostCents: 21000,
        ),
        Activity(
          id: 'pt-a6',
          title: 'Pastéis de Belém',
          place: 'Rua de Belém, 84',
          startsAt: DateTime(2026, 12, 13, 12, 30),
          category: BudgetCategory.food,
          estimatedCostCents: 9000,
        ),
        Activity(
          id: 'pt-a7',
          title: 'Tour por Sintra',
          place: 'Palácio da Pena',
          startsAt: DateTime(2026, 12, 15, 8, 30),
          category: BudgetCategory.activities,
          estimatedCostCents: 68000,
        ),
      ],
    ),
    Trip(
      id: 'gramado-2027',
      title: 'Serra Gaúcha',
      destination: 'Gramado, Brasil',
      startDate: DateTime(2027, 2, 5),
      endDate: DateTime(2027, 2, 9),
      travelers: 3,
      budgetCents: 520000,
      status: TripStatus.draft,
    ),
  ];
}
