import 'budget_category.dart';

/// Diferencia o que foi apenas planejado do que foi efetivamente pago,
/// conforme o "planejado versus realizado" do PROJECT_CONTEXT.
enum ExpenseStatus {
  planned('Planejada'),
  paid('Realizada');

  const ExpenseStatus(this.label);

  final String label;
}

/// Uma despesa da viagem.
class Expense {
  const Expense({
    required this.id,
    required this.description,
    required this.category,
    required this.amountCents,
    required this.date,
    required this.status,
  });

  final String id;
  final String description;
  final BudgetCategory category;

  /// Valor em centavos. Ver `Formatters.currency`.
  final int amountCents;
  final DateTime date;
  final ExpenseStatus status;

  bool get isPaid => status == ExpenseStatus.paid;
}
