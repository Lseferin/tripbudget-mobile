import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/icon_badge.dart';
import '../../../core/widgets/pill.dart';
import '../../../data/models/expense.dart';
import '../../../data/models/trip.dart';
import '../widgets/category_style.dart';

/// Aba "Gastos": lista de despesas, separando planejadas de realizadas.
class ExpensesTab extends StatelessWidget {
  const ExpensesTab({
    super.key,
    required this.trip,
    required this.onAddExpense,
  });

  final Trip trip;
  final VoidCallback onAddExpense;

  @override
  Widget build(BuildContext context) {
    final expenses = [...trip.expenses]
      ..sort((a, b) => a.date.compareTo(b.date));

    if (expenses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const EmptyState(
                icon: Icons.receipt_long_outlined,
                title: 'Nenhuma despesa ainda',
                message: 'As despesas desta viagem aparecerão aqui.',
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: onAddExpense,
                icon: const Icon(Icons.add),
                label: const Text('Nova despesa'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screen),
      // +1 para o resumo no topo da lista.
      itemCount: expenses.length + 2,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _ExpensesSummary(trip: trip);
        }

        if (index == 1) {
          return SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onAddExpense,
              icon: const Icon(Icons.add),
              label: const Text('Nova despesa'),
            ),
          );
        }

        return _ExpenseTile(expense: expenses[index - 2]);
      },
    );
  }
}

class _ExpensesSummary extends StatelessWidget {
  const _ExpensesSummary({required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    Widget item(String label, int cents, Color color) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.bodySmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            Formatters.currency(cents),
            style: textTheme.titleMedium?.copyWith(color: color),
          ),
        ],
      ),
    );

    return AppCard(
      color: AppColors.mint,
      showBorder: false,
      child: Row(
        children: [
          item('Realizadas', trip.spentCents, AppColors.petrol),
          item('Planejadas', trip.plannedCents, AppColors.yellowDark),
        ],
      ),
    );
  }
}

class _ExpenseTile extends StatelessWidget {
  const _ExpenseTile({required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final category = expense.category;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          IconBadge(
            icon: category.icon,
            size: 40,
            backgroundColor: category.color.withValues(alpha: 0.15),
            foregroundColor: AppColors.petrol,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(expense.description, style: textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  '${category.label} · ${Formatters.shortDate(expense.date)}',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatters.currency(expense.amountCents),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSpacing.xs),
              expense.isPaid
                  ? Pill(label: expense.status.label)
                  : Pill(
                      label: expense.status.label,
                      backgroundColor: AppColors.yellowPale,
                      foregroundColor: AppColors.yellowDark,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
