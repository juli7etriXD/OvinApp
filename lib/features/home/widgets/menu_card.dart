import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';

import '../models/menu_item.dart';

/// Tarjeta del menú principal con ilustración, descripción y acción interactiva.
class MenuCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.background,
      borderRadius: BorderRadius.circular(28),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Categoría + número
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.category,
                      style: const TextStyle(
                        fontSize: 11,
                        letterSpacing: 1.8,
                        fontWeight: FontWeight.w700,
                        color: AppColors.illInkSoft,
                      ),
                    ),
                  ),
                  Text(
                    item.number,
                    style: AppText.serif.copyWith(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: AppColors.illInkSoft,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Ilustración vectorial
              SizedBox(
                height: 130,
                width: double.infinity,
                child: CustomPaint(painter: item.illustration),
              ),
              const SizedBox(height: 12),

              // Título y descripción
              Text(
                item.title,
                style: AppText.serif.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: AppColors.illInkSoft,
                ),
              ),
              const SizedBox(height: 16),

              // Acción
              Row(
                children: [
                  Text(
                    item.action,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.illInk,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.illInk,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: AppColors.illInk,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

