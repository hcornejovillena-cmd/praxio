# HANDOFF — Praxio (Kit de Investigación de Mercados)
## Estado al cierre de conversación · 20 de julio de 2026 (sesión v6.0 — ver 4.8)

---

## 1. Descripción general del proyecto

Plataforma educativa de investigación cuantitativa de mercados, rebrandeada como **Praxio**.
Single-file HTML + Vanilla JS, sin backend, publicada en GitHub Pages.
Dos modos: **Modo Cálculo** (herramienta técnica, ahora con entrada orientada a decisión de negocio — ver 4.6.C) y **Modo Aprendizaje** (casos guiados pedagógicos).

**Archivo activo**: `kit_investigacion_mercados_v6.html` — 8.837 líneas (ver 4.8 — bump de versión a v6.0, analítica y exportación a Excel agregadas al módulo de Posicionamiento)
**Archivos históricos**: `kit_investigacion_mercados_v5.1.html` (v5.1) y `kit_investigacion_mercados_v5.html` (v5.0) se conservan en el repo como referencia, ya no son el activo.

**Publicado en GitHub**:
- Repo: https://github.com/hcornejovillena-cmd/praxio
- Live (GitHub Pages): https://hcornejovillena-cmd.github.io/praxio/ → `index.html` ya redirige localmente a `kit_investigacion_mercados_v6.html`, **pero v6.0 todavía no tiene commit ni push** — `git status` muestra `kit_investigacion_mercados_v6.html` y este HANDOFF como untracked, y `PRODUCT.md`/`README.md`/`index.html` como modificados sin commitear. El sitio en vivo sigue sirviendo v5.1 hasta que se commitee y pushee.
- Releases: `v5.0` y `v5.1` (tags + GitHub Releases con notas). **v6.0 aún no tiene tag ni release** — pendiente para cuando se decida publicar.
- Licencia: MIT (`LICENSE`)
- `PRODUCT.md` en la raíz documenta register/usuarios/positioning/anti-referencias (generado vía `/impeccable init`)

---

## 2. Módulos del Modo Cálculo

| Módulo | Motor (`engine`) | Estado |
|--------|-----------------|--------|
| CBC Conjoint | `conjoint` | ✅ Activo |
| MaxDiff (Best-Worst Scaling) | `maxdiff` | ✅ Activo |
| Van Westendorp PSM | `vw` | ✅ Activo |
| Van Westendorp + NMS | `nms` | ✅ Activo |
| TURF Analysis | `turf` | ✅ Activo |
| Mapa de Posicionamiento | `corr` | ✅ Activo — nuevo, ver 4.7 y 7.1 |


Cada módulo tiene: wizard de 3 pasos → carga/validación datos → análisis → resultados → exportación Excel → script R → IA generativa (fallback si sin API). El módulo de Posicionamiento tiene un wizard de 4 pasos (carga → configurar diccionario → diagnóstico → resultados) y exporta a Excel (coordenadas, residuos, inercia, conclusiones) y CSV de coordenadas; no tiene script R, decisión explícita — ver D22 y 4.8.

---

## 3. Modo Aprendizaje — Casos pedagógicos activos

| Caso | Módulo | Categoría | Estado |
|------|--------|-----------|--------|
| `cafe` | Van Westendorp | `precio` | ✅ |
| `seguro` | NMS | `precio` | ✅ |
| `yogurt` | MaxDiff | `criterios` | ✅ |
| `cafe_nms` | NMS | `precio` | ✅ |
| `yogurt_turf` | TURF | `portfolio` | ✅ |
| `plan_salud` | CBC Conjoint | `diseno` | ✅ |
| `bebidas_energ` | Análisis de Correspondencias | `posicionamiento` | ✅ Nuevo — ver 4.7 |

Flujo pedagógico (8 pasos): El problema → Caso → Orientación → Pretest → Diagnóstico (incluye tarjeta "Instrumento", nueva esta sesión — ver 4.5.B) → Análisis → Interpretación → Evaluación/Reporte.

---

## 4. Trabajo completado en la última conversación

### 4.1 CBC Conjoint — Modo Cálculo (correcciones críticas)

**Fix A — `loadCDemo()` reescrito**

El generador anterior producía sesgo sistemático de posición (opción 4 elegida 31% vs ~22% para las demás). El nuevo generador usa modelo logit real con ruido Gumbel (seed 2025, scale=1.0). Detecta automáticamente el atributo de precio y le asigna utilidades decrecientes. Resultados económicamente coherentes y reproducibles.

**Fix B — Simulador de market share**

- `initSim()`: ahora renderiza `simN` productos (variable 1–4), no 4 fijos
- `addSimProd()` / `rmSimProd()`: nuevas funciones con guardas (mín 1, máx 4)
- Por defecto inicia con **2 productos** al correr el análisis
- Preserva selecciones al agregar/quitar productos
- Badge dinámico ("2 productos") y botones +/− con estado disabled correcto
- `updateSim()`: lee exactamente `simN` perfiles y pasa `simN+1` a `calcShare()`
- Nota metodológica de "Ninguno" corregida (texto incorrecto sobre "referencia media del mercado")

**Fix C — Demo data**

Verificado con el ejemplo de tarjeta de crédito: con el nuevo `loadCDemo()`, 12% TEA obtiene utilidad estimada ~1.05 vs −0.99 para 24% TEA. Distribución de posiciones uniforme (16–25%). Ninguno ~16%.

### 4.2 CBC Conjoint — Modo Aprendizaje (implementación nueva)

**Caso `plan_salud` — Salud Directa**

- Empresa ficticia de planes de salud prepagados, Lima Metropolitana
- 4 atributos × 3 niveles: Prima mensual (S/80/120/180), Red de clínicas (Local/Regional/Nacional), Tope de cobertura (S/50K/100K/200K), Telemedicina (Sin/Básica/Completa)
- `genData()` interno: diseño (seed 3001) + elecciones logit (seed 1234), 100 respondentes, 2 versiones, 15 tareas
- Utilidades verdaderas diseñadas para jerarquía pedagógica: Prima ~40%, Red ~21%, Telemedicina ~19%, Tope ~16%
- Lección central del Escenario 2: plan premium (S/180 + mejores beneficios) captura 45.9% vs 23.1% del plan económico (S/80 + beneficios mínimos) — precio bajo no siempre gana
- Capa gerencial con 2 escenarios pre-configurados (no simulador interactivo)
- Bilingüe ES/EN ("Salud Directa" igual en ambos idiomas)
- 3 preguntas pretest/postest bilengüe cubriendo: utilidades parciales, importancia relativa, rol del simulador

**Activación de categoría `diseno`**: cambiado `active:false` → `active:true` en `EDU_PROBLEMS`.

**17 modificaciones**: EDU_PROBLEMS, EDU_CASES, EDU_QUESTIONS_BY_CASE, helpers (`eduIsConjoint`), bifurcaciones en `submitPretest`, `renderEduDiag`, `runEduAnalysis`, `renderEduResults`, `renderResultsRecap`, `copyAIPrompt`, `downloadReport`, `downloadCSV`, `evalMeth`, más 4 funciones nuevas de render.

### 4.3 Bugs corregidos

**Bug 1 — `renderEduBrief()` caía al fallback PSM**

Los motores `turf` y `conjoint` recibían el texto del Price Sensitivity Meter. Corregido con ramas explícitas para cada motor.

**Bug 2 — Diverging bar de utilidades parciales**

Los valores negativos (rojos) aparecían a la derecha en vez de a la izquierda. Implementado correctamente con dos semi-zonas de 57px + eje central de 2px.

### 4.4 i18n Van Westendorp (Modo Cálculo)

Primer módulo del Modo Cálculo traducido al inglés. Estrategia confirmada:

- HTML estático → `data-i18n` + DICT
- JS dinámico → ternarios `_lang==='es'?...:...`
- Al cambiar idioma: `applyI18n()` actualiza HTML estático; resultados ya renderizados se actualizan en el próximo análisis

**DICT**: ~104 claves `calc.vw.*` + 14 claves compartidas `calc.*` (botones, export, outliers, AI)

**HTML**: 41 atributos `data-i18n` en todo el módulo VW (wizard, paso 1, paso 2, paso 3)

**JS traducidas**: `renderVWResults()`, `renderOutlierBlock()` (compartida → beneficia NMS/MaxDiff/TURF automáticamente), `genVWAI()`, `expVW()`, `analyzeVW()`

**Incidente técnico resuelto**: Un `str_replace` parcial + limpieza mal anclada borró el cuerpo de `renderVWResults`. Resuelto. La función tiene 52 líneas y 4.185 chars. Sintaxis validada con acorn.

### 4.5 Trabajo completado en esta conversación

**A. i18n completo de los 4 módulos restantes del Modo Cálculo**

El Modo Cálculo es ahora **100% bilingüe ES/EN en sus 5 módulos** (VW, NMS, MaxDiff, CBC, TURF). Mismo patrón que VW (HTML estático → `data-i18n`; JS dinámico → ternarios), reutilizando claves compartidas (`calc.btn.*`, `calc.export.title`, `calc.md.ver1/ver2`, `calc.md.total`, etc.) entre módulos siempre que el texto coincidía exactamente.

| Módulo | Claves nuevas aprox. | Notas |
|--------|----------------------|-------|
| NMS | ~44 | Reutiliza `calc.vw.q1`–`q4` (preguntas idénticas al PSM clásico) |
| MaxDiff | ~66 | — |
| CBC Conjoint | ~81 | El más grande de los 4; incluye simulador de market share y curva de elasticidad |
| TURF | ~142 | El módulo más grande del Kit; incluye todo el sistema de Shapley Values |

**Bugs de variable-shadowing encontrados y corregidos durante la traducción**: tanto `renderMC()` (MaxDiff) como `renderCC()` (CBC) usaban una variable local `t` (alias de `S.m.cp`/`S.c.cp`, el índice de tarjeta actual) que tapaba la función global `t()` de traducción. Se renombró a `cp` en ambas funciones. **Precaución para futuros módulos**: revisar que ninguna variable local se llame `t` antes de traducir una función.

**Gap encontrado y corregido — fallbacks de IA no eran bilingües**: `fallbackVW()`, `fallbackNMS()`, `fallbackMaxDiff()` y `fallbackCBC()` (el texto que se muestra cuando no hay API key de IA configurada, que es el caso más común) estaban hardcodeados en español sin ninguna rama `_lang`, aunque los *prompts* enviados a la IA sí eran bilingües. Se corrigieron los 4 con el mismo patrón `_lang==='es'?...:...`. **Precaución**: si se agrega un módulo nuevo con IA, el fallback debe ser bilingüe desde el inicio, no solo el prompt.

**Estado i18n final**: ver tabla actualizada en sección 5.

**B. Modo Aprendizaje — puente pedagógico "Instrumento" en el paso Diagnóstico**

Feedback de un grupo piloto de alumnos: el salto entre Pretest (preguntas conceptuales) y Diagnóstico (tabla de calidad de datos ya procesados) era abrupto — nunca veían qué se le preguntó realmente a los encuestados.

Solución implementada: nueva función `renderEduInstrument()`, bifurcada por motor (mismo patrón que `renderEduDiag()`), que renderiza una tarjeta nueva al **inicio** del paso Diagnóstico (antes de la tarjeta de calidad de datos existente), con 3 partes por caso:
1. *Así se recolectó* — el instrumento real y concreto del caso activo (preguntas exactas de VW/NMS con el producto real; lista real de ítems para MaxDiff/TURF; tabla real de atributos/niveles para CBC), usando datos ya poblados en `S.vw/nms/m/turf/c` en el momento en que se llama (justo después de `genData()` en `submitPretest()`).
2. *Cómo aplicarlo en tu propio cuestionario* — tips prácticos por técnica (fijos por motor, no por caso).
3. Frase puente hacia el diagnóstico de datos.

Se llama junto a `renderEduDiag()` en `submitPretest()`. No requirió tocar el wizard (sigue en 9 pasos) ni el orden de ejecución existente. 15 claves nuevas (`edu.instr.*`) en el DICT.

**Pendiente conocido, fuera de este cambio**: los atributos/niveles del caso `plan_salud` (CBC) están hardcodeados solo en español dentro de `genData()` — no son objetos bilingües `{es,en}` como el resto del contenido del caso. Afecta esta tarjeta nueva y también los resultados del análisis conjoint en Modo Aprendizaje en general. No se tocó por ser un problema preexistente más amplio.

**C. Bayesian Smoothing (Empirical Bayes shrinkage) en MaxDiff y CBC — nuevo, basado en paper de Sawtooth Software**

Disparado por la lectura de *Orme, B. (2026). "Bayesian Smoothing in HB-MNL: An Intuitive Explanation." Sawtooth Software.* El paper explica por qué HB-MNL (con MCMC completo) suaviza las utilidades individuales hacia la media poblacional cuando los datos de un encuestado son ruidosos/escasos, y confía más en el dato propio cuando hay muchas elecciones consistentes.

**Decisión de alcance** (ver D9): implementar el *espíritu* del paper con una fórmula cerrada de Empirical Bayes (precision-weighted), sin MCMC completo — evaluado como demasiado costoso en complejidad/mantenimiento para este Kit (ver discusión completa en la conversación; Opción C fue descartada explícitamente).

**Fórmula usada** (idéntica en ambos módulos, derivada y simplificada de la ponderación por precisión normal-normal):

```
smoothed_ij = (popMean_j × avgExpo_j + raw_ij × n_ij) / (avgExpo_j + n_ij)
```

donde `n_ij` = veces que ese encuestado vio/eligió ese ítem/nivel, `avgExpo_j` = exposición promedio poblacional para ese ítem/nivel, y `popMean_j` = la estimación agregada ya existente (actúa como prior). Es matemáticamente equivalente al caso normal-normal con `σ²_i = τ²_j × avgExpo_j/n_ij`, sin necesitar estimar una constante de suavizado arbitraria.

**MaxDiff (`analyzeM`)**:
- Pasada 1 (sin cambios): cuenta best/worst crudos, ahora también captura exposición (`expo`) por ítem por encuestado.
- Calcula `popMean` y `avgExpo` por ítem a partir de la población.
- Pasada 2: aplica la fórmula, **re-centra** el vector suavizado de cada encuestado para que siga sumando exactamente 0 (propiedad necesaria para que `loadFromMaxDiff()` en TURF siga funcionando correctamente, ya que asume valores centrados en cero).
- Efecto en cascada automático: TURF modo ponderado hereda puntajes menos ruidosos sin ningún cambio de código adicional.
- Export `expMInd()` ahora tiene 4 hojas (antes 2): scores suavizados, netos suavizados, **netos sin suavizar** (nuevo) y **exposiciones por ítem** (nuevo), más nota de referencia al paper.
- Nueva nota metodológica visible en el paso de exportación (`calc.md.smoothing.note`), citando a Orme (2026).

**CBC (`analyzeC`)**: aquí el cambio es más grande porque **antes no existía ningún dato individual** — solo logit agregado por nivel. Se agregó:
- Pasada de conteo individual (misma lógica que el agregado, por encuestado) → utilidad cruda individual con el mismo transform log-odds centrado.
- `τ²` por nivel: varianza entre encuestados que sí vieron ese nivel ≥1 vez (piso mínimo 0.05, fallback a 1 si casi nadie lo vio).
- `avgExpo` por nivel, aplicando la misma fórmula, usando el **agregado ya existente** (`utils`) como `popMean` (no se recalcula la media poblacional desde las estimaciones individuales ruidosas — se usa la agregada estable).
- Resultado en `S.c.res.indivUtils` — **no toca** `renderCRes()`, `initSim()`, `initElast()` ni ningún render existente. El simulador de market share sigue usando utilidades agregadas (decisión explícita, ver D10).
- Nueva función `expCInd()` y botón "↓ Utilidades individuales": 4 hojas (utilidades suavizadas, sin suavizar, exposiciones por nivel, referencia).

**Validación**: ambas fórmulas se probaron con datos simulados aislados (fuera del HTML, en Node) confirmando que un encuestado con pocas exposiciones a un ítem/nivel se ajusta fuertemente hacia la media poblacional, mientras uno con exposición típica se ajusta levemente. Sintaxis completa validada con acorn después de cada cambio; balance de `<div>` verificado (1002/1002 al cierre).

**Pendiente derivado de este trabajo**: `S.c.res.indivUtils` ya está calculado y disponible, pero el simulador de market share de CBC (Modo Cálculo) todavía asume mercado homogéneo (utilidades agregadas para todos). Construir un simulador heterogéneo (cada "encuestado sintético" vota con sus propias utilidades individuales) es el candidato natural para la siguiente sesión — ver sección 11.

### 4.6 Sesión del 19 de julio de 2026 — v5.1, crítica de diseño, publicación

Esta sesión partió de `kit_investigacion_mercados_v5.html` (v5.0, la misma base de la sección 4.5) y terminó con el proyecto publicado en GitHub como `kit_investigacion_mercados_v5.1.html`. Dos líneas de trabajo corrieron en paralelo y se fusionaron al final: (A) mejoras aplicadas directamente sobre v5.0 vía una crítica de diseño formal, y (B) trabajo hecho por separado (fuera de esta conversación) directamente sobre una copia que terminó siendo v5.1 — con el simulador heterogéneo de CBC que la sección 4.4 dejaba pendiente, entre otras cosas. Ver 4.6.D para cómo se reconciliaron ambas.

**A. Hook de analítica de activación (GoatCounter)**

Se agregó `function track(evt,data)` (justo después de `let _lang='es'`), que llama a `window.goatcounter.count(...)` si está disponible, no-op silencioso si no (ad-blocker, offline, o sin site code). Site code activo: `praxio.goatcounter.com`.

Eventos instrumentados: `modulo_entrado` (en `swMod()`), `wizard_completado` (al final de `analyzeC/M/VW/NMS` y `runTURF`, con `modo:'calculo'|'aprendizaje'` derivado de `S.edu.active` para no mezclar las estadísticas de ambos modos), `export_realizado` (en los 7 `exp*()`), `caso_iniciado` y `caso_completado` (Modo Aprendizaje).

**Motivación**: antes de esta sesión no había ninguna forma de saber qué módulos se usan realmente ni dónde abandonan los usuarios — cualquier decisión de qué mejorar era una corazonada. Con esto ya se puede calcular el Swiss Knife Index real de los 5 módulos.

**B. Crítica de diseño formal (`/impeccable critique`) y fixes aplicados**

Se corrió el flujo de crítica de impeccable con dos evaluaciones aisladas (revisión de diseño + escaneo determinístico `detect.mjs`), sin navegador disponible en este entorno (limitación declarada explícitamente en el reporte). Score: **29/40 (Good)**. Snapshot guardado en `.impeccable/critique/`.

Hallazgos corregidos:
- **[P0] Pérdida silenciosa de datos en Modo Aprendizaje**: `startEduCase()` reescribía `S.edu.pretest/postest/response` sin confirmación al re-iniciar un caso con progreso ya hecho, a diferencia de `resetMod()` en Modo Cálculo que sí pasa por `confirmModal()`. Fix: nueva guarda `hasProgress` + `confirmModal()`, lógica de inicialización movida a `_doStartEduCase(cs)`.
- **[P1] Selector de técnica de Modo Cálculo sin guía**: se agregaron `title` + nuevo atributo `data-i18n-title` (mismo patrón que `data-i18n-ph`, manejado en `applyI18n()`) a los 5 botones de `#mbar-calc`, con una descripción de una línea de cuándo usar cada técnica. Ver también 4.6.C — luego se amplió a un rediseño mayor del punto de entrada.
- **[P1] Badge "✦ IA" vs. fallback**: investigado y descartado como falso positivo — `showAI()` ya distingue correctamente "✦ GPT" (verde) de "⚙ AUTO" (gris, con tooltip explicativo) en el resultado renderizado; el hallazgo solo había visto el badge genérico del header de la tarjeta.
- **[P2] 11 bordes laterales de color (`border-left`)**: prohibición explícita de la sección "Absolute bans" del propio skill de impeccable. Reemplazados por borde completo o tinte de fondo según el caso (`.turf-portfolio-highlight`, `.shapley-insight`, `.edu-brief`, `.diag-ok/warn/crit`, `.layer-interp-item`, las 2 tarjetas de distinción TURF/MaxDiff en Modo Aprendizaje, la tarjeta de utilidades por atributo en CBC, `.resp-block`).
- **[P2] Armador de atributos CBC sin colapsar**: `renderCA()` ahora colapsa un atributo a una fila resumen ("Nombre (N niveles)") cuando está completo (nombre + todos los niveles no vacíos), con botón "✎ Editar" para reabrir. Nueva función `toggleCAttrCollapse(ai)`, nuevo campo `a.collapsed` por atributo.

No corregidos por diseño (quedan documentados, no bloqueantes): exportación agregada vs. individual con estilo `.btn` idéntico (fácil clic equivocado); naming leftover `_geminiKey`/`id="gemini-key"` de una integración anterior con Gemini (la integración real ya usa OpenAI); 6 usos de `transition:width` (jank potencial, debería animarse por `transform`); ~30 em-dashes en el copy; tarjetas de selección única (`.meth-card`) usan `role="button"` en vez de `role="radio"`/`aria-selected`, así que un lector de pantalla no anuncia el cambio de selección; badge rojo "↓ Retrocedió" en el postest presenta un delta estadísticamente ruidoso (quiz de solo 3 preguntas) con demasiada contundencia visual.

**C. Fixes adicionales por feedback directo sobre la app ya publicada**

Tres correcciones más, pedidas después de revisar la v5.1 ya en vivo:

1. **Versión desincronizada**: el header mostraba "v5.0" aunque el archivo activo ya era v5.1 (mismo texto hardcodeado en 5 lugares: header, título y footer del reporte descargable, y ambos headers de script R). Se introdujo `const APP_VERSION='5.1'` (junto a `_lang`) y los 4 lugares en JS ahora interpolan `${APP_VERSION}`; el header estático (único lugar en HTML plano) se corrigió a mano. **Esto no debería volver a pasar en los 4 de 5 lugares que ahora dependen de la constante — solo el header HTML plano requiere corrección manual en el próximo bump de versión.**
2. **Reposicionamiento de Modo Cálculo** (el cambio más grande de la sesión): el feedback fue "ahora parece un conjunto de técnicas. Debes presentarlo como una herramienta para pasar de una decisión de marketing a un diseño, análisis e interpretación." Se agregó un nuevo bloque `#calc-decision-wrap` **antes** de la barra de pestañas técnicas (`#mbar-calc`), reutilizando las mismas 4 categorías de `EDU_PROBLEMS` (precio/atributos/diseno/portafolio) que ya usa el Paso 0 de Modo Aprendizaje — mismo copy, misma fuente de verdad, cero duplicación de contenido. Nuevo mapeo `CALC_DECISION_ENGINES` (`precio` → `['vw','nms']` con sub-elección; `atributos`→`['maxdiff']`; `diseno`→`['conjoint']`; `portafolio`→`['turf']`), nueva función `renderCalcDecisions()` (llamada en el bootstrap `window.addEventListener('load',...)` y de nuevo dentro de `applyI18n()` para que el picker cambie de idioma), y `goToCalcModule(engine)` que dispara `.click()` sobre el botón de pestaña real (preserva el `cls` de color de cada `swMod(...)`). La barra de pestañas técnicas sigue disponible debajo, sin quitarla, para quien ya sepa qué técnica necesita.
3. **API key demasiado protagonista**: la barra de API key era una franja oscura de ancho completo, siempre visible al entrar a Modo Cálculo, aunque es una función opcional (el análisis automático por reglas funciona sin ella). Rediseñada: el wrapper externo pasó de `.api-bar` (oscuro, full-width) a `.api-bar-mini` (chico, mismo tono que el fondo), con un solo botón de texto discreto como toggle (reemplaza al checkbox `#api-toggle-cb`, que se eliminó). Copy también ablandado tras una segunda ronda de feedback: de "⚙ IA avanzada (opcional): usar tu propia API key de OpenAI" a **"✦ Activar conclusiones asistidas por IA (opcional)"** — la mecánica de la API key queda explicada solo dentro del panel ya expandido, no en la etiqueta colapsada.

**D. Reconciliación v5.0 (esta conversación) vs. v5.1 (trabajo externo) — importante para la próxima sesión**

A mitad de sesión se descubrió que existía una `kit_investigacion_mercados_v5.1.html` con trabajo hecho por fuera de esta conversación, más avanzada que la v5.0 sobre la que se venían aplicando los fixes de 4.6.A/B. Se hizo un diff completo (34 hunks, revisados uno por uno, no solo los más grandes) y se confirmó que v5.1 incluía, además de lo ya conocido:

- **El simulador heterogéneo de CBC que la sección 11 (edición anterior) marcaba como "Prioridad inmediata #1"** — ya implementado en v5.1, ver 4.6.E. Esto salda el pendiente de la sección 4.4/D10.
- Gráfico de utilidades parciales de CBC convertido a barras divergentes centradas en cero (antes rango min→max sin signo).
- Curva de elasticidad de CBC reemplazada por un gráfico de línea real en Canvas (`drawElastChart()`), con detección de inversiones de monotonía.
- Plantilla de Excel para TURF (`dlTURFTpl()`, binaria/umbral), más una sección pedagógica nueva "¿Cómo se pregunta esto en la encuesta?" con contraste correcto/incorrecto.
- Fix de escalado de barras aplicado de forma consistente en CBC (importancia), MaxDiff (net scores) y TURF (Shapley): de "escalar a 100 literal" a "escalar al máximo real", quitando en los tres casos la fila "Total: 100%" redundante.
- **`applyI18n()` ahora re-renderiza paneles dinámicos de CBC/MaxDiff al cambiar de idioma** (`if(S.c.res){renderCRes();...} if(S.m.res){renderMRes();}`) — esto **revierte la Decisión D2** (ver sección 8, actualizada).

Todos los fixes de 4.6.A/B/C se replicaron manualmente sobre v5.1 (mismos `old_string`/`new_string` cuando el ancla no había cambiado; verificados anclaje por anclaje antes de cada edición, no asumidos). Sintaxis validada con `node --check` después de cada ronda. `kit_investigacion_mercados_v5.html` (v5.0) quedó en el repo tal cual, sin los fixes de 4.6, como referencia histórica — **no seguir editando v5.0**, toda la app viva es v5.1.

**E. Simulador heterogéneo de CBC (detalle técnico, trabajo externo integrado en v5.1)**

Tres reglas de simulación seleccionables vía nuevas pills `#sim-rule-pills` (nuevo campo `S.c.simRule`, default `'sop'`):
- `sop` (Preferencia compartida, **recomendado**): cada encuestado usa sus propias utilidades individuales (`S.c.res.indivUtils`, ya suavizadas con Empirical Bayes de la sección 4.5.C) para calcular su probabilidad logit personal de elegir cada producto; el share final es el promedio de esas probabilidades. Función `calcShareHet(profiles,'fc'|'sop')`.
- `fc` (Primera elección / voto): cada encuestado "vota" por su producto de mayor utilidad (o "Ninguno"); share = % de votos.
- `agg` (Agregado, clásico): el comportamiento original pre-heterogéneo, con `calcShareAgg(profiles)`. Se conserva como referencia histórica y comparativa.

`calcShare(profiles)` es ahora un dispatcher: `agg` → `calcShareAgg`; cualquier otra regla → `calcShareHet`. `setSimRule(rule,el)` actualiza `S.c.simRule`, la nota metodológica visible, y recalcula (`updateSim()`, `renderElast()`).

**F. 4 de los 5 "minor observations" de la crítica (4.6.B) resueltos**

Mismo día, después de publicar. Solo queda pendiente `transition:width` (ver sección 11).

- **Badge "↓ Retrocedió" ablandado**: cuando `gain<0` en `submitPosttest()`, se agrega una nota debajo del badge ("Con solo 3 preguntas, una diferencia de 1 punto no es concluyente"). El color rojo se conservó; solo se contextualizó.
- **Botones de exportación distinguidos**: `calc.cbc.btn.exportind` y `calc.md.btn.exportind` (los de datos por respondiente) ahora llevan el prefijo 👤, en vez de compartir el mismo `↓` que los agregados.
- **`role="radio"` + `aria-checked`** en las tarjetas `.meth-card` de problema y caso (Modo Aprendizaje), con `role="radiogroup"` en sus contenedores (`#edu-problem-list`, `#edu-case-list`). `selectEduCase()` actualiza `aria-checked` al mismo tiempo que `.selected`. El retrofit de accesibilidad (línea ~4740, `if(!el.hasAttribute('role'))...`) respeta el `role` explícito y no lo pisa.
- **Renombrado `_geminiKey`→`_openaiKey`, `id="gemini-key"`→`id="openai-key"`**, incluyendo un tooltip que decía textualmente "Ingresá una API key de Gemini" (factualmente incorrecto — la integración es OpenAI). Verificado con grep que no queda ningún rastro de "gemini" en el archivo.

### 4.7 Sesión de continuación (19 de julio de 2026) — Diseño completo del módulo Mapa de Posicionamiento

Sesión enteramente de **diseño** (sin código), disparada por la prioridad #1 ya identificada en la sección 11 de la edición anterior de este HANDOFF. Cero cambios al archivo HTML — el resultado completo de esta sesión vive en la sección 7.1 (reemplazada) y las decisiones D17-D19. Se resume aquí el proceso, no el contenido (que ya está en 7.1, para no duplicar).

**Orden de trabajo seguido** (relevante si una sesión futura necesita retomar un diseño de módulo nuevo con el mismo nivel de rigor):
1. Formato de entrada real, contrastado contra un Excel de ejemplo provisto por el usuario — se descubrió que la codificación real (slots multi-marca en P&P) era distinta de la asunción inicial (binaria 0/1), lo que confirma el valor de pedir/revisar un archivo real antes de fijar el parser.
2. Regla de limpieza de conflictos de digitación, con justificación explícita (no solo la regla, el "por qué").
3. Criterio de exclusión de categorías raras — el usuario propuso un criterio propio (media−1DE); se investigó literatura (Greenacre, Le Roux & Rouanet) antes de aceptarlo o reemplazarlo, y se reemplazó con sustento documentado.
4. Diseño visual del mapa (Canvas), iterado dos veces con feedback del usuario (números+leyenda para atributos, luego vectores desde el origen para marcas).
5. Detalle del parser con casos de prueba concretos sobre el archivo real.
6. Algoritmo de CA (SVD/Jacobi) y proyección de puntos suplementarios.
7. Integración con `EDU_CASES` (caso pedagógico con marca nicho deliberada).
8. Una tercera vía de entrada (tabla de contingencia agregada) surgida a mitad de sesión — evaluada, diseñada, y explícitamente acotada a Modo Cálculo.
9. Checklist de validación cruzada contra la filosofía del proyecto y las restricciones técnicas, que encontró 2 gaps reales antes de darlo por cerrado: falta de `fallbackPositioning()` (obligatorio por patrón existente) y contenido bilingüe aún no redactado.
10. Redacción completa del contenido bilingüe ES/EN.

**Gaps encontrados por el checklist de validación (paso 9) — ambos ya cerrados**:
- Todo módulo con IA necesita un fallback sin IA, bilingüe desde el inicio (lección ya conocida de 4.5.A, que casi se repite aquí de no mediar el checklist explícito) → diseñado `fallbackPositioning()`, ver 7.1.
- Contenido bilingüe no puede quedar como "descripción de qué debería decir el texto" — necesita redactarse en ES/EN real antes de considerarse listo para implementación → redactado en el último turno de la conversación.

**Nota metodológica para replicar este proceso en 7.2 (Segmentación) u otros módulos futuros**: el patrón de "proponer → contrastar con literatura o con datos reales → cerrar con justificación documentada" tomó varios turnos pero evitó al menos 2 decisiones débiles (codificación binaria asumida incorrectamente; criterio de exclusión de categorías raras sin sustento). Vale la pena presupuestar el mismo tiempo de diseño para 7.2, que además es más complejo (3 algoritmos encadenados).

**Siguiente paso real para la próxima sesión**: implementación del código. Todo el diseño (parser, algoritmo, visual, caso pedagógico, contenido bilingüe) está cerrado en la sección 7.1 — no debería haber necesidad de más rondas de diseño antes de codear, salvo que la implementación revele un caso no contemplado.

### 4.8 Sesión — 20 de julio de 2026 — versión v6.0, analítica y exportación a Excel de Posicionamiento

Sesión de continuación que partió de `kit_investigacion_mercados_v6.html` ya con el módulo de Posicionamiento implementado (código de 4.7 + los 5 bugs/extensiones encontrados tras subir el archivo, ya documentados en 7.1). El pedido del usuario fue explícito: la versión debe decir v6 en toda la app, y las funcionalidades que ya tenían los otros módulos (analítica, exportación) debían replicarse en el módulo nuevo.

**A. Bump de versión a v6.0**

- `APP_VERSION` (línea ~1526): `'5.1'` → `'6.0'`, se propaga automáticamente a los 4 lugares que ya dependían de la constante (reporte, footer, ambos headers de script R) — ver D16, seguía funcionando como se diseñó.
- Header estático del logo (`.logo-tag`, único lugar en texto plano): corregido a mano a `v6.0`.
- Verificado con grep que no queda ningún rastro de `v5.1`/`v5.0` en el HTML tras el cambio.

**B. Gap encontrado — Posicionamiento no tenía analítica de activación (GoatCounter)**

Los otros 5 módulos disparan `track('wizard_completado',...)` al terminar el análisis y `track('export_realizado',...)` en cada exportación (ver 4.6.A). Posicionamiento no tenía ninguno de los dos — `modulo_entrado` sí lo tenía porque es genérico (dispara en `swMod()` para cualquier módulo), igual que `caso_iniciado`/`caso_completado` (genéricos en Modo Aprendizaje). Agregado:
- `track('wizard_completado',{modulo:'corr',modo:'calculo'})` en `runCorrAnalysisCalc()`.
- `track('wizard_completado',{modulo:'corr',modo:'aprendizaje',caso:S.edu.caseId})` en la rama `eduIsPositioning()` de `runEduAnalysis()` — a diferencia de TURF/MaxDiff/NMS/Conjoint (que comparten una sola función `analyze*()` entre ambos modos y ya traían el track adentro), Posicionamiento resuelve Modo Cálculo y Modo Aprendizaje con dos bloques de código separados, así que necesitó dos llamadas a `track()` en dos sitios distintos en vez de una sola compartida.
- `track('export_realizado',{modulo:'corr',tipo:'coordenadas'})` en `dlCorrCSV()` (ya existía la función, le faltaba el track).

**C. Exportación a Excel del módulo de Posicionamiento**

El usuario evaluó explícitamente si sumaba exportar a Excel dado que ya existía `dlCorrCSV()`, y decidió que sí valía la pena **acotado a los indicadores que el CSV no trae** (el CSV solo tiene nombre/tipo/x/y/masa/cos²/estado — no matriz de residuos, no contribución `ctr`, no inercia por dimensión). También se descartó explícitamente el script R (ver D22) — de los 6 módulos del kit, solo CBC y MaxDiff lo tienen; replicar el parser de 3 formatos de entrada en R hubiera sido una duplicación de lógica sin caso de uso real.

Nueva función `expCorr()` (justo antes de `dlCorrCSV()`), workbook de 4 hojas usando el mismo patrón que `expVW()`/`expTURF()` (`XLSX.utils.aoa_to_sheet` + `book_append_sheet`, claves `t('calc.corr.exp.*')` para nombres de hoja y encabezados de columna, igual que el resto del kit):
1. **Coordenadas** — marcas y atributos (activos + suplementarios), x/y, masa %, cos² %, contribución a ejes % (`—` para suplementarios, que por definición no contribuyen), estado.
2. **Residuos estandarizados** — la matriz completa atributo × marca (`ca.stdResiduals`), el mismo número que ya sustenta `corrBuildInterpretation()` (D21), ahora exportable en su forma completa.
3. **Inercia por dimensión** — el scree plot de `corrScreeHtml()` en números, con columna de % acumulado.
4. **Conclusiones** — mismo texto visible en `#corrai` (IA o fallback), igual patrón que la hoja de conclusiones de `expVW()`.

Botón `↓ Excel resultados` agregado en el paso 4 del wizard de Posicionamiento (Modo Cálculo), reutilizando la clave compartida `calc.btn.excel` (sin clave nueva) y la clase `bpt` (el color primario que ya usan los otros botones del módulo, ej. "Analizar →"). ~15 claves i18n nuevas bajo `calc.corr.exp.*`, más reuso de `calc.ai.title` para el encabezado de la hoja de conclusiones.

**Validación**: sintaxis de los 2 bloques `<script>` con `new Function()` (equivalente a acorn), balance de `<div>` (1093/1093 antes y después), y una prueba funcional aislada en Node con datos simulados con la misma forma que produce `corrRunCA()`/`corrProjectSupplementary()` (marcas activas + suplementaria, atributos activos, matriz de residuos, `inertiaPerDim`) — confirmó que las 4 hojas se arman con los valores esperados, incluyendo el caso de un punto suplementario con `ctr:'—'`. Prueba manual en navegador real ejecutada por el usuario por fuera de esta conversación — sin incidencias reportadas.

**D. Documentación sincronizada**: `README.md` (lista de 6 módulos, nota sobre Excel/CSV sin R en Posicionamiento, referencias de archivo activo/histórico, versión del footer), `index.html` (redirect a `kit_investigacion_mercados_v6.html`), `PRODUCT.md` (Posicionamiento agregado a la descripción de producto, conteo de módulos con i18n completo actualizado a 6, referencias bibliográficas de CA agregadas), este HANDOFF (secciones 1, 5, 6, 7.1, 8, 10, 11), y una nueva entrada en `CAMBIOS.md` (ver ese archivo).

**Pendiente real, no bloqueante**: `git commit` + `push` de todo lo anterior — al cierre de esta sesión seguía sin hacerse (ver sección 1).

---

## 5. Estado de la i18n del Modo Cálculo

| Módulo | HTML estático | JS dinámico | Excel | AI prompt | AI fallback | Estado |
|--------|--------------|-------------|-------|-----------|-------------|--------|
| Van Westendorp | ✅ 41 attrs | ✅ 5 funciones | ✅ | ✅ | ✅ (corregido esta sesión) | **Completo** |
| NMS | ✅ 34 attrs | ✅ | ✅ | ✅ | ✅ (corregido esta sesión) | **Completo** |
| MaxDiff | ✅ | ✅ | ✅ + shrinkage | ✅ | ✅ (corregido esta sesión) | **Completo** |
| CBC Conjoint | ✅ | ✅ | ✅ + utilidades individuales | ✅ | ✅ (corregido esta sesión) | **Completo** |
| TURF | ✅ | ✅ (incluye Shapley Values) | ✅ | ✅ | — (usa fallback inline, ya bilingüe) | **Completo** |
| Mapa de Posicionamiento | ✅ ~27 claves `calc.corr.*` (ver 4.7) | ✅ | ✅ (agregado en 4.8 — sin script R, ver D22) | ✅ | ✅ `fallbackPositioning()` | **Completo** |

**El Modo Cálculo completo es bilingüe ES/EN.** No queda i18n pendiente en ninguno de los 6 módulos. Posicionamiento es el único de los 6 sin script R exportable (decisión explícita, ver D22) — el resto de la columna "AI prompt/fallback" y HTML/JS sí está completo igual que los demás.

**Infraestructura reutilizable construida**: las claves `calc.*` compartidas (botones, export, outliers, AI loading, `calc.version`, `calc.md.total`, `calc.md.ver1/ver2`) se comparten entre módulos. Si se agrega un módulo nuevo, revisar primero qué claves ya existen antes de crear nuevas.

**Lecciones para futuros módulos** (ver 4.5.A para detalle): revisar colisión de variable local `t` antes de traducir cualquier función; los fallbacks de IA deben ser bilingües desde el inicio, no solo el prompt.

---

## 6. Arquitectura técnica clave

### Constante de versión (nueva, sesión 4.6.C)

```javascript
let _lang='es';
const APP_VERSION='6.0';
```

Usada vía `${APP_VERSION}` en 4 de los 5 lugares donde se muestra el número de versión (header del reporte descargable, footer del reporte, y ambos headers de script R exportable). El header estático del logo en el HTML sigue siendo texto plano — es el único de los 5 que requiere corrección manual en el próximo bump de versión (corregido a mano a v6.0 en 4.8, junto con `README.md` e `index.html`).

### Analítica de activación (nueva, sesión 4.6.A)

```javascript
function track(evt,data){
  if(!window.goatcounter||!window.goatcounter.count)return;
  const parts=Object.entries(data||{}).filter(([,v])=>v!==''&&v!=null).map(([k,v])=>`${k}=${v}`);
  window.goatcounter.count({path:'evt/'+evt+(parts.length?'/'+parts.join('&'):''),title:evt,event:true});
}
```

No-op silencioso si GoatCounter no cargó. Site code activo: `praxio.goatcounter.com`. Eventos: `modulo_entrado`, `wizard_completado`, `export_realizado`, `caso_iniciado`, `caso_completado` — ver 4.6.A para el detalle de dónde se dispara cada uno.

### Decisión de negocio → técnica (nueva, sesión 4.6.C)

```javascript
const CALC_DECISION_ENGINES={precio:['vw','nms'],atributos:['maxdiff'],diseno:['conjoint'],portafolio:['turf']};
function renderCalcDecisions(){ /* reusa EDU_PROBLEMS[x].title/.cardDesc */ }
function goToCalcModule(engine){ document.getElementById('tab-'+engine)?.click(); /* ... */ }
```

Reutiliza `EDU_PROBLEMS` (la misma fuente de datos del Paso 0 de Modo Aprendizaje) para presentar Modo Cálculo como decisión de negocio primero, técnica después. Si se agrega una categoría nueva a `EDU_PROBLEMS`, agregar también su entrada en `CALC_DECISION_ENGINES` para que aparezca en el picker de Modo Cálculo.

### DICT de traducciones

```javascript
const I18N = {
  es: {
    'calc.vw.pts.title': 'Puntos de precio clave',
    'calc.btn.prev': '← Paso anterior',
    // ...
  },
  en: {
    'calc.vw.pts.title': 'Key price points',
    'calc.btn.prev': '← Previous step',
    // ...
  }
}
function t(key) { return (I18N[_lang] && I18N[_lang][key]) || I18N.es[key] || key; }
function applyI18n() {
  document.querySelectorAll('[data-i18n]').forEach(el => {
    el.innerHTML = t(el.getAttribute('data-i18n'));
  });
}
```

### Estado global

```javascript
const S = {
  c:   { attrs, vers, design, data, res, priceAttr, simN, simRule },  // CBC Conjoint — res.indivUtils: utilidades individuales suavizadas; simRule: 'sop'|'fc'|'agg' (nuevo, v5.1 — simulador heterogéneo, ver 4.6.E)
  m:   { items, vers, design, data, res },                    // MaxDiff — res.indivScores: net/norm ya suavizados con Empirical Bayes
  vw:  { data, res },                                         // Van Westendorp
  nms: { data, res },                                         // NMS
  turf:{ items, data, res },                                  // TURF
  edu: { step, caseId, startTime, analysisSnapshot, ... }    // Modo Aprendizaje
}
```

### Colores y constantes visuales

```javascript
const PCOLS = ['#c8430a', '#2563a8', '#1a7a4a', '#7c3aed']  // colores de producto
const COLS  = ['#c8430a', '#2563a8', '#1a7a4a', '#7c3aed', '#d97706', '#0891b2']  // colores generales
```

### RNG reproducible

```javascript
function rng(seed) {
  let s = seed;
  return function() { s = (s * 9301 + 49297) % 233280; return s / 233280; };
}
// Usado en todos los genData() con seeds fijos para reproducibilidad
```

### Patrón de bifurcación en Modo Aprendizaje

```javascript
function renderEduResults() {
  if (eduIsTURF())     { renderEduResultsTURF();     return; }
  if (eduIsMaxDiff())  { renderEduResultsMaxDiff();  return; }
  if (eduIsConjoint()) { renderEduResultsConjoint(); return; }
  // fallback: VW/NMS
}
```

---

## 7. Propuesta de nuevos módulos

Las siguientes extensiones fueron propuestas para la siguiente fase. Todas responden a la filosofía del proyecto.

### 7.1 Mapa de Posicionamiento (Análisis de Correspondencias) — **DISEÑO COMPLETO, listo para implementación**

> Especificación cerrada en sesión de continuación del 19 de julio de 2026 (ver 4.7 para el detalle completo de cómo se llegó a cada decisión). Este bloque reemplaza la propuesta breve original y es la referencia autoritativa para implementar el módulo. No requiere más diseño previo — el siguiente paso es codificar.

- **Problema gerencial**: ¿Cómo se percibe nuestra marca en relación a la competencia y los atributos del mercado?
- **Output**: mapa perceptual interactivo en Canvas con marcas y atributos en el mismo espacio bidimensional
- **Decisión gerencial**: identificar huecos de posicionamiento, detectar atributos diferenciadores, estrategia de reposicionamiento
- **Viabilidad técnica**: implementable en Vanilla JS sin librerías externas

**Tres formatos de entrada soportados** (detección automática por regex de headers, salvo el 3°):

| Formato | Estructura | Código "ninguna" | Disponible en |
|---|---|---|---|
| P&P (manual/wide) | `P{q}_{atributo}_{slot}`, un slot por marca posible; valor de celda = código de marca elegido en ese slot | **`99`** (numérico) | Modo Aprendizaje + Modo Cálculo |
| Forms (digital/long) | `P{q}_{atributo}`, texto de marcas separado por comas | **`'NONE'`** (string, mayúsculas) | Modo Aprendizaje + Modo Cálculo |
| Contingencia directa (tabla ya agregada) | Filas = atributos, columnas = marcas, celdas = conteos | N/A (no aplica, no hay nivel de encuestado) | **Solo Modo Cálculo** — Modo Aprendizaje necesita datos individuales para conectar con `renderEduInstrument()` y el diagnóstico de calidad |

Regla defensiva: el parser tolera `'NONE'` también en archivos P&P (con advertencia no bloqueante), para no romper con el desliz de nomenclatura más común, aunque `99` es la convención oficial documentada al usuario.

**Pipeline del parser** (formato-agnóstico a partir del paso 4): `corrDetectFormat` → `corrParsePP`/`corrParseForms` (colapsan a `Set<marca>|'NONE'` por encuestado×atributo) → `corrNormalize` (usa índice de fila como ID interno, nunca el `ID` del Excel — evita colisiones si hay duplicados) → `corrBuildMatrix` (conteo atributo×marca) → `corrApplyRareThreshold`.

**Regla de limpieza — conflicto "marca + ninguna" en la misma celda**: se conserva la marca seleccionada, se descarta solo el "ninguna" de esa celda puntual. **No se elimina el caso completo** (razón: el conflicto es local a una celda, no invalida los demás atributos de ese encuestado; ver D17). Se cuenta en diagnóstico (`diag.conflictCells`), nunca se oculta.

**Filas completamente vacías** (sin marcador explícito): se tratan igual que un "ninguna" explícito, pero se cuentan aparte (`diag.blankAsNone` vs. `diag.explicitNone`) para que el estudiante distinga desinterés real de un problema de digitación.

**Categorías raras (marcas/atributos con pocas menciones)**: en vez de eliminarlas, se tratan como **puntos suplementarios** (método estándar de Greenacre) — se excluyen del cálculo de los ejes pero se proyectan igual en el mapa, con estilo visual atenuado. Umbral por defecto: **5% del total de menciones de la tabla**, configurable — con base documentada en Le Roux & Rouanet (convención de modalidades raras en MCA), no en un criterio flotante tipo media−DE (evaluado y descartado, ver D18).

**Mínimos técnicos obligatorios**: bloquear el análisis si quedan menos de 3 marcas activas o menos de 3 atributos activos, tras cualquier filtro.

**Algoritmo**: matriz de residuos chi-cuadrado estandarizados `S_ij=(P_ij−r_i·c_j)/√(r_i·c_j)` → diagonalización de `Sᵀ·S` (la matriz simétrica más chica, normalmente marcas×marcas) vía **algoritmo de Jacobi** (iterativo, ~100 iter máx, tolerancia 1e-9) → coordenadas principales de marcas y atributos, masa, % de inercia por eje, y `cos²` (calidad de representación, requiere el espectro completo, no solo 2 dimensiones). Puntos suplementarios se proyectan reutilizando las coordenadas estándar ya calculadas (sin una segunda descomposición). Advertencia informativa si >20% de celdas tienen valor esperado `E_ij<5` (regla de Cochran).

**Diseño visual del mapa (Canvas)**: mapa **simétrico** centrado en el origen (no arranca en 0 como los demás charts del kit). Marcas = círculo, color de `PCOLS`, **vector trazado desde el origen** (ayuda a interpretar ángulos/dirección), con su nombre real como etiqueta. Atributos = cuadrado, color neutro único, **etiquetados con número (1,2,3...)** en vez de texto completo (para no saturar el mapa), con una leyenda HTML aparte (número→nombre completo) debajo del canvas — mismo patrón de leyenda ya usado en VW/NMS (`.vw-leg-item`). Tamaño de marcador = masa; opacidad = `cos²`; borde punteado = punto suplementario. Colisión de etiquetas resuelta con desplazamiento greedy simple. Ejes rotulados con % de inercia explicada. Tabla HTML de respaldo (nombre/tipo/masa/cos²/activo-suplementario) en vez de tooltips interactivos (ningún otro módulo del kit usa hover sobre Canvas — se mantiene la consistencia).

**Caso pedagógico**: `posicionamiento_energ` (o nombre similar) — bebidas energéticas, Lima Metropolitana, 150 encuestados, 5 marcas (`VoltMax` líder, `PowerShot` retadora, `EcoFuel` económica, `ZenBoost` premium, `NicheCharge` nicho — diseñada deliberadamente con probabilidades base bajas en todos los atributos para caer como punto suplementario real, no un recorte artificial), 10 atributos bilingües. `genData()` genera **respuestas individuales crudas en formato Forms** (no una matriz precocinada), para que el caso ejercite el mismo parser que usaría un archivo real subido por un profesor, y conecte con `renderEduInstrument()`.

**Contenido bilingüe ES/EN**: completo y cerrado — textos de `EDU_PROBLEMS`/`EDU_CASES`, 3 preguntas pretest + 3 postest, ~13 claves `corr.*` de advertencias/diagnóstico/leyenda, y plantilla de `fallbackPositioning()` (4 claves de interpolación: par marca-atributo más fuerte, marca más aislada, hueco de posicionamiento sin marca cercana, nota sobre puntos suplementarios). Ver detalle completo en el turno de la conversación donde se redactó — no repetido aquí para no duplicar contenido; **pendiente**: trasladar ese contenido al bloque `I18N` real del archivo HTML al momento de implementar.

**Riesgos de arquitectura identificados**:
- El render Canvas del mapa (simétrico, con vectores y etiquetas numeradas) no reutiliza el código de barras existente — es un tipo de dibujo nuevo.
- El parser de 3 formatos con detección automática es lógica nueva sin precedente en el kit (los demás módulos tienen un solo formato de entrada) — mayor superficie de bugs silenciosos si el diccionario de marcas no calza con los códigos del archivo.
- Exportación a script R (`library(ca)`) queda explícitamente pospuesta, no bloquea el lanzamiento.

**Distinción pedagógica pendiente de redactar en `EDU_PROBLEMS`**: contra Segmentación de Mercados (7.2, aún no implementado) — posicionamiento agrupa *percepciones sobre marcas*, segmentación agrupa *personas*. Dejar el campo de distinción ya reservado en la estructura para cuando 7.2 se implemente.

**Contribución a los ejes — insight interpretativo, no visual**: se calcula `ctr` (contribución de cada punto activo a los 2 ejes mostrados, usando `Φ`/`Γ`/`λ₁`/`λ₂`, ya disponibles del cálculo de CA — sin costo adicional). Regla estándar en CA/PCA: un punto con `ctr < 1/n` (n = cantidad de puntos activos de ese tipo) aporta menos de lo esperado si todos contribuyeran por igual — es decir, **no diferencia** en el mapa. Aplica simétricamente a marcas y atributos. Se muestra como sección aparte en la **capa interpretativa** ("Atributos que no diferencian a las marcas" / "Marcas sin posicionamiento distintivo"), calculada directamente de los números — resuelve el caso donde varios puntos quedan visualmente amontonados cerca del origen (validado con datos reales: la regla identificó exactamente los 4 atributos que se veían apretados en el centro del mapa de prueba, sin necesidad de tocar el layout ni los datos). Nueva clave de `fallbackPositioning()`: `corr.fallback.nondiscriminating`.

**Estado de implementación (Etapas 1-3, ya validadas de forma aislada antes de tocar el HTML)**:
- **Etapa 1 (parser)**: 3 formatos + reglas de limpieza — 17/17 pruebas (9 con el Excel real del usuario, 9 casos límite sintéticos). Verificado que P&P y Forms producen resultados idénticos celda por celda.
- **Etapa 2 (algoritmo)**: Jacobi + puntos suplementarios — validado numéricamente contra `scipy.linalg.svd` (coincidencia hasta 1e-16) y contra la fórmula de transición baricéntrica de Greenacre (verificada independientemente en Python). Se encontró y corrigió un bug real: la proyección suplementaria tenía una multiplicación de más por el valor singular. Se agregó `fixAxisSigns()` (mismo patrón que `sklearn.svd_flip`) para que la orientación del mapa sea determinística y no dependa del signo arbitrario que devuelva la diagonalización.
- **Etapa 3 (visual Canvas)**: `drawCorrespondenceMap()` + `corrPlaceLabels()` (colisión de etiquetas por spiral search) probados con un caso de 15 atributos — 0 solapamientos residuales incluso en un caso extremo de 15 puntos artificialmente amontonados. Decisión de diseño clave: el marcador siempre se dibuja en la coordenada verdadera (nunca se desplaza, para no misrepresentar el dato); solo la etiqueta legible puede desplazarse, con una línea guía delgada de vuelta al punto verdadero cuando esto ocurre.
- **Etapa 4 (integración al archivo real)**: **completa**. Sub-pasos ejecutados y validados en orden: (1) motor puro (parser P&P/Forms + algoritmo CA + dibujo del mapa) insertado y verificado numéricamente idéntico a las Etapas 1-3; (2) parser de tabla de contingencia (3er formato) diseñado, probado (11/11 casos, incluida la corrección de dar un error específico ante valores negativos en vez de uno genérico) e integrado; (3) integración pedagógica completa (`EDU_PROBLEMS.posicionamiento`, `EDU_CASES.bebidas_energ` con `genData()` en formato Forms y la marca `NicheCharge` deliberadamente rara, `EDU_QUESTIONS_BY_CASE`, helper `eduIsPositioning()`, bifurcaciones y funciones de render `renderEduDiagPositioning`/`renderEduResultsPositioning`/`renderResultsRecapPositioning`), validada con una prueba de integración jsdom que corre el wizard completo dentro del HTML real; (4) módulo completo de Modo Cálculo (tab, wizard de 4 pasos, soporte a los 3 formatos de entrada incluyendo diccionario dinámico de marcas para P&P), validado con archivos reales/realistas en los 3 formatos; y (5) las 4 bifurcaciones finales de Modo Aprendizaje (`copyAIPrompt`, `downloadReport`, `downloadCSV`, `evalMeth`, esta última con 2 opciones nuevas en el selector metodológico), validadas end-to-end.

**Metodología de validación usada en toda la Etapa 4**: cada sub-paso se probó de forma aislada (Node) antes de insertarse en el HTML, y tras cada inserción se corrió (a) validación de sintaxis con acorn, (b) verificación de balance de `<div>`, y (c) al menos una prueba de integración con jsdom que ejecuta el código real dentro del archivo (no una reimplementación de prueba) para detectar errores de runtime que la sola sintaxis no puede ver. Esto encontró y corrigió 2 bugs reales antes de llegar aquí: la proyección de puntos suplementarios (Etapa 2, ver más arriba) y el manejo de valores negativos en la tabla de contingencia (Etapa 4, sub-paso 2).

**Limitación de las pruebas**: jsdom no ejecuta un navegador real — no valida CSS visual, comportamiento de foco/teclado, ni carga de scripts externos (SheetJS/GoatCounter se stubearon o se compartió la misma instancia de la librería `xlsx` de Node). Antes de considerar el módulo 100% listo para producción, sigue pendiente una prueba manual en un navegador real (ver sección 11, punto sobre MCP de navegador).

**Exportación a Excel — implementada en 4.8**: `expCorr()` genera un workbook de 4 hojas (Coordenadas, Residuos estandarizados, Inercia por dimensión, Conclusiones). **Sin script R** — decisión explícita, ver D22.

**Bug real encontrado por el usuario tras subir el archivo (corregido) — i18n incompleto**: las ~27 claves `calc.corr.*` usadas en el HTML estático del wizard de Modo Cálculo (títulos, descripciones, dropzone, botones) nunca se agregaron al diccionario `I18N` — solo se habían agregado 3 claves sueltas (`corr.map.dim1/dim2`, `edu.instr.corr.tips`). El resultado: toda la interfaz del Paso 1 mostraba el texto crudo de la clave en vez de la traducción (ej. "calc.corr.what.title" en pantalla). Se agregaron las 27 claves faltantes en ES/EN.

**Lección de testing (i18n)**: las pruebas de integración jsdom de esta sesión verificaban que el HTML se generaba (`innerHTML.length > 0`) y que no había errores de JS — pero **nunca verificaron que el texto visible no fueran claves i18n sin traducir**. Es un tipo de bug que no lanza excepción ni rompe la funcionalidad (por eso pasó desapercibido en 4 rondas de pruebas), pero rompe la experiencia completa del usuario. Para módulos futuros, agregar una verificación explícita tipo `verify_no_raw_keys` (buscar patrones `data-i18n` sin resolver en `textContent`, no en `innerHTML`) como parte del checklist estándar de validación, no solo verificar longitud de contenido.

**Segundo bug real encontrado por el usuario tras subir el archivo (corregido) — escala del mapa**: el mapa se veía con mucho espacio en blanco y los puntos apiñados al centro. Causa raíz matemática confirmada con render real (node-canvas) y medición analítica: el código forzaba un cuadrado simétrico `±maxAbs` en las 4 direcciones desde el origen (0,0), pero los datos reales casi nunca llegan igual de lejos en las 4 direcciones (ej. el punto más extremo en X no es el mismo que el más extremo en Y) — eso desperdiciaba la mayor parte del canvas (medido: solo 52-54% de ocupación real antes del fix). Se corrigió para ajustar al rectángulo real que ocupan los datos (incluyendo el origen, para que los ejes sigan siendo visibles), manteniendo la regla no negociable de una sola escala para ambos ejes (sin distorsión). Tras el fix: 59-62% de ocupación, cerca del límite teórico (~73-77%) dado el margen fijo reservado para las etiquetas de los ejes. Los vectores marca→origen y el cruce de ejes también se corrigieron para partir del origen verdadero en píxeles (que ya no coincide necesariamente con el centro geométrico del canvas), no de un centro fijo asumido.

**Lección de testing (render visual)**: ninguna de las pruebas jsdom anteriores habría detectado este bug, porque todas usaban un stub vacío de `getContext()` (sin dibujar nada real) — solo verificaban que la función se llamara sin errores, no que el resultado visual fuera razonable. Se resolvió instalando `node-canvas` para renderizar píxeles reales y medir analíticamente/por imagen el porcentaje de ocupación del canvas. Para cambios futuros al render del mapa, usar este mismo método (render real + medición de bounding box) en vez de solo verificar ausencia de errores.

**Tercer bug real encontrado por el usuario (corregido) — punto suplementario desaparecía del mapa**: `corrProjectSupplementary()` nunca le asignaba el campo `mass` a los puntos suplementarios (solo `mentions`). En `drawCorrespondenceMap()`, el radio del círculo se calcula como `5+p.mass*20` — con `mass` indefinido eso da `NaN`, y el navegador deja de dibujar ese punto silenciosamente (sin lanzar error visible), aunque su vector sí se dibujaba (esa parte del código no depende de `mass`), lo que hacía muy confuso el síntoma (línea visible, sin marcador ni etiqueta al final). Se corrigió agregando `mass:mentions/grandTotal` en `corrProjectSupplementary()`, más un fallback defensivo `||0` en los cálculos de tamaño de `drawCorrespondenceMap()` para que un problema similar en el futuro produzca un punto pequeño en vez de uno invisible. Verificado con conteo de píxeles del color exacto de la marca en un render real.

**Funcionalidad agregada — interpretación automática en Modo Cálculo (Paso 4)**: el módulo de Posicionamiento no tenía la sección de "Conclusiones del análisis" (IA/fallback) que sí tienen los demás módulos de Modo Cálculo. Se agregó `fallbackPositioning()` (texto determinístico: asociación marca-atributo más fuerte, marca más distintiva, hueco de posicionamiento, atributos/marcas no diferenciadores vía `ctr` — mismo criterio D20 ya usado en Modo Aprendizaje pero en formato de prosa en vez de tarjetas) y `genCorrAI()` (llama a `callAI()` con ese fallback, mismo patrón que `genVWAI()` etc.), conectado al final de `runCorrAnalysisCalc()` y con su contenedor HTML (`.aic`/`#corrai`) en el Paso 4, idéntico visualmente a los demás módulos.

**Corrección metodológica de fondo (D21) — residuos estandarizados en vez de distancia geométrica, con números siempre visibles**: el usuario pasó una crítica externa (evaluación de un experto en CA) que identificó que la lógica de interpretación automática original tenía un problema real, no cosmético: usaba **distancia geométrica** en el mapa para decidir "asociación marca-atributo" y "hueco de posicionamiento", cuando el estadístico correcto en Análisis de Correspondencias es el **residuo estandarizado** de la tabla original (positivo = sobre-representado/atraído, negativo = repelido) — la distancia visual en un mapa simétrico es solo aproximada (nota metodológica que ya existía, pero la lógica de interpretación no la respetaba en la práctica). Además, el texto no mostraba ningún número de respaldo (cos², masa, contribución), lo que impedía verificar las afirmaciones.

Se corrigió de raíz:
1. `corrRunCA()` ahora expone `stdResiduals` (la matriz `S` ya calculada internamente para el SVD, indexada igual que `coordsAttrs`/`coordsBrands` — no cuesta cálculo adicional).
2. Nueva función compartida `corrBuildInterpretation(ca, supp)`: para cada marca activa, encuentra su atributo con **mayor residuo estandarizado** (no el geométricamente más cercano), y detecta si otra marca comparte ese mismo atributo con un residuo similar (≥70% del máximo) — marcándolo explícitamente como "territorio compartido, no exclusivo" (exactamente el error que señaló la crítica sobre PowerShot/VoltMax). El "hueco de posicionamiento" pasó a ser el atributo con **menor residuo máximo entre todas las marcas activas** (ninguna lo posee claramente), no el geométricamente más lejano — con lenguaje de cautela explícito ("debe confirmarse con la tabla completa de residuos, no solo con este resumen").
3. Tanto `fallbackPositioning()` (Modo Cálculo) como la capa interpretativa de `renderEduResultsPositioning()` (Modo Aprendizaje) usan ahora esta misma función compartida, y **siempre imprimen los números** (residuo, cos², masa, ctr) junto a cada afirmación — nunca una afirmación cualitativa sin el dato que la respalda.
4. `copyAIPrompt()`, `downloadReport()`, `downloadCSV()` y el prompt de `genCorrAI()` (para cuando sí hay API key configurada) se actualizaron igual, para que la IA externa reciba los mismos residuos/ctr como contexto y no solo masa/cos².

Validado end-to-end con el caso demo: confirma numéricamente que VoltMax y PowerShot comparten "Da energía real" (residuos 0.06 y 0.08), identifica "Marca confiable" como hueco (residuo máximo=0.02, distinto del resultado anterior basado en distancia), y lista explícitamente ctr de cada no-diferenciador.

**Lección de fondo**: una simplificación "genérica" en la interpretación automática no es solo menos informativa — puede ser **metodológicamente incorrecta** si el atajo (distancia geométrica) no es el estadístico que realmente sustenta la afirmación (asociación real vía residuos). Para futuros módulos con capa interpretativa automática, verificar explícitamente que el criterio usado sea el estadísticamente correcto para la técnica, no solo el más fácil de calcular a partir de las coordenadas ya disponibles, y exponer siempre los números de respaldo en la salida.

**Extensión — tabla de estadísticos completa + matriz de residuos visible**: la tabla numérica (Modo Aprendizaje y Modo Cálculo) solo mostraba `Masa %` y `Rep. %` (que en realidad ya era el cos², solo con un nombre ambiguo — el usuario preguntó explícitamente si eran lo mismo). Se corrigió: la columna se renombró a `cos² %` sin ambigüedad, se agregó `Contrib. ejes %` (el `ctr` ya calculado, mostrando "—" para puntos suplementarios ya que por definición no contribuyen a los ejes), y se agregó una **matriz completa de residuos estandarizados** (atributo × marca) debajo de la tabla principal, coloreando en verde los residuos positivos (evidencia de asociación real) — el mismo número que ya usa `corrBuildInterpretation()` para las afirmaciones de texto, ahora visible en su forma completa para que el usuario pueda verificar cualquier par marca-atributo por sí mismo, no solo los que el texto decide mencionar.

**Extensión final — gráfico de barras de inercia por dimensión (scree plot)**: agregado a ambos modos (`corrScreeHtml()`, función compartida), justo debajo de la matriz de residuos. Muestra el % de inercia de **todas** las dimensiones del rango de la solución (no solo Dim1/Dim2 ya graficadas), con las 2 primeras resaltadas en color y el resto en gris. Decisión de diseño (discutida explícitamente con el usuario antes de codear): **no** se implementan gráficos adicionales Dim1-Dim3/Dim2-Dim3 ni un visor 3D dentro del kit — se verificó con el caso demo que Dim3 solo explica 2.2% de la inercia (Dim1+Dim2 ya cubren 97.8%), por lo que en la gran mayoría de casos reales de posicionamiento esas dimensiones adicionales son ruido, no señal. En vez de eso, el scree plot le da al usuario la evidencia (el % real de Dim3+) para decidir por sí mismo si vale la pena exportar las coordenadas (ya posible vía CSV) y explorarlas en software especializado (ej. paquete `ca` de R, que sí tiene visualización 3D madura) — coherente con "no reinventar herramientas que el software estadístico ya resuelve bien".

**Estado del módulo al cierre de la sesión de continuación (19 de julio)**: funcionalmente completo — parser (3 formatos), algoritmo (Jacobi + puntos suplementarios + residuos + contribución), visual (mapa Canvas con colisión de etiquetas, escala ajustada al rectángulo real de datos), integración completa a Modo Aprendizaje y Modo Cálculo, interpretación automática metodológicamente correcta (residuos estandarizados, no distancia geométrica) con todos los números de respaldo visibles, y scree plot.

**Cierre del módulo (sesión 4.8, 20 de julio)**: exportación a Excel implementada (`expCorr()`, 4 hojas). Prueba manual en navegador real ejecutada por el usuario — sin incidencias reportadas. El módulo se da por **completo**, sin exportación a script R (D22).

### 7.2 Segmentación de Mercados

Módulo compuesto con tres técnicas encadenadas pedagógicamente:

| Técnica | Propósito en el flujo | Algoritmo |
|---------|----------------------|-----------|
| **Cluster Analysis** | Identificar segmentos naturales | K-Means (k=2–6) con criterio de codo (WSS) |
| **Árbol de Decisión** | Describir segmentos con variables observables | CART simplificado (Gini impurity, profundidad máx 4) |
| **Regresión Logística** | Probabilidad de pertenencia a un segmento | Regresión logística binomial (gradient descent) o multinomial |

**Flujo pedagógico sugerido**:
1. Cluster → asignar segmento a cada encuestado
2. Árbol → perfilar cada segmento con variables sociodemográficas/actitudinales observables
3. Logística → scoring: dado un nuevo individuo, ¿a qué segmento pertenece con qué probabilidad?

**Input**: variables de actitud/comportamiento por encuestado (escala Likert o binarias)

**Output**: mapa de segmentos, árbol visual, tabla de probabilidades P(segmento|variables)

**Caso pedagógico sugerido**: segmentación de consumidores de servicios financieros en Lima

**Viabilidad técnica**: K-Means y regresión logística son implementables en Vanilla JS. El árbol CART requiere ~150 líneas adicionales.

### 7.3 Otras extensiones posibles (prioridad menor)

| Módulo | Algoritmo | Justificación |
|--------|-----------|---------------|
| Análisis Factorial | PCA / FA con rotación Varimax | Reducción de dimensiones previa al cluster |
| Regresión lineal múltiple | OLS con diagnósticos | Modelos de predicción de intención de compra |
| Escalamiento Multidimensional (MDS) | SMACOF | Alternativa al mapa de correspondencias |

---

## 8. Decisiones de diseño confirmadas

No revertir sin discusión explícita.

| # | Decisión | Detalle |
|---|----------|---------|
| D1 | RNG con seed fija | Todos los `genData()` usan seeds fijos para reproducibilidad |
| D2 | ~~Sin re-render automático al cambiar idioma~~ **REVERTIDA en v5.1** | Ahora `applyI18n()` sí re-renderiza CBC/MaxDiff (y el picker de decisión de Modo Cálculo) si ya hay resultados calculados — ver 4.6.D. Motivo del cambio no documentado por esta conversación (trabajo externo integrado); si se revierte de nuevo, hacerlo con discusión explícita, igual que cualquier otra decisión de esta tabla |
| D3 | Exclusión del scope i18n | Script R (comentarios en ES), nombres de hojas Excel internas, genXAI en ES salvo solicitud |
| D4 | Simulador CBC en Modo Aprendizaje | Escenarios pre-configurados, no simulador interactivo |
| D5 | "Salud Directa" bilingüe | Nombre de empresa igual en ES y EN |
| D6 | 2 productos por defecto en simulador | El simulador CBC del Modo Cálculo inicia con 2 productos |
| D7 | Gumbel noise scale=1.0 | Para `loadCDemo()` y `genData()` de casos pedagógicos CBC |
| D8 | Estrategia i18n mixta | HTML estático → `data-i18n`; JS dinámico → ternarios `_lang==='es'?...:...`. Extendida en 4.6.B con `data-i18n-title` (mismo patrón que `data-i18n-ph`, para atributos `title`) |
| D9 | Bayesian smoothing: Empirical Bayes cerrado, no MCMC completo | HB-MNL con Metropolis-Hastings evaluado y descartado por costo de complejidad/mantenimiento; se implementó el espíritu del paper de Orme (2026) con fórmula cerrada precision-weighted |
| D10 | ~~Simulador de market share CBC sigue homogéneo~~ **RESUELTA en v5.1** | Simulador heterogéneo implementado con 3 reglas seleccionables (`sop`/`fc`/`agg`) — ver 4.6.E. Ya no es trabajo pendiente |
| D11 | Nunca nombrar una variable local `t` en funciones a traducir | Colisión con la función global `t()` de i18n; encontrado y corregido en `renderMC()` y `renderCC()` |
| D12 | Analítica sin cookies ni PII (GoatCounter) | Se eligió sobre Plausible/Umami/GA por ser gratis para uso no comercial y no requerir servidor propio (Umami) ni costo recurrente (Plausible) — ver 4.6.A |
| D13 | Modo Aprendizaje debe confirmar antes de perder progreso, igual que Modo Cálculo | `startEduCase()` ahora pasa por `confirmModal()` si hay progreso real (`hasProgress`); antes solo `resetMod()` (Modo Cálculo) tenía esta guarda — asimetría corregida en 4.6.B |
| D14 | Modo Cálculo se presenta como decisión de negocio primero, técnica después | Nuevo picker `#calc-decision-wrap` reutiliza `EDU_PROBLEMS`; la barra de pestañas técnicas (`#mbar-calc`) se conserva debajo, no se elimina — ver 4.6.C |
| D15 | La API key de OpenAI es una función avanzada opcional, nunca protagonista | Colapsada por defecto detrás de un toggle discreto (`.api-bar-mini`); copy explícitamente no-técnico ("Activar conclusiones asistidas por IA") — ver 4.6.C |
| D16 | Número de versión desde una única constante (`APP_VERSION`) | Evita que la versión mostrada se desincronice entre header/reporte/scripts R como pasó entre v5.0 y v5.1 — ver 4.6.C |
| D17 | Conflicto "marca + ninguna" en la misma celda: conservar la marca, descartar el "ninguna" | No eliminar el caso completo — el conflicto es local a una celda, no invalida el resto del encuestado; se cuenta en diagnóstico, nunca se oculta. Definida en el diseño del módulo de Posicionamiento (7.1), ver 4.7 |
| D18 | Umbral de categorías raras en CA: 5% de menciones totales, no media−1DE | El criterio original propuesto (media−DE) es inestable con pocas marcas y no reproducible entre estudios; se adoptó el umbral documentado en Le Roux & Rouanet (MCA) junto con el método de puntos suplementarios de Greenacre en vez de eliminación directa — ver 4.7 |
| D19 | Formato de entrada "tabla de contingencia directa" (Posicionamiento) solo en Modo Cálculo | Modo Aprendizaje requiere datos individuales para el diagnóstico de calidad y el puente pedagógico `renderEduInstrument()`; una tabla ya agregada pierde esa capa de aprendizaje — ver 4.7 |
| D20 | Criterio de "atributo/marca no diferenciador" en Posicionamiento: contribución (`ctr`) por debajo de `1/n`, no proximidad visual al origen | Regla estándar de CA/PCA, calculada de los números (no del layout del mapa); resuelve el caso de puntos visualmente amontonados sin tocar datos ni gráfica — validado con datos reales, identifica exactamente los puntos apretados. Ver 4.7 |
| D21 | Interpretación automática de Posicionamiento (asociación marca-atributo, hueco de posicionamiento): usa residuos estandarizados (`stdResiduals`), no distancia geométrica en el mapa; siempre imprime los números de respaldo (residuo, cos², masa, ctr) | Corrección de una crítica externa real: la distancia visual en un mapa simétrico de CA es solo aproximada; el estadístico correcto de asociación es el residuo estandarizado de la tabla original. Compartido entre Modo Cálculo y Modo Aprendizaje vía `corrBuildInterpretation()`. Ver sesión de continuación posterior a 4.7 |
| D22 | Posicionamiento no exporta script R (solo Excel) | Solo 2 de los 6 módulos del kit (CBC, MaxDiff) tienen script R — no es un estándar universal a igualar. Un script R fiel a Posicionamiento tendría que reimplementar el parser de 3 formatos de entrada (P&P/Forms/contingencia) en otro lenguaje sin caso de uso real que lo pida; en vez de eso, el script R asumiría partir de la tabla de contingencia ya calculada (`library(ca)`), que es exactamente lo que ya se puede exportar vía Excel/CSV. Decidido con el usuario en 4.8, no evaluado como trabajo pendiente |

---

## 9. Convenciones de código

### Reemplazo de funciones JS

Siempre reemplazar el bloque completo de la función. Nunca usar anclas parciales que puedan coincidir con contenido interno de la función.

```
✅ Correcto: reemplazar desde `function foo(){` hasta su `}` final
❌ Incorrecto: anclar por un comentario interno que pueda aparecer también dentro del cuerpo
```

### Naming de claves DICT

```
calc.[modulo].[seccion].[elemento]   → específicas del módulo
calc.[elemento]                      → compartidas entre módulos
```

Ejemplos: `calc.vw.pts.title`, `calc.btn.prev`, `calc.export.title`

### Validación de sintaxis

Antes de entregar cualquier archivo, validar con acorn:

```javascript
// acorn instalado en /home/claude/node_modules/acorn
const acorn = require('/home/claude/node_modules/acorn');
acorn.parse(code, { ecmaVersion: 2022, sourceType: 'script' });
```

### Casos pedagógicos — estructura genData()

Para el motor `conjoint`:

```javascript
genData: () => {
  // retorna siempre:
  return { attrs, design, data };
  // attrs: [{name, levels}]
  // design: array de versiones, cada versión es array de tareas, cada tarea es array de perfiles
  // data: [{id_encuestado, version, tarea_1, ..., tarea_T}]
}
```

Para otros motores: array plano de rows según el formato de cada motor.

### Bifurcaciones en Modo Aprendizaje

Siempre agregar la bifurcación al inicio de la función, antes del comportamiento por defecto:

```javascript
function renderEduDiag() {
  if (eduIsMaxDiff())  { renderEduDiagMaxDiff();  return; }
  if (eduIsTURF())     { renderEduDiagTURF();      return; }
  if (eduIsConjoint()) { renderEduDiagConjoint();  return; }
  // fallback: VW/NMS
}
```

---

## 10. Archivos del proyecto

| Archivo | Descripción | Prioridad para nueva conversación |
|---------|-------------|----------------------------------|
| `HANDOFF_Kit_v6_Estado_y_Roadmap.md` | Este documento | Alta — subir al proyecto |
| `kit_investigacion_mercados_v6.html` | **Archivo activo.** Código fuente completo (8.837 líneas). Sin commit/push todavía — ver sección 1 | Alta — subir al proyecto |
| `kit_investigacion_mercados_v5.1.html` | v5.1 — referencia histórica, no editar más | Baja |
| `kit_investigacion_mercados_v5.html` | v5.0 — referencia histórica, no editar más | Baja |
| `PRODUCT.md` | Register, usuarios, positioning, anti-referencias, principios de diseño (generado vía `/impeccable init`) | Alta — da contexto estratégico que este HANDOFF no cubre |
| `README.md` | Descripción pública del repo + link a la demo en vivo | Media |
| `LICENSE` | MIT | Baja |
| `CAMBIOS.md` | Registro de cambios (rebranding a Praxio, accesibilidad WCAG AA, sesión v6.0) | Media |
| `index.html` | Redirect a `kit_investigacion_mercados_v6.html` (actualizado en 4.8), para que la raíz de GitHub Pages funcione una vez se haga push | Baja |
| `.impeccable/critique/*.md` | Snapshot de la crítica de diseño de la sesión del 19 de julio (score 29/40) | Media — backlog para la próxima pasada de polish |
| `.gitignore` | Excluye artefactos de R (`.RData`, `.Rhistory`), `.claude/`, `.impeccable/`, y el prototipo R/Shiny superado (`Ejecutable.R`, `R/analysis.R`, `.Rproj`) | — |

**Nota**: `CONTEXTO_Kit_Investigacion_Mercados.md` (mencionado en versiones anteriores de este HANDOFF) no existe en la carpeta del proyecto — puede haberse perdido o nunca haberse creado. Si hace falta ese contexto, `PRODUCT.md` cubre ahora una función equivalente (más formal, generada por impeccable).

**Prototipo R/Shiny descartado**: el proyecto tenía `Ejecutable.R`, `R/analysis.R` y un `.Rproj` de un prototipo Shiny anterior, ya roto (`Ejecutable.R` dependía de un `app.R` que ya no existe en la carpeta). Se sacaron del repo público esta sesión (siguen localmente, ver `.gitignore`) — no es trabajo pendiente, es historia descartada.

---

## 11. Recomendaciones para la nueva conversación

### Antes que nada: confirmar que no hay una v6.1 dando vueltas

La sesión que reconcilió v5.0 vs. v5.1 (ver 4.6.D) perdió tiempo real por no preguntar esto primero. **Primer paso de la próxima sesión**: preguntar directamente si existe una versión más nueva en la carpeta antes de asumir que `kit_investigacion_mercados_v6.html` sigue siendo la última palabra. También confirmar si ya se hizo `git commit`/`push` de v6.0 (ver sección 1 — al cierre de esta sesión, no estaba hecho).

### Prioridad inmediata

La i18n del Modo Cálculo sigue **completa** (los 6 módulos, incluido Posicionamiento desde 4.7/4.8). El simulador heterogéneo de CBC (antes prioridad #1) **ya está resuelto** en v5.1 — ver 4.6.E. Líneas de trabajo abiertas, en orden sugerido:

1. **Mapa de Posicionamiento (Análisis de Correspondencias)** — **cerrado**. Diseño, código (parser, algoritmo, visual, integración), exportación a Excel (4.8) y prueba manual en navegador real (confirmada por el usuario en 4.8) — todo completo. Sin script R, por decisión explícita (D22), no por pendiente.
2. **Commit + push de v6.0** — cambios locales sin subir al repo (`kit_investigacion_mercados_v6.html`, este HANDOFF, y ediciones a `PRODUCT.md`/`README.md`/`index.html`/`CAMBIOS.md`). El sitio en vivo sigue en v5.1 hasta que se haga.
3. **Aplicar Empirical Bayes shrinkage también al script R exportable** (`buildMScript`, `buildCScript`) — hoy los scripts R usan `mlogit`/conteo simple sin ningún smoothing; sería consistente ofrecer también ahí una versión con `bayesm` o `ChoiceModelR` (HB real) como alternativa avanzada.
4. **Único minor observation de la crítica de diseño (4.6.B) que sigue pendiente**: los 6 `transition:width` (CBC/VW/NMS bar fills) deberían migrar a `transform` para evitar jank. Es el más laborioso de los 5 encontrados — el texto (%) va *dentro* del mismo elemento que se anima, así que animar por `transform:scaleX()` en vez de `width` requiere primero separar la etiqueta de texto de la barra que se escala, en las ~4 funciones de render afectadas (CBC, MaxDiff, TURF/Shapley). Los otros 4 (badge "Retrocedió" sin matiz, botones de export sin distinguir, `role="radio"` faltante, naming `_geminiKey`) se corrigieron en la sesión del 19 de julio, ver 4.6.F.
5. **Configurar un servidor MCP de navegador** (Playwright/Puppeteer/chrome-devtools) si se quiere una crítica de diseño con evidencia visual real — las sesiones anteriores corrieron con la limitación declarada de "sin navegador disponible", basadas en lectura de código fuente únicamente (la prueba manual de Posicionamiento en 4.8 sí se hizo en navegador real, pero por fuera de esta conversación, sin evidencia capturada aquí).

### Módulo más valioso para agregar primero (nuevo módulo, no mejora de existente)

El **Mapa de Posicionamiento (Análisis de Correspondencias)** es la prioridad más alta por tres razones:

1. Es visualmente impactante — el mapa perceptual es el output más reconocible para gerentes y estudiantes
2. No existe ninguna herramienta libre equivalente en español para docencia universitaria
3. El algoritmo (SVD) es implementable en ~100 líneas de Vanilla JS sin librerías externas

### Módulo de mayor complejidad

El de **Segmentación de Mercados** requiere tres algoritmos encadenados (K-Means + CART + Logística). Recomendable implementarlos en módulos separados primero y luego conectarlos en un flujo integrado.

### Nota sobre la arquitectura de nuevos módulos

Para cada módulo nuevo, el patrón establecido es:

1. Agregar entrada en `EDU_PROBLEMS` con `active: true`
2. Agregar caso en `EDU_CASES` con `genData()` interno
3. Agregar preguntas en `EDU_QUESTIONS_BY_CASE`
4. Agregar helper `eduIsXxx()`
5. Bifurcar en: `submitPretest`, `renderEduDiag`, `renderEduInstrument`, `runEduAnalysis`, `renderEduResults`, `renderResultsRecap`, `copyAIPrompt`, `downloadReport`, `downloadCSV`, `evalMeth`
6. Implementar funciones de render: `renderEduDiagXxx`, `renderEduResultsXxx`, `renderResultsRecapXxx`, `renderEduInstrumentXxx` (si el motor requiere contenido de instrumento distinto al fallback VW/NMS)

### Pendientes conocidos (no bloqueantes, documentados para no perderlos)

- Atributos/niveles del caso `plan_salud` (CBC, Modo Aprendizaje) están hardcodeados solo en español — no son objetos bilingües `{es,en}` como el resto del caso.
- El script R exportable (`buildCScript`, `buildMScript`) no incluye Bayesian smoothing (ver punto 3 de "Prioridad inmediata").
