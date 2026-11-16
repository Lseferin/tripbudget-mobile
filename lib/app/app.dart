import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/theme/app_theme.dart';
import '../data/repositories/trip_repository.dart';
import '../features/shell/app_shell.dart';
import '../features/trips/trips_controller.dart';

/// Widget raiz do aplicativo.
///
/// É um `StatefulWidget` porque é DONO do [TripsController]: cria no
/// `initState` e libera no `dispose`. Quem cria um `ChangeNotifier` é
/// responsável por descartá-lo.
class TripBudgetApp extends StatefulWidget {
  const TripBudgetApp({super.key, required this.repository});

  /// Recebido de fora (injeção de dependência): o `main.dart` decide qual
  /// implementação usar, e os testes podem passar uma versão sem atraso.
  final TripRepository repository;

  @override
  State<TripBudgetApp> createState() => _TripBudgetAppState();
}

class _TripBudgetAppState extends State<TripBudgetApp> {
  late final TripsController _tripsController;

  @override
  void initState() {
    super.initState();
    _tripsController = TripsController(repository: widget.repository)
      ..loadTrips(); // `..` (cascade): chama o método e mantém o objeto.
  }

  @override
  void dispose() {
    _tripsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripBudget',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: AppShell(controller: _tripsController),
    );
  }
}
