import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';

import '../models/fiber_feature.dart';

/// Tarjeta que describe una característica observable de la fibra.
///
/// Cambia visualmente según [FiberFeature.highlighted]: cuando está
/// resaltada aparece con borde de color y fondo claro.
class FeatureCard extends StatelessWidget {
  final FiberFeature feature;
  final Color accent;

  const FeatureCard({
    super.key,
    required this.feature,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final on = feature.highlighted;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: on ? AppColors.illPaper : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: on ? accent : AppColors.paperBorder,
          width: on ? 2 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: on ? accent : AppColors.inkBubble,
              border: Border.all(
                color: on ? AppColors.illInk : AppColors.paperBorder,
                width: 1.5,
              ),
            ),
            child: Icon(
              feature.icon,
              size: 20,
              color: on ? AppColors.illInk : AppColors.illInkSoft,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: AppText.serif.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: on ? AppColors.illInk : AppColors.illInkSoft,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature.text,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: on ? AppColors.illInk : AppColors.illInkSoft,
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

