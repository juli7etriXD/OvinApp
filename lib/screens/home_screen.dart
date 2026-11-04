import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/text_styles.dart';
import 'kit_screens/kit_screen.dart';
import 'games_screens/games_screen.dart';
import 'knowledge_screens/mas_info_screen.dart';
import 'knowledge_screens/knowledge_screen.dart';
import 'future_projects_screens/future_projects_screen.dart';

class _MenuItem {
  final String category;
  final String number;
  final String title;
  final String description;
  final String action;
  final Color background;
  final CustomPainter illustration;
  final Widget Function() screen;

  const _MenuItem({
    required this.category,
    required this.number,
    required this.title,
    required this.description,
    required this.action,
    required this.background,
    required this.illustration,
    required this.screen,
  });
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<_MenuItem> get _items => [
        _MenuItem(
          category: 'MANOS A LA LANA',
          number: '01',
          title: 'Armá tu Ovikit',
          description:
              'Un pequeño laboratorio, grandes descubrimientos. Empezá con lo que tenés en casa.',
          action: 'Preparar mi kit',
          background: AppColors.cardKit,
          illustration: _KitPainter(),
          screen: () => const KitScreen(),
        ),
        _MenuItem(
          category: 'CURIOSIDAD EN ACCIÓN',
          number: '02',
          title: 'Aprendé jugando',
          description:
              'Poné a prueba lo que sabés con trivias, desafíos y nuestro microscopio virtual.',
          action: 'Vamos a jugar',
          background: AppColors.cardGames,
          illustration: _GamesPainter(),
          screen: () => const JuegosScreen(),
        ),
        _MenuItem(
          category: 'UN MUNDO DE FIBRAS',
          number: '03',
          title: 'Explorá la lana',
          description:
              'Mucho más que una fibra. Conocé sus propiedades y su conexión con el planeta.',
          action: 'Quiero descubrir',
          background: AppColors.cardKnowledge,
          illustration: _BookPainter(),
          screen: () => const KnowledgeScreen(),
        ),
        _MenuItem(
          category: 'SIGAMOS CRECIENDO',
          number: '04',
          title: 'Lo que viene',
          description:
              'Las buenas ideas crecen en comunidad. Descubrí nuestros próximos pasos.',
          action: 'Mirar al futuro',
          background: AppColors.cardFuture,
          illustration: _PencilPainter(),
          screen: () => const FutureProjectsScreen(),
        ),
        _MenuItem(
          category: 'información de nosotros uwu',
          number: '05',
          title: 'Más información',
          description: 'Encuentranos en redes!',
          action: 'Quiero buscarlos en redes',
          background: AppColors.cardKnowledge,
          illustration: _KitPainter(),
          screen: () => const MasInfoScreen(),
        )
      ];

  void _go(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            // ---------- Encabezado ----------
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'OvinApp',
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Más información',
                  icon: const Icon(Icons.info_outline,
                      color: AppColors.illInkSoft),
                  onPressed: () => _go(context, const MasInfoScreen()),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Elegí tu\npróxima aventura',
              style: AppText.serif.copyWith(
                fontSize: 36,
                height: 1.1,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // ---------- Tarjetas ----------
            for (final item in items) ...[
              _MenuCard(
                item: item,
                onTap: () => _go(context, item.screen()),
              ),
              const SizedBox(height: 18),
            ],
          ],
        ),
      ),
    );
  }
}

// ====================== TARJETA ======================
class _MenuCard extends StatelessWidget {
  final _MenuItem item;
  final VoidCallback onTap;
  const _MenuCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.background,
      borderRadius: BorderRadius.circular(28),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Categoría + número
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.category,
                      style: const TextStyle(
                        fontSize: 11,
                        letterSpacing: 1.8,
                        fontWeight: FontWeight.w700,
                        color: AppColors.illInkSoft,
                      ),
                    ),
                  ),
                  Text(
                    item.number,
                    style: AppText.serif.copyWith(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: AppColors.illInkSoft,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Ilustración
              SizedBox(
                height: 130,
                width: double.infinity,
                child: CustomPaint(painter: item.illustration),
              ),
              const SizedBox(height: 12),

              // Título y descripción
              Text(
                item.title,
                style: AppText.serif.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: AppColors.illInkSoft,
                ),
              ),
              const SizedBox(height: 16),

              // Acción
              Row(
                children: [
                  Text(
                    item.action,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.illInk,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.illInk,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward,
                      size: 20, color: AppColors.illInk),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ====================== ILUSTRACIONES ======================
// Todas se dibujan en un lienzo imaginario de 200 x 120 y se escalan.

Paint _line([double width = 2]) => Paint()
  ..color = AppColors.illInk
  ..style = PaintingStyle.stroke
  ..strokeWidth = width
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round;

Paint _fill(Color c) => Paint()..color = c;

void _shape(Canvas c, Path p, Color fill) {
  c.drawPath(p, _fill(fill));
  c.drawPath(p, _line());
}

void _rrect(Canvas c, Rect r, double radius, Color fill) {
  final rr = RRect.fromRectAndRadius(r, Radius.circular(radius));
  c.drawRRect(rr, _fill(fill));
  c.drawRRect(rr, _line());
}

void _circle(Canvas c, Offset o, double r, Color fill) {
  c.drawCircle(o, r, _fill(fill));
  c.drawCircle(o, r, _line());
}

void _spark(Canvas c, Offset o, double r) {
  final p = _line(1.8);
  c.drawLine(o.translate(0, -r), o.translate(0, r), p);
  c.drawLine(o.translate(-r, 0), o.translate(r, 0), p);
}

void _fit(Canvas canvas, Size size) {
  final k = math.min(size.width / 200, size.height / 120);
  canvas.translate((size.width - 200 * k) / 2, (size.height - 120 * k) / 2);
  canvas.scale(k);
}

// ----- 01: caja con frasco, lista y ovillo -----
class _KitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _fit(canvas, size);

    // Solapas abiertas
    _shape(
      canvas,
      Path()
        ..moveTo(55, 62)
        ..lineTo(38, 42)
        ..lineTo(72, 42)
        ..lineTo(78, 62)
        ..close(),
      AppColors.illCardboard,
    );
    _shape(
      canvas,
      Path()
        ..moveTo(145, 62)
        ..lineTo(162, 42)
        ..lineTo(128, 42)
        ..lineTo(122, 62)
        ..close(),
      AppColors.illCardboard,
    );

    // Frasco
    _rrect(canvas, const Rect.fromLTWH(84, 12, 8, 14), 2, AppColors.illRose);
    _rrect(canvas, const Rect.fromLTWH(78, 26, 20, 38), 5, AppColors.illBlue);
    canvas.drawLine(const Offset(78, 40), const Offset(98, 40), _line(1.5));

    // Lista de papel
    _rrect(canvas, const Rect.fromLTWH(102, 18, 26, 46), 3, AppColors.illPaper);
    for (final y in [28.0, 36.0, 44.0, 52.0]) {
      canvas.drawLine(Offset(107, y), Offset(123, y), _line(1.3));
    }

    // Ovillo de lana
    _circle(canvas, const Offset(147, 44), 15, AppColors.illRose);
    final yarn = _line(1.4);
    canvas.drawPath(
      Path()
        ..moveTo(135, 38)
        ..quadraticBezierTo(147, 32, 159, 40)
        ..moveTo(133, 46)
        ..quadraticBezierTo(147, 40, 161, 48)
        ..moveTo(137, 54)
        ..quadraticBezierTo(148, 48, 158, 54),
      yarn,
    );

    // Frente de la caja
    _rrect(canvas, const Rect.fromLTWH(50, 62, 100, 46), 4,
        AppColors.illCardboard);
    canvas.drawLine(const Offset(88, 80), const Offset(112, 80), _line());
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ----- 02: joystick + microscopio + destellos -----
class _GamesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _fit(canvas, size);

    // Joystick
    canvas.drawLine(const Offset(66, 78), const Offset(66, 50), _line(4));
    _circle(canvas, const Offset(66, 42), 10, AppColors.illRose);
    _rrect(canvas, const Rect.fromLTWH(28, 78, 76, 26), 9, AppColors.illGreen);
    _circle(canvas, const Offset(46, 91), 4, AppColors.illYellow);
    _circle(canvas, const Offset(88, 91), 4, AppColors.illYellow);

    // Microscopio: base, brazo y tubo
    _rrect(canvas, const Rect.fromLTWH(116, 100, 56, 8), 3,
        AppColors.illCardboard);
    canvas.drawPath(
      Path()
        ..moveTo(160, 100)
        ..quadraticBezierTo(184, 76, 154, 50),
      _line(4),
    );
    canvas.drawLine(const Offset(124, 88), const Offset(152, 88), _line());

    canvas.save();
    canvas.translate(138, 54);
    canvas.rotate(-0.45);
    _rrect(canvas, const Rect.fromLTWH(-5, -44, 10, 8), 2, AppColors.illRose);
    _rrect(canvas, const Rect.fromLTWH(-8, -36, 16, 44), 3, AppColors.illBlue);
    canvas.restore();

    // Destellos
    _spark(canvas, const Offset(104, 22), 6);
    _spark(canvas, const Offset(178, 24), 5);
    _spark(canvas, const Offset(112, 62), 4);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ----- 03: libro abierto con una hoja que brota -----
class _BookPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _fit(canvas, size);

    // Páginas
    _shape(
      canvas,
      Path()
        ..moveTo(100, 104)
        ..quadraticBezierTo(70, 94, 28, 100)
        ..lineTo(28, 54)
        ..quadraticBezierTo(70, 46, 100, 58)
        ..close(),
      AppColors.illPaper,
    );
    _shape(
      canvas,
      Path()
        ..moveTo(100, 104)
        ..quadraticBezierTo(130, 94, 172, 100)
        ..lineTo(172, 54)
        ..quadraticBezierTo(130, 46, 100, 58)
        ..close(),
      AppColors.illPaper,
    );

    // Renglones
    final t = _line(1.3);
    for (final y in [66.0, 74.0, 82.0]) {
      canvas.drawLine(Offset(40, y), Offset(84, y + 3), t);
      canvas.drawLine(Offset(116, y + 3), Offset(160, y), t);
    }

    // Tallo y hojas
    canvas.drawPath(
      Path()
        ..moveTo(100, 58)
        ..quadraticBezierTo(97, 40, 100, 22),
      _line(2.5),
    );
    _shape(
      canvas,
      Path()
        ..moveTo(100, 36)
        ..quadraticBezierTo(106, 8, 138, 12)
        ..quadraticBezierTo(134, 40, 100, 36)
        ..close(),
      AppColors.illGreen,
    );
    _shape(
      canvas,
      Path()
        ..moveTo(99, 46)
        ..quadraticBezierTo(88, 28, 66, 32)
        ..quadraticBezierTo(74, 50, 99, 46)
        ..close(),
      AppColors.illGreen,
    );
    canvas.drawLine(const Offset(104, 33), const Offset(130, 17), _line(1.2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ----- 04: lápiz hacia abajo del que crece un brote -----
class _PencilPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _fit(canvas, size);

    // Suelo
    canvas.drawLine(const Offset(50, 104), const Offset(150, 104), _line());

    // Brote
    canvas.drawPath(
      Path()
        ..moveTo(100, 104)
        ..quadraticBezierTo(98, 90, 100, 78),
      _line(2.5),
    );
    _shape(
      canvas,
      Path()
        ..moveTo(100, 90)
        ..quadraticBezierTo(84, 70, 66, 76)
        ..quadraticBezierTo(76, 94, 100, 90)
        ..close(),
      AppColors.illGreen,
    );
    _shape(
      canvas,
      Path()
        ..moveTo(100, 84)
        ..quadraticBezierTo(116, 62, 136, 68)
        ..quadraticBezierTo(126, 90, 100, 84)
        ..close(),
      AppColors.illGreen,
    );

    // Lápiz (punta hacia abajo)
    _rrect(canvas, const Rect.fromLTWH(90, 2, 20, 8), 2, AppColors.illRose);
    _shape(
      canvas,
      Path()
        ..moveTo(90, 10)
        ..lineTo(110, 10)
        ..lineTo(110, 42)
        ..lineTo(90, 42)
        ..close(),
      AppColors.illYellow,
    );
    _shape(
      canvas,
      Path()
        ..moveTo(90, 42)
        ..lineTo(110, 42)
        ..lineTo(100, 64)
        ..close(),
      AppColors.illCardboard,
    );
    canvas.drawPath(
      Path()
        ..moveTo(96, 56)
        ..lineTo(104, 56)
        ..lineTo(100, 64)
        ..close(),
      _fill(AppColors.illInk),
    );

    // Destellos
    _spark(canvas, const Offset(60, 30), 5);
    _spark(canvas, const Offset(146, 40), 6);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}