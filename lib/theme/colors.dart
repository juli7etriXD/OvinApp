import 'package:flutter/material.dart';

/// Todos los colores de OvinApp en un solo lugar.
class AppColors {
  AppColors._(); // evita que se instancie

  // ---------- Paleta base ----------
  static const Color primary = Color(0xFF6B8E23); // Verde sustentable
  static const Color primaryDark = Color(0xFF4F6B1A); // Verde oscuro (degradados)
  static const Color onPrimary = Colors.white;

  static const Color secondary = Color(0xFFD2B48C); // Arena / madera
  static const Color onSecondary = Color(0xFF3E2723);

  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFF5F5DC); // Beige
  static const Color onSurface = Color(0xFF3E2723);

  static const Color error = Color(0xFFD32F2F);

  // ---------- Estados y avisos ----------
  static const Color itemOwnedBg = Color(0xFFE6EDCF); // verde muy claro
  static const Color warningBg = Color(0xFFFFF1E0);
  static const Color warningText = Color(0xFF8F4B2B);

  // ---------- Trivia ----------
  static const Color correctBg = Color(0xFFE3EFCF);
  static const Color correctBorder = Color(0xFF6B8E23);
  static const Color wrongBg = Color(0xFFFBE3DC);
  static const Color wrongBorder = Color(0xFFD32F2F);
  static const Color hintBg = Color(0xFFFFF4DA);
  static const Color hintBorder = Color(0xFFC88A2D);
  static const Color danger = Color(0xFFFFB4A2);

  // ---------- Microscopio ----------
  static const Color microBg = Color(0xFFEFF3EA);
  static const Color woolFill = Color(0xFFD9B38C);
  static const Color woolOutline = Color(0xFF8B5E3C);
  static const Color woolScale = Color(0xFF8F4B2B);
  static const Color medulla = Color(0xFF3E2723);
  static const Color acrylicEdge = Color(0xFF6B7A90);
  static const Color acrylicFill = Color(0xFFB8C4D6);
  static const Color acrylicShine = Color(0xFFF2F6FB);
  static const Color vignette = Color(0x55000000);

  // ---------- Arrastrar y soltar ----------
  static const Color dragAcrylicBg = Color(0xFFE8EEF5);

  // ---------- Home: tarjetas e ilustraciones ----------
  static const Color cardKit = Color(0xFFF5EBD7);       // crema
  static const Color cardGames = Color(0xFFE3EFD9);     // verde pastel
  static const Color cardKnowledge = Color(0xFFF6DFC8); // durazno / arena
  static const Color cardFuture = Color(0xFFE6E0F2);    // lavanda

  static const Color illInk = Color(0xFF4A3B2E);        // trazo y textos
  static const Color illInkSoft = Color(0xFF7A6A5A);    // textos secundarios
  static const Color illCardboard = Color(0xFFD9B38C);
  static const Color illGreen = Color(0xFF9DBB84);
  static const Color illRose = Color(0xFFE3A5A0);
  static const Color illBlue = Color(0xFFA9C7DB);
  static const Color illYellow = Color(0xFFF2D58A);
  static const Color illPaper = Color(0xFFFFFBF2);

  // ---------- Fondo por sección (alias de las tarjetas de la Home) ----------
  static const Color bgKit = cardKit;
  static const Color bgGames = cardGames;
  static const Color bgKnowledge = cardKnowledge;
  static const Color bgFuture = cardFuture;

  // ---------- Superficies internas ----------
  static const Color paperBorder = Color(0xFFE6DCC8); // borde suave de tarjetas
  static const Color inkTrack = Color(0x1F4A3B2E);    // pista de barras de progreso (ink al 12%)
  static const Color inkBubble = Color(0x144A3B2E);   // burbuja detrás de íconos (ink al 8%)
}