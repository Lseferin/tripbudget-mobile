import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/budget_progress_bar.dart';
import '../../../core/widgets/metric_tile.dart';
import '../../../data/models/trip.dart';
import '../widgets/category_style.dart';

/// Aba "Resumo": orçamento planejado versus gasto e distribuição por categoria.
///
/// Todos os números vêm de getters do model [Trip]. A tela só formata e
/// exibe; nenhuma regra de cálculo fica aqui.
class SummaryTab extends StatelessWidget {
  const SummaryTab({super.key, required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: [
        Row(
          children: [
            Expanded(
              child: MetricTile(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Orçamento',
                value: Formatters.currency(trip.budgetCents),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: MetricTile(
                icon: Icons.receipt_long_outlined,
                label: 'Gasto',
                value: Formatters.currency(trip.spentCents),
                iconBackground: AppColors.lavenderPale,
                iconColor: AppColors.lavender,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: MetricTile(
                icon: Icons.event_note_outlined,
                label: 'Planejado',
                value: Formatters.currency(trip.plannedCents),
                iconBackground: AppColors.yellowPale,
                iconColor: AppColors.yellowDark,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: MetricTile(
                icon: Icons.savings_outlined,
                label: 'Saldo',
                value: Formatters.currency(trip.remainingCents),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _BalanceCard(trip: trip),
        const SizedBox(height: AppSpacing.lg),
        _CategoryBreakdown(trip: trip),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final percent = (trip.budgetUsage * 100).round();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Visão geral', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.lg),
          Text('Saldo disponível', style: textTheme.bodySmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            Formatters.currency(trip.remainingCents),
            style: textTheme.headlineMedium?.copyWith(color: AppColors.petrol),
          ),
          const SizedBox(height: AppSpacing.md),
          BudgetProgressBar(value: trip.budgetUsage, height: 8),
          const SizedBox(height: AppSpacing.sm),
          Text('$percent% do orçamento utilizado', style: textTheme.bodySmall),
          const Divider(height: AppSpacing.xxl),
          Row(
            children: [
              Expanded(
                child: _MiniMetric(
                  label: 'Gasto por pessoa',
                  value: Formatters.currency(trip.spentPerTravelerCents),
                ),
              ),
              Expanded(
                child: _MiniMetric(
                  label: 'Média por dia (${trip.durationDays} dias)',
                  value: Formatters.currency(trip.spentPerDayCents),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.bodySmall),
        const SizedBox(height: AppSpacing.xs),
        Text(value, style: textTheme.titleMedium),
      ],
    );
  }
}

class _CategoryBreakdown extends StatelessWidget {
  const _CategoryBreakdown({required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final totals = trip.spentByCategory;
    final spent = trip.spentCents;

    // Ordena as categorias da maior para a menor.
    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Gastos por categoria', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text('Distribuição do que já foi pago', style: textTheme.bodySmall),
          const SizedBox(height: AppSpacing.lg),
          if (entries.isEmpty)
            Text('Nenhum gasto realizado ainda.', style: textTheme.bodySmall)
          else
            for (final entry in entries) ...[
              Row(
                children: [
                  Icon(entry.key.icon, size: 18, color: entry.key.color),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(entry.key.label)),
                  Text(
                    Formatters.currency(entry.value),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              BudgetProgressBar(
                value: entry.value / spent,
                color: entry.key.color,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
        ],
      ),
    );
  }
}
