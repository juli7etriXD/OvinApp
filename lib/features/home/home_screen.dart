import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';

import '../about/mas_info_screen.dart';
import 'data/menu_items_data.dart';
import 'widgets/menu_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _go(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final items = getHomeMenuItems();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            // ---------- Encabezado ----------
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'OvinApp',
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Más información',
                  icon: const Icon(
                    Icons.info_outline,
                    color: AppColors.illInkSoft,
                  ),
                  onPressed: () => _go(context, const MasInfoScreen()),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Elegí tu\npróxima aventura',
              style: AppText.serif.copyWith(
                fontSize: 36,
                height: 1.1,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // ---------- Tarjetas ----------
            for (final item in items) ...[
              MenuCard(
                item: item,
                onTap: () => _go(context, item.screen()),
              ),
              const SizedBox(height: 18),
            ],
          ],
        ),
      ),
    );
  }
}
