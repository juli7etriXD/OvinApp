import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';

/// Diálogo que muestra el resumen final de la trivia terminada.
class TriviaResultDialog extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onRetry;
  final VoidCallback onExit;

  const TriviaResultDialog({
    super.key,
    required this.score,
    required this.total,
    required this.onRetry,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = score / total;
    final String message;
    final IconData icon;

    if (ratio >= 0.8) {
      message = '¡Excelente! Sabés mucho sobre la lana.';
      icon = Icons.emoji_events;
    } else if (ratio >= 0.5) {
      message = '¡Muy bien! Un repaso más y lo dominás.';
      icon = Icons.thumb_up_alt_outlined;
    } else {
      message = 'Seguí explorando la app y volvé a intentarlo.';
      icon = Icons.menu_book_outlined;
    }

    return AlertDialog(
      backgroundColor: AppColors.illPaper,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Column(
        children: [
          Icon(icon, size: 56, color: AppColors.illInk),
          const SizedBox(height: 8),
          Text(
            '¡Trivia terminada!',
            textAlign: TextAlign.center,
            style: AppText.serif.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$score / $total',
            style: AppText.serif.copyWith(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
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
          onPressed: onRetry,
          child: const Text('Reintentar'),
        ),
      ],
    );
  }
}

