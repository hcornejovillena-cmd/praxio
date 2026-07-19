# Registro de cambios — Praxio (ex "Kit de Investigación de Mercados")

Archivo afectado: `kit_investigacion_mercados_v5.html`
Alcance: rebranding + mejoras de UI/UX. **No se modificó ninguna lógica de cálculo/análisis** (CBC Conjoint, MaxDiff, Van Westendorp, NMS, TURF, Shapley).

---

## 1. Rebranding: "Kit de Investigación de Mercados" → Praxio

El nombre pasó de ser puramente descriptivo a una marca ("Praxio") con el nombre anterior como tagline.

- `<title>` de la pestaña: **Praxio — Kit de Investigación de Mercados**
- Header: **Praxio** como nombre grande, con **"Kit de Investigación de Mercados"** como subtítulo debajo
- Línea de crédito separada: **"v5.0 · por Hugo Cornejo Villena"** (antes iba mezclada en la misma línea que el tagline)
- Tag de Modo Aprendizaje: "🎓 Modo Aprendizaje · Praxio"
- Footer y título de reportes exportados: ahora usan "Praxio" (vía diccionario i18n, se propaga automáticamente)
- Encabezados de los scripts R exportables (CBC y MaxDiff): "Praxio — Kit de Investigación de Mercados v5.0" (de paso se corrigió el número de versión, que había quedado en v3.0)
- Nuevas claves de traducción agregadas: `app.tagline`, `app.by` (ES: "por" / EN: "by")

### Jerarquía visual del header
- `.logo` pasó de fila (`flex-direction:row`) a columna, para apilar nombre / subtítulo / crédito
- `.logo-name` (Praxio): de `1.35rem` a `2.1rem` (`1.6rem` en mobile)
- Nueva clase `.logo-sub` para el tagline: sans-serif, `.84rem`, color `#c8c0b0`
- `.logo-tag` (línea de crédito) se mantuvo para "v5.0 · por [autor]"

---

## 2. Accesibilidad

- **Encabezados semánticos**: los 62 títulos de tarjeta (`.ct`) pasaron de `<div>` a `<h3>`; el nombre de la app en el header pasó a `<h1>`. Ahora un lector de pantalla puede navegar la app por secciones.
- **Navegación por teclado**: se agregó un enhancer JS (`MutationObserver`) que detecta automáticamente cualquier `div`/`span` interactivo (pills, tarjetas de método, dropzones de carga, pasos del wizard) y les asigna `tabindex="0"` + `role="button"`, más un listener global de Enter/Space. Se aplica también a elementos generados dinámicamente después de la carga inicial.
- **Contraste de color** (ajustes de tokens para cumplir WCAG AA ≥4.5:1):
  - `--ink3` (texto secundario en toda la app): `#8a8278` (~3.8:1) → `#6b6459` (~5.8:1)
  - `.modebtn-sub` (subtítulo de los botones de modo): `#5a5550` (~2.4:1) → `#9a9288` (~5.8:1)
  - `.api-info` (nota debajo del campo de API key): `#4b5563` (~2.35:1, prácticamente invisible sobre el fondo oscuro) → `#9ca3af` (~7:1)
- **`aria-live="polite"`** en las 5 zonas donde la IA genera conclusiones (CBC, MaxDiff, VW, NMS, TURF), para que un lector de pantalla anuncie cuando termina de cargar.
- **`aria-label`** agregado a botones de ícono solo (✕ eliminar atributo/nivel/ítem, ＋ agregar nivel) e inputs sin `<label>` visible en los constructores de atributos (CBC) e ítems (MaxDiff).
- **Foco visible**: regla global `:focus-visible` para que la navegación por teclado sea visible en cualquier control.

## 3. Prevención de pérdida de datos

- El botón "↺ Nuevo análisis" (`resetMod()`) ya no borra el módulo directamente. Ahora abre un modal de confirmación propio (mismo lenguaje visual que el resto de la app) y solo si el usuario confirma se ejecuta el reset.

## 4. Notificaciones

- Los 29 `alert()` nativos del navegador (validaciones: "máximo 6 atributos", "completá el análisis primero", errores de lectura de Excel, etc.) se reemplazaron por un componente de **toast** propio, no bloqueante, consistente con el resto del sistema visual.

## 5. Navegación del wizard

- Los pasos del wizard (los 5 módulos de cálculo + modo aprendizaje, 26 pasos en total) ahora son clicables **solo cuando ya están completados**: permiten volver atrás a revisar/editar. Antes el cursor sugería que todos los pasos eran clicables pero no hacían nada.

## 6. Feedback que no depende solo del color

- En el pretest/postest del modo aprendizaje, la opción correcta/incorrecta ahora se marca con un ícono ✓/✕ además del color de fondo (mejora para usuarios daltónicos).

## 7. Wording más preciso

- El botón y las notas de la API key ahora aclaran que se guarda **solo para la sesión actual** (se pierde al recargar la página), en vez de sugerir que queda guardada de forma persistente.

## 8. Responsive y áreas táctiles

- Nuevo breakpoint `@media(max-width:480px)`: grids de 4 columnas (simulador, price points, resumen de resultados) bajan a 1 columna; `.modebar` gana scroll horizontal de respaldo.
- Nueva regla `@media(pointer:coarse)`: botones, pills y controles de paginación amplían su área táctil a ≥44px solo en pantallas táctiles, sin afectar la densidad visual en desktop.

---

## Notas

- Se generó una copia de respaldo del archivo original antes de los cambios: `kit_investigacion_mercados_v5.html.bak` (se puede borrar una vez confirmado que todo funciona bien).
- Existe otra copia del archivo en `AI-assisted Learning Environment for Applied Market Research/kit_investigacion_mercados_v5.html`, con contenido más antiguo/distinto. **No fue modificada** — avisar si también se quieren aplicar estos cambios ahí.
- Todos los cambios fueron verificados cargando el archivo en Chrome (headless) sin errores de consola, y con capturas de pantalla del header en Modo Aprendizaje, Modo Cálculo y con la barra de API expandida.
