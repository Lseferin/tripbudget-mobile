# TripBudget Mobile

Aplicativo Flutter do TripBudget: planejamento de viagens com controle de
orçamento. Este é o **MVP navegável**, com dados locais (sem backend e sem
autenticação). A identidade visual segue o projeto Web (`../tripbudget-web`).

## O que o MVP faz

| Tela | Conteúdo |
|---|---|
| **Início** | Saudação, próxima viagem (com contagem de dias), orçamento total e já gasto, atalhos, próximas viagens |
| **Minhas viagens** | Lista com destino, datas, viajantes, status e uso do orçamento; filtro por status; botão "Nova viagem" |
| **Detalhes da viagem** | Abas **Resumo** (orçamento × gasto × planejado, saldo, gasto por pessoa/dia, gastos por categoria), **Roteiro** (seletor de dias + atividades) e **Gastos** (despesas planejadas e realizadas) |
| **Nova viagem** | Formulário com validação; a viagem criada aparece imediatamente na Início e na lista |

As viagens criadas ficam **apenas em memória**: ao fechar o app, voltam os
dados demonstrativos.

## Como executar

Pré-requisitos: Flutter 3.47+ / Dart 3.13+, Android SDK e um emulador.

```bash
cd tripbudget-mobile
flutter pub get

# Liste e inicie um emulador
flutter emulators
flutter emulators --launch Medium_Phone_API_37.0

# Execute (com o emulador já iniciado)
flutter run
```

Durante o `flutter run`: **r** = hot reload, **R** = hot restart, **q** = sair.

No VS Code: abra a pasta `tripbudget-mobile`, selecione o dispositivo na barra
inferior e pressione **F5**.

### Verificações

```bash
flutter analyze        # análise estática (lints + tipagem estrita)
flutter test           # testes unitários e de widget
flutter build apk --debug
```

## Arquitetura

```
lib/
├── main.dart                 # ponto de entrada: escolhe o repositório e inicia o app
├── app/
│   └── app.dart              # MaterialApp, tema, idioma; dono do TripsController
├── core/                     # reutilizável e sem regra de negócio
│   ├── theme/                # cores, espaçamentos e ThemeData
│   ├── utils/formatters.dart # moeda (BRL) e datas em pt-BR
│   └── widgets/              # AppCard, Pill, IconBadge, MetricTile, EmptyState...
├── data/                     # modelo de domínio e acesso a dados
│   ├── models/               # Trip, Expense, Activity, TripDraft, enums
│   ├── repositories/         # TripRepository (contrato) + InMemoryTripRepository
│   └── mock/                 # dados demonstrativos
└── features/                 # telas, agrupadas por funcionalidade
    ├── shell/app_shell.dart  # barra de navegação inferior
    ├── home/home_screen.dart
    └── trips/
        ├── trips_controller.dart   # estado compartilhado (ChangeNotifier)
        ├── trip_navigation.dart    # fluxos de navegação reutilizados
        ├── trips_screen.dart
        ├── create_trip_screen.dart
        ├── detail/                 # tela de detalhes e suas abas
        └── widgets/                # TripCard, TripCover, TripStatusPill...
```

### Fluxo de dados

```
InMemoryTripRepository ──► TripsController ──► ListenableBuilder ──► Telas
   (dados)                  (estado + regras     (reconstrói quando     (só exibem e
                             de apresentação)     notifyListeners)        disparam ações)
```

1. A **tela** chama uma ação do controller (ex.: `createTrip`).
2. O **controller** pede ao **repositório**, atualiza a lista e chama `notifyListeners()`.
3. Todo `ListenableBuilder` que escuta o controller é reconstruído: Início e lista
   mostram a nova viagem ao mesmo tempo.

### Decisões e motivos

| Decisão | Motivo |
|---|---|
| **Nenhuma dependência externa** | `ChangeNotifier` + `ListenableBuilder` já resolvem o estado de um app deste tamanho. O único pacote extra é `flutter_localizations`, que faz parte do SDK, para o seletor de datas em português |
| **Sem Provider (por enquanto)** | O controller é passado pelo construtor. Com poucas telas isso é explícito e fácil de seguir. Quando a árvore crescer e o repasse ficar trabalhoso, o Provider entra sem mudar o controller |
| **Repositório como interface** | Telas e controller dependem de `TripRepository`, não da implementação. A integração com o NestJS será uma nova classe (`ApiTripRepository`) trocada no `main.dart` |
| **Métodos `Future` mesmo em memória** | A API real será assíncrona. O app já trata carregamento e erro, e a latência simulada exercita isso |
| **Models imutáveis com getters calculados** | Totais (`spentCents`, `remainingCents`...) derivam das despesas e nunca ficam dessincronizados |
| **Dinheiro em centavos (`int`)** | `double` acumula erros de arredondamento. Centavos inteiros são o padrão para valores monetários e combinam com o futuro backend |
| **`TripDraft` separado de `Trip`** | O formulário não tem `id`; quem gera é o repositório. Equivale a um `CreateTripDto` |
| **Ícones/cores das categorias via `extension`** | O model (`data/`) não depende do Flutter; a aparência fica na camada de UI |
| **Capas em gradiente** | O MVP não usa imagens externas; a cor é derivada do id da viagem |
| **Fonte Roboto (padrão)** | O Web usa Inter via Google Fonts (externo). Pode ser adicionada depois como asset local |

## Guia de estudo: onde encontrar cada conceito

| Conceito | Onde ver no código |
|---|---|
| `StatelessWidget` | `core/widgets/*`, `TripCard`, `HomeScreen`: só desenham o que recebem |
| `StatefulWidget` + `setState` | `TripsScreen` (filtro), `ItineraryTab` (dia selecionado), `AppShell` (aba atual) |
| Ciclo de vida (`initState` / `dispose`) | `app.dart` (cria e descarta o controller), `ItineraryTab.initState`, `CreateTripScreen.dispose` (libera `TextEditingController`s) |
| `BuildContext` | `Theme.of(context)`, `Navigator.of(context)`, `ScaffoldMessenger.of(context)`; `context.mounted` após `await` em `trip_navigation.dart` |
| Estado efêmero × estado da aplicação | Filtro/aba/dia ficam no `State` da tela; a lista de viagens fica no `TripsController` |
| `ChangeNotifier` + `ListenableBuilder` | `trips_controller.dart` e `widgets/trips_state_view.dart` |
| Navegação (`push` / `pop` com resultado) | `trip_navigation.dart` (`push<Trip>`) e `create_trip_screen.dart` (`Navigator.pop(context, trip)`) |
| Abas | `TripDetailScreen` (`DefaultTabController`, `TabBar`, `TabBarView`) |
| Listas | `ListView` (Início), `ListView.separated` (lista, gastos, roteiro), lista horizontal (dias, filtros), `key: ValueKey(trip.id)` |
| Formulários | `CreateTripScreen`: `Form`, `GlobalKey<FormState>`, `TextFormField.validator`, `DropdownButtonFormField`, `showDateRangePicker`, `inputFormatters` |
| Models e tipagem | `data/models/*`: classes imutáveis, `const`, enums com campos, `late`, null safety (`?`, `!`, promoção de tipo) |
| Dart moderno | `switch` como expressão e com padrões (`< 0 =>`), records `(Color, Color)`, `extension`, collection `if`/`for`, cascade `..` |
| Testes | `test/`: unitários (formatadores, model, controller com relógio fixo) e de widget (fluxo de criação completo) |

## Próximos passos (fora do MVP)

- Persistência local ou integração com a API NestJS (`ApiTripRepository`).
- Edição/exclusão de viagens; cadastro de despesas e atividades.
- Autenticação.
- Fonte Inter como asset local.
