import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';

/// Tarjeta que muestra el enunciado de la pregunta.
class QuestionCard extends StatelessWidget {
  final String text;

  const QuestionCard({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.illPaper,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.paperBorder),
      ),
      child: Text(
        text,
        style: AppText.serif.copyWith(
          fontSize: 19,
          fontWeight: FontWeight.w600,
          height: 1.35,
        ),
      ),
    );
  }
}

