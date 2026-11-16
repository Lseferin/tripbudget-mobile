import 'package:flutter/material.dart';

import '../../data/models/trip.dart';
import 'create_trip_screen.dart';
import 'detail/trip_detail_screen.dart';
import 'trips_controller.dart';

/// Fluxos de navegação de viagens, usados pela Home e pela lista.
///
/// Centralizar aqui evita duplicar a mesma lógica nas duas telas.
abstract final class TripNavigation {
  /// Empilha a tela de detalhes. O `BuildContext` indica de qual ponto da
  /// árvore de widgets procuramos o `Navigator` mais próximo.
  static Future<void> openDetail(BuildContext context, Trip trip) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => TripDetailScreen(trip: trip)),
    );
  }

  /// Abre o formulário e aguarda o resultado.
  ///
  /// `push<Trip>` retorna um `Future<Trip?>`, que é completado quando o
  /// formulário chama `Navigator.pop(context, trip)`. Se o usuário apenas
  /// voltar, o resultado é `null`.
  static Future<void> createTrip(
    BuildContext context,
    TripsController controller,
  ) async {
    final trip = await Navigator.of(context).push<Trip>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => CreateTripScreen(onSave: controller.createTrip),
      ),
    );

    // Depois de um `await`, a tela pode ter sido descartada. `context.mounted`
    // confirma que o widget ainda está na árvore antes de usar o context.
    if (trip == null || !context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viagem "${trip.title}" criada.'),
        action: SnackBarAction(
          label: 'Ver',
          onPressed: () {
            if (context.mounted) openDetail(context, trip);
          },
        ),
      ),
    );
  }
}
