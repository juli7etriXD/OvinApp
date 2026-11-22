import 'package:flutter/material.dart';

/// Modelo que representa una característica observable de una fibra
/// bajo el microscopio (ej. "Cutícula escamosa", "Superficie lisa").
///
/// [highlighted] indica si la característica es visible al nivel de
/// zoom actual.
class FiberFeature {
  final IconData icon;
  final String title;
  final String text;
  final bool highlighted;

  const FiberFeature(this.icon, this.title, this.text, this.highlighted);
}

