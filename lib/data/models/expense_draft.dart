
import 'budget_category.dart';
import 'expense.dart';

/// Dados necessários para cadastrar uma nova despesa.
class ExpenseDraft {
  const ExpenseDraft({
    required this.description,
    required this.category,
    required this.amountCents,
    required this.date,
    required this.status,
  });

  final String description;
  final BudgetCategory category;
  final int amountCents;
  final DateTime date;
  final ExpenseStatus status;
}
