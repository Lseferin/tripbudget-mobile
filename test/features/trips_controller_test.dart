import 'package:flutter_test/flutter_test.dart';
import 'package:tripbudget_mobile/data/models/trip_draft.dart';
import 'package:tripbudget_mobile/data/models/trip_status.dart';
import 'package:tripbudget_mobile/data/repositories/in_memory_trip_repository.dart';
import 'package:tripbudget_mobile/features/trips/trips_controller.dart';

void main() {
  late TripsController controller;

  // `setUp` roda antes de cada teste: cada um começa com estado limpo.
  setUp(() {
    controller = TripsController(
      repository: InMemoryTripRepository(latency: Duration.zero),
      clock: () => DateTime(2026, 11, 16), // data fixa da apresentação
    );
  });

  tearDown(() => controller.dispose());

  test('carrega viagens ordenadas pela data de ida', () async {
    await controller.loadTrips();

    expect(controller.isLoading, isFalse);
    expect(controller.errorMessage, isNull);
    expect(controller.trips.map((t) => t.id), [
      'rio-2026',
      'portugal-2026',
      'gramado-2027',
    ]);
  });

  test('identifica a próxima viagem e os dias restantes', () async {
    await controller.loadTrips();

    final next = controller.nextTrip!;
    expect(next.id, 'rio-2026');
    expect(controller.daysUntil(next), 11);
  });

  test('createTrip adiciona a viagem e notifica os ouvintes', () async {
    await controller.loadTrips();
    var notifications = 0;
    controller.addListener(() => notifications++);

    final trip = await controller.createTrip(
      TripDraft(
        title: 'Chapada Diamantina',
        destination: 'Lençóis, Brasil',
        startDate: DateTime(2027, 1, 10),
        endDate: DateTime(2027, 1, 15),
        travelers: 2,
        budgetCents: 400000,
        status: TripStatus.draft,
      ),
    );

    expect(notifications, 1);
    expect(controller.trips, contains(trip));
    expect(controller.trips.length, 4);
    expect(controller.totalBudgetCents, 350000 + 1200000 + 520000 + 400000);
  });
}
