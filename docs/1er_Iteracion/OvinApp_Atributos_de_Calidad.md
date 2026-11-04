# Atributos de Calidad - OvinApp

## QA-1: Usabilidad / Portabilidad

- **Escenario:** Uso multiplataforma unificado en entornos educativos.
- **Estímulo:** Acceso y uso de los módulos educativos de la aplicación.
- **Fuente del Estímulo:** Un docente o estudiante en una escuela rural, como la escuela Cerro Leones.
- **Artefacto:** Capa de Presentación (Interfaz de Usuario) implementada en Flutter.
- **Entorno:** Ejecución normal durante una clase, alternando entre dispositivos móviles (Android/iOS) y navegadores web (PWA).
- **Respuesta:** El sistema adapta y renderiza la interfaz gráfica de manera responsiva, manteniendo la misma disposición de elementos, flujos y estética sin importar la plataforma.
- **Medida de Respuesta:** 0 diferencias en la interfaz de usuario y flujos funcionales entre las plataformas empleando 100% el mismo código base.

---

## QA-2: Rendimiento / Desempeño

- **Escenario:** Renderizado de componentes interactivos y gamificados.
- **Estímulo:** El usuario interactúa deslizando el simulador del microscopio o arrastrando elementos en el juego drag-and-drop.
- **Fuente del Estímulo:** Usuario final (estudiante).
- **Artefacto:** Módulo de Juegos (Motor de renderizado de Flutter / Canvas).
- **Entorno:** Ejecución en un dispositivo móvil de gama media con recursos limitados.
- **Respuesta:** El sistema procesa los gestos de interacción táctil y actualiza los gráficos (ej. las imágenes de fibras a nivel microscópico) de forma fluida sin bloquear el hilo principal.
- **Medida de Respuesta:** La tasa de fotogramas por segundo (FPS) se mantiene de forma sostenida a $\geq 60$ FPS durante toda la animación e interacción.

---

## QA-3: Disponibilidad / Offline

- **Escenario:** Consulta y guardado de progreso sin conectividad.
- **Estímulo:** Solicitud de acceso al checklist del "Ovikit" y lectura de artículos sobre las propiedades de la lana.
- **Fuente del Estímulo:** Usuario final (docente o estudiante).
- **Artefacto:** Módulos de "Armado de Kit", "Base de Conocimiento" y Base de Datos Local.
- **Entorno:** Operación en zonas rurales o aulas sin conexión a Internet (estado desconectado).
- **Respuesta:** El sistema intercepta la petición, prescinde de llamadas al backend (Firebase/Supabase) y resuelve la carga de contenido y guardado de estados directamente desde la base de datos local y los *assets* empaquetados.
- **Medida de Respuesta:** 100% de disponibilidad de los artículos, pasos de experimentos y checklists funcionales sin conexión a la red.

---

## QA-4: Mantenibilidad / Modificabilidad

- **Escenario:** Incorporación de nuevo contenido educativo.
- **Estímulo:** Solicitud de integración de un nuevo experimento práctico para el kit o un nuevo minijuego interactivo.
- **Fuente del Estímulo:** Desarrollador o equipo de mantenimiento.
- **Artefacto:** Código fuente de OvinApp (Arquitectura de módulos).
- **Entorno:** Tiempo de diseño y desarrollo.
- **Respuesta:** El equipo de desarrollo añade los nuevos archivos, assets y controladores de estado inyectándolos en el sistema de navegación sin alterar el funcionamiento interno de los módulos preexistentes.
- **Medida de Respuesta:** La integración del nuevo módulo requiere la modificación de menos del 5% del código base total existente.

---


# 1.4 Restricciones de Arquitectura (CON)

- **CON-1**: Implementación en el framework Flutter (Dart) con soporte multiplataforma (iOS, Android, Web/PWA).

- **CON-2**: Integración ligera con backend (Firebase / Supabase) para evitar dependencias complejas o costosas.