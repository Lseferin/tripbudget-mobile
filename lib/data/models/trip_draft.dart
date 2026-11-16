import 'trip_status.dart';

/// Dados preenchidos no formulário de nova viagem, antes de ser salva.
///
/// Não tem `id` porque quem gera o identificador é o repositório (hoje em
/// memória, no futuro o backend). É o equivalente a um `CreateTripDto` da API.
class TripDraft {
  const TripDraft({
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.travelers,
    required this.budgetCents,
    required this.status,
  });

  final String title;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final int travelers;
  final int budgetCents;
  final TripStatus status;
}
