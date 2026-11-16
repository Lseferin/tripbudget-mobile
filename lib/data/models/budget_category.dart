/// Categorias de custo, compartilhadas entre despesas e atividades do roteiro.
///
/// Ícones e cores ficam fora do model (na camada de apresentação), para que
/// esta camada não dependa do Flutter e possa ser testada isoladamente.
enum BudgetCategory {
  lodging('Hospedagem'),
  transport('Transporte'),
  food('Alimentação'),
  activities('Passeios'),
  other('Outros');

  const BudgetCategory(this.label);

  final String label;
}
