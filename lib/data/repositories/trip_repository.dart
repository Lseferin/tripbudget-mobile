import '../models/trip.dart';
import '../models/trip_draft.dart';

/// Contrato de acesso aos dados de viagens.
///
/// O restante do app depende apenas desta interface. Hoje a implementação é
/// [InMemoryTripRepository]; quando o backend NestJS existir, criaremos uma
/// implementação HTTP sem alterar telas nem o controller.
///
/// Os métodos retornam `Future` mesmo em memória, porque o acesso real à API
/// será assíncrono. Assim o app já nasce preparado para carregamento e erro.
abstract interface class TripRepository {
  Future<List<Trip>> fetchTrips();

  Future<Trip> createTrip(TripDraft draft);
}
