import 'package:flutter/material.dart';

import 'package:ovinapp/core/widgets/widget.dart';
import 'package:ovinapp/core/theme/theme.dart';

class KnowledgeScreen extends StatelessWidget {
  const KnowledgeScreen({super.key});

  static const List<Map<String, String>> _articles = [
    {
      'title': 'Propiedades térmicas de la lana',
      'summary': 'La lana mantiene una temperatura corporal estable gracias a su alta capacidad de aislamiento y a su capacidad de retener hasta 30% de su peso en vapor de agua.',
    },
    {
      'title': 'Higroscopicidad y elasticidad',
      'summary': 'La higroscopicidad permite absorber vapor, mientras que la estructura helicoidal de la queratina brinda gran elasticidad y resistencia a la tracción.',
    },
    {
      'title': 'Comparación con fibras sintéticas',
      'summary': 'A diferencia de las fibras sintéticas, la lana es renovable, biodegradable y posee una mayor capacidad de regulación térmica.',
    },
  ];

  static const List<IconData> _articleIcons = [
    Icons.thermostat,
    Icons.water_drop_outlined,
    Icons.compare_arrows,
  ];

  static const List<Color> _articleAccents = [
    AppColors.illRose,
    AppColors.illBlue,
    AppColors.illGreen,
  ];

  static const List<Map<String, String>> _glossary = [
    {
      'term': 'Aislamiento térmico',
      'definition':
          'Capacidad de una fibra para reducir la transferencia de calor.',
    },
    {
      'term': 'Queratina',
      'definition': 'Proteína estructural que constituye la fibra de la lana.',
    },
    {
      'term': 'Escamas',
      'definition':
          'Estructura externa de la fibra que brinda resistencia al desgaste.',
    },
    {
      'term': 'Higroscopicidad',
      'definition':
          'Capacidad de absorber vapor de agua hasta un 30% de su peso.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            const SectionHeader(
              category: 'UN MUNDO DE FIBRAS',
              number: '03',
              title: 'Explorá la lana',
              subtitle: 'Mucho más que una fibra. Propiedades, comparaciones y vocabulario.',
              background: AppColors.bgKnowledge,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.inkBubble,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: AppColors.illInk,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  labelColor: AppColors.illPaper,
                  unselectedLabelColor: AppColors.illInk,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: 'Artículos'),
                    Tab(text: 'Glosario'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _articleList(),
                  const _GlossaryWidget(glossary: _glossary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _articleList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      itemCount: _articles.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final article = _articles[index];
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.illPaper,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.paperBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _articleAccents[index % _articleAccents.length],
                      border: Border.all(color: AppColors.illInk, width: 1.5),
                    ),
                    child: Icon(
                      _articleIcons[index % _articleIcons.length],
                      color: AppColors.illInk,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      article['title']!,
                      style: AppText.serif.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                article['summary']!,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: AppColors.illInkSoft,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GlossaryWidget extends StatefulWidget {
  final List<Map<String, String>> glossary;
  const _GlossaryWidget({required this.glossary});

  @override
  State<_GlossaryWidget> createState() => _GlossaryWidgetState();
}

class _GlossaryWidgetState extends State<_GlossaryWidget> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    // Orden alfabético y filtro por término
    final filtered =
        widget.glossary
            .where(
              (e) => e['term']!.toLowerCase().contains(
                _filter.trim().toLowerCase(),
              ),
            )
            .toList()
          ..sort(
            (a, b) =>
                a['term']!.toLowerCase().compareTo(b['term']!.toLowerCase()),
          );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: TextField(
            onChanged: (v) => setState(() => _filter = v),
            style: const TextStyle(color: AppColors.illInk),
            cursorColor: AppColors.illInk,
            decoration: InputDecoration(
              hintText: 'Buscar término',
              hintStyle: const TextStyle(color: AppColors.illInkSoft),
              prefixIcon: const Icon(Icons.search, color: AppColors.illInkSoft),
              filled: true,
              fillColor: AppColors.illPaper,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: AppColors.paperBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: AppColors.illInk,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const Center(
                  child: Text(
                    'No encontramos ese término.',
                    style: TextStyle(color: AppColors.illInkSoft),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final entry = filtered[i];
                    final letter = entry['term']![0].toUpperCase();
                    final showLetter =
                        i == 0 ||
                        filtered[i - 1]['term']![0].toUpperCase() != letter;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showLetter)
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 6),
                            child: Text(
                              letter,
                              style: AppText.serif.copyWith(
                                fontSize: 26,
                                fontStyle: FontStyle.italic,
                                color: AppColors.illInkSoft,
                              ),
                            ),
                          ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.illPaper,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.paperBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry['term']!,
                                style: AppText.serif.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                entry['definition']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.4,
                                  color: AppColors.illInkSoft,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}
