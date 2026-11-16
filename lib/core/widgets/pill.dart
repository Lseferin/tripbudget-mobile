import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Etiqueta arredondada usada para status (equivalente a `.status-pill`).
class Pill extends StatelessWidget {
  const Pill({
    super.key,
    required this.label,
    this.backgroundColor = AppColors.mint,
    this.foregroundColor = AppColors.greenDark,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
            color: foregroundColor,
          ),
        ),
      ),
    );
  }
}
