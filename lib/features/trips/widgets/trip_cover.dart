import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Capa em gradiente que substitui as fotos do Web (o MVP não usa imagens
/// externas). A combinação de cores é escolhida a partir do id da viagem,
/// então cada viagem mantém sempre a mesma capa.
///
/// Com [height] informado, a capa tem altura fixa e o [child] a preenche.
/// Sem [height], a capa cresce conforme o conteúdo, o que evita overflow
/// quando os textos quebram em mais linhas.
class TripCover extends StatelessWidget {
  const TripCover({
    super.key,
    required this.tripId,
    required this.child,
    this.height,
    this.borderRadius = BorderRadius.zero,
  });

  final String tripId;
  final Widget child;
  final double? height;
  final BorderRadius borderRadius;

  static const _palettes = [
    [AppColors.petrol, AppColors.green],
    [AppColors.petrolDark, AppColors.petrol],
    [AppColors.greenDark, Color(0xFF3BBCA6)],
  ];

  /// Soma dos códigos dos caracteres: sempre o mesmo resultado para o mesmo
  /// id (o `hashCode` de String não tem essa garantia entre execuções).
  List<Color> get _colors {
    final seed = tripId.codeUnits.fold(0, (sum, unit) => sum + unit);
    return _palettes[seed % _palettes.length];
  }

  @override
  Widget build(BuildContext context) {
    final fixedHeight = height;

    // `ClipRRect` recorta o ícone decorativo nos cantos arredondados.
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        width: double.infinity,
        height: fixedHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _colors,
          ),
        ),
        // Um `Stack` assume o tamanho dos filhos NÃO posicionados. Com altura
        // fixa, o filho preenche tudo (`Positioned.fill`); sem ela, o próprio
        // filho define o tamanho da capa.
        child: Stack(
          children: [
            Positioned(
              right: -18,
              bottom: -24,
              child: Icon(
                Icons.flight_takeoff_rounded,
                size: 130,
                color: AppColors.white.withValues(alpha: 0.08),
              ),
            ),
            if (fixedHeight != null) Positioned.fill(child: child) else child,
          ],
        ),
      ),
    );
  }
}
