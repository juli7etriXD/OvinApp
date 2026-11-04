import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../widgets/section_header.dart';
import 'package:ovinapp/screens/multimedia_screen.dart';

// ---------- Modelos ----------
class _Material {
  final String name;
  final IconData icon;
  const _Material(this.name, this.icon);
}

class _Experiment {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final List<String> steps;
  final String? warning;
  const _Experiment({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.steps,
    this.warning,
  });
}

const List<_Material> _materials = [
  _Material('Bandeja', Icons.inbox_outlined),
  _Material('Arena', Icons.grain),
  _Material('Vela', Icons.wb_incandescent_outlined),
  _Material('Plato', Icons.circle_outlined),
  _Material('Pinza', Icons.content_cut),
  _Material('Encendedor', Icons.local_fire_department_outlined),
  _Material('Balanza', Icons.scale_outlined),
  _Material('Lana', Icons.spa_outlined),
  _Material('Acrílico', Icons.science_outlined),
];

const List<_Experiment> _experiments = [
  _Experiment(
    title: 'Prueba Ignífuga / LOI',
    subtitle: 'Cómo reacciona cada fibra frente al fuego',
    icon: Icons.local_fire_department_outlined,
    accent: AppColors.illRose,
    warning:
        'Realizá esta prueba con un adulto, lejos de materiales inflamables '
        'y con la bandeja con arena a mano para apagar cualquier llama.',
    steps: [
      'Colocá la bandeja sobre una superficie firme y cubrí el fondo con arena.',
      'Cortá una tira de lana y una de acrílico del mismo tamaño.',
      'Sujetá la primera tira con la pinza y encendé la vela.',
      'Acercá la muestra a la llama y observá qué pasa. Luego retirala.',
      'Apagá cualquier llama sobre la arena y dejá enfriar en el plato.',
      'Repetí con la otra fibra y comparalas: ¿gotea?, ¿se apaga sola?, ¿cómo es la ceniza?',
    ],
  ),
  _Experiment(
    title: 'Biodegradabilidad',
    subtitle: 'Qué pasa con cada fibra al enterrarla',
    icon: Icons.eco_outlined,
    accent: AppColors.illGreen,
    steps: [
      'Cortá dos muestras del mismo tamaño: una de lana y una de acrílico.',
      'Pesalas con la balanza y anotá el peso de cada una.',
      'Enterralas en tierra húmeda, en lugares distintos y bien marcados.',
      'Mantené la tierra húmeda y esperá varias semanas.',
      'Desenterrá las muestras con cuidado y observá su aspecto.',
      'Volvé a pesarlas y comparalas con el peso inicial.',
    ],
  ),
  _Experiment(
    title: 'Fricción / Escamas',
    subtitle: 'Por qué la lana se afieltra y el acrílico no',
    icon: Icons.back_hand_outlined,
    accent: AppColors.illCardboard,
    steps: [
      'Mojá una muestra de lana y una de acrílico con agua tibia y un poco de jabón.',
      'Frotá cada muestra entre las palmas durante un par de minutos.',
      'Enjuagá y dejá reposar sobre el plato.',
      'Observá y tocá ambas: ¿cuál se apelmazó?',
      'Relacionalo con las escamas de la lana que viste en el Microscopio.',
    ],
  ),
];

class KitScreen extends StatefulWidget {
  const KitScreen({super.key});

  @override
  State<KitScreen> createState() => _KitScreenState();
}

class _KitScreenState extends State<KitScreen> {
  static const _kMaterialsKey = 'kit_checked';
  static const _kStepsKey = 'kit_steps_done';

  Set<String> _checked = {};
  Set<String> _stepsDone = {}; // formato "expIndex-stepIndex"

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _checked = (prefs.getStringList(_kMaterialsKey) ?? []).toSet();
      _stepsDone = (prefs.getStringList(_kStepsKey) ?? []).toSet();
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kMaterialsKey, _checked.toList());
    await prefs.setStringList(_kStepsKey, _stepsDone.toList());
  }

  void _toggleMaterial(String name) {
    setState(() {
      _checked.contains(name) ? _checked.remove(name) : _checked.add(name);
    });
    _save();
  }

  void _toggleStep(int exp, int step) {
    final key = '$exp-$step';
    setState(() {
      _stepsDone.contains(key) ? _stepsDone.remove(key) : _stepsDone.add(key);
    });
    _save();
  }

  Future<void> _confirmReset() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.illPaper,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Reiniciar progreso',
            style: AppText.serif.copyWith(fontWeight: FontWeight.bold)),
        content: const Text(
          'Se desmarcarán todos los materiales y pasos.',
          style: TextStyle(color: AppColors.illInkSoft),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar',
                style: TextStyle(color: AppColors.illInkSoft)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.illInk,
              foregroundColor: AppColors.illPaper,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
    if (ok == true) {
      setState(() {
        _checked.clear();
        _stepsDone.clear();
      });
      _save();
    }
  }

  int _doneSteps(int exp) =>
      List.generate(_experiments[exp].steps.length, (i) => '$exp-$i')
          .where(_stepsDone.contains)
          .length;

  @override
  Widget build(BuildContext context) {
    final total = _materials.length;
    final have = _checked.length;
    final ready = have == total;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SectionHeader(
            category: 'MANOS A LA LANA',
            number: '01',
            title: 'Armá tu Ovikit',
            subtitle: ready
                ? '¡Tu kit está completo! Ya podés hacer todos los experimentos.'
                : 'Te faltan ${total - have} materiales para completar el kit.',
            background: AppColors.bgKit,
            actions: [
              IconButton(
                tooltip: 'Reiniciar progreso',
                icon: const Icon(Icons.restart_alt, color: AppColors.illInk),
                onPressed: _confirmReset,
              ),
            ],
            bottom: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: have / total,
                      minHeight: 10,
                      backgroundColor: AppColors.inkTrack,
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.illGreen),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '$have/$total',
                  style: AppText.serif.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              children: [
                const _SectionTitle(
                  title: 'Materiales',
                  subtitle: 'Tocá los que ya tenés',
                ),
                const SizedBox(height: 12),
                _buildMaterialsGrid(),
                const SizedBox(height: 30),
                const _SectionTitle(
                  title: 'Experimentos',
                  subtitle: 'Guías paso a paso',
                ),
                const SizedBox(height: 12),
                for (int i = 0; i < _experiments.length; i++) ...[
                  _buildExperiment(i),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 8),
                _buildVideoButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Grilla de materiales ----------
  Widget _buildMaterialsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 0.95,
      children: _materials.map((m) {
        final owned = _checked.contains(m.name);
        return Material(
          color: owned ? AppColors.itemOwnedBg : AppColors.illPaper,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => _toggleMaterial(m.name),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: owned ? AppColors.illGreen : AppColors.paperBorder,
                  width: owned ? 2 : 1,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(m.icon, size: 30, color: AppColors.illInk),
                        const SizedBox(height: 6),
                        Text(
                          m.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                owned ? FontWeight.bold : FontWeight.w500,
                            color: AppColors.illInk,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (owned)
                    const Positioned(
                      top: 6,
                      right: 6,
                      child: Icon(Icons.check_circle,
                          size: 18, color: AppColors.illGreen),
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ---------- Tarjeta de experimento ----------
  Widget _buildExperiment(int index) {
    final exp = _experiments[index];
    final done = _doneSteps(index);
    final total = exp.steps.length;
    final finished = done == total;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.illPaper,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.paperBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: const RoundedRectangleBorder(),
          collapsedShape: const RoundedRectangleBorder(),
          iconColor: AppColors.illInk,
          collapsedIconColor: AppColors.illInkSoft,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: exp.accent,
              border: Border.all(color: AppColors.illInk, width: 1.5),
            ),
            child: Icon(
              finished ? Icons.check : exp.icon,
              color: AppColors.illInk,
            ),
          ),
          title: Text(
            exp.title,
            style: AppText.serif.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exp.subtitle,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.illInkSoft),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: done / total,
                    minHeight: 6,
                    backgroundColor: AppColors.inkTrack,
                    valueColor: AlwaysStoppedAnimation(exp.accent),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$done de $total pasos',
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.illInkSoft),
                ),
              ],
            ),
          ),
          children: [
            if (exp.warning != null)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warningBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: exp.accent),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: AppColors.warningText),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        exp.warning!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.warningText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            for (int s = 0; s < total; s++)
              _buildStep(index, s, exp.steps[s], exp.accent),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(int exp, int step, String text, Color accent) {
    final done = _stepsDone.contains('$exp-$step');
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => _toggleStep(exp, step),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done ? accent : Colors.transparent,
                border: Border.all(color: AppColors.illInk, width: 1.5),
              ),
              child: done
                  ? const Icon(Icons.check, size: 16, color: AppColors.illInk)
                  : Text(
                      '${step + 1}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.illInk,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: done ? AppColors.illInkSoft : AppColors.illInk,
                  decoration: done ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Botón de video ----------
  Widget _buildVideoButton() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.illInk,
          foregroundColor: AppColors.illPaper,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MultimediaScreen()),
        ),
        icon: const Icon(Icons.play_circle_outline),
        label: const Text(
          'Ver tutorial en video',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          title,
          style: AppText.serif.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: AppColors.illInkSoft),
          ),
        ),
      ],
    );
  }
}