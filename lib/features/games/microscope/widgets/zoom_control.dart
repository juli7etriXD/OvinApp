import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';

/// Control deslizante de zoom con íconos de lupa e indicador de aumento.
class ZoomControl extends StatelessWidget {
  final double zoom;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const ZoomControl({
    super.key,
    required this.zoom,
    this.min = 1.0,
    this.max = 4.0,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.zoom_out, color: AppColors.illInk),
            Expanded(
              child: Slider(
                value: zoom,
                min: min,
                max: max,
                activeColor: AppColors.illInk,
                inactiveColor: AppColors.inkTrack,
                onChanged: onChanged,
              ),
            ),
            const Icon(Icons.zoom_in, color: AppColors.illInk),
          ],
        ),
        Text(
          'Aumento: ${(zoom * 100).round()}x',
          style: AppText.serif.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

