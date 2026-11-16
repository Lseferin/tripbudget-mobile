import 'budget_category.dart';

/// Uma atividade do roteiro (passeio, refeição, deslocamento...).
class Activity {
  const Activity({
    required this.id,
    required this.title,
    required this.place,
    required this.startsAt,
    required this.category,
    this.estimatedCostCents = 0,
  });

  final String id;
  final String title;
  final String place;

  /// Data e horário de início. O dia do roteiro é derivado deste campo.
  final DateTime startsAt;
  final BudgetCategory category;

  /// Custo estimado em centavos; 0 significa gratuito.
  final int estimatedCostCents;

  bool get isFree => estimatedCostCents == 0;
}
