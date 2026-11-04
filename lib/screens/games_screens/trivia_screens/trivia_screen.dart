import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../theme/colors.dart';
import '../../../../theme/text_styles.dart';
import '../../../../widgets/section_header.dart';

// ----- Modelo de pregunta -----
class _Question {
  final String text;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const _Question({
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

// ----- Lista de preguntas -----
const List<_Question> _questions = [
  // Verdadero / Falso
  _Question(
    text: '¿La lana de oveja se derrite y gotea plástico caliente cuando entra en contacto con la llama, al igual que las fibras acrílicas?',
    options: ['Verdadero', 'Falso'],
    correctIndex: 1,
    explanation: 'A diferencia de las fibras sintéticas como el acrílico, la lana no se funde ni gotea al quemarse, sino que se carboniza formando una ceniza suave.',
  ),
  _Question(
    text: '¿Es verdad que la lana es una fibra higroscópica capaz de absorber hasta un 33% de su peso en vapor de agua sin sentirse húmeda al tacto?',
    options: ['Verdadero', 'Falso'],
    correctIndex: 0,
    explanation: 'La lana es altamente higroscópica y puede absorber hasta un 33% de su propio peso seco en vapor de agua del ambiente sin sentirse húmeda al tacto.',
  ),
  _Question(
    text: '¿Las fibras sintéticas de acrílico poseen escamas biológicas en su superficie que se traban entre sí provocando el afieltrado del tejido?',
    options: ['Verdadero', 'Falso'],
    correctIndex: 1,
    explanation: 'La fibra acrílica carece de escamas biológicas, por lo que no puede afieltrarse ni apelmazarse al frotarse.',
  ),
  _Question(
    text: '¿La lana es un material biodegradable que se descompone en el suelo en cuestión de semanas o meses por la acción de microorganismos?',
    options: ['Verdadero', 'Falso'],
    correctIndex: 0,
    explanation: 'Al ser una proteína natural, los microorganismos del suelo secretan enzimas que descomponen la lana en pocas semanas o meses, liberando nutrientes a la tierra.',
  ),
  _Question(
    text: '¿Una hebra de lana en seco puede estirarse hasta un 30% de su longitud y retornar a su tamaño original sin romperse?',
    options: ['Verdadero', 'Falso'],
    correctIndex: 0,
    explanation: 'Gracias a su estructura proteica en hélice, la lana puede estirarse hasta un 30% en estado seco y un 50% en estado húmedo, regresando a su forma original sin romperse.',
  ),

  // Opción múltiple
  _Question(
    text: '¿Qué fina capa de grasa microscópica unida covalentemente a la superficie de la lana le otorga su propiedad repelente al agua superficial?',
    options: [
      'Lanolina libre de grasa sebácea',
      'Enzima queratinasa purificada',
      'Proteína cistina aislada',
      'Ácido 18-metileicosanoico (18-MEA)',
    ],
    correctIndex: 3,
    explanation: 'En la superficie exterior de la lana existe una capa lipídica microscópica compuesta por ácido 18-metileicosanoico (18-MEA) que actúa como repelente natural del agua.',
  ),
  _Question(
    text: '¿Por qué la lana de oveja posee un Índice Límite de Oxígeno (LOI) tan alto (∼25.2%), lo que la convierte en una fibra autoextinguible?',
    options: [
      'Porque se enciende a una temperatura extremadamente baja de 100 °C',
      'Porque se fabrica mediante la extrusión de polímeros petroquímicos resistentes al calor',
      'Por su alto contenido de nitrógeno (∼15-16%) y la retención de humedad y azufre en su estructura proteica',
      'Porque está compuesta por cadenas vegetales ricas en celulosa sin tratar',
    ],
    correctIndex: 2,
    explanation: 'Su resistencia nativa al fuego se debe a su alto contenido de nitrógeno, actuando como retardante, y a la retención de humedad y azufre en su estructura de queratina.',
  ),
  _Question(
    text: '¿Cómo se llama el proceso en el que las escamas de la cutícula de la lana se abren y se traban de forma irreversible al aplicar fricción, humedad y jabón?',
    options: ['Polimerización', 'Texturizado', 'Extrusión', 'Afieltrado'],
    correctIndex: 3,
    explanation: 'Mediante la fricción, humedad, calor y jabón, las escamas de la cutícula se abren y se traban irreversiblemente, provocando el afieltrado.',
  ),
  _Question(
    text: '¿Por qué las bolitas (pills) que se forman en las prendas de lana tienden a desprenderse solas a diferencia de las formadas en telas acrílicas?',
    options: [
      'Porque la lana tiene una tenacidad a la tracción moderada, por lo que los hilos que sostienen la bolita se rompen fácil',
      'Porque la lana se funde formando ceniza que destruye las bolitas',
      'Porque las fibras acrílicas se disuelven completamente al frotarse con la piel',
      'Porque el acrílico no libera extremos de fibra durante la abrasión',
    ],
    correctIndex: 0,
    explanation: 'La lana presenta una tenacidad moderada, provocando que las bolitas se desprendan solas; en contraste, las fibras acrílicas tienen alta tenacidad y las bolitas quedan firmemente sujetas.',
  ),
  _Question(
    text: '¿Qué estructura molecular interna en el córtex funciona como un muelle o resorte elástico permitiendo a la lana recuperarse tras arrugarse?',
    options: [
      'La capa lipídica de ácido 18-metileicosanoico',
      'Los filamentos sintéticos extruidos de forma lineal',
      'Las proteínas en hélice Alfa (α-hélix) unidas por enlaces disulfuro',
      'El canal medular hueco lleno de aire estático',
    ],
    correctIndex: 2,
    explanation: 'Las proteínas en hélice Alfa funcionan como resortes elásticos moleculares que, junto a los enlaces disulfuro, permiten a la fibra volver a su posición original tras la tracción.',
  ),
];
class TriviaScreen extends StatefulWidget {
  const TriviaScreen({super.key});

  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
  static const int _secondsPerQuestion = 15;
  static const int _questionsPerGame = 10;

  late List<_Question> _quiz;

  int _currentIndex = 0;
  int? _selectedOption;
  bool _showExplanation = false;
  int _score = 0;
  int _secondsLeft = _secondsPerQuestion;
  Timer? _timer;

  bool get _timeUp => _showExplanation && _selectedOption == null;

  List<_Question> _newQuiz() =>
      (List<_Question>.of(_questions)..shuffle()).take(_questionsPerGame).toList();

  @override
  void initState() {
    super.initState();
    _quiz = _newQuiz();
    _startTimer();
  }

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
    final total = _quiz.length;
    final ratio = _score / total;
    final String message;
    final IconData icon;
    if (ratio >= 0.8) {
      message = '¡Excelente! Sabés mucho sobre la lana.';
      icon = Icons.emoji_events;
    } else if (ratio >= 0.5) {
      message = '¡Muy bien! Un repaso más y lo dominás.';
      icon = Icons.thumb_up_alt_outlined;
    } else {
      message = 'Seguí explorando la app y volvé a intentarlo.';
      icon = Icons.menu_book_outlined;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.illPaper,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Column(
          children: [
            Icon(icon, size: 56, color: AppColors.illInk),
            const SizedBox(height: 8),
            Text(
              '¡Trivia terminada!',
              textAlign: TextAlign.center,
              style: AppText.serif.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$_score / $total',
              style: AppText.serif.copyWith(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
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
              _restart();
            },
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
              _scoreChip(),
              const SizedBox(width: 8),
              _timerBadge(danger),
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
                  _buildQuestionCard(q),
                  const SizedBox(height: 16),
                  for (int i = 0; i < q.options.length; i++) ...[
                    _buildOption(q, i),
                    const SizedBox(height: 10),
                  ],
                  if (_showExplanation) ...[
                    const SizedBox(height: 6),
                    _buildExplanation(q),
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

  // ---------- Puntaje y temporizador (van en el encabezado) ----------
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
            '$_score',
            style: const TextStyle(
              color: AppColors.illInk,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _timerBadge(bool danger) {
    final color = danger ? AppColors.wrongBorder : AppColors.illInk;
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(
              value: _secondsLeft / _secondsPerQuestion,
              strokeWidth: 5,
              backgroundColor: AppColors.inkTrack,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          Text(
            '$_secondsLeft',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Tarjeta con la pregunta ----------
  Widget _buildQuestionCard(_Question q) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.illPaper,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.paperBorder),
      ),
      child: Text(
        q.text,
        style: AppText.serif.copyWith(
          fontSize: 19,
          fontWeight: FontWeight.w600,
          height: 1.35,
        ),
      ),
    );
  }

  // ---------- Opción de respuesta ----------
  Widget _buildOption(_Question q, int i) {
    final isSelected = _selectedOption == i;
    final isCorrect = q.correctIndex == i;
    final revealed = _showExplanation;

    Color bg = AppColors.illPaper;
    Color border = AppColors.paperBorder;
    Color badge = AppColors.bgGames;
    IconData? trailing;

    if (revealed && isCorrect) {
      bg = AppColors.correctBg;
      border = AppColors.correctBorder;
      badge = AppColors.illGreen;
      trailing = Icons.check_circle;
    } else if (revealed && isSelected) {
      bg = AppColors.wrongBg;
      border = AppColors.wrongBorder;
      badge = AppColors.illRose;
      trailing = Icons.cancel;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: revealed ? null : () => _selectOption(i),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border, width: revealed ? 2 : 1),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: badge,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.illInk, width: 1.5),
                ),
                child: Text(
                  String.fromCharCode(65 + i), // A, B, C, D
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.illInk,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  q.options[i],
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.3,
                    color: AppColors.illInk,
                  ),
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                Icon(trailing, color: border),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Explicación ----------
  Widget _buildExplanation(_Question q) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.hintBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.illYellow, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline, color: AppColors.illInk),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_timeUp)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text(
                      '¡Se acabó el tiempo!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.warningText,
                      ),
                    ),
                  ),
                Text(
                  q.explanation,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: AppColors.illInk,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Botón inferior ----------
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