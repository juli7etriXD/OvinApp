import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';

/// Tarjeta que muestra la justificación científica de la respuesta
/// y si expiró el tiempo.
class ExplanationCard extends StatelessWidget {
  final String explanation;
  final bool timeUp;

  const ExplanationCard({
    super.key,
    required this.explanation,
    required this.timeUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.hintBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.illYellow, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline, color: AppColors.illInk),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (timeUp)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text(
                      '¡Se acabó el tiempo!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.warningText,
                      ),
                    ),
                  ),
                Text(
                  explanation,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: AppColors.illInk,
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

