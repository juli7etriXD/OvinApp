import 'dart:async';
import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../../theme/text_styles.dart';
import '../../../widgets/section_header.dart';

// ----- Modelo -----
class _Claim {
  final String text;
  final bool isWool; // true = lana, false = acrílico
  const _Claim(this.text, this.isWool);
}

const List<_Claim> _allClaims = [
  _Claim('Se carboniza al quemarse, sin gotear', true),
  _Claim('Absorbe hasta 33% de su peso en vapor de agua', true),
  _Claim('Tiene escamas en la cutícula que se traban', true),
  _Claim('Se descompone en el suelo en semanas o meses', true),
  _Claim('Se derrite y gotea al entrar en contacto con la llama', false),
  _Claim('Carece de escamas, por eso no se afieltra', false),
  _Claim('Sus bolitas (pills) quedan firmemente sujetas', false),
  _Claim('Es un polímero sintético de origen petroquímico', false),
];

class DragDropScreen extends StatefulWidget {
  const DragDropScreen({super.key});

  @override
  State<DragDropScreen> createState() => _DragDropScreenState();
}

class _DragDropScreenState extends State<DragDropScreen> {
  late List<_Claim> _pending;
  final List<_Claim> _wool = [];
  final List<_Claim> _acrylic = [];
  int _mistakes = 0;

  // Retroalimentación visual temporal sobre una zona
  bool? _flashWool; // zona que parpadea (true = lana, false = acrílico)
  bool _flashOk = false;
  Timer? _flashTimer;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    _pending = List<_Claim>.from(_allClaims)..shuffle();
    _wool.clear();
    _acrylic.clear();
    _mistakes = 0;
    _flashWool = null;
  }

  void _reset() {
    _flashTimer?.cancel();
    setState(_initGame);
  }

  void _flash(bool onWool, bool ok) {
    _flashTimer?.cancel();
    setState(() {
      _flashWool = onWool;
      _flashOk = ok;
    });
    _flashTimer = Timer(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _flashWool = null);
    });
  }

  void _drop(_Claim claim, bool droppedOnWool) {
    final ok = claim.isWool == droppedOnWool;
    if (ok) {
      setState(() {
        _pending.remove(claim);
        (droppedOnWool ? _wool : _acrylic).insert(0, claim);
      });
      _flash(droppedOnWool, true);
      if (_pending.isEmpty) {
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) _showResult();
        });
      }
    } else {
      setState(() => _mistakes++);
      _flash(droppedOnWool, false);
    }
  }

  void _showResult() {
    final perfect = _mistakes == 0;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.illPaper,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Column(
          children: [
            Icon(
              perfect ? Icons.emoji_events : Icons.thumb_up_alt_outlined,
              size: 56,
              color: AppColors.illInk,
            ),
            const SizedBox(height: 8),
            Text(
              '¡Completado!',
              textAlign: TextAlign.center,
              style: AppText.serif.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$_mistakes ${_mistakes == 1 ? 'error' : 'errores'}',
              style: AppText.serif.copyWith(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              perfect
                  ? 'Clasificaste todo sin errores. ¡Excelente!'
                  : '¡Buen trabajo! Probá de nuevo para llegar a cero errores.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.illInkSoft),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Salir',
                style: TextStyle(color: AppColors.illInkSoft)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.illInk,
              foregroundColor: AppColors.illPaper,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _reset();
            },
            child: const Text('Jugar de nuevo'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _flashTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = _allClaims.length;
    final done = total - _pending.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SectionHeader(
            category: 'CURIOSIDAD EN ACCIÓN',
            title: 'Arrastrar y Soltar',
            subtitle: 'Clasificadas: $done de $total',
            background: AppColors.bgGames,
            actions: [
              _mistakesChip(),
              IconButton(
                tooltip: 'Reiniciar',
                icon: const Icon(Icons.refresh, color: AppColors.illInk),
                onPressed: _reset,
              ),
            ],
            bottom: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: done / total,
                minHeight: 8,
                backgroundColor: AppColors.inkTrack,
                valueColor: const AlwaysStoppedAnimation(AppColors.illGreen),
              ),
            ),
          ),
          Expanded(flex: 5, child: _buildCardArea()),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildZone(
                      title: 'Lana',
                      icon: Icons.spa_outlined,
                      bg: AppColors.cardKnowledge,
                      accent: AppColors.illCardboard,
                      placed: _wool,
                      isWool: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildZone(
                      title: 'Acrílico',
                      icon: Icons.science_outlined,
                      bg: AppColors.dragAcrylicBg,
                      accent: AppColors.illBlue,
                      placed: _acrylic,
                      isWool: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Contador de errores (en el encabezado) ----------
  Widget _mistakesChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.illPaper,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.paperBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.close_rounded, size: 18, color: AppColors.illInk),
          const SizedBox(width: 4),
          Text(
            '$_mistakes',
            style: const TextStyle(
              color: AppColors.illInk,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Zona de la tarjeta actual ----------
  Widget _buildCardArea() {
    if (_pending.isEmpty) {
      return const Center(
        child: Icon(Icons.check_circle,
            size: 72, color: AppColors.correctBorder),
      );
    }

    final claim = _pending.first;
    final feedback = _flashWool != null
        ? (_flashOk ? '¡Correcto!' : 'Ahí no va, probá en la otra zona')
        : 'Arrastrá la tarjeta hacia la fibra correcta';
    final feedbackColor = _flashWool == null
        ? AppColors.illInkSoft
        : (_flashOk ? AppColors.correctBorder : AppColors.wrongBorder);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            feedback,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: feedbackColor,
            ),
          ),
          const SizedBox(height: 12),
          Draggable<_Claim>(
            data: claim,
            feedback: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: 260,
                child: _claimCard(claim.text, lifted: true),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: _claimCard(claim.text),
            ),
            child: _claimCard(claim.text),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.layers_outlined,
                  size: 16, color: AppColors.illInkSoft),
              const SizedBox(width: 6),
              Text(
                _pending.length > 1
                    ? 'Quedan ${_pending.length - 1} más'
                    : 'Es la última',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.illInkSoft,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _claimCard(String text, {bool lifted = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.illPaper,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.illInk, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.inkTrack,
            blurRadius: lifted ? 18 : 8,
            offset: Offset(0, lifted ? 10 : 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.drag_indicator, color: AppColors.illInkSoft),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppText.serif.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Zona de destino ----------
  Widget _buildZone({
    required String title,
    required IconData icon,
    required Color bg,
    required Color accent,
    required List<_Claim> placed,
    required bool isWool,
  }) {
    return DragTarget<_Claim>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (details) => _drop(details.data, isWool),
      builder: (context, candidate, rejected) {
        final hovering = candidate.isNotEmpty;
        final flashing = _flashWool == isWool;

        Color fill = bg;
        Color border = AppColors.illInk;
        if (flashing) {
          fill = _flashOk ? AppColors.correctBg : AppColors.wrongBg;
          border = _flashOk ? AppColors.correctBorder : AppColors.wrongBorder;
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: border,
              width: (hovering || flashing) ? 3.5 : 1.5,
            ),
            boxShadow: hovering
                ? [BoxShadow(color: accent, blurRadius: 14)]
                : null,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    flashing
                        ? (_flashOk ? Icons.check_circle : Icons.cancel)
                        : icon,
                    color: flashing ? border : AppColors.illInk,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: AppText.serif.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Expanded(
                child: placed.isEmpty
                    ? Center(
                        child: Text(
                          hovering ? '¡Soltá!' : 'Soltá acá',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.illInkSoft,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: placed.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 6),
                        itemBuilder: (_, i) => _placedChip(placed[i].text),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _placedChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.illPaper,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.illGreen, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(Icons.check_circle,
                size: 14, color: AppColors.correctBorder),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11,
                height: 1.25,
                color: AppColors.illInk,
              ),
            ),
          ),
        ],
      ),
    );
  }
}