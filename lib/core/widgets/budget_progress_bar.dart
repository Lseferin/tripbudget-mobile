import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Barra de progresso do orçamento (equivalente a `.progress`).
///
/// [value] vai de 0.0 a 1.0. Valores acima de 1.0 indicam orçamento estourado:
/// a barra fica cheia e muda para a cor de alerta.
class BudgetProgressBar extends StatelessWidget {
  const BudgetProgressBar({
    super.key,
    required this.value,
    this.height = 6,
    this.color = AppColors.green,
    this.trackColor = AppColors.track,
  });

  final double value;
  final double height;
  final Color color;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    final isOverBudget = value > 1;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: LinearProgressIndicator(
        value: value.clamp(0, 1).toDouble(),
        minHeight: height,
        backgroundColor: trackColor,
        color: isOverBudget ? AppColors.danger : color,
      ),
    );
  }
}
