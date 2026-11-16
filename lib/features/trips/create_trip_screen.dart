import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/trip.dart';
import '../../data/models/trip_draft.dart';
import '../../data/models/trip_status.dart';

/// Formulário de nova viagem.
///
/// A tela não conhece o controller nem o repositório: recebe apenas a função
/// [onSave]. Ao terminar, devolve a viagem criada com `Navigator.pop`.
class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key, required this.onSave});

  final Future<Trip> Function(TripDraft draft) onSave;

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  /// A `GlobalKey` dá acesso ao `FormState`, que valida todos os campos.
  final _formKey = GlobalKey<FormState>();

  // Um controller por campo de texto. Eles guardam o valor digitado e
  // PRECISAM ser liberados no `dispose`.
  final _titleController = TextEditingController();
  final _destinationController = TextEditingController();
  final _datesController = TextEditingController();
  final _travelersController = TextEditingController(text: '2');
  final _budgetController = TextEditingController();

  DateTimeRange? _dates;
  TripStatus _status = TripStatus.planning;
  bool _isSaving = false;

  /// Ciclo de vida: `dispose` é chamado quando o State sai da árvore
  /// definitivamente. Liberamos aqui os recursos criados por ele.
  @override
  void dispose() {
    _titleController.dispose();
    _destinationController.dispose();
    _datesController.dispose();
    _travelersController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _pickDates() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 3),
      initialDateRange: _dates,
      helpText: 'Datas da viagem',
      saveText: 'Confirmar', // botão do modo calendário
      confirmText: 'Confirmar', // botão do modo digitação
    );
    if (picked == null) return;

    setState(() {
      _dates = picked;
      _datesController.text = Formatters.dateRange(picked.start, picked.end);
    });
  }

  Future<void> _submit() async {
    // `validate()` executa o `validator` de cada campo e exibe os erros.
    final isValid = _formKey.currentState?.validate() ?? false;
    final dates = _dates;
    if (!isValid || dates == null) return;

    final draft = TripDraft(
      title: _titleController.text.trim(),
      destination: _destinationController.text.trim(),
      startDate: dates.start,
      endDate: dates.end,
      travelers: int.parse(_travelersController.text),
      budgetCents: Formatters.parseCurrency(_budgetController.text)!,
      status: _status,
    );

    setState(() => _isSaving = true);
    try {
      final trip = await widget.onSave(draft);
      // Após o `await`, o usuário pode ter saído da tela.
      if (!mounted) return;
      Navigator.of(context).pop(trip);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível salvar a viagem.')),
      );
    }
  }

  // Validadores: retornam `null` quando o valor é válido, ou a mensagem de erro.

  String? _required(String? value, String message) =>
      (value == null || value.trim().isEmpty) ? message : null;

  String? _validateTravelers(String? value) {
    final travelers = int.tryParse(value ?? '');
    if (travelers == null || travelers < 1) {
      return 'Informe ao menos 1 viajante.';
    }
    if (travelers > 50) return 'Máximo de 50 viajantes.';
    return null;
  }

  String? _validateBudget(String? value) {
    final cents = Formatters.parseCurrency(value ?? '');
    if (cents == null || cents <= 0) return 'Informe um orçamento válido.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Nova viagem')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          children: [
            Text('INFORMAÇÕES BÁSICAS', style: textTheme.labelSmall),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Nome da viagem',
                hintText: 'Ex.: Férias em Portugal',
              ),
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              validator: (v) => _required(v, 'Dê um nome para sua viagem.'),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _destinationController,
              decoration: const InputDecoration(
                labelText: 'Destino',
                hintText: 'Ex.: Lisboa, Portugal',
                prefixIcon: Icon(Icons.place_outlined),
              ),
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              validator: (v) => _required(v, 'Informe o destino.'),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Campo somente leitura: o toque abre o seletor de datas.
            TextFormField(
              controller: _datesController,
              readOnly: true,
              onTap: _pickDates,
              decoration: const InputDecoration(
                labelText: 'Datas',
                hintText: 'Selecione ida e volta',
                prefixIcon: Icon(Icons.calendar_today_outlined),
              ),
              validator: (_) =>
                  _dates == null ? 'Selecione as datas da viagem.' : null,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('DETALHES E ORÇAMENTO', style: textTheme.labelSmall),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _travelersController,
              decoration: const InputDecoration(
                labelText: 'Viajantes',
                prefixIcon: Icon(Icons.group_outlined),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.next,
              validator: _validateTravelers,
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _budgetController,
              decoration: const InputDecoration(
                labelText: 'Orçamento total',
                hintText: 'Ex.: 12.000,00',
                prefixText: 'R\$ ',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              validator: _validateBudget,
            ),
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<TripStatus>(
              initialValue: _status,
              decoration: const InputDecoration(labelText: 'Status'),
              items: [
                for (final status in TripStatus.values)
                  DropdownMenuItem(value: status, child: Text(status.label)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _status = value);
              },
            ),
            const SizedBox(height: AppSpacing.xxl),
            FilledButton.icon(
              // `null` desabilita o botão enquanto salva, evitando envio duplo.
              onPressed: _isSaving ? null : _submit,
              icon: _isSaving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_rounded),
              label: Text(_isSaving ? 'Salvando...' : 'Criar viagem'),
            ),
          ],
        ),
      ),
    );
  }
}
