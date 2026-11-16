import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../../data/models/trip.dart';
import '../../data/models/trip_draft.dart';
import '../../data/repositories/trip_repository.dart';

/// Estado compartilhado das viagens (o "estado da aplicação").
///
/// `ChangeNotifier` é a forma mais simples de estado observável do Flutter:
/// quando algo muda, chamamos [notifyListeners] e todo widget que está
/// escutando (via `ListenableBuilder`) é reconstruído.
///
/// O controller não conhece widgets: ele recebe um [TripRepository] e expõe
/// dados prontos para as telas. Isso separa a lógica da apresentação e
/// permite testá-lo sem renderizar nada.
class TripsController extends ChangeNotifier {
  // `this._repository` em parâmetro nomeado: quem chama escreve
  // `repository:` (sem o `_`), mas o campo continua privado.
  TripsController({required this._repository, DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final TripRepository _repository;

  /// Fonte da data atual. Injetável para que os testes sejam determinísticos.
  final DateTime Function() _clock;

  List<Trip> _trips = const [];
  bool _isLoading = false;
  String? _errorMessage;

  /// Visão somente leitura: as telas não conseguem alterar a lista diretamente;
  /// toda mudança passa pelos métodos do controller.
  UnmodifiableListView<Trip> get trips => UnmodifiableListView(_trips);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  DateTime get today {
    final now = _clock();
    return DateTime(now.year, now.month, now.day);
  }

  /// Viagens que ainda não terminaram, da mais próxima para a mais distante.
  List<Trip> get upcomingTrips =>
      _trips.where((trip) => !trip.endDate.isBefore(today)).toList();

  Trip? get nextTrip => upcomingTrips.isEmpty ? null : upcomingTrips.first;

  int get totalBudgetCents =>
      upcomingTrips.fold(0, (total, trip) => total + trip.budgetCents);

  int get totalSpentCents =>
      upcomingTrips.fold(0, (total, trip) => total + trip.spentCents);

  /// Dias até o início da viagem (0 = começa hoje; negativo = em andamento).
  int daysUntil(Trip trip) => trip.startDate.difference(today).inDays;

  Future<void> loadTrips() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _trips = _sorted(await _repository.fetchTrips());
    } catch (_) {
      _errorMessage = 'Não foi possível carregar suas viagens.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Salva uma nova viagem e atualiza todas as telas que estão escutando.
  Future<Trip> createTrip(TripDraft draft) async {
    final trip = await _repository.createTrip(draft);
    _trips = _sorted([..._trips, trip]);
    notifyListeners();
    return trip;
  }

  static List<Trip> _sorted(List<Trip> trips) =>
      [...trips]..sort((a, b) => a.startDate.compareTo(b.startDate));
}
