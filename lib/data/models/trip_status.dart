/// Situação da viagem.
///
/// Enum "aprimorado" (Dart 3): cada valor carrega um rótulo para exibição.
/// O nome do valor (`planning`) é o que seria enviado para a API;
/// o rótulo (`Planejando`) é só apresentação.
enum TripStatus {
  draft('Rascunho'),
  planning('Planejando'),
  confirmed('Confirmada');

  const TripStatus(this.label);

  final String label;
}
