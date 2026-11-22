import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';

/// Chip pequeño que muestra una afirmación ya clasificada correctamente
/// dentro de una zona de destino.
class PlacedChip extends StatelessWidget {
  final String text;

  const PlacedChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.illPaper,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.illGreen, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.check_circle,
              size: 14,
              color: AppColors.correctBorder,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11,
                height: 1.25,
                color: AppColors.illInk,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

