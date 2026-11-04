import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/text_styles.dart';

/// Encabezado pastel compartido por todas las pantallas.
class SectionHeader extends StatelessWidget {
  final String category; // ej. 'MANOS A LA LANA'
  final String? number; // ej. '01'
  final String title;
  final String? subtitle;
  final Color background;
  final List<Widget> actions; // botones a la derecha (ej. reiniciar)
  final Widget? bottom; // contenido extra debajo (barra de progreso, etc.)

  const SectionHeader({
    super.key,
    required this.category,
    required this.title,
    required this.background,
    this.number,
    this.subtitle,
    this.actions = const [],
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        8,
        MediaQuery.of(context).padding.top + 8,
        16,
        22,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila superior: volver, categoría, acciones y número
          Row(
            children: [
              IconButton(
                tooltip: 'Volver',
                icon: const Icon(Icons.arrow_back, color: AppColors.illInk),
                onPressed: () => Navigator.maybePop(context),
              ),
              Expanded(child: Text(category, style: AppText.label)),
              ...actions,
              if (number != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    number!,
                    style: AppText.serif.copyWith(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: AppColors.illInkSoft,
                    ),
                  ),
                ),
            ],
          ),
          // Título y subtítulo
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.serif.copyWith(
                    fontSize: 32,
                    height: 1.1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: AppColors.illInkSoft,
                    ),
                  ),
                ],
                if (bottom != null) ...[
                  const SizedBox(height: 14),
                  bottom!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}