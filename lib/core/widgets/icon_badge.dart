import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Ícone dentro de um quadrado arredondado colorido
/// (equivalente a `.stat-icon` e `.metric-icon` do Web).
class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.icon,
    this.backgroundColor = AppColors.mint,
    this.foregroundColor = AppColors.green,
    this.size = 42,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(icon, color: foregroundColor, size: size * 0.5),
    );
  }
}
