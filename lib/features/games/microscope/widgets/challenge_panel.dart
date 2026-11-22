import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';

import 'answer_button.dart';

/// Panel inferior del modo "Desafío".
///
/// Muestra los botones de respuesta (Lana / Acrílico), el resultado
/// con feedback visual y el botón para pasar a la siguiente muestra.
class ChallengePanel extends StatelessWidget {
  final bool? answeredCorrectly;
  final bool mysteryIsWool;
  final ValueChanged<bool> onAnswer;
  final VoidCallback onNextSample;

  const ChallengePanel({
    super.key,
    required this.answeredCorrectly,
    required this.mysteryIsWool,
    required this.onAnswer,
    required this.onNextSample,
  });

  @override
  Widget build(BuildContext context) {
    final answered = answeredCorrectly != null;
    final ok = answeredCorrectly == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '¿Qué fibra estás mirando?',
          textAlign: TextAlign.center,
          style: AppText.serif.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Pista: buscá escamas tipo teja en los bordes.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: AppColors.illInkSoft),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AnswerButton(
                label: 'Lana',
                icon: Icons.spa_outlined,
                color: AppColors.illCardboard,
                onTap: answered ? null : () => onAnswer(true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnswerButton(
                label: 'Acrílico',
                icon: Icons.science_outlined,
                color: AppColors.illBlue,
                onTap: answered ? null : () => onAnswer(false),
              ),
            ),
          ],
        ),
        if (answered) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ok ? AppColors.correctBg : AppColors.wrongBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: ok ? AppColors.correctBorder : AppColors.wrongBorder,
                width: 2,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  ok ? Icons.check_circle : Icons.cancel,
                  color: ok ? AppColors.correctBorder : AppColors.wrongBorder,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${ok ? '¡Correcto!' : 'Casi.'} Era '
                    '${mysteryIsWool ? 'lana' : 'acrílico'}: '
                    '${mysteryIsWool ? 'se distinguen las escamas superpuestas y los bordes dentados.' : 'la superficie es lisa, de grosor uniforme y sin escamas.'}',
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: AppColors.illInk,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.illInk,
              foregroundColor: AppColors.illPaper,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: onNextSample,
            icon: const Icon(Icons.arrow_forward),
            label: const Text(
              'Otra muestra',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ],
    );
  }
}

