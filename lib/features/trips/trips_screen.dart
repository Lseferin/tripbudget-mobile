import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/models/trip_status.dart';
import 'trip_navigation.dart';
import 'trips_controller.dart';
import 'widgets/trip_card.dart';
import 'widgets/trips_state_view.dart';

/// Lista de viagens com filtro por status.
///
/// É um `StatefulWidget` porque guarda o filtro selecionado. Esse estado é
/// "efêmero": só interessa a esta tela, então não vai para o controller.
class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key, required this.controller});

  final TripsController controller;

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  /// `null` significa "Todas".
  TripStatus? _statusFilter;

  void _selectFilter(TripStatus? status) {
    // `setState` avisa o Flutter que o estado mudou e agenda um novo `build`.
    setState(() => _statusFilter = status);
  }

  @override
  Widget build(BuildContext context) {
    // Dentro do State, as propriedades do widget ficam em `widget.`.
    final controller = widget.controller;
    final textTheme = Theme.of(context).textTheme;

    return TripsStateView(
      controller: controller,
      builder: (context) {
        final trips = controller.trips
            .where((t) => _statusFilter == null || t.status == _statusFilter)
            .toList();

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SUAS AVENTURAS', style: textTheme.labelSmall),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Minhas viagens', style: textTheme.headlineMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${controller.trips.length} viagens cadastradas',
                    style: textTheme.bodySmall?.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
            _StatusFilterBar(
              selected: _statusFilter,
              onSelected: _selectFilter,
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: trips.isEmpty
                  ? Center(
                      child: EmptyState(
                        icon: Icons.flight_outlined,
                        title: 'Nenhuma viagem encontrada',
                        message: 'Ajuste o filtro ou crie uma nova viagem.',
                        actionLabel: 'Criar viagem',
                        onAction: () =>
                            TripNavigation.createTrip(context, controller),
                      ),
                    )
                  // `ListView.separated` (variante do `.builder`) cria os itens
                  // sob demanda: só os visíveis na tela são construídos.
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screen,
                        AppSpacing.sm,
                        AppSpacing.screen,
                        96, // espaço para o botão flutuante não cobrir o último card
                      ),
                      itemCount: trips.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final trip = trips[index];
                        return TripCard(
                          // A `key` ajuda o Flutter a identificar cada item
                          // quando a lista muda (filtro, inclusão).
                          key: ValueKey(trip.id),
                          trip: trip,
                          onTap: () => TripNavigation.openDetail(context, trip, controller),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _StatusFilterBar extends StatelessWidget {
  const _StatusFilterBar({required this.selected, required this.onSelected});

  final TripStatus? selected;
  final ValueChanged<TripStatus?> onSelected;

  @override
  Widget build(BuildContext context) {
    // `<TripStatus?>[null, ...TripStatus.values]`: "Todas" + cada status.
    final options = <TripStatus?>[null, ...TripStatus.values];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final status = options[index];
          return ChoiceChip(
            label: Text(status?.label ?? 'Todas'),
            selected: selected == status,
            showCheckmark: false,
            onSelected: (_) => onSelected(status),
          );
        },
      ),
    );
  }
}
