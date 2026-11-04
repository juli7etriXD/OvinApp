import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../widgets/section_header.dart';

class MultimediaScreen extends StatefulWidget {
  const MultimediaScreen({super.key});

  @override
  State<MultimediaScreen> createState() => _MultimediaScreenState();
}

class _MultimediaScreenState extends State<MultimediaScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: 'dQw4w9WgXcQ', // reemplazar por tu ID
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      aspectRatio: 16 / 9,
      builder: (context, player) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              const SectionHeader(
                category: 'VER Y APRENDER',
                title: 'Tutoriales',
                subtitle: 'Mirá las experiencias y guías en video.',
                background: AppColors.bgKit,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.illInk, width: 1.5),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: player,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Tutorial del Ovikit',
                      style: AppText.serif.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Usá los controles del reproductor para pausar, ajustar el volumen o pasar a pantalla completa.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.45,
                        color: AppColors.illInkSoft,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}