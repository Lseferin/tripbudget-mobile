import '../mock/mock_trips.dart';
import '../models/trip.dart';
import '../models/trip_draft.dart';
import 'trip_repository.dart';

/// Implementação local de [TripRepository], com dados demonstrativos.
///
/// Os dados vivem apenas na memória: ao fechar o app, as viagens criadas são
/// perdidas. [latency] simula o tempo de resposta de uma API, para que os
/// estados de carregamento sejam exercitados; nos testes usamos zero.
class InMemoryTripRepository implements TripRepository {
  InMemoryTripRepository({
    List<Trip>? initialTrips,
    this.latency = const Duration(milliseconds: 600),
  }) : _trips = [...(initialTrips ?? buildMockTrips())];

  final List<Trip> _trips;
  final Duration latency;
  int _nextId = 1;

  @override
  Future<List<Trip>> fetchTrips() async {
    await Future<void>.delayed(latency);
    // Devolve uma cópia: quem chama não consegue alterar a lista interna.
    return List.unmodifiable(_trips);
  }

  @override
  Future<Trip> createTrip(TripDraft draft) async {
    await Future<void>.delayed(latency);
    final trip = Trip(
      id: 'local-${_nextId++}',
      title: draft.title,
      destination: draft.destination,
      startDate: draft.startDate,
      endDate: draft.endDate,
      travelers: draft.travelers,
      budgetCents: draft.budgetCents,
      status: draft.status,
    );
    _trips.add(trip);
    return trip;
  }
}
