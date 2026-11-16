import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/icon_badge.dart';
import '../../core/widgets/metric_tile.dart';
import '../../core/widgets/section_header.dart';
import '../../data/mock/mock_trips.dart';
import '../../data/models/trip.dart';
import '../trips/trip_navigation.dart';
import '../trips/trips_controller.dart';
import '../trips/widgets/trip_card.dart';
import '../trips/widgets/trips_state_view.dart';

/// Dashboard inicial: saudação, próxima viagem, resumo de orçamento,
/// atalhos e as próximas viagens.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.controller,
    required this.onSeeAllTrips,
  });

  final TripsController controller;

  /// A Home não sabe como trocar de aba: ela apenas avisa o `AppShell`.
  final VoidCallback onSeeAllTrips;

  @override
  Widget build(BuildContext context) {
    return TripsStateView(
      controller: controller,
      builder: (context) {
        final upcoming = controller.upcomingTrips;
        final nextTrip = controller.nextTrip;

        // `ListView` com `children` é adequado aqui: poucos itens, de tipos
        // diferentes. Para listas longas e homogêneas, usamos `ListView.builder`.
        return ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.lg,
            AppSpacing.screen,
            AppSpacing.xxl,
          ),
          children: [
            _Greeting(today: controller.today, upcomingCount: upcoming.length),
            const SizedBox(height: AppSpacing.xl),
            if (nextTrip != null) ...[
              _NextTripCard(
                trip: nextTrip,
                daysUntil: controller.daysUntil(nextTrip),
                onTap: () => TripNavigation.openDetail(context, nextTrip),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            Row(
              children: [
                Expanded(
                  child: MetricTile(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Orçamento total',
                    value: Formatters.currency(controller.totalBudgetCents),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: MetricTile(
                    icon: Icons.trending_up_rounded,
                    label: 'Já gasto',
                    value: Formatters.currency(controller.totalSpentCents),
                    iconBackground: AppColors.yellowPale,
                    iconColor: AppColors.yellowDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Atalhos', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _Shortcut(
                    icon: Icons.add_rounded,
                    label: 'Nova viagem',
                    onTap: () => TripNavigation.createTrip(context, controller),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _Shortcut(
                    icon: Icons.luggage_outlined,
                    label: 'Minhas viagens',
                    onTap: onSeeAllTrips,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            SectionHeader(
              title: 'Próximas viagens',
              subtitle: 'Continue de onde parou',
              actionLabel: 'Ver todas',
              onAction: onSeeAllTrips,
            ),
            if (upcoming.isEmpty)
              AppCard(
                child: EmptyState(
                  icon: Icons.flight_outlined,
                  title: 'Nenhuma viagem planejada',
                  message: 'Crie sua primeira viagem para começar.',
                  actionLabel: 'Criar viagem',
                  onAction: () =>
                      TripNavigation.createTrip(context, controller),
                ),
              )
            else
              // `for` dentro de uma lista: "collection for" do Dart.
              for (final trip in upcoming.take(2)) ...[
                TripCard(
                  trip: trip,
                  onTap: () => TripNavigation.openDetail(context, trip),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
          ],
        );
      },
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.today, required this.upcomingCount});

  final DateTime today;
  final int upcomingCount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final summary = switch (upcomingCount) {
      0 => 'Nenhuma viagem chegando. Que tal planejar a próxima?',
      1 => 'Você tem 1 viagem chegando.',
      _ => 'Você tem $upcomingCount viagens chegando.',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Formatters.longDate(today).toUpperCase(),
          style: textTheme.labelSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text('Olá, $demoUserName!', style: textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(summary, style: textTheme.bodySmall?.copyWith(fontSize: 13)),
      ],
    );
  }
}

class _NextTripCard extends StatelessWidget {
  const _NextTripCard({
    required this.trip,
    required this.daysUntil,
    required this.onTap,
  });

  final Trip trip;
  final int daysUntil;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final whenText = switch (daysUntil) {
      < 0 => 'Em andamento',
      0 => 'Começa hoje',
      1 => 'Amanhã',
      _ => 'Em $daysUntil dias',
    };
    const lightText = TextStyle(fontSize: 12, color: Color(0xCCFFFFFF));

    return AppCard(
      onTap: onTap,
      color: AppColors.petrol,
      showBorder: false,
      padding: const EdgeInsets.all(AppSpacing.lg + 2),
      child: Row(
        children: [
          IconBadge(
            icon: Icons.flight_takeoff_rounded,
            backgroundColor: AppColors.white.withValues(alpha: 0.12),
            foregroundColor: AppColors.yellow,
            size: 46,
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Próxima viagem', style: lightText),
                const SizedBox(height: 2),
                Text(
                  whenText,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(trip.destination, style: lightText),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_rounded, color: Color(0xA6FFFFFF)),
        ],
      ),
    );
  }
}

class _Shortcut extends StatelessWidget {
  const _Shortcut({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      color: AppColors.mint,
      showBorder: false,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        children: [
          IconBadge(icon: icon, size: 36, backgroundColor: AppColors.white),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.petrol,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
