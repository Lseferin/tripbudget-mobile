
import 'package:flutter/material.dart';

import '../../../data/models/budget_category.dart';
import '../../../data/models/expense.dart';
import '../../../data/models/expense_draft.dart';

/// Formulário para cadastrar uma nova despesa de uma viagem.
class CreateExpenseScreen extends StatefulWidget {
  const CreateExpenseScreen({super.key});

  @override
  State<CreateExpenseScreen> createState() =>
      _CreateExpenseScreenState();
}

class _CreateExpenseScreenState extends State<CreateExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  BudgetCategory _category = BudgetCategory.food;
  ExpenseStatus _status = ExpenseStatus.paid;
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  int? _parseAmount(String value) {
    final normalized = value
        .trim()
        .replaceAll('.', '')
        .replaceAll(',', '.');

    final amount = double.tryParse(normalized);

    if (amount == null || amount <= 0) {
      return null;
    }

    return (amount * 100).round();
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _date = selectedDate;
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amountCents = _parseAmount(_amountController.text);

    if (amountCents == null) {
      return;
    }

    final draft = ExpenseDraft(
      description: _descriptionController.text.trim(),
      category: _category,
      amountCents: amountCents,
      date: _date,
      status: _status,
    );

    Navigator.of(context).pop(draft);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova despesa'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                hintText: 'Ex.: Almoço no restaurante',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe a descrição da despesa.';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Valor',
                hintText: 'Ex.: 125,50',
                prefixText: 'R\$ ',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) {
                if (value == null || _parseAmount(value) == null) {
                  return 'Informe um valor válido.';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<BudgetCategory>(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: 'Categoria',
                border: OutlineInputBorder(),
              ),
              items: BudgetCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.label),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _category = value;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<ExpenseStatus>(
              initialValue: _status,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: ExpenseStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status.label),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _status = value;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Data da despesa'),
              subtitle: Text(
                '${_date.day.toString().padLeft(2, '0')}/'
                '${_date.month.toString().padLeft(2, '0')}/'
                '${_date.year}',
              ),
              trailing: const Icon(Icons.calendar_month_outlined),
              onTap: _selectDate,
            ),

            const SizedBox(height: 28),

            FilledButton(
              onPressed: _save,
              child: const Text('Salvar despesa'),
            ),
          ],
        ),
      ),
    );
  }
}
