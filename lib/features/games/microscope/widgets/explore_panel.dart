import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';

import '../models/fiber_feature.dart';
import 'feature_card.dart';

/// Panel inferior del modo "Explorar".
///
/// Muestra un switch para la médula (solo en lana) y tarjetas con las
/// características observables según el nivel de zoom.
class ExplorePanel extends StatelessWidget {
  final bool isWool;
  final double zoom;
  final bool showMedulla;
  final ValueChanged<bool> onMedullaChanged;

  const ExplorePanel({
    super.key,
    required this.isWool,
    required this.zoom,
    required this.showMedulla,
    required this.onMedullaChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scalesVisible = zoom >= 2.0;

    final List<FiberFeature> features = isWool
        ? [
            FiberFeature(
              Icons.waves,
              'Ondulación (crimp)',
              'Con poco aumento se nota que la fibra no es recta: tiene un '
                  'rizo natural, como un resorte estirado.',
              !scalesVisible,
            ),
            FiberFeature(
              Icons.layers_outlined,
              'Cutícula escamosa',
              'Con más aumento aparecen las escamas superpuestas como tejas. '
                  'Sus puntas apuntan siempre de la raíz hacia la punta, por '
                  'eso los bordes se ven dentados.',
              scalesVisible,
            ),
          ]
        : [
            FiberFeature(
              Icons.horizontal_rule,
              'Superficie lisa',
              'Se fabrica por extrusión: la fibra es continua, sin escamas '
                  'ni irregularidades.',
              true,
            ),
            FiberFeature(
              Icons.straighten,
              'Grosor constante',
              'Parece un cilindro de diámetro perfectamente uniforme, sin '
                  'capas internas como el córtex o la médula.',
              true,
            ),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isWool)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: AppColors.illInk,
            activeTrackColor: AppColors.illGreen,
            title: const Text(
              'Mostrar canal medular',
              style: TextStyle(
                color: AppColors.illInk,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text(
              'Línea oscura central, visible en lanas más gruesas',
              style: TextStyle(fontSize: 12, color: AppColors.illInkSoft),
            ),
            value: showMedulla,
            onChanged: onMedullaChanged,
          ),
        const SizedBox(height: 8),
        for (final f in features) ...[
          FeatureCard(
            feature: f,
            accent: isWool ? AppColors.illCardboard : AppColors.illBlue,
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

