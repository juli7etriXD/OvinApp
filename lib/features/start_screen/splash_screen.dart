import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';

import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Ciclo de caminata (se repite)
  late final AnimationController _walk = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3600),
  )..repeat();

  // Progreso de la barra (una sola vez)
  late final AnimationController _load = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3600),
  );

  late final Animation<double> _progress = CurvedAnimation(
    parent: _load,
    curve: Curves.easeInOut,
  );

  @override
  void initState() {
    super.initState();
    _load.forward().whenComplete(_goHome);
  }

  void _goHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, _, _) => const HomeScreen(),
        transitionsBuilder: (_, anim, _, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _walk.dispose();
    _load.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardKit,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Text(
                'OvinApp',
                style: AppText.serif.copyWith(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Descubrí las propiedades de la lana',
                style: TextStyle(fontSize: 14, color: AppColors.illInkSoft),
              ),
              const Spacer(),
              AspectRatio(
                aspectRatio: 1,
                child: AnimatedBuilder(
                  animation: _walk,
                  builder: (_, _) =>
                      CustomPaint(painter: _SheepPainter(_walk.value)),
                ),
              ),
              const Spacer(),
              AnimatedBuilder(
                animation: _progress,
                builder: (_, _) => _LoadingBar(value: _progress.value),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ====================== BARRA DE CARGA ======================
class _LoadingBar extends StatelessWidget {
  final double value;
  const _LoadingBar({required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.illPaper,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.illInk, width: 1.5),
          ),
          padding: const EdgeInsets.all(2),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: value.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.illGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Cargando… ${(value * 100).round()}%',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.illInkSoft,
          ),
        ),
      ],
    );
  }
}

// ====================== OVEJA ======================
// Se dibuja en un lienzo de 200 x 200 y se escala.
class _SheepPainter extends CustomPainter {
  final double t; // 0..1, un ciclo de caminata
  const _SheepPainter(this.t);

  Paint _fill(Color c) => Paint()..color = c;

  Paint _stroke(Color c, double w) => Paint()
    ..color = c
    ..style = PaintingStyle.stroke
    ..strokeWidth = w
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    final k = size.width / 200;
    canvas.scale(k);

    final phase = t * 2 * math.pi;

    // Suelo: rayitas que se desplazan hacia atrás
    _paintGround(canvas);

    // Sombra (se achica cuando la oveja sube)
    final bounce = math.sin(phase * 2).abs(); // 2 rebotes por ciclo
    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(100, 180),
        width: 110 - bounce * 10,
        height: 12,
      ),
      _fill(AppColors.inkTrack),
    );

    // Todo el cuerpo rebota
    canvas.save();
    canvas.translate(0, -bounce * 6);

    _paintLeg(canvas, 78, phase);
    _paintLeg(canvas, 122, phase + math.pi);

    _paintWool(canvas);
    _paintEar(canvas, left: true);
    _paintEar(canvas, left: false);
    _paintFace(canvas);

    canvas.restore();
  }

  void _paintGround(Canvas canvas) {
    final p = _stroke(AppColors.paperBorder, 3);
    final shift = (t * 40) % 40;
    for (double x = 240 - shift; x > -40; x -= 40) {
      canvas.drawLine(Offset(x, 186), Offset(x + 16, 186), p);
    }
  }

  void _paintLeg(Canvas canvas, double x, double phase) {
    final swing = math.sin(phase) * 9;
    final lift = math.max(0, math.cos(phase)) * 6;
    final top = Offset(x, 142);
    final foot = Offset(x + swing, (168 - lift).toDouble());

    canvas.drawLine(top, foot, _stroke(AppColors.sheepOutline, 15));
    canvas.drawLine(top, foot, _stroke(AppColors.sheepFace, 9));

    // Pezuña
    final hoof = RRect.fromRectAndRadius(
      Rect.fromCenter(center: foot.translate(0, 3), width: 15, height: 8),
      const Radius.circular(3),
    );
    canvas.drawRRect(hoof, _fill(AppColors.sheepHoof));
    canvas.drawRRect(hoof, _stroke(AppColors.sheepOutline, 2));
  }

  void _paintWool(Canvas canvas) {
    const center = Offset(100, 98);
    final circles = <MapEntry<Offset, double>>[const MapEntry(center, 56)];
    for (int i = 0; i < 12; i++) {
      final a = i * 2 * math.pi / 12;
      circles.add(
        MapEntry(center + Offset(math.cos(a) * 52, math.sin(a) * 50), 21),
      );
    }

    // 1) contornos gruesos  2) rellenos (tapan los trazos interiores)
    for (final c in circles) {
      canvas.drawCircle(c.key, c.value, _stroke(AppColors.sheepOutline, 7));
    }
    for (final c in circles) {
      canvas.drawCircle(c.key, c.value, _fill(AppColors.sheepWool));
    }
  }

  void _paintEar(Canvas canvas, {required bool left}) {
    final dir = left ? -1.0 : 1.0;
    canvas.save();
    canvas.translate(100 + dir * 44, 88);
    canvas.rotate(dir * 0.9); // caídas hacia afuera

    final outer = Rect.fromCenter(
      center: const Offset(0, 8),
      width: 22,
      height: 36,
    );
    final inner = Rect.fromCenter(
      center: const Offset(0, 10),
      width: 11,
      height: 22,
    );

    canvas.drawOval(outer, _fill(AppColors.sheepFace));
    canvas.drawOval(outer, _stroke(AppColors.sheepOutline, 3.5));
    canvas.drawOval(inner, _fill(AppColors.sheepEarInner));
    canvas.restore();
  }

  void _paintFace(Canvas canvas) {
    final face = Rect.fromCenter(
      center: const Offset(100, 100),
      width: 64,
      height: 58,
    );

    canvas.drawOval(face, _fill(AppColors.sheepFace));
    canvas.drawOval(face, _stroke(AppColors.sheepFaceBorder, 4));

    // Rizo en la frente
    final curl = Path()
      ..moveTo(95, 74)
      ..quadraticBezierTo(93, 62, 101, 63)
      ..quadraticBezierTo(107, 64, 105, 70);
    canvas.drawPath(curl, _stroke(AppColors.sheepFaceBorder, 3.5));

    // Mejillas difuminadas
    final blush = Paint()
      ..color = AppColors.sheepCheek.withValues(alpha: 0.85)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(const Offset(80, 109), 8, blush);
    canvas.drawCircle(const Offset(120, 109), 8, blush);

    // Ojos (parpadeo corto una vez por ciclo)
    final blink = t > 0.92;
    final eye = _fill(AppColors.sheepOutline);
    for (final x in [88.0, 112.0]) {
      if (blink) {
        canvas.drawLine(
          Offset(x - 4, 97),
          Offset(x + 4, 97),
          _stroke(AppColors.sheepOutline, 2.5),
        );
      } else {
        canvas.drawCircle(Offset(x, 97), 4.6, eye);
      }
    }

    // Nariz triangular rosada
    final nose = Path()
      ..moveTo(95.5, 103)
      ..lineTo(104.5, 103)
      ..lineTo(100, 109)
      ..close();
    canvas.drawPath(nose, _fill(AppColors.sheepCheek));

    // Boca en "w"
    final mouth = Path()
      ..moveTo(92, 111)
      ..quadraticBezierTo(96, 119, 100, 111)
      ..quadraticBezierTo(104, 119, 108, 111);
    canvas.drawPath(mouth, _stroke(AppColors.sheepOutline, 2.6));
  }

  @override
  bool shouldRepaint(covariant _SheepPainter old) => old.t != t;
}
