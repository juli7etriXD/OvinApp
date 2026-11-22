import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';

/// Chip que muestra la cantidad de errores acumulados en el header.
class MistakesChip extends StatelessWidget {
  final int mistakes;

  const MistakesChip({super.key, required this.mistakes});

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
          const Icon(Icons.close_rounded, size: 18, color: AppColors.illInk),
          const SizedBox(width: 4),
          Text(
            '$mistakes',
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

