import 'package:flutter/material.dart';

import '../trips_controller.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/trip.dart';
import '../widgets/trip_cover.dart';
import '../widgets/trip_status_pill.dart';
import 'expenses_tab.dart';
import 'itinerary_tab.dart';
import 'summary_tab.dart';
import '../trip_navigation.dart';

/// Detalhes de uma viagem, organizados em abas: Resumo, Roteiro e Gastos.
///
/// `DefaultTabController` cria e gerencia o `TabController` internamente, e
/// o disponibiliza para `TabBar` e `TabBarView` pelo `BuildContext`.
class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({
    super.key,
    required this.tripId,
    required this.controller,
  });

  final String tripId;
  final TripsController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final trip = controller.trips.firstWhere(
          (trip) => trip.id == tripId,
        );

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Detalhes da viagem'),
            ),
            body: Column(
              children: [
                _TripHeader(trip: trip),

                const TabBar(
                  tabs: [
                    Tab(text: 'Resumo'),
                    Tab(text: 'Roteiro'),
                    Tab(text: 'Gastos'),
                  ],
                ),

                Expanded(
                  child: TabBarView(
                    children: [
                      SummaryTab(trip: trip),
                      ItineraryTab(trip: trip),
                      ExpensesTab(
                        trip: trip,
                        onAddExpense: () {
                          TripNavigation.createExpense(
                            context,
                            tripId: tripId,
                            controller: controller,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TripHeader extends StatelessWidget {
  const _TripHeader({required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    const infoStyle = TextStyle(fontSize: 12, color: Color(0xD9FFFFFF));

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        AppSpacing.md,
      ),
      child: TripCover(
        tripId: trip.id,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            // Sem altura fixa: a coluna ocupa só o necessário para o conteúdo.
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TripStatusPill(status: trip.status),
              const SizedBox(height: AppSpacing.xl),
              Text(
                trip.title,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              // `Wrap` quebra para a linha de baixo quando não há espaço,
              // em vez de causar overflow como uma `Row` faria.
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.xs,
                children: [
                  _HeaderInfo(
                    icon: Icons.place_outlined,
                    text: trip.destination,
                    style: infoStyle,
                  ),
                  _HeaderInfo(
                    icon: Icons.calendar_today_outlined,
                    text: Formatters.dateRange(trip.startDate, trip.endDate),
                    style: infoStyle,
                  ),
                  _HeaderInfo(
                    icon: Icons.group_outlined,
                    text: '${trip.travelers} viajantes',
                    style: infoStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderInfo extends StatelessWidget {
  const _HeaderInfo({
    required this.icon,
    required this.text,
    required this.style,
  });

  final IconData icon;
  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: style.color),
        const SizedBox(width: AppSpacing.xs),
        Text(text, style: style),
      ],
    );
  }
}
