import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'app_card.dart';
import 'icon_badge.dart';

/// Card com ícone, rótulo e valor (equivalente a `.metric-card`).
class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconBackground = AppColors.mint,
    this.iconColor = AppColors.green,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color iconBackground;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          IconBadge(
            icon: icon,
            size: 38,
            backgroundColor: iconBackground,
            foregroundColor: iconColor,
          ),
          const SizedBox(width: AppSpacing.md),
          // `Expanded` faz o texto ocupar o espaço restante da Row;
          // sem ele, valores longos causariam overflow horizontal.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: textTheme.bodySmall, maxLines: 1),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
