import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../../theme/text_styles.dart';
import '../../../widgets/section_header.dart';

class MicroscopeScreen extends StatefulWidget {
  const MicroscopeScreen({super.key});

  @override
  State<MicroscopeScreen> createState() => _MicroscopeScreenState();
}

class _MicroscopeScreenState extends State<MicroscopeScreen> {
  static const double _lensSize = 300;

  final _random = math.Random();

  bool _challenge = false; // false = explorar, true = desafío
  bool _isWool = true; // muestra elegida en modo explorar
  double _zoom = 1.5;
  Offset _pan = Offset.zero;
  bool _showMedulla = false;

  // Desafío
  late bool _mysteryIsWool = _random.nextBool();
  bool? _answeredCorrectly; // null = sin responder
  int _correct = 0;
  int _attempts = 0;

  bool get _currentIsWool => _challenge ? _mysteryIsWool : _isWool;

  void _resetView() {
    _zoom = 1.5;
    _pan = Offset.zero;
  }

  void _setMode(bool challenge) {
    setState(() {
      _challenge = challenge;
      _resetView();
      if (challenge) _newSample();
    });
  }

  @override
  void initState() {
    super.initState();
    _nextMystery();
  }

  void _newSample() {
    _nextMystery();
    _answeredCorrectly = null;
    _resetView();
  }

  void _nextMystery() {
    _mysteryIsWool = !_mysteryIsWool;
  }

  void _answer(bool guessWool) {
    if (_answeredCorrectly != null) return;
    setState(() {
      _attempts++;
      _answeredCorrectly = guessWool == _mysteryIsWool;
      if (_answeredCorrectly!) _correct++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SectionHeader(
            category: 'CURIOSIDAD EN ACCIÓN',
            title: 'Microscopio',
            subtitle: _challenge
                ? 'Adiviná qué fibra estás mirando.'
                : 'Mirá de cerca la lana y el acrílico.',
            background: AppColors.bgGames,
            actions: [if (_challenge) _scoreChip()],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildModeSelector(),
                  const SizedBox(height: 16),
                  if (!_challenge) ...[
                    _buildSampleSelector(),
                    const SizedBox(height: 16),
                  ],
                  Center(child: _buildLens()),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Arrastrá la muestra para moverla',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.illInkSoft),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildZoomControl(),
                  const SizedBox(height: 12),
                  if (_challenge) _buildChallengePanel() else _buildInfoPanel(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Marcador (en el encabezado) ----------
  Widget _scoreChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.illPaper,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.paperBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, size: 18, color: AppColors.illInk),
          const SizedBox(width: 4),
          Text(
            '$_correct/$_attempts',
            style: const TextStyle(
              color: AppColors.illInk,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Selectores ----------
  ButtonStyle get _segmentStyle => SegmentedButton.styleFrom(
        backgroundColor: AppColors.illPaper,
        foregroundColor: AppColors.illInk,
        selectedBackgroundColor: AppColors.illInk,
        selectedForegroundColor: AppColors.illPaper,
        side: const BorderSide(color: AppColors.paperBorder),
      );

  Widget _buildModeSelector() {
    return SegmentedButton<bool>(
      style: _segmentStyle,
      segments: const [
        ButtonSegment(
          value: false,
          icon: Icon(Icons.search),
          label: Text('Explorar'),
        ),
        ButtonSegment(
          value: true,
          icon: Icon(Icons.help_outline),
          label: Text('Desafío'),
        ),
      ],
      selected: {_challenge},
      onSelectionChanged: (s) => _setMode(s.first),
    );
  }

  Widget _buildSampleSelector() {
    return SegmentedButton<bool>(
      style: _segmentStyle,
      segments: const [
        ButtonSegment(value: true, label: Text('Lana')),
        ButtonSegment(value: false, label: Text('Acrílico')),
      ],
      selected: {_isWool},
      onSelectionChanged: (s) => setState(() {
        _isWool = s.first;
        _pan = Offset.zero;
      }),
    );
  }

  // ---------- Lente ----------
  Widget _buildLens() {
    return Container(
      width: _lensSize,
      height: _lensSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.illInk, width: 8),
        boxShadow: const [
          BoxShadow(
            color: AppColors.inkTrack,
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: GestureDetector(
          onPanUpdate: (d) => setState(() => _pan += d.delta),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(
                painter: _FiberPainter(
                  isWool: _currentIsWool,
                  zoom: _zoom,
                  pan: _pan,
                  showMedulla: _showMedulla && _currentIsWool,
                ),
              ),
              // Viñeta para dar sensación de lente
              const IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [Colors.transparent, AppColors.vignette],
                      stops: [0.7, 1.0],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Zoom ----------
  Widget _buildZoomControl() {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.zoom_out, color: AppColors.illInk),
            Expanded(
              child: Slider(
                value: _zoom,
                min: 1.0,
                max: 4.0,
                activeColor: AppColors.illInk,
                inactiveColor: AppColors.inkTrack,
                onChanged: (v) => setState(() => _zoom = v),
              ),
            ),
            const Icon(Icons.zoom_in, color: AppColors.illInk),
          ],
        ),
        Text(
          'Aumento: ${(_zoom * 100).round()}x',
          style: AppText.serif.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ---------- Panel del modo explorar ----------
  Widget _buildInfoPanel() {
    final scalesVisible = _zoom >= 2.0;
    final List<_Feature> features = _isWool
        ? [
            _Feature(
              Icons.waves,
              'Ondulación (crimp)',
              'Con poco aumento se nota que la fibra no es recta: tiene un '
                  'rizo natural, como un resorte estirado.',
              !scalesVisible,
            ),
            _Feature(
              Icons.layers_outlined,
              'Cutícula escamosa',
              'Con más aumento aparecen las escamas superpuestas como tejas. '
                  'Sus puntas apuntan siempre de la raíz hacia la punta, por '
                  'eso los bordes se ven dentados.',
              scalesVisible,
            ),
          ]
        : [
            _Feature(
              Icons.horizontal_rule,
              'Superficie lisa',
              'Se fabrica por extrusión: la fibra es continua, sin escamas '
                  'ni irregularidades.',
              true,
            ),
            _Feature(
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
        if (_isWool)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: AppColors.illInk,
            activeTrackColor: AppColors.illGreen,
            title: const Text(
              'Mostrar canal medular',
              style: TextStyle(
                  color: AppColors.illInk, fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              'Línea oscura central, visible en lanas más gruesas',
              style: TextStyle(fontSize: 12, color: AppColors.illInkSoft),
            ),
            value: _showMedulla,
            onChanged: (v) => setState(() => _showMedulla = v),
          ),
        const SizedBox(height: 8),
        for (final f in features) ...[
          _FeatureCard(
            feature: f,
            accent: _isWool ? AppColors.illCardboard : AppColors.illBlue,
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  // ---------- Panel del desafío ----------
  Widget _buildChallengePanel() {
    final answered = _answeredCorrectly != null;
    final ok = _answeredCorrectly == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '¿Qué fibra estás mirando?',
          textAlign: TextAlign.center,
          style: AppText.serif.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Pista: buscá escamas tipo teja en los bordes.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: AppColors.illInkSoft),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _AnswerButton(
                label: 'Lana',
                icon: Icons.spa_outlined,
                color: AppColors.illCardboard,
                onTap: answered ? null : () => _answer(true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _AnswerButton(
                label: 'Acrílico',
                icon: Icons.science_outlined,
                color: AppColors.illBlue,
                onTap: answered ? null : () => _answer(false),
              ),
            ),
          ],
        ),
        if (answered) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ok ? AppColors.correctBg : AppColors.wrongBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: ok ? AppColors.correctBorder : AppColors.wrongBorder,
                width: 2,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  ok ? Icons.check_circle : Icons.cancel,
                  color: ok ? AppColors.correctBorder : AppColors.wrongBorder,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${ok ? '¡Correcto!' : 'Casi.'} Era '
                    '${_mysteryIsWool ? 'lana' : 'acrílico'}: '
                    '${_mysteryIsWool ? 'se distinguen las escamas superpuestas y los bordes dentados.' : 'la superficie es lisa, de grosor uniforme y sin escamas.'}',
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: AppColors.illInk,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.illInk,
              foregroundColor: AppColors.illPaper,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: () => setState(_newSample),
            icon: const Icon(Icons.arrow_forward),
            label: const Text(
              'Otra muestra',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ],
    );
  }
}

// ---------- Widgets auxiliares ----------
class _Feature {
  final IconData icon;
  final String title;
  final String text;
  final bool highlighted;
  const _Feature(this.icon, this.title, this.text, this.highlighted);
}

class _FeatureCard extends StatelessWidget {
  final _Feature feature;
  final Color accent;
  const _FeatureCard({required this.feature, required this.accent});

  @override
  Widget build(BuildContext context) {
    final on = feature.highlighted;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: on ? AppColors.illPaper : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: on ? accent : AppColors.paperBorder,
          width: on ? 2 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: on ? accent : AppColors.inkBubble,
              border: Border.all(
                color: on ? AppColors.illInk : AppColors.paperBorder,
                width: 1.5,
              ),
            ),
            child: Icon(
              feature.icon,
              size: 20,
              color: on ? AppColors.illInk : AppColors.illInkSoft,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: AppText.serif.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: on ? AppColors.illInk : AppColors.illInkSoft,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature.text,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: on ? AppColors.illInk : AppColors.illInkSoft,
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

class _AnswerButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  const _AnswerButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppColors.illInk,
        disabledBackgroundColor: AppColors.inkBubble,
        disabledForegroundColor: AppColors.illInkSoft,
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: const BorderSide(color: AppColors.illInk, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

// ---------- Dibujo de las fibras ----------
class _FiberPainter extends CustomPainter {
  final bool isWool;
  final double zoom;
  final Offset pan;
  final bool showMedulla;

  const _FiberPainter({
    required this.isWool,
    required this.zoom,
    required this.pan,
    required this.showMedulla,
  });

  static const double _spacing = 80; // separación vertical entre fibras
  static const double _step = 3; // resolución del trazo

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.microBg);

    canvas.save();
    canvas.translate(size.width / 2 + pan.dx, size.height / 2 + pan.dy);
    canvas.scale(zoom);

    // Zona visible en coordenadas del "mundo"
    final xMin = (-size.width / 2 - pan.dx) / zoom - 30;
    final xMax = (size.width / 2 - pan.dx) / zoom + 30;
    final yMin = (-size.height / 2 - pan.dy) / zoom;
    final yMax = (size.height / 2 - pan.dy) / zoom;

    final kStart = (yMin / _spacing).floor() - 1;
    final kEnd = (yMax / _spacing).ceil() + 1;

    for (int k = kStart; k <= kEnd; k++) {
      if (isWool) {
        _paintWool(canvas, k, xMin, xMax);
      } else {
        _paintAcrylic(canvas, k, xMin, xMax);
      }
    }

    canvas.restore();
  }

  // ----- Lana: ondulada, grosor variable, con escamas -----
  double _yAt(int k, double x) =>
      k * _spacing + 12 * math.sin(x / 35 + k * 1.7);

  double _wAt(int k, double x) => 26 + 3 * math.sin(x / 23 + k);

  void _paintWool(Canvas canvas, int k, double xMin, double xMax) {
    final x0 = (xMin / _step).floor() * _step;

    final outline = Paint()
      ..color = AppColors.woolOutline
      ..strokeCap = StrokeCap.round;
    final fill = Paint()
      ..color = AppColors.woolFill
      ..strokeCap = StrokeCap.round;

    // 1) contorno y 2) relleno, tramo a tramo (el grosor varía)
    for (double x = x0; x < xMax; x += _step) {
      final a = Offset(x, _yAt(k, x));
      final b = Offset(x + _step, _yAt(k, x + _step));
      canvas.drawLine(a, b, outline..strokeWidth = _wAt(k, x) + 3);
    }
    for (double x = x0; x < xMax; x += _step) {
      final a = Offset(x, _yAt(k, x));
      final b = Offset(x + _step, _yAt(k, x + _step));
      canvas.drawLine(a, b, fill..strokeWidth = _wAt(k, x));
    }

    // 3) canal medular (opcional)
    if (showMedulla) {
      final med = Paint()
        ..color = AppColors.medulla.withValues(alpha: 0.75)
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round;
      for (double x = x0; x < xMax; x += _step) {
        canvas.drawLine(
          Offset(x, _yAt(k, x)),
          Offset(x + _step, _yAt(k, x + _step)),
          med,
        );
      }
    }

    // 4) escamas: aparecen gradualmente al aumentar el zoom
    final alpha = ((zoom - 1.6) / 1.2).clamp(0.0, 1.0);
    if (alpha <= 0) return;

    const scaleStep = 9.0;
    final scalePaint = Paint()
      ..color = AppColors.woolScale.withValues(alpha: alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final toothPaint = Paint()
      ..color = AppColors.woolOutline.withValues(alpha: alpha)
      ..style = PaintingStyle.fill;

    final sx0 = (xMin / scaleStep).floor() * scaleStep;
    for (double x = sx0; x < xMax; x += scaleStep) {
      final y = _yAt(k, x);
      final w = _wAt(k, x);
      final angle = math.atan2(_yAt(k, x + 1) - _yAt(k, x - 1), 2);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);

      // Borde de la escama (curva que apunta hacia +x)
      final arc = Path()
        ..moveTo(0, -w / 2)
        ..quadraticBezierTo(8, -w / 4, 8, 0)
        ..quadraticBezierTo(8, w / 4, 0, w / 2);
      canvas.drawPath(arc, scalePaint);

      // Dientes en los bordes, todos apuntando en la misma dirección
      final top = Path()
        ..moveTo(0, -w / 2)
        ..lineTo(5, -w / 2 - 2.5)
        ..lineTo(8, -w / 2)
        ..close();
      final bottom = Path()
        ..moveTo(0, w / 2)
        ..lineTo(5, w / 2 + 2.5)
        ..lineTo(8, w / 2)
        ..close();
      canvas.drawPath(top, toothPaint);
      canvas.drawPath(bottom, toothPaint);

      canvas.restore();
    }
  }

  // ----- Acrílico: cilindro recto, liso y uniforme -----
  void _paintAcrylic(Canvas canvas, int k, double xMin, double xMax) {
    const double w = 26;
    final rect = Rect.fromLTRB(xMin, k * _spacing - w / 2, xMax, k * _spacing + w / 2);

    final body = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.acrylicEdge,
          AppColors.acrylicFill,
          AppColors.acrylicShine,
          AppColors.acrylicFill,
          AppColors.acrylicEdge,
        ],
        stops: [0.0, 0.25, 0.4, 0.7, 1.0],
      ).createShader(rect);

    canvas.drawRect(rect, body);

    final edge = Paint()
      ..color = AppColors.acrylicEdge
      ..strokeWidth = 1.5;
    canvas.drawLine(rect.topLeft, rect.topRight, edge);
    canvas.drawLine(rect.bottomLeft, rect.bottomRight, edge);
  }

  @override
  bool shouldRepaint(covariant _FiberPainter old) =>
      old.isWool != isWool ||
      old.zoom != zoom ||
      old.pan != pan ||
      old.showMedulla != showMedulla;
}