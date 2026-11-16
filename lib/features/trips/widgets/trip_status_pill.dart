import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/pill.dart';
import '../../../data/models/trip_status.dart';

/// [Pill] com as cores correspondentes a cada [TripStatus].
class TripStatusPill extends StatelessWidget {
  const TripStatusPill({super.key, required this.status});

  final TripStatus status;

  @override
  Widget build(BuildContext context) {
    // Pattern matching com "record" `(Color, Color)`: devolve duas cores
    // de uma só vez, sem precisar criar uma classe só para isso.
    final (background, foreground) = switch (status) {
      TripStatus.confirmed => (AppColors.mint, AppColors.greenDark),
      TripStatus.planning => (AppColors.yellowPale, AppColors.yellowDark),
      TripStatus.draft => (AppColors.cloud, AppColors.muted),
    };
    return Pill(
      label: status.label,
      backgroundColor: background,
      foregroundColor: foreground,
    );
  }
}
