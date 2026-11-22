import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';
import 'package:ovinapp/core/widgets/widget.dart';

import 'widgets/challenge_panel.dart';
import 'widgets/explore_panel.dart';
import 'widgets/lens_viewport.dart';
import 'widgets/score_chip.dart';
import 'widgets/zoom_control.dart';

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
  bool? _answeredCorrectly;
  int _correct = 0;
  int _attempts = 0;

  bool get _currentIsWool => _challenge ? _mysteryIsWool : _isWool;

  @override
  void initState() {
    super.initState();
    _nextMystery();
  }

  // ---------- Lógica ----------

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

  // ---------- UI ----------

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
            actions: [
              if (_challenge)
                ScoreChip(correct: _correct, attempts: _attempts),
            ],
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
                  Center(
                    child: LensViewport(
                      size: _lensSize,
                      isWool: _currentIsWool,
                      zoom: _zoom,
                      pan: _pan,
                      showMedulla: _showMedulla,
                      onPanUpdate: (delta) =>
                          setState(() => _pan += delta),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Arrastrá la muestra para moverla',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.illInkSoft,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ZoomControl(
                    zoom: _zoom,
                    onChanged: (v) => setState(() => _zoom = v),
                  ),
                  const SizedBox(height: 12),
                  if (_challenge)
                    ChallengePanel(
                      answeredCorrectly: _answeredCorrectly,
                      mysteryIsWool: _mysteryIsWool,
                      onAnswer: _answer,
                      onNextSample: () => setState(_newSample),
                    )
                  else
                    ExplorePanel(
                      isWool: _isWool,
                      zoom: _zoom,
                      showMedulla: _showMedulla,
                      onMedullaChanged: (v) =>
                          setState(() => _showMedulla = v),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

