import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';

/// Opción de respuesta interactiva con badge de letra (A, B, C...) y feedback visual
/// al revelarse el resultado.
class OptionTile extends StatelessWidget {
  final int index;
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool revealed;
  final VoidCallback? onTap;

  const OptionTile({
    super.key,
    required this.index,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.revealed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = AppColors.illPaper;
    Color border = AppColors.paperBorder;
    Color badge = AppColors.bgGames;
    IconData? trailing;

    if (revealed && isCorrect) {
      bg = AppColors.correctBg;
      border = AppColors.correctBorder;
      badge = AppColors.illGreen;
      trailing = Icons.check_circle;
    } else if (revealed && isSelected) {
      bg = AppColors.wrongBg;
      border = AppColors.wrongBorder;
      badge = AppColors.illRose;
      trailing = Icons.cancel;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: revealed ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border, width: revealed ? 2 : 1),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: badge,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.illInk, width: 1.5),
                ),
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C, D
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.illInk,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.3,
                    color: AppColors.illInk,
                  ),
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                Icon(trailing, color: border),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

