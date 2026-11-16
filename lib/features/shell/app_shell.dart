import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../trips/trip_navigation.dart';
import '../trips/trips_controller.dart';
import '../trips/trips_screen.dart';

/// Estrutura principal: barra de navegação inferior com as abas do app.
///
/// Guarda apenas o índice da aba selecionada (estado efêmero).
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.controller});

  final TripsController controller;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const _homeIndex = 0;
  static const _tripsIndex = 1;

  int _currentIndex = _homeIndex;

  void _selectTab(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Scaffold(
      body: SafeArea(
        // `IndexedStack` mantém todas as abas montadas e exibe só uma.
        // Assim, trocar de aba não perde o filtro nem a rolagem.
        child: IndexedStack(
          index: _currentIndex,
          children: [
            HomeScreen(
              controller: controller,
              onSeeAllTrips: () => _selectTab(_tripsIndex),
            ),
            TripsScreen(controller: controller),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == _tripsIndex
          ? FloatingActionButton.extended(
              onPressed: () => TripNavigation.createTrip(context, controller),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Nova viagem'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _selectTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.luggage_outlined),
            selectedIcon: Icon(Icons.luggage_rounded),
            label: 'Viagens',
          ),
        ],
      ),
    );
  }
}
