import 'dart:async';

import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';
import 'package:ovinapp/core/widgets/widget.dart';

import 'data/trivia_data.dart';
import 'models/question.dart';
import 'widgets/explanation_card.dart';
import 'widgets/option_tile.dart';
import 'widgets/question_card.dart';
import 'widgets/timer_badge.dart';
import 'widgets/trivia_result_dialog.dart';
import 'widgets/trivia_score_chip.dart';

class TriviaScreen extends StatefulWidget {
  const TriviaScreen({super.key});

  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
  static const int _secondsPerQuestion = 15;
  static const int _questionsPerGame = 10;

  late List<Question> _quiz;

  int _currentIndex = 0;
  int? _selectedOption;
  bool _showExplanation = false;
  int _score = 0;
  int _secondsLeft = _secondsPerQuestion;
  Timer? _timer;

  bool get _timeUp => _showExplanation && _selectedOption == null;

  List<Question> _newQuiz() =>
      (List<Question>.of(triviaQuestions)..shuffle())
          .take(_questionsPerGame)
          .toList();

  @override
  void initState() {
    super.initState();
    _quiz = _newQuiz();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ---------- Lógica del Temporizador y Flujo ----------

  void _startTimer() {
    _secondsLeft = _secondsPerQuestion;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft > 1) {
        setState(() => _secondsLeft--);
      } else {
        t.cancel();
        setState(() {
          _secondsLeft = 0;
          _showExplanation = true;
        });
      }
    });
  }

  void _selectOption(int? value) {
    if (value == null || _showExplanation) return;
    _timer?.cancel();
    setState(() {
      _selectedOption = value;
      _showExplanation = true;
      if (value == _quiz[_currentIndex].correctIndex) _score++;
    });
  }

  void _nextQuestion() {
    if (_currentIndex + 1 < _quiz.length) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _showExplanation = false;
      });
      _startTimer();
    } else {
      _showResult();
    }
  }

  void _restart() {
    setState(() {
      _quiz = _newQuiz();
      _currentIndex = 0;
      _selectedOption = null;
      _showExplanation = false;
      _score = 0;
    });
    _startTimer();
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => TriviaResultDialog(
        score: _score,
        total: _quiz.length,
        onRetry: () {
          Navigator.pop(ctx);
          _restart();
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
    final q = _quiz[_currentIndex];
    final total = _quiz.length;
    final danger = _secondsLeft <= 5 && !_showExplanation;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SectionHeader(
            category: 'CURIOSIDAD EN ACCIÓN',
            title: 'Trivia',
            subtitle: 'Pregunta ${_currentIndex + 1} de $total',
            background: AppColors.bgGames,
            actions: [
              TriviaScoreChip(score: _score),
              const SizedBox(width: 8),
              TimerBadge(
                secondsLeft: _secondsLeft,
                totalSeconds: _secondsPerQuestion,
                danger: danger,
              ),
            ],
            bottom: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (_currentIndex + 1) / total,
                minHeight: 8,
                backgroundColor: AppColors.inkTrack,
                valueColor: const AlwaysStoppedAnimation(AppColors.illGreen),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  QuestionCard(text: q.text),
                  const SizedBox(height: 16),
                  for (int i = 0; i < q.options.length; i++) ...[
                    OptionTile(
                      index: i,
                      text: q.options[i],
                      isSelected: _selectedOption == i,
                      isCorrect: q.correctIndex == i,
                      revealed: _showExplanation,
                      onTap: () => _selectOption(i),
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (_showExplanation) ...[
                    const SizedBox(height: 6),
                    ExplanationCard(
                      explanation: q.explanation,
                      timeUp: _timeUp,
                    ),
                  ],
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    final isLast = _currentIndex + 1 == _quiz.length;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.illInk,
              foregroundColor: AppColors.illPaper,
              disabledBackgroundColor: AppColors.inkTrack,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: _showExplanation ? _nextQuestion : null,
            icon: Icon(isLast ? Icons.flag : Icons.arrow_forward),
            label: Text(
              isLast ? 'Finalizar' : 'Siguiente',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

