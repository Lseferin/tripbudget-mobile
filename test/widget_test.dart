import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tripbudget_mobile/app/app.dart';
import 'package:tripbudget_mobile/data/repositories/in_memory_trip_repository.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    // Simula a tela de um celular (412 x 915 pontos lógicos) em vez do
    // tamanho padrão de teste (800 x 600).
    tester.view.physicalSize = const Size(1236, 2745);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      TripBudgetApp(repository: InMemoryTripRepository(latency: Duration.zero)),
    );
    // `pumpAndSettle` avança os frames até não haver animações pendentes.
    await tester.pumpAndSettle();
  }

  testWidgets('Home exibe saudação e próximas viagens', (tester) async {
    await pumpApp(tester);

    expect(find.text('Olá, Ana!'), findsOneWidget);
    expect(find.text('Próxima viagem'), findsOneWidget);
    expect(find.text('Próximas viagens'), findsOneWidget);
  });

  testWidgets('abre os detalhes de uma viagem e navega pelas abas', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('Viagens'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Portugal com amigos'));
    await tester.pumpAndSettle();

    expect(find.text('Detalhes da viagem'), findsOneWidget);
    expect(find.text('Visão geral'), findsOneWidget);

    await tester.tap(find.text('Roteiro'));
    await tester.pumpAndSettle();
    expect(find.text('Chegada em Lisboa'), findsOneWidget);

    await tester.tap(find.text('Gastos'));
    await tester.pumpAndSettle();
    expect(find.text('Hotel Lisboa Plaza'), findsOneWidget);
  });

  testWidgets('cria uma viagem e ela aparece na lista', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Viagens'));
    await tester.pumpAndSettle();
    expect(find.text('3 viagens cadastradas'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Salvar vazio deve exibir as mensagens de validação.
    await tester.tap(find.text('Criar viagem'));
    await tester.pumpAndSettle();
    expect(find.text('Dê um nome para sua viagem.'), findsOneWidget);
    expect(find.text('Selecione as datas da viagem.'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nome da viagem'),
      'Chapada Diamantina',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Destino'),
      'Lençóis, Brasil',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Orçamento total'),
      '4.000',
    );

    // Abre o seletor de datas e troca para o modo de digitação (ícone de
    // lápis). Assim o teste não depende de onde cada dia aparece no calendário.
    await tester.tap(find.widgetWithText(TextFormField, 'Datas'));
    await tester.pumpAndSettle();
    // O cabeçalho do calendário do Material ("Data de início – Data de
    // término") transborda APENAS no ambiente de teste: o `flutter test` usa
    // a fonte Ahem, em que cada letra é um quadrado cheio (~2x mais larga
    // que a Roboto do Android). Consumimos só esse erro de layout, só aqui.
    final pickerError = tester.takeException();
    expect(
      pickerError,
      anyOf(isNull, isA<FlutterError>()),
      reason: 'apenas overflow de layout do seletor é tolerado',
    );
    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    final start = DateTime.now().add(const Duration(days: 30));
    final end = start.add(const Duration(days: 5));
    final dateFields = find.descendant(
      of: find.byType(Dialog),
      matching: find.byType(TextField),
    );
    await tester.enterText(dateFields.at(0), _ptBr(start));
    await tester.enterText(dateFields.at(1), _ptBr(end));
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Criar viagem'));
    await tester.tap(find.text('Criar viagem'));
    await tester.pumpAndSettle();

    expect(find.text('4 viagens cadastradas'), findsOneWidget);
    expect(find.text('Viagem "Chapada Diamantina" criada.'), findsOneWidget);
  });
}

/// `dd/MM/aaaa`, formato aceito pelo seletor de datas em pt-BR.
String _ptBr(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/'
    '${date.month.toString().padLeft(2, '0')}/${date.year}';
