import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/budget_progress_bar.dart';
import '../../../data/models/trip.dart';
import 'trip_cover.dart';
import 'trip_status_pill.dart';

/// Card de viagem usado na Home e na lista (equivalente a `.trip-card`).
///
/// É um `StatelessWidget`: só exibe a [Trip] recebida e avisa o pai pelo
/// callback [onTap]. Quem decide o que acontece no toque é a tela.
class TripCard extends StatelessWidget {
  const TripCard({super.key, required this.trip, required this.onTap});

  final Trip trip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final percent = (trip.budgetUsage * 100).round();

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TripCover(
            tripId: trip.id,
            height: 128,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TripStatusPill(status: trip.status),
                  const Spacer(),
                  Text(
                    trip.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _IconText(
                    icon: Icons.place_outlined,
                    text: trip.destination,
                    color: AppColors.white.withValues(alpha: 0.85),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _IconText(
                        icon: Icons.calendar_today_outlined,
                        text: Formatters.dateRange(
                          trip.startDate,
                          trip.endDate,
                        ),
                      ),
                    ),
                    _IconText(
                      icon: Icons.group_outlined,
                      text: '${trip.travelers} viajantes',
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Text('Orçamento usado', style: textTheme.bodySmall),
                    const Spacer(),
                    Text(
                      '$percent%',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.petrol,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                BudgetProgressBar(value: trip.budgetUsage),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Text(
                      Formatters.currency(trip.spentCents),
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'de ${Formatters.currency(trip.budgetCents)}',
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget privado (prefixo `_`): só pode ser usado neste arquivo.
class _IconText extends StatelessWidget {
  const _IconText({
    required this.icon,
    required this.text,
    this.color = AppColors.muted,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: AppSpacing.xs),
        Flexible(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
