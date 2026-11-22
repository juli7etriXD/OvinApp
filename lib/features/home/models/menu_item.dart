import 'package:flutter/material.dart';

/// Modelo que representa una tarjeta de aventura/sección en la pantalla principal.
class MenuItem {
  final String category;
  final String number;
  final String title;
  final String description;
  final String action;
  final Color background;
  final CustomPainter illustration;
  final Widget Function() screen;

  const MenuItem({
    required this.category,
    required this.number,
    required this.title,
    required this.description,
    required this.action,
    required this.background,
    required this.illustration,
    required this.screen,
  });
}

