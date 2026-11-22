import 'package:flutter/material.dart';
import 'colors.dart';

class AppText {
  AppText._();

  /// Títulos en serif. Si el dispositivo no la tiene, usa las alternativas.
  static const TextStyle serif = TextStyle(
    fontFamily: 'serif',
    fontFamilyFallback: ['Georgia', 'Times New Roman'],
    color: AppColors.illInk,
  );

  /// Etiqueta pequeña en mayúsculas (ej. "MANOS A LA LANA").
  static const TextStyle label = TextStyle(
    fontSize: 11,
    letterSpacing: 1.8,
    fontWeight: FontWeight.w700,
    color: AppColors.illInkSoft,
  );
}