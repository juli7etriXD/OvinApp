import '../models/question.dart';

/// Banco de preguntas sobre la lana y las fibras sintéticas.
const List<Question> triviaQuestions = [
  // Verdadero / Falso
  Question(
    text:
        '¿La lana de oveja se derrite y gotea plástico caliente cuando entra en contacto con la llama, al igual que las fibras acrílicas?',
    options: ['Verdadero', 'Falso'],
    correctIndex: 1,
    explanation:
        'A diferencia de las fibras sintéticas como el acrílico, la lana no se funde ni gotea al quemarse, sino que se carboniza formando una ceniza suave.',
  ),
  Question(
    text:
        '¿Es verdad que la lana es una fibra higroscópica capaz de absorber hasta un 33% de su peso en vapor de agua sin sentirse húmeda al tacto?',
    options: ['Verdadero', 'Falso'],
    correctIndex: 0,
    explanation:
        'La lana es altamente higroscópica y puede absorber hasta un 33% de su propio peso seco en vapor de agua del ambiente sin sentirse húmeda al tacto.',
  ),
  Question(
    text:
        '¿Las fibras sintéticas de acrílico poseen escamas biológicas en su superficie que se traban entre sí provocando el afieltrado del tejido?',
    options: ['Verdadero', 'Falso'],
    correctIndex: 1,
    explanation:
        'La fibra acrílica carece de escamas biológicas, por lo que no puede afieltrarse ni apelmazarse al frotarse.',
  ),
  Question(
    text:
        '¿La lana es un material biodegradable que se descompone en el suelo en cuestión de semanas o meses por la acción de microorganismos?',
    options: ['Verdadero', 'Falso'],
    correctIndex: 0,
    explanation:
        'Al ser una proteína natural, los microorganismos del suelo secretan enzimas que descomponen la lana en pocas semanas o meses, liberando nutrientes a la tierra.',
  ),
  Question(
    text:
        '¿Una hebra de lana en seco puede estirarse hasta un 30% de su longitud y retornar a su tamaño original sin romperse?',
    options: ['Verdadero', 'Falso'],
    correctIndex: 0,
    explanation:
        'Gracias a su estructura proteica en hélice, la lana puede estirarse hasta un 30% en estado seco y un 50% en estado húmedo, regresando a su forma original sin romperse.',
  ),

  // Opción múltiple
  Question(
    text:
        '¿Qué fina capa de grasa microscópica unida covalentemente a la superficie de la lana le otorga su propiedad repelente al agua superficial?',
    options: [
      'Lanolina libre de grasa sebácea',
      'Enzima queratinasa purificada',
      'Proteína cistina aislada',
      'Ácido 18-metileicosanoico (18-MEA)',
    ],
    correctIndex: 3,
    explanation:
        'En la superficie exterior de la lana existe una capa lipídica microscópica compuesta por ácido 18-metileicosanoico (18-MEA) que actúa como repelente natural del agua.',
  ),
  Question(
    text:
        '¿Por qué la lana de oveja posee un Índice Límite de Oxígeno (LOI) tan alto (∼25.2%), lo que la convierte en una fibra autoextinguible?',
    options: [
      'Porque se enciende a una temperatura extremadamente baja de 100 °C',
      'Porque se fabrica mediante la extrusión de polímeros petroquímicos resistentes al calor',
      'Por su alto contenido de nitrógeno (∼15-16%) y la retención de humedad y azufre en su estructura proteica',
      'Porque está compuesta por cadenas vegetales ricas en celulosa sin tratar',
    ],
    correctIndex: 2,
    explanation:
        'Su resistencia nativa al fuego se debe a su alto contenido de nitrógeno, actuando como retardante, y a la retención de humedad y azufre en su estructura de queratina.',
  ),
  Question(
    text:
        '¿Cómo se llama el proceso en el que las escamas de la cutícula de la lana se abren y se traban de forma irreversible al aplicar fricción, humedad y jabón?',
    options: ['Polimerización', 'Texturizado', 'Extrusión', 'Afieltrado'],
    correctIndex: 3,
    explanation:
        'Mediante la fricción, humedad, calor y jabón, las escamas de la cutícula se abren y se traban irreversiblemente, provocando el afieltrado.',
  ),
  Question(
    text:
        '¿Por qué las bolitas (pills) que se forman en las prendas de lana tienden a desprenderse solas a diferencia de las formadas en telas acrílicas?',
    options: [
      'Porque la lana tiene una tenacidad a la tracción moderada, por lo que los hilos que sostienen la bolita se rompen fácil',
      'Porque la lana se funde formando ceniza que destruye las bolitas',
      'Porque las fibras acrílicas se disuelven completamente al frotarse con la piel',
      'Porque el acrílico no libera extremos de fibra durante la abrasión',
    ],
    correctIndex: 0,
    explanation:
        'La lana presenta una tenacidad moderada, provocando que las bolitas se desprendan solas; en contraste, las fibras acrílicas tienen alta tenacidad y las bolitas quedan firmemente sujetas.',
  ),
  Question(
    text:
        '¿Qué estructura molecular interna en el córtex funciona como un muelle o resorte elástico permitiendo a la lana recuperarse tras arrugarse?',
    options: [
      'La capa lipídica de ácido 18-metileicosanoico',
      'Los filamentos sintéticos extruidos de forma lineal',
      'Las proteínas en hélice Alfa (α-hélix) unidas por enlaces disulfuro',
      'El canal medular hueco lleno de aire estático',
    ],
    correctIndex: 2,
    explanation:
        'Las proteínas en hélice Alfa funcionan como resortes elásticos moleculares que, junto a los enlaces disulfuro, permiten a la fibra volver a su posición original tras la tracción.',
  ),
];

