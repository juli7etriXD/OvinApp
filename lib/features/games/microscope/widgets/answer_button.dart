import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';

/// Botón de respuesta para el modo desafío (ej. "Lana" / "Acrílico").
///
/// Se deshabilita pasando [onTap] como `null` una vez respondida la pregunta.
class AnswerButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const AnswerButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppColors.illInk,
        disabledBackgroundColor: AppColors.inkBubble,
        disabledForegroundColor: AppColors.illInkSoft,
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: const BorderSide(color: AppColors.illInk, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

