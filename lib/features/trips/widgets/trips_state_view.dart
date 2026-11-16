import 'package:flutter/material.dart';

import '../../../core/widgets/empty_state.dart';
import '../trips_controller.dart';

/// Trata os estados "carregando" e "erro" das viagens, para que Home e lista
/// não repitam essa lógica. Quando os dados estão prontos, chama [builder].
///
/// `ListenableBuilder` escuta o controller: a cada `notifyListeners()`, só o
/// trecho dentro de `builder` é reconstruído, e não a tela inteira.
class TripsStateView extends StatelessWidget {
  const TripsStateView({
    super.key,
    required this.controller,
    required this.builder,
  });

  final TripsController controller;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        if (controller.isLoading && controller.trips.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final error = controller.errorMessage;
        if (error != null) {
          return Center(
            child: EmptyState(
              icon: Icons.cloud_off_outlined,
              title: 'Algo deu errado',
              message: error,
              actionLabel: 'Tentar novamente',
              onAction: controller.loadTrips,
            ),
          );
        }

        return builder(context);
      },
    );
  }
}
