import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../theme/colors.dart';
import '../../../theme/text_styles.dart';
import '../../../widgets/section_header.dart';
import '../multimedia_screen.dart';

const String _instagramUrl = 'https://www.instagram.com/ovinosfcv/';
const String _webUrl =
    'https://sites.google.com/vet.unicen.edu.ar/espacio-de-formacin-integral-p?usp=sharing&pli=1&authuser=0';

class MasInfoScreen extends StatelessWidget {
  const MasInfoScreen({super.key});

  Future<void> _openUrl(BuildContext context, String url) async {
    final messenger = ScaffoldMessenger.of(context);
    final uri = Uri.parse(url);
    bool ok = false;
    try {
      ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      ok = false;
    }
    if (!ok) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el enlace.')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const SectionHeader(
            category: 'SOBRE EL PROYECTO',
            title: 'Más información',
            subtitle: 'Conocé y seguí el proyecto desde donde quieras.',
            background: AppColors.bgKit,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              children: [
                _LinkCard(
                  icon: Icons.camera_alt_outlined,
                  accent: AppColors.illRose,
                  label: 'Instagram',
                  description:
                      'Seguinos para ver novedades, fotos y experiencias del proyecto.',
                  action: 'Abrir Instagram',
                  onTap: () => _openUrl(context, _instagramUrl),
                ),
                const SizedBox(height: 16),
                _LinkCard(
                  icon: Icons.language,
                  accent: AppColors.illGreen,
                  label: 'Página web',
                  description:
                      'Conocé más sobre el proyecto, su equipo y sus objetivos.',
                  action: 'Visitar sitio',
                  onTap: () => _openUrl(context, _webUrl),
                ),
                const SizedBox(height: 16),
                _LinkCard(
                  icon: Icons.play_circle_outline,
                  accent: AppColors.illYellow,
                  label: 'Video de presentación',
                  description:
                      'Mirá el video del proyecto sin salir de la aplicación.',
                  action: 'Reproducir video',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MultimediaScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final String label;
  final String description;
  final String action;
  final VoidCallback onTap;

  const _LinkCard({
    required this.icon,
    required this.accent,
    required this.label,
    required this.description,
    required this.action,
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
                    Row(
                      children: [
                        Text(
                          action,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.illInk,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.illInk,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward,
                            size: 16, color: AppColors.illInk),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}