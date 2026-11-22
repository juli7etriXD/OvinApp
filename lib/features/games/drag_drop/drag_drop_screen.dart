import 'dart:async';

import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';
import 'package:ovinapp/core/widgets/widget.dart';

import 'data/claims_data.dart';
import 'models/claim.dart';
import 'widgets/claim_card.dart';
import 'widgets/drop_zone.dart';
import 'widgets/mistakes_chip.dart';
import 'widgets/result_dialog.dart';

class DragDropScreen extends StatefulWidget {
  const DragDropScreen({super.key});

  @override
  State<DragDropScreen> createState() => _DragDropScreenState();
}

class _DragDropScreenState extends State<DragDropScreen> {
  late List<Claim> _pending;
  final List<Claim> _wool = [];
  final List<Claim> _acrylic = [];
  int _mistakes = 0;

  // Retroalimentación visual temporal sobre una zona
  bool? _flashWool;
  bool _flashOk = false;
  Timer? _flashTimer;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  @override
  void dispose() {
    _flashTimer?.cancel();
    super.dispose();
  }

  // ---------- Lógica del juego ----------

  void _initGame() {
    _pending = List<Claim>.from(allClaims)..shuffle();
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

  void _drop(Claim claim, bool droppedOnWool) {
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ResultDialog(
        mistakes: _mistakes,
        onPlayAgain: () {
          Navigator.pop(ctx);
          _reset();
        },
        onExit: () {
          Navigator.pop(ctx);
          Navigator.pop(context);
        },
      ),
    );
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    final total = allClaims.length;
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
              MistakesChip(mistakes: _mistakes),
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
                    child: DropZone(
                      title: 'Lana',
                      icon: Icons.spa_outlined,
                      background: AppColors.cardKnowledge,
                      accent: AppColors.illCardboard,
                      placed: _wool,
                      isWool: true,
                      flashWool: _flashWool,
                      flashOk: _flashOk,
                      onDrop: (claim) => _drop(claim, true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropZone(
                      title: 'Acrílico',
                      icon: Icons.science_outlined,
                      background: AppColors.dragAcrylicBg,
                      accent: AppColors.illBlue,
                      placed: _acrylic,
                      isWool: false,
                      flashWool: _flashWool,
                      flashOk: _flashOk,
                      onDrop: (claim) => _drop(claim, false),
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

  Widget _buildCardArea() {
    if (_pending.isEmpty) {
      return const Center(
        child: Icon(
          Icons.check_circle,
          size: 72,
          color: AppColors.correctBorder,
        ),
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
          Draggable<Claim>(
            data: claim,
            feedback: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: 260,
                child: ClaimCard(text: claim.text, lifted: true),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: ClaimCard(text: claim.text),
            ),
            child: ClaimCard(text: claim.text),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.layers_outlined,
                size: 16,
                color: AppColors.illInkSoft,
              ),
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
}

