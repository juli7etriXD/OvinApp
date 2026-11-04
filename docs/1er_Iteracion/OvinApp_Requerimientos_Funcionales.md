# Requerimientos Funcionales - OvinApp

## RF-1: Home / Menú

- **Historia de Usuario:** Como **usuario (estudiante o docente)** quiero **ver una pantalla principal con un menú de 4 secciones (Armado de Kit, Juegos, Más Información, Proyectos Futuros)** para **navegar de forma rápida e intuitiva por todas las funcionalidades de la aplicación**.

- **Criterios de Aceptación:**
  - La pantalla principal debe renderizarse correctamente al iniciar la aplicación.
  - Deben existir 4 botones, íconos o tarjetas visuales claramente identificables, uno para cada sección principal.
  - Al tocar o hacer clic en cualquier opción del menú, el sistema debe redirigir al usuario a la pantalla del módulo correspondiente sin errores de enrutamiento.

---

## RF-2: Armado de Kit

- **Historia de Usuario:** Como **estudiante** quiero **acceder a guías interactivas paso a paso y a un checklist de materiales** para **poder recolectar los insumos necesarios y ejecutar correctamente los experimentos prácticos en casa o la escuela**.

- **Criterios de Aceptación:**
  - La pantalla debe mostrar un checklist interactivo con los elementos necesarios (bandeja, arena, vela, plato, pinza, encendedor, balanza, lana, acrílico, etc.) y permitir que el usuario marque los que ya posee.
  - Debe incluir las instrucciones estructuradas paso a paso para ejecutar experimentos específicos: Prueba Ignífuga/LOI, Biodegradabilidad y Fricción/Escamas.
  - El estado del checklist (ítems marcados/desmarcados) debe guardarse localmente para no perder el progreso al cerrar la app.

---

## RF-3: Reproducción Multimedia

- **Historia de Usuario:** Como **usuario** quiero **contar con un reproductor de video integrado** para **visualizar tutoriales y experiencias documentadas sin necesidad de salir de la aplicación**.

- **Criterios de Aceptación:**
  - El módulo multimedia debe integrar un reproductor compatible con enlaces externos (ej. YouTube).
  - Se deben poder reproducir de forma fluida los videos de referencia, como las experiencias documentadas en la Escuela Cerro Leones.
  - El reproductor debe incluir controles básicos de reproducción (pausa, reproducir, control de volumen, pantalla completa).

---

## RF-4: Módulo de Juegos

- **Historia de Usuario:** Como **estudiante** quiero **participar en trivias a contrarreloj, un simulador de microscopio y juegos drag-and-drop** para **reforzar los conceptos aprendidos sobre las fibras textiles de manera lúdica y entretenida**.

- **Criterios de Aceptación:**
  - El sistema debe incluir una trivia con un temporizador visible que descuente los segundos por pregunta.
  - Debe existir una pantalla que simule la vista de un microscopio escolar para diferenciar visualmente la estructura de las fibras.
  - El motor del juego drag-and-drop debe permitir arrastrar un elemento y soltarlo en su objetivo, brindando retroalimentación visual inmediata (correcto/incorrecto).

---

## RF-5: Base de Conocimiento

- **Historia de Usuario:** Como **usuario entusiasta o investigador** quiero **consultar una base de datos con propiedades térmicas, mecánicas, higroscópicas y un glosario técnico** para **comprender el fundamento teórico y científico detrás del comportamiento de la lana frente a las fibras sintéticas**.

- **Criterios de Aceptación:**
  - El módulo debe listar artículos legibles sobre las propiedades clave, detallando características como la higroscopicidad (capacidad de absorber hasta el 30% de su propio peso en vapor), su elasticidad, resistencia y su cualidad de fibra natural, renovable y biodegradable.
  - Debe incorporar un glosario técnico con un buscador o índice alfabético para términos específicos (ej. aislación térmica, queratina, escamas).
  - El texto debe ser responsivo y adaptar su tamaño a la pantalla del dispositivo móvil.

---

## RF-6: Proyectos Futuros & Feedback

- **Historia de Usuario:** Como **docente o usuario de la comunidad** quiero **un espacio para enviar comentarios, fotos de mis kits caseros y leer sobre nuevas actualizaciones** para **compartir mi experiencia práctica y mantenerme conectado con la evolución del proyecto**.

- **Criterios de Aceptación:**
  - La sección debe presentar un panel de "Novedades" con texto o imágenes sobre proyectos futuros.
  - Debe incluir un formulario funcional que permita al usuario escribir sugerencias o comentarios.
  - El formulario debe incluir un botón de carga para adjuntar y enviar al menos una fotografía del "Ovikit" armado por el usuario.