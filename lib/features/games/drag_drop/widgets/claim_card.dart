import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';

/// Tarjeta visual que muestra el texto de una afirmación.
///
/// Se usa tanto como child del [Draggable] como en el feedback
/// flotante mientras se arrastra.
class ClaimCard extends StatelessWidget {
  final String text;

  /// Si `true`, se aplica una sombra más pronunciada (estado "levantado").
  final bool lifted;

  const ClaimCard({
    super.key,
    required this.text,
    this.lifted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.illPaper,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.illInk, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.inkTrack,
            blurRadius: lifted ? 18 : 8,
            offset: Offset(0, lifted ? 10 : 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.drag_indicator, color: AppColors.illInkSoft),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppText.serif.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

