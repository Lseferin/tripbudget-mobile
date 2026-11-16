import 'package:flutter/material.dart';

import 'app/app.dart';
import 'data/repositories/in_memory_trip_repository.dart';

/// Ponto de entrada do aplicativo.
///
/// O `main` só monta as dependências e inicia o app. Quando existir o
/// backend, basta trocar `InMemoryTripRepository` por uma implementação HTTP.
void main() {
  runApp(TripBudgetApp(repository: InMemoryTripRepository()));
}
