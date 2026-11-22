import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';

import '../painters/fiber_painter.dart';

/// Lente circular del microscopio con viñeta, paneo por gesto y zoom.
class LensViewport extends StatelessWidget {
  final double size;
  final bool isWool;
  final double zoom;
  final Offset pan;
  final bool showMedulla;
  final ValueChanged<Offset> onPanUpdate;

  const LensViewport({
    super.key,
    required this.size,
    required this.isWool,
    required this.zoom,
    required this.pan,
    required this.showMedulla,
    required this.onPanUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.illInk, width: 8),
        boxShadow: const [
          BoxShadow(
            color: AppColors.inkTrack,
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: GestureDetector(
          onPanUpdate: (d) => onPanUpdate(d.delta),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(
                painter: FiberPainter(
                  isWool: isWool,
                  zoom: zoom,
                  pan: pan,
                  showMedulla: showMedulla && isWool,
                ),
              ),
              // Viñeta para dar sensación de lente
              const IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [Colors.transparent, AppColors.vignette],
                      stops: [0.7, 1.0],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

