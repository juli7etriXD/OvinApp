import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';

import '../models/claim.dart';
import 'placed_chip.dart';

/// Zona de destino (lana o acrílico) donde el usuario suelta las tarjetas.
///
/// Muestra retroalimentación visual al recibir un hover o al acertar / fallar.
class DropZone extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color background;
  final Color accent;
  final List<Claim> placed;
  final bool isWool;

  /// Estado del flash de retroalimentación.
  /// `null` = sin flash; `true` = flasheando esta zona.
  final bool? flashWool;
  final bool flashOk;

  /// Callback cuando se suelta una tarjeta en esta zona.
  final void Function(Claim claim) onDrop;

  const DropZone({
    super.key,
    required this.title,
    required this.icon,
    required this.background,
    required this.accent,
    required this.placed,
    required this.isWool,
    required this.flashWool,
    required this.flashOk,
    required this.onDrop,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<Claim>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (details) => onDrop(details.data),
      builder: (context, candidate, rejected) {
        final hovering = candidate.isNotEmpty;
        final flashing = flashWool == isWool;

        Color fill = background;
        Color border = AppColors.illInk;
        if (flashing) {
          fill = flashOk ? AppColors.correctBg : AppColors.wrongBg;
          border = flashOk ? AppColors.correctBorder : AppColors.wrongBorder;
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: border,
              width: (hovering || flashing) ? 3.5 : 1.5,
            ),
            boxShadow: hovering
                ? [BoxShadow(color: accent, blurRadius: 14)]
                : null,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    flashing
                        ? (flashOk ? Icons.check_circle : Icons.cancel)
                        : icon,
                    color: flashing ? border : AppColors.illInk,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: AppText.serif.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Expanded(
                child: placed.isEmpty
                    ? Center(
                        child: Text(
                          hovering ? '¡Soltá!' : 'Soltá acá',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.illInkSoft,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: placed.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 6),
                        itemBuilder: (_, i) => PlacedChip(text: placed[i].text),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
