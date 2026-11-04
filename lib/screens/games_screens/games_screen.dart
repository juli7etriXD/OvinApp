import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../widgets/section_header.dart';
import '../games_screens/trivia_screens/trivia_screen.dart';
import '../games_screens/microscope_screens/microscope_screen.dart';
import '../games_screens/drag_drop_screens/drag_drop_screen.dart';

class JuegosScreen extends StatelessWidget {
  const JuegosScreen({super.key});

  void _go(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const SectionHeader(
            category: 'CURIOSIDAD EN ACCIÓN',
            number: '02',
            title: 'Aprendé jugando',
            subtitle:
                'Trivias, desafíos y nuestro microscopio virtual para descubrir la lana.',
            background: AppColors.bgGames,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              children: [
                _GameCard(
                  icon: Icons.quiz_outlined,
                  accent: AppColors.illYellow,
                  label: 'Trivia',
                  description:
                      'Respondé contra el reloj y descubrí cuánto sabés de la lana.',
                  tag: '10 preguntas · 15 s',
                  onTap: () => _go(context, const TriviaScreen()),
                ),
                const SizedBox(height: 16),
                _GameCard(
                  icon: Icons.biotech_outlined,
                  accent: AppColors.illBlue,
                  label: 'Microscopio',
                  description:
                      'Mirá de cerca las fibras y compará la lana con el acrílico.',
                  tag: 'Explorá con zoom',
                  onTap: () => _go(context, const MicroscopeScreen()),
                ),
                const SizedBox(height: 16),
                _GameCard(
                  icon: Icons.touch_app_outlined,
                  accent: AppColors.illRose,
                  label: 'Arrastrar y Soltar',
                  description:
                      'Clasificá cada característica en la fibra que le corresponde.',
                  tag: '8 tarjetas',
                  onTap: () => _go(context, const DragDropScreen()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final String label;
  final String description;
  final String tag;
  final VoidCallback onTap;

  const _GameCard({
    required this.icon,
    required this.accent,
    required this.label,
    required this.description,
    required this.tag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.illPaper,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.paperBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent,
                  border: Border.all(color: AppColors.illInk, width: 1.5),
                ),
                child: Icon(icon, size: 32, color: AppColors.illInk),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppText.serif.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: AppColors.illInkSoft,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.inkBubble,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.illInk,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, color: AppColors.illInk),
            ],
          ),
        ),
      ),
    );
  }
}