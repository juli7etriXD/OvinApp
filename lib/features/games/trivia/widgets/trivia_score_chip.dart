import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';

/// Chip en el encabezado que muestra la puntuación actual de aciertos.
class TriviaScoreChip extends StatelessWidget {
  final int score;

  const TriviaScoreChip({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.illPaper,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.paperBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, size: 18, color: AppColors.illInk),
          const SizedBox(width: 4),
          Text(
            '$score',
            style: const TextStyle(
              color: AppColors.illInk,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

