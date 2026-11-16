import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Superfície branca com borda fina e cantos arredondados: o "card" padrão
/// do TripBudget (equivalente às classes `.panel` e `.stat-card` do Web).
///
/// Quando [onTap] é informado, o card fica clicável e exibe o efeito de toque
/// (ripple) do Material.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.color = AppColors.white,
    this.showBorder = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color color;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.card),
      side: showBorder
          ? const BorderSide(color: AppColors.border)
          : BorderSide.none,
    );

    // `Material` fornece a superfície onde o `InkWell` desenha o ripple.
    // `clipBehavior` garante que o ripple respeite os cantos arredondados.
    return Material(
      color: color,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
