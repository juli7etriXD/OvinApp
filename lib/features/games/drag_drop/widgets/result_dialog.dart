import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';

/// Diálogo que se muestra al completar el juego de arrastrar y soltar.
class ResultDialog extends StatelessWidget {
  final int mistakes;
  final VoidCallback onPlayAgain;
  final VoidCallback onExit;

  const ResultDialog({
    super.key,
    required this.mistakes,
    required this.onPlayAgain,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final perfect = mistakes == 0;

    return AlertDialog(
      backgroundColor: AppColors.illPaper,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Column(
        children: [
          Icon(
            perfect ? Icons.emoji_events : Icons.thumb_up_alt_outlined,
            size: 56,
            color: AppColors.illInk,
          ),
          const SizedBox(height: 8),
          Text(
            '¡Completado!',
            textAlign: TextAlign.center,
            style: AppText.serif.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$mistakes ${mistakes == 1 ? 'error' : 'errores'}',
            style: AppText.serif.copyWith(
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            perfect
                ? 'Clasificaste todo sin errores. ¡Excelente!'
                : '¡Buen trabajo! Probá de nuevo para llegar a cero errores.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.illInkSoft),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: onExit,
          child: const Text(
            'Salir',
            style: TextStyle(color: AppColors.illInkSoft),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.illInk,
            foregroundColor: AppColors.illPaper,
          ),
          onPressed: onPlayAgain,
          child: const Text('Jugar de nuevo'),
        ),
      ],
    );
  }
}

