# Documento de Diseño Arquitectónico (ADD 2.0) - OvinApp

# 1. Entradas del Diseño (Design Inputs)

## 1.1 Propósito e Historia

OvinApp es una aplicación interactiva y educativa diseñada para dar a conocer las propiedades físico-textiles y ecológicas de la lana comparada con fibras sintéticas. Guía a los usuarios en el armado del **"Ovikit" casero**, ofrece minijuegos y difunde material educativo.

## 1.2 Requerimientos Funcionales (RF)

- **RF-1 (Home/Menú):** Pantalla principal con acceso a 4 secciones (Armado de Kit, Juegos, Más Información, Proyectos Futuros).
- **RF-2 (Armado de Kit):** Guías interactivas, paso a paso y checklist para experimentos (ej. Prueba Ignífuga/LOI, Biodegradabilidad, Fricción/Escamas).
- **RF-3 (Reproducción Multimedia):** Reproductor integrado para visualizar videos explicativos (experiencias como la Escuela Cerro Leones).
- **RF-4 (Módulo de Juegos):** Trivias a contrarreloj, simulador de microscopio y juegos drag-and-drop.
- **RF-5 (Base de Conocimiento):** Consulta de propiedades térmicas, mecánicas, higroscópicas y glosario técnico.
- **RF-6 (Proyectos Futuros & Feedback):** Envío de comentarios, fotos de kits caseros y novedades.

## 1.3 Escenarios de Atributos de Calidad (QA)

- **QA-1 (Usabilidad / Portabilidad):** Un docente o estudiante en una escuela rural (ej. Cerro Leones) debe poder ejecutar la app tanto en un dispositivo Android/iOS como en un navegador web (PWA) sin diferencias en la interfaz de usuario.
- **QA-2 (Rendimiento / Desempeño):** La animación del simulador de microscopio y la interacción drag-and-drop deben mantenerse sostenidas a $\geq 60$ FPS en dispositivos móviles de gama media.
- **QA-3 (Disponibilidad / Offline):** El checklist del kit y la lectura de artículos deben funcionar al 100% sin conexión a Internet (soporte offline-first).
- **QA-4 (Mantenibilidad / Modificabilidad):** Debe ser posible agregar un nuevo minijuego o un nuevo experimento en el kit afectando menos del 5% del código base existente.

## 1.4 Restricciones de Arquitectura (CON)

- **CON-1:** Implementación en el framework Flutter (Dart) con soporte multiplataforma (iOS, Android, Web/PWA).
- **CON-2:** Integración ligera con backend (Firebase / Supabase) para evitar dependencias complejas o costosas.

---

# 2. Iteraciones del Método ADD

## ITERACIÓN 1: Establecer la Estructura General del Sistema (Arquitectura Global)

### Paso 1: Seleccionar el elemento del sistema a diseñar

Todo el sistema OvinApp (App Móvil y Web).

### Paso 2: Identificar drivers de arquitectura

- QA-1 (Multiplataforma Móvil/Web).
- QA-3 (Funcionalidad Offline).
- CON-1 (Framework Flutter).

### Paso 3: Elegir un concepto de diseño

**Patrón de Arquitectura:** Arquitectura Limpia (Clean Architecture) combinada con un patrón de presentación BLoC / Cubit o Provider/ChangeNotifier nativo de Flutter.

**Táctica de Software:** Separación de responsabilidades en capas independientes (Presentación, Dominio, Datos) e inyección de dependencias.

### Paso 4: Instanciar elementos arquitectónicos y definir interfaces

- **Capa de Presentación (UI + State Management):** Widgets Flutter, pantallas, controladores de estado (Cubit / Notifier).
- **Capa de Dominio (Domain):** Entidades de negocio (KitItem, Experiment, GameQuiz, Article) y Casos de Uso (GetExperiments, SaveChecklistStatus).
- **Capa de Datos (Data):** Repositorios con estrategia de cache local (Hive / Shared Preferences) y sincronización remota (Firebase / Supabase).

**Diagrama de arquitectura:**

```text
+-------------------------------------------------------+
|                 PRESENTATION LAYER                    |
|       (Flutter Widgets / UI, Screens, Cubits)         |
+-------------------------------------------------------+
                           |
                           v
+-------------------------------------------------------+
|                    DOMAIN LAYER                       |
|        (Entities, Use Cases, Value Objects)           |
+-------------------------------------------------------+
                           ^
                           |
+-------------------------------------------------------+
|                     DATA LAYER                        |
|  (Repositories, Local Storage/Hive, Remote API/Data)  |
+-------------------------------------------------------+
```

### Paso 5: Definir ubicación de requerimientos

- La lógica de persistencia offline se resuelve en la Capa de Datos.
- La respuesta responsiva para Web/Móvil se resuelve en la Capa de Presentación.

### Paso 6: Evaluar el diseño

**Resultado:** La Clean Architecture en Flutter permite compilar sin cambios para Android, iOS y Web, garantizando soporte Offline-First para escuelas rurales.

---

## ITERACIÓN 2: Diseño de la Pantalla Principal y Sistema de Navegación

### Paso 1: Seleccionar el elemento a diseñar

Módulo de Navegación y Screen Principal (Home).

### Paso 2: Identificar drivers de arquitectura

- RF-1 (Home/Menú de 4 opciones).
- QA-1 (Navegación responsiva multiplataforma).

### Paso 3: Elegir un concepto de diseño

**Enrutamiento Declarativo:** Uso del paquete `go_router` en Flutter para soporte unificado de URLs en Web (PWA) y rutas profundas (deep linking) en móviles.

**Patrón de Navegación:** Dashboard Grid / Adaptive Layout (Grilla responsiva que conmuta de 2 columnas en teléfonos a 4 columnas en tablets/desktop).

### Paso 4: Instanciar elementos arquitectónicos

- **AppRouter:** Maneja la pila de navegación.
- **HomeScreen:** Layout principal adaptativo (LayoutBuilder).
- **MenuCardWidget:** Widget reutilizable para las 4 opciones principales (Armado de Kit, Juegos, Más Información, Proyectos Futuros).

**Diagrama de navegación:**

```text
                  +-------------------+
                  |    AppRouter      |
                  +-------------------+
                            |
                            v
                  +-------------------+
                  |    HomeScreen     |
                  +-------------------+
                            |
        +-------------------+-------------------+
        |                   |                   |
+---------------+   +---------------+   +---------------+
|  KitModule    |   |  GamesModule  |   |  InfoModule   |
+---------------+   +---------------+   +---------------+
```

### Paso 5: Definir ubicación de requerimientos

El mapa de rutas satisface el acceso rápido a los 4 módulos exigidos en el RF-1.

### Paso 6: Evaluar el diseño

**Resultado:** `go_router` maneja limpiamente la navegación tanto en navegadores Web como en gestos móviles sin romper el historial del navegador.

---

## ITERACIÓN 3: Módulo 1 - "Armado de Kit" (Checklist, Guías de Experimentos y Multimedia)

### Paso 1: Seleccionar el elemento a diseñar

Subsistema del Ovikit Casero (Checklist interactivo, experimentos ignífugos/LOI, biodegradabilidad y videos).

### Paso 2: Identificar drivers de arquitectura

- RF-2.
- RF-3.
- QA-3 (Soporte 100% offline para listas de materiales e instrucciones).

### Paso 3: Elegir un concepto de diseño

**Base de datos Local NoSQL:** Uso de Hive o Isar para almacenamiento ultrarrápido y liviano key-value en dispositivos móviles y almacenamiento local en Web (IndexedDB).

**Video Player Abstraction:** Capa de abstracción para renderizar videos (reproductor local / Web de YouTube).

### Paso 4: Instanciar elementos arquitectónicos

- **KitChecklistCubit:** Gestiona el estado de los insumos seleccionados por el usuario (Bandeja, Vela, Pinzas, Muestras de lana Merino/acrílica, Reactivos).
- **ExperimentDetailScreen:** Muestra el procedimiento paso a paso (ej. Prueba Ignífuga LOI) con toggles de teoría integrada.
- **VideoPlayerWidget:** Componente dinámico ajustado según el origen de la fuente (Video incrustado de la Escuela Cerro Leones).

**Diagrama de componentes:**

```text
+--------------------------+       +----------------------------+
| ExperimentDetailScreen   | ----> | KitChecklistCubit          |
+--------------------------+       +----------------------------+
             |                                   |
             v                                   v
+--------------------------+       +----------------------------+
| EmbeddedVideoWidget      |       | LocalKitRepository (Hive)  |
+--------------------------+       +----------------------------+
```

### Paso 5: Definir ubicación de requerimientos

Persistencia del estado del checklist dentro del almacenamiento local en disco/memoria mediante `LocalKitRepository`.

### Paso 6: Evaluar el diseño

**Resultado:** El usuario puede marcar materiales e ingresar a los experimentos del Ovikit en el aula o el campo sin depender de conexión celular.

---

## ITERACIÓN 4: Módulo 2 - "Juegos e Interacción" (Gamificación y Rendimiento Gráfico)

### Paso 1: Seleccionar el elemento a diseñar

Módulo de minijuegos (Trivia, Simulador de Microscopio, Drag-and-Drop).

### Paso 2: Identificar drivers de arquitectura

- RF-4.
- QA-2 (Rendimiento fluido a $\geq 60$ FPS durante la interacción gráfica).

### Paso 3: Elegir un concepto de diseño

**Representación Gráfica Directa:** Renderizado interactivo usando `CustomPainter` / `InteractiveViewer` para la simulación de acercamiento del microscopio visualizando escamas de lana vs. fibras sintéticas.

**Patrón State Machine:** Para controlar los estados de los juegos (Inicio, En progreso, Pregunta Respondida, Resultado Final).

### Paso 4: Instanciar elementos arquitectónicos

- **MicroscopeSimulatorWidget:** Permite al usuario manipular un slider/gesto de pellizco para conmutar entre vistas micrográficas de lana Merino (con escamas) y acrílico.
- **QuizGameEngine:** Motor lógico para el control del cronómetro, puntajes e historias de aciertos.
- **DragDropMatchWidget:** Interfaz para unir propiedades (ej. Higroscopicidad, Resiliencia) con sus definiciones prácticas.

**Diagrama de componentes:**

```text
+--------------------------+
|      GameManager         |
+--------------------------+
             |
    +---------+---------+--------------------+
    |                   |                    |
    v                   v                    v
+---------------+  +--------------------+  +-------------------+
|  QuizEngine   |  | MicroscopePainter  |  | DragDropEngine    |
+---------------+  +--------------------+  +-------------------+
```

### Paso 5: Definir ubicación de requerimientos

Tareas pesadas de procesamiento de puntajes e imágenes aisladas para evitar bloquear el hilo principal (UI Thread).

### Paso 6: Evaluar el diseño

**Resultado:** Flutter aprovecha el renderizado por hardware de la GPU (Skia / Impeller), alcanzando 60 FPS estables al simular la lente del microscopio.

---

## ITERACIÓN 5: Módulo 3 y 4 - Base de Conocimiento, Proyectos Futuros y Feedback

### Paso 1: Seleccionar el elemento a diseñar

Módulos "Más Información" y "Proyectos Futuros / Feedback".

### Paso 2: Identificar drivers de arquitectura

- RF-5.
- RF-6.
- QA-4 (Mantenibilidad / Modificabilidad para nuevos artículos o proyectos).

### Paso 3: Elegir un concepto de diseño

**Contenido Basado en Datos (Data-driven Content / Markdown):** Renderizado de artículos científicos (propiedades térmicas, acústicas, elásticas) formateados mediante Markdown.

**Servicio de Feedback Asíncrono:** Módulo para enviar sugerencias o imágenes de la experiencia comunitaria hacia un servicio en la nube (ej. Firebase Firestore / Cloud Storage).

### Paso 4: Instanciar elementos arquitectónicos

- **KnowledgeRepository:** Lee los documentos estructurados (físico-química de la lana, glosario, bibliografía).
- **MarkdownArticleScreen:** Renderiza fórmulas, tablas comparativas (Lana vs. Sintéticos) e imágenes ilustrativas.
- **FeedbackService:** Maneja el envío diferido de sugerencias (si no hay red, encola el envío hasta recuperar conexión).

**Diagrama de componentes:**

```text
+----------------------------+
|   MarkdownArticleScreen    | <--- KnowledgeRepository (JSON/Asset)
+----------------------------+
              |
              v
+----------------------------+
|    FeedbackFormWidget      | ---> FeedbackService (Firestore/HTTP)
+----------------------------+
```

### Paso 5: Definir ubicación de requerimientos

- Artículos precargados en la app (Assets) para consulta rápida local.
- Conexión externa remota únicamente al enviar el formulario de feedback.

### Paso 6: Evaluar el diseño

**Resultado:** Añadir nuevos artículos académicos o actualización de proyectos futuros solo requiere editar un archivo Markdown o JSON en los Assets, satisfaciendo el criterio de mantenibilidad QA-4.