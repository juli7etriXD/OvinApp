import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';

/// Chip que muestra el puntaje (aciertos / intentos) en el header del desafío.
class ScoreChip extends StatelessWidget {
  final int correct;
  final int attempts;

  const ScoreChip({
    super.key,
    required this.correct,
    required this.attempts,
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
            '$correct/$attempts',
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

