import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';

/// Dibuja las fibras de lana u acrílico dentro de la lente del microscopio.
///
/// - **Lana**: fibras onduladas con grosor variable, escamas que aparecen
///   gradualmente al aumentar el zoom, y canal medular opcional.
/// - **Acrílico**: cilindros rectos, lisos y uniformes con degradado.
class FiberPainter extends CustomPainter {
  final bool isWool;
  final double zoom;
  final Offset pan;
  final bool showMedulla;

  const FiberPainter({
    required this.isWool,
    required this.zoom,
    required this.pan,
    required this.showMedulla,
  });

  static const double _spacing = 80; // separación vertical entre fibras
  static const double _step = 3; // resolución del trazo

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.microBg);

    canvas.save();
    canvas.translate(size.width / 2 + pan.dx, size.height / 2 + pan.dy);
    canvas.scale(zoom);

    // Zona visible en coordenadas del "mundo"
    final xMin = (-size.width / 2 - pan.dx) / zoom - 30;
    final xMax = (size.width / 2 - pan.dx) / zoom + 30;
    final yMin = (-size.height / 2 - pan.dy) / zoom;
    final yMax = (size.height / 2 - pan.dy) / zoom;

    final kStart = (yMin / _spacing).floor() - 1;
    final kEnd = (yMax / _spacing).ceil() + 1;

    for (int k = kStart; k <= kEnd; k++) {
      if (isWool) {
        _paintWool(canvas, k, xMin, xMax);
      } else {
        _paintAcrylic(canvas, k, xMin, xMax);
      }
    }

    canvas.restore();
  }

  // ----- Lana: ondulada, grosor variable, con escamas -----

  double _yAt(int k, double x) =>
      k * _spacing + 12 * math.sin(x / 35 + k * 1.7);

  double _wAt(int k, double x) => 26 + 3 * math.sin(x / 23 + k);

  void _paintWool(Canvas canvas, int k, double xMin, double xMax) {
    final x0 = (xMin / _step).floor() * _step;

    final outline = Paint()
      ..color = AppColors.woolOutline
      ..strokeCap = StrokeCap.round;
    final fill = Paint()
      ..color = AppColors.woolFill
      ..strokeCap = StrokeCap.round;

    // 1) contorno y 2) relleno, tramo a tramo (el grosor varía)
    for (double x = x0; x < xMax; x += _step) {
      final a = Offset(x, _yAt(k, x));
      final b = Offset(x + _step, _yAt(k, x + _step));
      canvas.drawLine(a, b, outline..strokeWidth = _wAt(k, x) + 3);
    }
    for (double x = x0; x < xMax; x += _step) {
      final a = Offset(x, _yAt(k, x));
      final b = Offset(x + _step, _yAt(k, x + _step));
      canvas.drawLine(a, b, fill..strokeWidth = _wAt(k, x));
    }

    // 3) canal medular (opcional)
    if (showMedulla) {
      final med = Paint()
        ..color = AppColors.medulla.withValues(alpha: 0.75)
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round;
      for (double x = x0; x < xMax; x += _step) {
        canvas.drawLine(
          Offset(x, _yAt(k, x)),
          Offset(x + _step, _yAt(k, x + _step)),
          med,
        );
      }
    }

    // 4) escamas: aparecen gradualmente al aumentar el zoom
    final alpha = ((zoom - 1.6) / 1.2).clamp(0.0, 1.0);
    if (alpha <= 0) return;

    const scaleStep = 9.0;
    final scalePaint = Paint()
      ..color = AppColors.woolScale.withValues(alpha: alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final toothPaint = Paint()
      ..color = AppColors.woolOutline.withValues(alpha: alpha)
      ..style = PaintingStyle.fill;

    final sx0 = (xMin / scaleStep).floor() * scaleStep;
    for (double x = sx0; x < xMax; x += scaleStep) {
      final y = _yAt(k, x);
      final w = _wAt(k, x);
      final angle = math.atan2(_yAt(k, x + 1) - _yAt(k, x - 1), 2);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);

      // Borde de la escama (curva que apunta hacia +x)
      final arc = Path()
        ..moveTo(0, -w / 2)
        ..quadraticBezierTo(8, -w / 4, 8, 0)
        ..quadraticBezierTo(8, w / 4, 0, w / 2);
      canvas.drawPath(arc, scalePaint);

      // Dientes en los bordes, todos apuntando en la misma dirección
      final top = Path()
        ..moveTo(0, -w / 2)
        ..lineTo(5, -w / 2 - 2.5)
        ..lineTo(8, -w / 2)
        ..close();
      final bottom = Path()
        ..moveTo(0, w / 2)
        ..lineTo(5, w / 2 + 2.5)
        ..lineTo(8, w / 2)
        ..close();
      canvas.drawPath(top, toothPaint);
      canvas.drawPath(bottom, toothPaint);

      canvas.restore();
    }
  }

  // ----- Acrílico: cilindro recto, liso y uniforme -----

  void _paintAcrylic(Canvas canvas, int k, double xMin, double xMax) {
    const double w = 26;
    final rect = Rect.fromLTRB(
      xMin,
      k * _spacing - w / 2,
      xMax,
      k * _spacing + w / 2,
    );

    final body = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.acrylicEdge,
          AppColors.acrylicFill,
          AppColors.acrylicShine,
          AppColors.acrylicFill,
          AppColors.acrylicEdge,
        ],
        stops: [0.0, 0.25, 0.4, 0.7, 1.0],
      ).createShader(rect);

    canvas.drawRect(rect, body);

    final edge = Paint()
      ..color = AppColors.acrylicEdge
      ..strokeWidth = 1.5;
    canvas.drawLine(rect.topLeft, rect.topRight, edge);
    canvas.drawLine(rect.bottomLeft, rect.bottomRight, edge);
  }

  @override
  bool shouldRepaint(covariant FiberPainter old) =>
      old.isWool != isWool ||
      old.zoom != zoom ||
      old.pan != pan ||
      old.showMedulla != showMedulla;
}

