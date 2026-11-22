import 'package:ovinapp/core/theme/theme.dart';

import '../models/menu_item.dart';
import '../painters/home_painters.dart';

import '../../kit/kit_screen.dart';
import '../../games/games_screen.dart';
import '../../knowledge/knowledge_screen.dart';
import '../../future_projects/future_projects_screen.dart';

/// Lista de secciones principales para la pantalla de inicio.
List<MenuItem> getHomeMenuItems() => [
  MenuItem(
    category: 'MANOS A LA LANA',
    number: '01',
    title: 'Armá tu Ovikit',
    description: 'Un pequeño laboratorio, grandes descubrimientos. Empezá con lo que tenés en casa.',
    action: 'Preparar mi kit',
    background: AppColors.cardKit,
    illustration: const KitPainter(),
    screen: () => const KitScreen(),
  ),
  MenuItem(
    category: 'CURIOSIDAD EN ACCIÓN',
    number: '02',
    title: 'Aprendé jugando',
    description: 'Poné a prueba lo que sabés con trivias, desafíos y nuestro microscopio virtual.',
    action: 'Vamos a jugar',
    background: AppColors.cardGames,
    illustration: const GamesPainter(),
    screen: () => const JuegosScreen(),
  ),
  MenuItem(
    category: 'UN MUNDO DE FIBRAS',
    number: '03',
    title: 'Explorá la lana',
    description: 'Mucho más que una fibra. Conocé sus propiedades y su conexión con el planeta.',
    action: 'Quiero descubrir',
    background: AppColors.cardKnowledge,
    illustration: const BookPainter(),
    screen: () => const KnowledgeScreen(),
  ),
  MenuItem(
    category: 'SIGAMOS CRECIENDO',
    number: '04',
    title: 'Lo que viene',
    description: 'Las buenas ideas crecen en comunidad. Descubrí nuestros próximos pasos.',
    action: 'Mirar al futuro',
    background: AppColors.cardFuture,
    illustration: const PencilPainter(),
    screen: () => const FutureProjectsScreen(),
  ),
];
