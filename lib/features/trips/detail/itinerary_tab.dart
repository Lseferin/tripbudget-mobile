import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/icon_badge.dart';
import '../../../data/models/activity.dart';
import '../../../data/models/trip.dart';
import '../widgets/category_style.dart';

/// Aba "Roteiro": seletor de dias e atividades do dia escolhido.
class ItineraryTab extends StatefulWidget {
  const ItineraryTab({super.key, required this.trip});

  final Trip trip;

  @override
  State<ItineraryTab> createState() => _ItineraryTabState();
}

class _ItineraryTabState extends State<ItineraryTab> {
  // `late`: será inicializado antes do primeiro uso (no `initState`).
  late DateTime _selectedDay;

  /// Ciclo de vida: `initState` é chamado UMA vez, quando o State é criado,
  /// antes do primeiro `build`. É o lugar certo para inicializar estado
  /// que depende das propriedades do widget (`widget.trip`).
  @override
  void initState() {
    super.initState();
    _selectedDay = widget.trip.days.first;
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    final activities = trip.activitiesOn(_selectedDay);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.lg,
            AppSpacing.screen,
            AppSpacing.md,
          ),
          child: Text(
            '${trip.durationDays} dias · ${trip.activities.length} atividades',
            style: textTheme.bodySmall,
          ),
        ),
        SizedBox(
          height: 68,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            itemCount: trip.days.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final day = trip.days[index];
              return _DayChip(
                day: day,
                selected: day == _selectedDay,
                onTap: () => setState(() => _selectedDay = day),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: activities.isEmpty
              ? Center(
                  child: EmptyState(
                    icon: Icons.event_available_outlined,
                    title: 'Dia ${_selectedDay.day} está livre',
                    message: 'Nenhuma atividade planejada para este dia.',
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    AppSpacing.sm,
                    AppSpacing.screen,
                    AppSpacing.xxl,
                  ),
                  itemCount: activities.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) =>
                      _ActivityTile(activity: activities[index]),
                ),
        ),
      ],
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.day,
    required this.selected,
    required this.onTap,
  });

  final DateTime day;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? AppColors.white : AppColors.ink;
    return AppCard(
      onTap: onTap,
      color: selected ? AppColors.petrol : AppColors.white,
      showBorder: !selected,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            Formatters.weekdayShort(day),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: selected ? AppColors.mintStrong : AppColors.muted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${day.day}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final category = activity.category;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          SizedBox(
            width: 46,
            child: Text(
              Formatters.time(activity.startsAt),
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.petrol,
              ),
            ),
          ),
          IconBadge(
            icon: category.icon,
            size: 38,
            backgroundColor: category.color.withValues(alpha: 0.15),
            foregroundColor: AppColors.petrol,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.title, style: textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  '${category.label} · ${activity.place}',
                  style: textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            activity.isFree
                ? 'Grátis'
                : Formatters.currency(activity.estimatedCostCents),
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
