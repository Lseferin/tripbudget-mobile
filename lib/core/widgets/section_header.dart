import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Título de seção com subtítulo opcional e ação à direita ("Ver todas").
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Dart permite usar variáveis locais "promovidas": depois do teste
    // `label != null`, o compilador sabe que `label` é String (não String?).
    final label = actionLabel;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textTheme.titleLarge),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(subtitle!, style: textTheme.bodySmall),
                ],
              ],
            ),
          ),
          if (label != null)
            TextButton(onPressed: onAction, child: Text(label)),
        ],
      ),
    );
  }
}
