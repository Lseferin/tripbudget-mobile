import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/budget_category.dart';

/// `extension` adiciona membros a um tipo existente sem modificá-lo.
///
/// Assim o enum [BudgetCategory] (camada de dados) continua sem depender do
/// Flutter, e a apresentação (ícone e cor) fica aqui, na camada de UI.
extension BudgetCategoryStyle on BudgetCategory {
  IconData get icon => switch (this) {
    BudgetCategory.lodging => Icons.bed_outlined,
    BudgetCategory.transport => Icons.flight_outlined,
    BudgetCategory.food => Icons.restaurant_outlined,
    BudgetCategory.activities => Icons.account_balance_outlined,
    BudgetCategory.other => Icons.receipt_long_outlined,
  };

  Color get color => switch (this) {
    BudgetCategory.lodging => AppColors.petrol,
    BudgetCategory.transport => AppColors.green,
    BudgetCategory.food => AppColors.yellow,
    BudgetCategory.activities => AppColors.seaFoam,
    BudgetCategory.other => AppColors.lavender,
  };
}
