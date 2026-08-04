# HANDOFF — Praxio (Kit de Investigación de Mercados)
## Estado al cierre de conversación · 27 de julio de 2026 (versión v6.2 — ver 4.9 y 4.10)

> **Documento único y vigente.** Consolida todo el estado del proyecto. La versión a publicar es la **v6.2**: `APP_VERSION='6.2'` en el código, y el número aparece en el pie de página, en el instrumento imprimible y en la cabecera de los dos scripts R generados.
>
> **Nota de mantenimiento:** hasta v6.1 el logo del encabezado tenía la versión escrita a mano (`v6.0`) y quedó desincronizada de `APP_VERSION` durante dos versiones. Se corrigió al numerar v6.2 y se le puso `id="logo-version"`. Al subir de versión hay que tocar **ambos** puntos, o mejor, hacer que el logo lea la constante. Si aparecen archivos sueltos tipo `HANDOFF_Addendum_*.md`, `CHANGELOG_Corr_v6.1.md` o `AUDITORIA_Motor_CBC.md` de la sesión del 26 de julio, su contenido ya está integrado aquí y pueden descartarse.

---

## 0. Qué cambió en la v6.2 (resumen ejecutivo)

Versión centrada en el **rigor estadístico** de los seis motores. No agrega módulos nuevos; reescribe dos motores, audita y corrige los cuatro restantes, y alinea los scripts R exportables con el kit.

### Cambios de fondo

| Área | Qué cambió | Decisión |
|---|---|---|
| **CBC** | Motor reescrito: MNL estimado por Newton-Raphson + utilidades individuales como modo de la posterior (MAP), con μ y τ² por Empirical Bayes vía EM. Sustituye el análisis por conteos y el suavizado heurístico | D29 |
| **MaxDiff** | Motor reescrito: logit secuencial best-worst estimado + MAP individual, reutilizando el núcleo numérico de CBC. Puntajes con reescalado exponencial estándar | D30 |
| **Scripts R** | Pasan a ser **implementaciones de referencia** que reproducen el kit exactamente, en R base (solo dependen de `readxl`). Validados ejecutando en R los scripts que genera el propio HTML | D31 |
| **Posicionamiento, TURF, VW, NMS** | Auditados y corregidos. El núcleo estadístico de los cuatro era correcto; los defectos estaban en escalas, umbrales y límites | D32–D36 |

### Correcciones con efecto visible en los resultados

- **TURF ponderado**: el reach ya no reescala a cada encuestado por su propio rango. Antes, con el umbral por defecto, *todo* portafolio de k≥2 alcanzaba al 100% de la muestra y el ranking quedaba empatado. El umbral por defecto sube de 0.30 a 0.50 (D32, D33).
- **NMS**: el paso de la curva de demanda ya no se fuerza a entero. Una gaseosa de S/1.5–6 pasa de 5 puntos de curva a 57 (D32).
- **Posicionamiento**: el umbral de "atributo no diferenciador" se corrige de `1/n` a `2/n`, coherente con la escala de la contribución. Marca más atributos que antes, y también cambia el texto interpretativo (D32, D35).
- **Shapley general (TURF)**: barajado corregido a Fisher-Yates (el anterior tenía 144σ de desviación respecto de la uniforme) y reparto proporcional en vez de restar el mínimo — antes el ítem de menor aporte siempre se mostraba como 0.0% (D35).
- **MaxDiff**: los puntajes usan ahora el reescalado exponencial estándar, con interpretación probabilística. **Los números difieren de corridas previas** (D30).

### Transparencia y diagnóstico

- **NMS**: la calibración de intención de compra deja de estar oculta. Tres presets (conservadora / moderada / optimista) con lectura automática de **sensibilidad**: cuánto se mueve el precio óptimo entre supuestos (D34).
- **VW y NMS**: **intervalos de confianza al 95% por bootstrap** sobre los cuatro puntos de precio y el precio óptimo (D36).
- **NMS**: ya no descarta encuestados en silencio; los reporta desglosados por causa (D35).
- **CBC y MaxDiff**: diagnósticos en escala estándar de la industria (RLH con su referencia de azar) y hoja "Ajuste del modelo" en el Excel (D29, D30).
- **MaxDiff**: la fórmula del número de tarjetas se explica en vivo en el Paso 1 (D24).
- **Posicionamiento**: correcciones sobre los tres formatos de entrada y el mapa (columna "NONE", tamaño y proporción del canvas, legibilidad de etiquetas) — ver 4.9.A.

### Qué revisar al probar esta versión

Las validaciones se hicieron sobre los núcleos numéricos ejecutados en Node y R, no sobre el flujo completo en navegador. Antes de dar por buena la publicación conviene correr los seis módulos con datos reales y confirmar: renderizado con las escalas nuevas (MaxDiff, TURF, NMS), apertura de los Excel exportados, comportamiento del simulador de CBC, y tiempos de cómputo reales en máquina del usuario.

---

## 1. Descripción general del proyecto

Plataforma educativa de investigación cuantitativa de mercados, rebrandeada como **Praxio**.
Single-file HTML + Vanilla JS, sin backend, publicada en GitHub Pages.
Dos modos: **Modo Cálculo** (herramienta técnica, ahora con entrada orientada a decisión de negocio — ver 4.6.C) y **Modo Aprendizaje** (casos guiados pedagógicos).

**Archivo activo**: `kit_investigacion_mercados_v6.2.html` — 8.837 líneas (ver 4.8 — bump de versión a v6.0, analítica y exportación a Excel agregadas al módulo de Posicionamiento)
**Archivos históricos**: `kit_investigacion_mercados_v5.1.html` (v5.1) y `kit_investigacion_mercados_v5.html` (v5.0) se conservan en el repo como referencia, ya no son el activo.

**Publicado en GitHub**:
- Repo: https://github.com/hcornejovillena-cmd/praxio
- Live (GitHub Pages): https://hcornejovillena-cmd.github.io/praxio/ → `index.html` ya redirige localmente a `kit_investigacion_mercados_v6.2.html`, **pero v6.0 todavía no tiene commit ni push** — `git status` muestra `kit_investigacion_mercados_v6.2.html` y este HANDOFF como untracked, y `PRODUCT.md`/`README.md`/`index.html` como modificados sin commitear. El sitio en vivo sigue sirviendo v5.1 hasta que se commitee y pushee.
- Releases: `v5.0` y `v5.1` (tags + GitHub Releases con notas). **v6.0 aún no tiene tag ni release** — pendiente para cuando se decida publicar.
- Licencia: MIT (`LICENSE`)
- `PRODUCT.md` en la raíz documenta register/usuarios/positioning/anti-referencias (generado vía `/impeccable init`)

---

## 2. Módulos del Modo Cálculo

| Módulo | Motor (`engine`) | Estado |
|--------|-----------------|--------|
| CBC Conjoint | `conjoint` | ✅ Activo — motor reescrito a MNL + MAP en v6.1, ver 4.9 y D29 |
| MaxDiff (Best-Worst Scaling) | `maxdiff` | ✅ Activo — motor reescrito a logit secuencial + MAP en v6.1, ver 4.9 y D30 |
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

Sesión de continuación que partió de `kit_investigacion_mercados_v6.2.html` ya con el módulo de Posicionamiento implementado (código de 4.7 + los 5 bugs/extensiones encontrados tras subir el archivo, ya documentados en 7.1). El pedido del usuario fue explícito: la versión debe decir v6 en toda la app, y las funcionalidades que ya tenían los otros módulos (analítica, exportación) debían replicarse en el módulo nuevo.

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

**D. Documentación sincronizada**: `README.md` (lista de 6 módulos, nota sobre Excel/CSV sin R en Posicionamiento, referencias de archivo activo/histórico, versión del footer), `index.html` (redirect a `kit_investigacion_mercados_v6.2.html`), `PRODUCT.md` (Posicionamiento agregado a la descripción de producto, conteo de módulos con i18n completo actualizado a 6, referencias bibliográficas de CA agregadas), este HANDOFF (secciones 1, 5, 6, 7.1, 8, 10, 11), y una nueva entrada en `CAMBIOS.md` (ver ese archivo).

**Pendiente real, no bloqueante**: `git commit` + `push` de todo lo anterior — al cierre de esta sesión seguía sin hacerse (ver sección 1).

---

### 4.9 Sesión — 26 de julio de 2026 — versión v6.1: correcciones de Posicionamiento y reescritura de los motores de elección discreta

Sesión larga, con dos bloques bien distintos: primero la depuración del módulo de Posicionamiento con datos reales del usuario, y después una revisión metodológica de CBC y MaxDiff que terminó en la reescritura completa de ambos motores.

#### A. Mapa de Posicionamiento — correcciones sobre los 3 formatos de entrada

El usuario probó el módulo con archivos reales de los tres formatos y reportó inconsistencias. Todas corregidas y validadas contra sus propios archivos.

1. **Bug — el token `NONE` se colaba como marca (formato Forms).** El parser real (`corrResolveCellForms`) aplicaba correctamente la regla D17 (conservar la marca, descartar el "ninguna" de esa celda), pero una función distinta —`confirmCorrConfig`, la que arma la lista de códigos de marca para que el usuario los nombre— solo descartaba `"NONE"` cuando era el valor **completo** de la celda, no cuando aparecía como token dentro de una lista separada por comas. Resultado: en celdas tipo `"Marca, NONE"`, el `NONE` entraba a `brandDict` y aparecía en el mapa como marca suplementaria con 0 menciones. Corregido alineando ambas lógicas. Validado con `ACorr_Forms.xlsx` (fila 10, `P1_7 = "Omnifit (Omnilife), NONE"`): tras el fix se detectan exactamente las 5 marcas legítimas.

2. **Vacío de especificación — columna `NONE` en tabla de contingencia.** El formato de contingencia no tenía regla equivalente a la de P&P (`99`) y Forms (`'NONE'`), porque se asumió que una tabla ya agregada no traería esa columna. El archivo del usuario demostró que sí puede traerla, y con conteos reales. Ver **D23**.

3. **Aclaración pedagógica — etiqueta "893+2" en el diagnóstico.** Una sola línea sumaba dos conceptos distintos sin explicarlos. Separada en dos líneas autoexplicativas: *"Celdas marcadas explícitamente como 'ninguna marca'"* y *"Celdas vacías sin marcador (ningún atributo asociado, ni siquiera 'ninguna')"*, esta última resaltada como advertencia cuando es mayor a 0, porque puede indicar un problema de digitación. Aplicado en Modo Cálculo y Modo Aprendizaje.

4. **Layout del mapa — dos causas encadenadas.** El usuario reportó el mapa "pequeño y apiñado". Resultaron ser dos problemas distintos:
   - *Tope fijo de 560px*: tanto el `<div>` contenedor como el cálculo JS en `drawCorrespondenceMap` limitaban el canvas a 560px sin relación con el ancho real de la tarjeta (900-1000px en escritorio). Corregido para escalar con el contenedor, con tope de 960px.
   - *Canvas forzado a cuadrado*: ya con el ancho correcto (verificado en la consola del navegador del usuario: `canvas.width=960`, `parentElement.offsetWidth=960`), el mapa seguía viéndose comprimido. La causa era que `canvas.width === canvas.height` siempre. Manteniendo la misma escala en ambos ejes —correcto, para no distorsionar—, un dataset con inercia muy asimétrica (Dim 1 = 91.6%, Dim 2 = 8.4%) queda graficado en una banda horizontal delgada dentro de un cuadrado, con la mayor parte vacía. Ahora el alto se calcula según la proporción real `rangeY/rangeX`, con piso `max(320, 0.35×ancho)` y techo `1.2×ancho` para evitar formas extremas. Caso del usuario: pasa de 960×960 (≈65% en blanco) a 960×336.

5. **Legibilidad — números de atributo.** El número iba en blanco **dentro** del cuadrado, compartiendo la opacidad reducida por `cos²`; con `cos²` bajo (opacidad mínima 0.35) quedaba casi invisible. Ahora el cuadrado conserva el atenuado (esa información sigue siendo válida) pero el número se dibuja **afuera**, en negro sólido y opacidad plena, igual que el nombre de marca junto al círculo.

6. **No-fix documentado — atributos suplementarios.** El usuario cuestionó que los atributos pudieran quedar como suplementarios, argumentando que todos los encuestados evalúan todos los atributos (a diferencia de las marcas, que no todos conocen). Se revisó contra D18: la regla de categorías raras es simétrica para filas y columnas por una propiedad del Análisis de Correspondencias, no por descuido. La "oportunidad de respuesta" no determina la masa de un atributo en la matriz final: un atributo puede ser evaluado por los 144 encuestados y aun así acumular pocas menciones si la mayoría respondió "ninguna marca" para él. **Sin cambios de código**; queda registrado por si se reabre.

#### B. MaxDiff — transparencia de la fórmula de diseño

El usuario preguntó cuál era la justificación metodológica del número de tarjetas. La fórmula (`ns = máx(8, ⌈N×4/K⌉)`) ya estaba implementada desde antes pero nunca se explicaba al estudiante. Ver **D24**.

#### C. Revisión metodológica a partir del paper de Orme (2026)

El usuario aportó *Orme, B. (2026). "Bayesian Smoothing in HB-MNL: An Intuitive Explanation." Sawtooth Software* y pidió evaluar si el kit lo aplicaba correctamente. El paper describe **dos** factores que gobiernan el encogimiento hacia la población en HB-MNL: el **volumen** de elecciones y la **consistencia** de las respuestas (la nitidez de la verosimilitud). La implementación de D9 solo capturaba el primero.

Esto abrió una cadena de trabajo que terminó reescribiendo ambos motores:

1. **D25** — se agregó consistencia individual por validación leave-one-out a MaxDiff.
2. **D26** — se descubrió que en CBC la variable `τ²` se calculaba desde versiones anteriores pero **nunca entraba a la fórmula final** (código vestigial). Se corrigió su estimación (método de momentos, descontando la varianza de muestreo) y se la puso a determinar el peso del shrinkage. En el camino se detectó y corrigió una **regresión introducida en esa misma sesión**: la propiedad suma-cero por atributo se rompía (desviación de hasta 0.4262) porque el peso `w` pasó a variar por nivel; se resolvió con re-centrado, igual que ya hacía MaxDiff.
3. **D27** — normalización del hit rate por el nivel de azar.
4. **Auditoría completa del motor CBC**, que encontró cuatro puntos más (ver D28 y D29).

**Las decisiones D25, D26 y D27 quedaron superadas** por la reescritura posterior. Se conservan en la tabla como registro de la evolución, marcadas explícitamente.

#### D. Reescritura de los motores de CBC y MaxDiff

Motivación declarada por el usuario: dejar ambos módulos en condiciones de resistir una auditoría externa (planteó compartir el enlace con Bryan Orme, autor del paper). Ver **D29** (CBC) y **D30** (MaxDiff) para la especificación completa.

Punto crítico de diseño detectado durante el análisis: una implementación **parcial** —MNL solo a nivel agregado— habría sido *peor* que el estado previo, porque los betas MNL y los logits de conteos están en escalas distintas y el suavizado consiste precisamente en mezclar ambos niveles. Por eso se implementó MNL en los dos niveles o en ninguno.

**Resultados de validación** (simulación con parámetros conocidos, réplica aislada del núcleo numérico ejecutada en Node):

| Prueba | Resultado |
|---|---|
| CBC — recuperación de parámetros (N=300 homogéneos) | Error absoluto medio **0.021** |
| CBC — correlación utilidad individual verdadera vs. estimada (2 segmentos opuestos) | **0.920** |
| MaxDiff — recuperación agregada (12 ítems, N=400) | Error absoluto medio **0.040** |
| MaxDiff — correlación individual (2 segmentos invertidos) | **0.81 – 0.85** según configuración |
| Suma cero por atributo / por ítem | Exacta (por construcción de la codificación) |

**Rendimiento medido** (tiempo total del ajuste, incluido el EM):

| Configuración | Tiempo |
|---|---|
| CBC 3 atributos × 3 niveles, N=120 | 231 ms |
| CBC 5 × 4, N=300 | 797 ms |
| CBC 6 × 5, N=500 | 2.4 s |
| CBC 8 × 6, N=800 | 9.1 s |
| MaxDiff 12 ítems K=4, n=150 | 321 ms |
| MaxDiff 30 ítems K=5, n=300 | 1.5 s |

El costo domina por `N × P³` (inversión de la información por encuestado). Se añadieron **iteraciones EM adaptativas** (`workUnit = N × P²`: >800k → 3; >200k → 4; en otro caso 6). Justificación medida: entre 6 y 10 iteraciones EM la correlación individual solo mejora 0.003.

#### G. Alineación de los scripts R exportables

Al cerrar los motores quedó una inconsistencia concreta: el script R de CBC ya usaba `mlogit` —es decir, **antes de v6.1 el script R era más riguroso que el kit**, que hacía análisis por conteos—, pero calculaba la importancia sobre las utilidades agregadas. Tras D28(d) el kit la calcula por encuestado y la promedia, y la diferencia no es cosmética: sobre los mismos datos sintéticos, 23.4% frente a 42.1% para el mismo atributo.

Se descartó apoyarse en `bayesm`/`ChoiceModelR` como motor: hacen HB por MCMC completo y entregan medias posteriores con priors propios, no modos posteriores con τ² estimado por EM. Darían números parecidos pero nunca idénticos — inútil cuando el objetivo es que un tercero pueda **verificar**. Ver **D31**.

**Validación cruzada JS ↔ R.** Se generaron datos sintéticos, se corrió el motor JS, y se ejecutaron en R los scripts **tal como los produce el HTML** (no una versión adaptada a mano) sobre los mismos datos:

| | Motor JS | Script R |
|---|---|---|
| CBC — log-verosimilitud agregada | −1264.5675 | −1264.57 |
| CBC — Precio Bajo / Medio / Alto | 0.3528 / 0.1263 / −0.4792 | 0.3528 / 0.1263 / −0.4792 |
| CBC — importancia (Marca/Precio/Garantía) | 42.15 / 39.09 / 18.76 | 42.1 / 39.1 / 18.8 |
| MaxDiff — log-verosimilitud | −988.8996 | −988.9 |
| MaxDiff — utilidades (8 ítems) | idénticas | idénticas |

Nota de infraestructura: la validación se hizo con R instalado en el entorno de trabajo, pero **sin acceso a CRAN**. Eso forzó a reescribir los scripts en R base, lo que resultó ser una mejora — el script original dependía de `tidyverse`, `AlgDesign` y `mlogit`; ahora solo de `readxl`.

#### E. Sesgo residual documentado (no es un defecto corregible)

La importancia individual promediada **subestima levemente el atributo de señal débil** (en la simulación: 10.6% frente a 14.3% real). Es el sesgo de encogimiento: la media poblacional de ese atributo es ≈0 (los segmentos se cancelan) y su τ² es bajo, así que las utilidades individuales se comprimen y el rango se acorta. Se verificó que crece con las iteraciones EM (14.8% con EM=2 → 9.2% con EM=10) **mientras la correlación individual mejora en paralelo** (0.902 → 0.923): es el compromiso sesgo-varianza, inherente a cualquier estimador con shrinkage, HB incluido. Documentado para que no se lea como error de implementación.

#### F. Estado de validación al cierre

Todas las validaciones de los motores se hicieron sobre el **núcleo numérico extraído y ejecutado en Node**, no sobre el flujo completo del wizard en navegador. **Pendiente de prueba manual en navegador real**: renderizado de resultados con la nueva escala de puntajes de MaxDiff, apertura de los Excel exportados (hoja nueva "Ajuste del modelo", columnas RLH), y comportamiento del simulador de CBC con las utilidades nuevas.

---

### 4.10 Sesión — 27 de julio de 2026 — auditoría y corrección de los cuatro motores restantes

Cerrado el frente que quedaba abierto tras la reescritura de CBC y MaxDiff: Posicionamiento, TURF, Van Westendorp y NMS. Mismo método que la auditoría de CBC — lectura del código, verificación algebraica y validación numérica sobre las funciones reales extraídas del HTML. Ver **D32**.

**Conclusión de fondo: el núcleo estadístico de los cuatro motores estaba correcto.** Los defectos encontrados vivían en la periferia — escalas, umbrales y límites — no en las fórmulas.

#### Correcciones aplicadas

| # | Módulo | Problema | Corrección |
|---|---|---|---|
| 1 | TURF | Reach ponderado reescalaba cada encuestado a `[-1,1]` por su propio rango | Se centra por encuestado (solo en modo estándar; el anclado conserva su cero absoluto) y se escala con un **factor único para toda la muestra**, lo que hace el resultado invariante a las unidades de entrada sin aplanar las diferencias de intensidad entre personas |
| 2 | NMS | Paso de la curva de demanda forzado a entero ≥1 | Paso proporcional al rango, redondeado a una precisión relativa a la magnitud |
| 3 | Posicionamiento | Umbral de "no diferenciador" incoherente con la escala de `ctr` | `2/n` en vez de `1/n`, coherente con que `ctr` suma las dos dimensiones |
| 4 | TURF | Sin guarda ante la explosión combinatoria | Estimación del costo antes de arrancar: aviso por encima de 200.000 combinaciones, bloqueo con explicación por encima de 2.000.000 |
| 5 | NMS | Calibración de intención de compra oculta en el código | Nota pedagógica que muestra los factores efectivamente usados, más la advertencia de que el ingreso estimado no es una predicción |
| 6 | TURF | Empates no reportados; solapamiento sin definir | Se cuenta y muestra cuántas combinaciones comparten el máximo; se documenta que la matriz usa índice de Jaccard (simétrico), no la medida condicional |
| 7 | VW | Desviación estándar con divisor poblacional | Divisor muestral (n−1) |

#### Validación de la corrección de TURF

Muestra simulada de 200 encuestados en 3 segmentos con favoritos distintos (utilidades tipo MaxDiff). Con umbral 0.5 el motor corregido recupera exactamente la estructura:

| Portafolio | Reach | Esperado |
|---|---|---|
| Favoritos del segmento 1 | 33.5% | ~33% |
| Favoritos del segmento 2 | 33.5% | ~33% |
| Dos segmentos combinados | 67.0% | ~67% |
| Los tres segmentos | 100.0% | 100% |
| Ítems que no son favoritos de nadie | 0.0% | 0% |

Verificado además que el resultado es **idéntico** con los mismos datos expresados en escala 0-100 y en escala −2..2 (invariancia a las unidades), y que un encuestado cuyos dos peores ítems forman el portafolio ya **no** se cuenta como alcanzado.

#### Corrección del paso de precios en NMS

| Producto | Rango | Puntos antes | Puntos ahora |
|---|---|---|---|
| Gaseosa 500 ml | S/1.5 – 6 | 5 | 57 |
| Snack | S/2 – 8 | 7 | 61 |
| Café instantáneo | S/8 – 35 | 28 | 55 |

#### Cierre de las decisiones abiertas del hallazgo 1 (ver D33)

Las tres decisiones que habían quedado abiertas se resolvieron en la misma sesión:

**Escala (A).** Se conserva la normalización de D32. La alternativa —usar las utilidades tal cual, más fiel a Orme si el insumo son utilidades logit— se descartó porque el módulo lee un archivo arbitrario: con puntajes 0-100, `exp(100)` desborda a infinito y todos quedan alcanzados. Se asume explícitamente que fijar la escala global en SD=1 es una convención, documentada ahora en la nota metodológica del módulo.

**Umbral (B).** Sube de 0.30 a 0.50. Línea base de probabilidad para un encuestado promedio (ítems en su nivel medio):

| k | estándar (c=3) | anclado (c=1) |
|---|---|---|
| 1 | 0.250 | 0.500 |
| 2 | 0.400 | 0.667 |
| 3 | 0.500 | 0.750 |
| 4 | 0.571 | 0.800 |

Un umbral por debajo de esa línea deja pasar a todos automáticamente. Con 0.30, un portafolio de k=4 daba 100% en la validación segmentada; con 0.50 daba 67%, que es la estructura real. **Es mitigación, no cura**: la línea base sube con k por construcción de la fórmula, así que la curva de reach por k debe leerse sabiendo eso. Se descartó un umbral relativo a la línea base (más elegante, pero se aparta de Orme y agrega carga conceptual).

**Contrato de datos del modo anclado (C).** Implementada la advertencia: si se elige "anclado" y ningún valor del archivo es negativo, se avisa que el cero no separa comprar de no comprar y que todos quedarán alcanzados.

---


#### Cierre del hallazgo 5 — calibración de intención de compra (ver D34)

El hallazgo 5 había quedado resuelto solo a medias: los factores se hicieron visibles pero no se tocaron, y seguían siendo más generosos que la práctica habitual. Se cerró convirtiendo el supuesto en material pedagógico en vez de intentar acertar el valor "correcto".

| Preset | 5 | 4 | 3 | 2 | 1 |
|---|---|---|---|---|---|
| Conservadora | 0.70 | 0.35 | 0.10 | 0.03 | 0 |
| Moderada (por defecto, la histórica del kit) | 0.70 | 0.50 | 0.30 | 0.10 | 0 |
| Optimista | 0.80 | 0.60 | 0.40 | 0.15 | 0 |

**Por qué presets y no campos editables.** Una perilla numérica libre invita a moverla hasta que el resultado dé lo que uno quiere — la lección opuesta a la que el kit busca enseñar — y agrega complejidad sobre una decisión que el estudiante normalmente no está en condiciones de tomar.

**Lectura de sensibilidad.** Junto a la curva se muestra el precio de máximo ingreso y de máxima demanda bajo las tres calibraciones, con un veredicto según la dispersión relativa. Validado con simulación:

| Escenario | cons. | mod. | opt. | Dispersión | Veredicto |
|---|---|---|---|---|---|
| Intención moderada | 3.13 | 3.23 | 3.23 | 3.2% | robusto |
| Intención polarizada alta | 3.23 | 3.53 | 3.63 | 12.4% | tomar como rango |

**Advertencia en la app.** La nota metodológica del módulo dice explícitamente que no existe un conjunto de deflactores estándar publicado y verificable, que los que circulan vienen de práctica de industria y modelos propietarios, y que la pregunta útil no es cuál calibración es correcta sino qué tan frágil es la conclusión ante ese supuesto.

---


#### Cabos sueltos de la auditoría (ver D35)

Al preguntar el usuario si quedaba algo abierto, se encontraron **dos huecos de la propia auditoría de D32**, no del código auditado:

**NMS descartaba encuestados en silencio.** La auditoría dio por verificado que los excluidos se contaban, pero eso solo valía para Van Westendorp. El filtro de NMS es más estricto (exige intención de compra entre 1 y 5) y no informaba nada. Ahora se muestran desglosados por causa junto al número de casos analizados.

**`calcShapleyGeneral` nunca se auditó.** Se había saltado explícitamente. Tenía tres defectos:

| Defecto | Medición | Corrección |
|---|---|---|
| Barajado con `sort(()=>r()-0.5)`, no uniforme | 144σ de desviación vs. 2.8σ con Fisher-Yates | Fisher-Yates |
| `MAX_SAMPLES_PER_SIZE=2000` muerta (`Math.min(2000,200)`) | siempre 200 muestras | constante única y honesta |
| Normalización restando el mínimo | el ítem de menor aporte siempre 0.0% | reparto proporcional |

Efecto de la última sobre cinco ítems que aportan 12 / 11.5 / 11 / 10.5 / 10 puntos de alcance:

| | Mostrado |
|---|---|
| Antes | 40% / 30% / 20% / 10% / **0%** |
| Ahora | 21.8% / 20.9% / 20% / 19.1% / 18.2% |

**El generador pseudoaleatorio del kit quedó descartado como causa.** Se sospechó de él al ver desviaciones altas, pero el LCG (constantes de Numerical Recipes, mod 2³²) se comporta bien: con Fisher-Yates da 2.8σ y `Math.random` 2.2σ, ambos ruido de muestreo. El sesgo era íntegramente del barajado.

**Alcance del Modo Aprendizaje.** Auditado: `runEduAnalysis` invoca los mismos motores del Modo Cálculo sin lógica estadística duplicada, así que las correcciones de D28–D34 se propagan automáticamente. Los `renderEduDiag*` no calculan estadística propia salvo un promedio descriptivo en TURF. **Consecuencia a tener presente:** `corrBuildInterpretation` usa `nonDifferentiating`, así que la corrección del umbral de contribución (D32) también cambia el texto interpretativo — ahora menciona más atributos como no diferenciadores, en ambos modos.

---


#### Intervalos de confianza por bootstrap (ver D36)

Cierre del único punto de la auditoría que quedaba sin implementar. Los cuatro puntos de VW y el precio óptimo de NMS eran estimaciones puntuales sin medida de incertidumbre.

**Método.** Bootstrap no paramétrico remuestreando **encuestados** con reemplazo (no precios sueltos: las cuatro respuestas de una persona están correlacionadas), 2000 réplicas, intervalo percentil 2.5–97.5 sin supuesto de normalidad.

**Validación de cobertura** — la estimación puntual cae dentro de su intervalo en los 12 casos probados, y la amplitud decrece con N:

| | N=80 | N=200 | N=500 |
|---|---|---|---|
| OPP | 2.80 · [2.57, 2.80] | 2.95 · [2.85, 2.95] | 2.95 · [2.87, 2.95] |
| IPP | 3.72 · [3.60, 4.21] | 3.71 · [3.60, 3.90] | 3.69 · [3.62, 3.79] |
| PME | 4.46 · [4.17, 4.71] | 4.34 · [4.23, 4.46] | 4.30 · [4.23, 4.44] |

Costo medido: 15–110 ms. La eficiencia viene de acumular histogramas sobre la grilla de precios (O(N+P) por réplica) en vez de recorrer todos los encuestados en cada precio (O(N×P)).

**Nota sobre un comportamiento que puede confundir.** Cuando las cuatro distribuciones de precio apenas se solapan —muestras muy homogéneas— las curvas se cruzan en zonas planas donde ambas valen casi cero, la intersección queda mal determinada y el bootstrap devuelve intervalos anchos. Eso **no es un defecto del bootstrap sino información**: revela una fragilidad que la estimación puntual esconde. Conviene tenerlo presente al interpretar, porque va contra la intuición de que una muestra homogénea da resultados más precisos.

**Complementariedad con D34.** En NMS quedan visibles a la vez las dos fuentes de incertidumbre: la de muestreo (bootstrap) y la del supuesto de calibración (presets). Son independientes y conviene leerlas juntas.

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

### Núcleo numérico de elección discreta (nuevo, v6.1 — ver 4.9.D, D29 y D30)

Bloque compartido por CBC y MaxDiff, sin dependencias externas y compatible con la restricción de archivo HTML único. Ubicado inmediatamente antes de `analyzeC()`.

| Función | Rol |
|---|---|
| `cbcSolve(A,b)` | Resuelve `A·x = b` por Gauss-Jordan con pivoteo parcial |
| `cbcInvDiag(A)` | Diagonal de `A⁻¹` (varianzas posteriores para el paso M del EM) |
| `cbcBuildSpec(attrs)` | Especificación del modelo: índices de parámetros y codificación de efectos |
| `cbcXConcept(spec,prod)` / `cbcXNone(spec)` | Vectores de diseño **dispersos** `{ix,vx}` para un concepto y para la alternativa "Ninguno" |
| `cbcEval(tasks,beta,P,mu,tau2,wantH)` | Log-verosimilitud, gradiente e información de Fisher; con `mu`/`tau2` añade el término del prior (MAP) |
| `cbcFit(tasks,P,opts)` | Newton-Raphson con *line search* por bisección y ridge numérico (1e-8) |
| `cbcBetaToUtils(spec,beta)` | Parámetros → utilidades por nivel |
| `mdBuildItemVectors(N)` | (MaxDiff) Vectores por ítem y su versión negada para la elección del "peor" |
| `mdBetaToUtils(beta,N)` / `mdUtilsToScores(u)` | (MaxDiff) Parámetros → utilidades → puntajes exponenciales que suman 100 |

**Especificación estadística compartida:**

- **Codificación de efectos.** Un atributo con L niveles aporta L−1 parámetros libres; el último queda determinado como −(suma de los demás). La **suma cero es estructural, no un re-centrado posterior** — esto elimina la clase de bug detectada en D26.
- **Alternativa "Ninguno" modelada** en CBC con su propio parámetro (ASC). Antes esas respuestas (`tarea = 0`) no aportaban al numerador pero sí al denominador de las tasas, sesgando todo hacia abajo en silencio.
- **Best-worst como logit secuencial** en MaxDiff: `P(mejor=b) = exp(β_b)/Σ_{j∈S} exp(β_j)` y `P(peor=w|b) = exp(−β_w)/Σ_{j∈S\{b}} exp(−β_j)`. La segunda es una tarea MNL común con los vectores de diseño negados, por eso el núcleo se reutiliza tal cual.
- **Utilidades individuales por MAP**: modo de la posterior de cada encuestado, maximizando la verosimilitud de *sus* elecciones penalizada por la distancia a la media poblacional, con τ² como fuerza del prior. Es literalmente el `Posterior ∝ Verosimilitud × Densidad Previa` de Orme (2026). La penalización garantiza que el problema esté bien condicionado incluso con separación completa o pocas tareas — el escenario donde la máxima verosimilitud individual sobreajusta.
- **(μ, τ²) por Empirical Bayes vía EM con aproximación de Laplace**, equivalente al nivel superior de un HB sin MCMC:
  - *Paso E*: modo y curvatura de la posterior de cada encuestado dados (μ, τ²).
  - *Paso M*: `μ_p = media_i(β_ip)` y `τ²_p = media_i[(β_ip − μ_p)² + V_ip]`, con `V_ip` la varianza posterior. **Sumar `V_ip` es esencial**: sin ese término τ² se subestima porque los modos ya vienen encogidos.
  - Piso `τ² ≥ 0.01` para que no colapse a cero y congele a todos en la media poblacional.
  - Iteraciones adaptativas: `workUnit = N × P²`; >800k → 3, >200k → 4, en otro caso 6.
- **Warm start**: cada encuestado arranca de μ, así tras la primera vuelta Newton converge en 1-3 iteraciones.

**Por qué ya no hay heurística de consistencia.** No hace falta ponderar por exposición × tasa de acierto: quien responde de forma errática tiene una verosimilitud plana (muchos vectores de utilidad la explican igual de bien) y el prior domina; quien responde mucho y consistente tiene una verosimilitud afilada que domina al prior. Es el mismo cociente de verosimilitudes que describe el paper, calculado explícitamente en vez de aproximado.

**Diagnósticos en escala estándar de la industria.** Se sustituyó la métrica ad-hoc `consistencia_pct` por **RLH** (root likelihood, `exp(LL/n)` — media geométrica de la probabilidad asignada a las alternativas efectivamente elegidas, la métrica de ajuste de Sawtooth), acompañado de su **RLH de azar** (`media(1/J)`) como referencia de lectura, la **tasa de acierto** y el número de tareas. En MaxDiff el azar difiere entre la elección del "mejor" (1/K) y la del "peor" (1/(K−1)), y se promedia correctamente.

**Estructura de resultados:**

- `S.c.res` = `{utils, utilsPooled, imp, impAgg, lc, data, indivUtils, fitInfo, spec}` — `utils` son las poblacionales (media de las individuales), `utilsPooled` el MNL agregado puro como referencia, `lc` los conteos conservados como diagnóstico. Cada `indivUtils[i]` trae `rlh`, `rlhChance`, `hitRate`, `nTasks`.
- `S.m.res` = `{ranked, indivScores, fitInfo}` — `ranked[i].net` es la utilidad estimada y `.score` el puntaje exponencial; cada `indivScores[i]` trae `net`, `netRaw` (neto descriptivo), `expo`, `norm` (puntajes que suman 100), `rlh`, `rlhChance`, `hitRate`, `nTasks`.
- `fitInfo` = `{P, nResp, llPooled, tau2, rlhMean, rlhChance}`, exportado a la hoja "Ajuste del modelo".

---

## 7. Propuesta de nuevos módulos

Las siguientes extensiones fueron propuestas para la siguiente fase. Todas responden a la filosofía del proyecto.

### 7.1 Mapa de Posicionamiento (Análisis de Correspondencias) — ✅ **IMPLEMENTADO Y CERRADO** (v6.0, correcciones en v6.1)

> Esta sección se conserva como registro del diseño original. El módulo está activo desde v6.0 (ver 4.7 y 4.8) y recibió correcciones sobre los tres formatos de entrada en v6.1 (ver 4.9.A). No es trabajo pendiente.

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
| D9 | ~~Bayesian smoothing: Empirical Bayes cerrado, no MCMC completo~~ **SUPERADA en v6.1 por D29 (CBC) y D30 (MaxDiff)** | HB-MNL con Metropolis-Hastings evaluado y descartado por costo de complejidad/mantenimiento; se implementó el espíritu del paper de Orme (2026) con fórmula cerrada precision-weighted. **En v6.1 esto se sustituyó por la implementación literal del mecanismo**: modelo estimado por máxima verosimilitud e utilidades individuales como modo de la posterior (MAP), con hiperparámetros por Empirical Bayes vía EM. Se mantiene la decisión de fondo de **no usar MCMC**; lo que cambió es que ya no se aproxima con una fórmula cerrada heurística sino que se resuelve el problema de optimización real |
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
| D23 | Columna "NONE"/"Ninguna" en tabla de contingencia: exclusión automática con aviso visible en el diagnóstico | A diferencia de P&P (`99`) y Forms (`'NONE'`), el formato de contingencia no tenía regla para esta columna porque se asumió que una tabla ya agregada no la traería; el archivo real del usuario demostró lo contrario. Metodológicamente "NONE" no es una marca sino la ausencia de asociación: dejarla infla la inercia total y puede aparecer aislada en el mapa por representar no-consumo, no una percepción. Se detecta con `/^(NONE\|NINGUNA)$/i` (mismo criterio case-insensitive que `CORR_TOTAL_RE`) y se excluye igual que la columna "Total", reportando en el diagnóstico el nombre de la columna y cuántas menciones representaba — nunca en silencio. Se descartó la alternativa de bloquear la carga: es más consistente con el trato que ya reciben P&P/Forms. Decidido con el usuario en 4.9.A |
| D24 | La fórmula del número de tarjetas MaxDiff se explica al usuario en vivo, no se calcula en silencio | El motor ya usaba `ns = máx(8, ⌈N×4/K⌉)` (N = ítems, K = ítems por tarjeta) desde antes, pero era una caja negra para el estudiante. Se agregó una nota pedagógica en el Paso 1 con la fórmula, su justificación en tres restricciones (estabilidad estadística — mínimo de exposiciones por ítem según Sawtooth/Orme, con 4 como objetivo frente al piso de 3 recomendado; balance del diseño tipo BIBD; fatiga del encuestado) y el cálculo resuelto en vivo según los ítems y el K configurados. El rango 4-5 del selector también tiene base: Cohen (2003) encontró que 3 ítems por tarjeta discriminan poco y 6+ saturan cognitivamente. Sin cambios en el algoritmo. Referencias: Finn & Louviere (1992); Cohen (2003); Louviere, Flynn & Marley (2015). Decidido con el usuario en 4.9.B |
| D25 | ~~MaxDiff: consistencia individual (leave-one-out) en el suavizado, no solo volumen~~ **SUPERADA por D30** | A partir del paper de Orme (2026) se detectó que la fórmula solo modelaba el volumen de exposición, no la consistencia de las elecciones. Se agregó una tasa de coincidencia por validación leave-one-out (para cada tarjeta, comparar la elección contra el neto propio calculado *excluyendo esa tarjeta*, evitando la circularidad) como multiplicador de la exposición efectiva. Validado: encuestado coherente 0.94, aleatorio 0.20 (piso). **Superada**: con el modelo estimado de D30, la curvatura de la verosimilitud produce ese comportamiento automáticamente y la heurística dejó de ser necesaria. Registro histórico, ver 4.9.C |
| D26 | ~~CBC: τ² pasa a usarse realmente en la fórmula de shrinkage~~ **SUPERADA por D29** | Se descubrió que `τ²` (heterogeneidad entre encuestados por nivel) se calculaba desde versiones anteriores pero nunca entraba a la fórmula final — código vestigial de un enfoque más riguroso que quedó sin conectar. Se corrigió su estimación por método de momentos (la varianza observada entre utilidades individuales es `τ² + varianza de muestreo`; sin descontar el segundo término, τ² queda inflado) y se la puso a determinar el peso vía `w = τ²/(τ²+σ²)`. Efecto medido: con la fórmula anterior el peso era 0.500 tanto con heterogeneidad real como sin ella; con la nueva, 0.110 cuando las diferencias son ruido y 0.540 cuando son reales. **Regresión detectada y corregida en la misma sesión**: al variar `w` por nivel se rompió la suma-cero por atributo (desviación hasta 0.4262), resuelta con re-centrado. **Superada** por D29. Registro histórico, ver 4.9.C |
| D27 | ~~Normalización del hit rate por el nivel de azar~~ **SUPERADA por D29 y D30** | El hit rate crudo no era comparable con "0 = sin información": con 4 conceptos por tarea, responder al voleo ya acierta ~25%. Se reescaló a `(acierto − azar)/(1 − azar)` con el azar calculado según el número real de alternativas de cada tarea, aplicado simultáneamente a CBC y MaxDiff para no romper la consistencia entre módulos (en MaxDiff el azar por tarjeta es exactamente `1/K`). **Superada**: los modelos estimados de D29/D30 no usan el hit rate para ponderar nada; se conserva solo como diagnóstico, junto al RLH. Registro histórico, ver 4.9.C |
| D28 | CBC: correcciones de estimación previas a la reescritura (vigentes) | Cuatro correcciones que sobreviven a la reescritura porque son independientes del estimador: **(a)** el número de tareas `T` se deriva del diseño cargado en vez de hardcodearse en 15 — la ruta `skipDesign` sí permite reimportar un diseño con otra cantidad de tareas, y el análisis habría leído tareas inexistentes; **(b)** el clamp fijo `[0.01, 0.99]` sobre las tasas de elección se reemplazó por la corrección de continuidad `(ch+0.5)/(tot+1)` (Haldane-Anscombe) — el clamp era independiente de la evidencia (0 elecciones daba logit −4.60 tanto con 3 como con 30 exposiciones) y con configuraciones que el kit permite (4 atributos × 5 niveles) afectaba al 10% de las celdas encuestado×nivel, inflando τ²; **(c)** el fallback `τ²=1` cuando menos de 2 encuestados veían un nivel era arbitrario y 20× mayor que el piso, produciendo *menos* suavizado donde hay *menos* evidencia — ahora usa la mediana de los τ² del mismo atributo; **(d)** la importancia pasa a calcularse dentro de cada encuestado y promediarse, conservando la agregada como referencia exportada con nota explicativa. Efecto medido de (d) con dos segmentos opuestos: la agregada hunde a Precio a 19.5% siendo el atributo más decisivo (40% real), la individual promediada lo recupera en 41.6%. Decidido con el usuario en 4.9.C/D |
| D29 | CBC: el motor se reescribe como **MNL estimado + MAP individual con Empirical Bayes**, sustituyendo el análisis por conteos y el suavizado heurístico | Ver especificación completa en la sección 6 (*Núcleo numérico de elección discreta*). Motivación: dejar el módulo en condiciones de auditoría externa. El *counting analysis* anterior ignoraba que los conceptos son paquetes, no modelaba la verosimilitud y su "cero" por atributo era una convención de centrado, no un parámetro estimado. Punto crítico: implementar MNL **solo** a nivel agregado habría sido peor que no hacerlo, porque los betas MNL y los logits de conteos están en escalas distintas y el suavizado mezcla ambos niveles — por eso se hizo en los dos o en ninguno. Elimina la necesidad de D25/D26/D27: la curvatura de la verosimilitud reproduce el mecanismo del paper de Orme automáticamente. Se mantiene la decisión de fondo de D9 (**sin MCMC**). Validado con recuperación de parámetros conocidos (error 0.021) y correlación individual 0.920. Decidido con el usuario en 4.9.D |
| D30 | MaxDiff: el motor se reescribe como **logit secuencial best-worst estimado + MAP individual**, con reescalado exponencial de los puntajes | Continuación directa de D29: mantener MaxDiff con puntajes netos habría dejado el kit con un módulo riguroso y otro heurístico, asimetría que un revisor externo detecta de inmediato. El best-worst se modela como dos elecciones logit por tarjeta (el "mejor" entre los K ítems mostrados; el "peor" entre los K−1 restantes con las utilidades **negadas**), formulación que permite reutilizar **sin modificación** el núcleo MNL de CBC. El puntaje neto (mejor − peor) se conserva como estadístico descriptivo pero deja de ser el estimador: no pondera por el tamaño del conjunto en que compitió cada ítem, no usa la verosimilitud y su escala no es comparable entre diseños. Los puntajes pasan al reescalado exponencial estándar `100·exp(u_i)/Σexp(u_j)`, que suma 100 y tiene interpretación probabilística directa (probabilidad de ser elegido el mejor de un conjunto con todos los ítems), en vez del desplazamiento y proporción anterior que no la tenía — **los números difieren de corridas previas**. Validado con error de recuperación 0.040 y correlación individual 0.81-0.85. Decidido con el usuario en 4.9.D |
| D31 | Los scripts R exportables pasan a ser **implementaciones de referencia** que reproducen el kit exactamente, en R base | Tras D29/D30 quedó una inconsistencia real: el script R calculaba la importancia sobre las utilidades agregadas mientras el kit la calcula por encuestado y la promedia (en simulación: 23.4% vs. 42.1% para el mismo atributo). Se evaluó apoyarse en `bayesm`/`ChoiceModelR`, pero **esos paquetes no pueden reproducir el kit**: hacen HB por MCMC completo (medias posteriores con priors propios), no MAP con τ² por EM — darían resultados parecidos pero nunca idénticos, que es justo lo que no sirve cuando el objetivo es verificación. Se implementó por tanto el mismo estimador en R: `mnl_eval` / `mnl_fit` (Newton-Raphson con line search), codificación de efectos, "Ninguno" como alternativa, y el bucle EM completo. **Solo requiere `readxl`**; todo el cálculo es R base, a propósito, para reducir fallos de instalación en clase y superficie de divergencia por versiones de paquetes. `mlogit`/`bayesm` quedan como bloque de contraste opcional, con advertencia explícita de por qué sus números difieren. **Validado ejecutando en R los scripts generados por el propio HTML** contra los mismos datos sintéticos: CBC log-verosimilitud −1264.57 (JS: −1264.5675), utilidades y importancias coincidentes a la precisión mostrada; MaxDiff log-verosimilitud −988.9 (JS: −988.8996), utilidades idénticas ítem por ítem. Decidido con el usuario en 4.9.G |
| D32 | Auditoría y corrección de los cuatro motores restantes (Posicionamiento, TURF, VW, NMS) | Cerrado el frente que quedaba tras D29/D30. **El núcleo estadístico de los cuatro resultó correcto** —verificado algebraica y numéricamente: la proyección baricéntrica de puntos suplementarios en CA es exacta (el término espurio se anula porque √c está en el núcleo de S), las inercias suman 1, Jacobi ordena descendente, las cuatro intersecciones de VW corresponden a la definición estándar con cruce único garantizado, el trapecio de demanda de NMS es la especificación correcta, la enumeración de TURF es exhaustiva (garantiza el óptimo, a diferencia de los greedy comerciales) y su Shapley usa permutaciones exactas porque `kmax≤6`. Los problemas estaban en la periferia: **(a)** el reach ponderado de TURF reescalaba las utilidades de cada encuestado a `[-1,1]` por su propio rango, destruyendo la escala absoluta que la fórmula de Orme/Howell presupone — con el umbral por defecto eso hacía que todo portafolio de k≥2 alcanzara al 100% de la muestra (probabilidad mínima posible 0.424 > 0.30) y el ranking quedara íntegramente empatado, además de vaciar de sentido la variante anclada; **(b)** el paso de la curva de demanda de NMS se forzaba a entero ≥1, dejando una gaseosa de S/1.5–6 con solo 5 puntos de curva —inutilizable para consumo masivo peruano—; **(c)** el criterio de "no diferenciador" en CA comparaba `ctr1+ctr2` (cuyo promedio es 2/n) contra 1/n, marcando solo lo que estaba por debajo de la mitad del promedio (4 de 15 atributos en vez de 7). Decidido con el usuario en 4.10 |
| D33 | TURF ponderado: convención de escala documentada, umbral por defecto 0.50 y advertencia de contrato en modo anclado | Cierre de las tres decisiones que quedaban abiertas del hallazgo 1 de D32. **(a) Escala:** se conserva la normalización introducida en D32 —centrado por encuestado solo en modo estándar, más un factor de escala único para toda la muestra— frente a la alternativa de usar las utilidades tal cual. Razón: el módulo lee un archivo arbitrario y acepta puntajes en cualquier unidad; sin normalizar, `exp()` de un puntaje 0-100 desborda a infinito y todos quedan alcanzados, una versión peor del bug corregido. Se asume explícitamente que fijar la escala global en SD=1 es una **convención**, y por eso queda documentada en la nota metodológica del módulo: la palanca real del usuario es el umbral, no la escala. **(b) Umbral:** sube de 0.30 a 0.50. Justificación medida: como `P = Σexp(U)/(Σexp(U)+c)` crece con el tamaño del portafolio, un encuestado promedio ya alcanza 0.40 con k=2 y 0.57 con k=4 en modo estándar; un umbral por debajo de esa línea base deja pasar a todos automáticamente y aplana la curva de ganancia marginal. En la validación con datos segmentados, un portafolio de k=4 daba 100% con umbral 0.30 y 67% con 0.50, siendo este último el que refleja la estructura real. Queda documentado que es **mitigación, no cura**: la línea base sube con k por construcción, así que la curva de reach por k debe leerse sabiendo eso. Se descartó un umbral relativo a la línea base por apartarse de Orme y agregar carga conceptual a una herramienta de enseñanza. **(c) Contrato de datos:** se avisa cuando se elige modo anclado y ningún valor del archivo es negativo, caso en que el cero no separa comprar de no comprar y todos quedan alcanzados. Decidido con el usuario en 4.10 |
| D34 | NMS: la calibración de intención de compra pasa a ser un supuesto explícito con tres presets y lectura automática de sensibilidad | Cierre del hallazgo 5 de D32. Se descartó tanto dejar los valores fijos (aunque visibles) como elegir "los correctos", porque **no existe un conjunto de deflactores estándar publicado y verificable**: los que circulan provienen de práctica de industria y modelos propietarios, y varían entre firmas. Se descartó también permitir editar los cinco valores a mano, por un riesgo pedagógico concreto — una perilla libre invita a moverla hasta que el resultado convenga, que es exactamente la lección opuesta a la que el kit quiere enseñar, y agrega complejidad sobre una decisión que el estudiante no está en condiciones de tomar. La solución adoptada convierte el problema en su propia lección: tres presets con nombre (**conservadora** `0.70/0.35/0.10/0.03/0`, tomada de la práctica clásica de top-box; **moderada** `0.70/0.50/0.30/0.10/0`, la histórica del kit, por defecto; **optimista** `0.80/0.60/0.40/0.15/0`), y junto a los resultados una **lectura automática de sensibilidad** que muestra el precio de máximo ingreso y de máxima demanda bajo las tres, con un veredicto en lenguaje llano según la dispersión relativa (<5% robusto; 5-15% tomar como rango; >15% la conclusión depende fuertemente del supuesto, reportar rango). Las tres calibraciones se calculan de una sola vez en `analyzeNMS`, así que cambiar de preset solo re-dibuja. La advertencia sobre la ausencia de estándar publicado **está en la app**, no solo en este documento. Decidido con el usuario en 4.10 |
| D35 | Cierre de los cabos sueltos de la auditoría: excluidos en NMS, `calcShapleyGeneral` y alcance del Modo Aprendizaje | Al revisar si quedaba algo abierto de D32 aparecieron **dos huecos de la propia auditoría**, además del punto 8 que ya estaba declarado como extensión. **(a) NMS descartaba encuestados en silencio.** La auditoría dio por verificado que "los excluidos se cuentan", pero eso solo era cierto en Van Westendorp; NMS aplica un filtro *más estricto* —exige además que la intención de compra esté entre 1 y 5— y no informaba nada. Ahora se cuentan y se muestran **desglosados por causa** (jerarquía de precios inconsistente / intención fuera de escala), junto al número de casos efectivamente analizados. **(b) `calcShapleyGeneral` nunca se auditó** (se saltó explícitamente como "atribución heurística documentada"). Tenía tres defectos: usaba `[...arr].sort(()=>r()-0.5)` para barajar, que **no produce permutaciones uniformes** —medido: 144σ de desviación respecto de la uniforme, frente a 2.8σ con Fisher-Yates—, sesgando el muestreo de portafolios base y con él la contribución estimada de cada ítem; la constante `MAX_SAMPLES_PER_SIZE=2000` estaba muerta porque `Math.min(2000,200)` da siempre 200; y normalizaba **restando el mínimo** antes de repartir el 100%, lo que forzaba al ítem de menor aporte a mostrarse siempre como 0.0% y exageraba las diferencias (cinco ítems que aportan 12/11.5/11/10.5/10 puntos de alcance se mostraban como 40/30/20/10/0% en vez de 21.8/20.9/20/19.1/18.2%). Corregidos los tres. **Se verificó de paso que el generador pseudoaleatorio del kit no era el problema**: con Fisher-Yates da 2.8σ y con `Math.random` 2.2σ, ambos dentro del ruido de muestreo. **(c) Alcance del Modo Aprendizaje**, que tampoco se había auditado: `runEduAnalysis` invoca **los mismos motores** que el Modo Cálculo (`runTURF`, `analyzeM`, `analyzeNMS`, `analyzeC`, `corrRunCA`+`corrProjectSupplementary`, `analyzeVW`) sin lógica estadística duplicada, de modo que todas las correcciones de D28–D34 se propagan solas; los `renderEduDiag*` no calculan estadística propia salvo un promedio descriptivo en TURF. Decidido con el usuario en 4.10 |
| D36 | Intervalos de confianza por bootstrap en Van Westendorp y NMS | Último punto pendiente de la auditoría de D32 (el #8, clasificado desde el inicio como extensión y no corrección). Los cuatro puntos de precio de VW y el precio óptimo de NMS eran estimaciones puntuales sin ninguna medida de incertidumbre, fáciles de leer como cifras exactas. Se implementó **bootstrap no paramétrico remuestreando encuestados con reemplazo** —no precios sueltos: las cuatro respuestas de una persona están correlacionadas y deben viajar juntas— con 2000 réplicas e intervalo percentil (2.5–97.5), que no supone normalidad. Implementación eficiente: en vez de reconstruir las curvas acumuladas recorriendo todos los encuestados en cada precio (O(N×P) por réplica), se guarda la posición de los cuatro precios de cada persona en la grilla y se arman histogramas que luego se acumulan (O(N+P) por réplica); para NMS se precalcula la matriz de probabilidades por encuestado y precio para no reconstruir el trapecio en cada réplica. Costo medido: 15–110 ms según tamaño de muestra. **Validación de cobertura:** la estimación puntual cae dentro de su intervalo en los 12 casos probados (4 puntos × 3 tamaños de muestra), y la amplitud decrece con N como corresponde (IPP: 0.61 → 0.30 → 0.17 al pasar de N=80 a 200 a 500). Se añade una lectura en lenguaje llano según la amplitud relativa (<10% bien determinados; 10-25% tratar como rango; >25% la muestra no alcanza, reportar el rango y considerar ampliarla). En NMS el intervalo del precio de máximo ingreso se muestra junto a la lectura de sensibilidad de D34, de modo que quedan visibles a la vez las dos fuentes de incertidumbre: la de muestreo (bootstrap) y la del supuesto de calibración (presets). Decidido con el usuario en 4.10 |

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
| `HANDOFF_Kit_v6.2_Estado_y_Roadmap.md` | Este documento — **único HANDOFF vigente**. Consolida los addenda sueltos de la sesión v6.1 | Alta — subir al proyecto |
| `kit_investigacion_mercados_v6.2.html` | **Archivo activo, versión a publicar.** Código fuente completo. Motores de CBC y MaxDiff reescritos (4.9.D) y los cuatro motores restantes auditados y corregidos (4.10). Revisado y aprobado por el usuario | Alta — subir al proyecto |
| `kit_investigacion_mercados_v5.1.html` | v5.1 — referencia histórica, no editar más | Baja |
| `kit_investigacion_mercados_v5.html` | v5.0 — referencia histórica, no editar más | Baja |
| `PRODUCT.md` | Register, usuarios, positioning, anti-referencias, principios de diseño (generado vía `/impeccable init`) | Alta — da contexto estratégico que este HANDOFF no cubre |
| `README.md` | Descripción pública del repo + link a la demo en vivo | Media |
| `LICENSE` | MIT | Baja |
| `CAMBIOS.md` | Registro de cambios (rebranding a Praxio, accesibilidad WCAG AA, sesión v6.0) | Media |
| `index.html` | Redirect a `kit_investigacion_mercados_v6.2.html` (actualizado en 4.8), para que la raíz de GitHub Pages funcione una vez se haga push | Baja |
| `.impeccable/critique/*.md` | Snapshot de la crítica de diseño de la sesión del 19 de julio (score 29/40) | Media — backlog para la próxima pasada de polish |
| `.gitignore` | Excluye artefactos de R (`.RData`, `.Rhistory`), `.claude/`, `.impeccable/`, y el prototipo R/Shiny superado (`Ejecutable.R`, `R/analysis.R`, `.Rproj`) | — |

**Nota sobre los archivos de la sesión v6.1**: durante la sesión del 26 de julio se generaron archivos de trabajo intermedios (`HANDOFF_Addendum_D23…D29_*.md`, `CHANGELOG_Corr_v6.1.md`, `AUDITORIA_Motor_CBC.md`). **Todo su contenido está integrado en este documento** (secciones 4.9, 6 y 8) y la numeración de decisiones se consolidó aquí, por lo que esos archivos no deben subirse al repo: duplicarían información y usan una numeración provisional distinta.

**Nota**: `CONTEXTO_Kit_Investigacion_Mercados.md` (mencionado en versiones anteriores de este HANDOFF) no existe en la carpeta del proyecto — puede haberse perdido o nunca haberse creado. Si hace falta ese contexto, `PRODUCT.md` cubre ahora una función equivalente (más formal, generada por impeccable).

**Prototipo R/Shiny descartado**: el proyecto tenía `Ejecutable.R`, `R/analysis.R` y un `.Rproj` de un prototipo Shiny anterior, ya roto (`Ejecutable.R` dependía de un `app.R` que ya no existe en la carpeta). Se sacaron del repo público esta sesión (siguen localmente, ver `.gitignore`) — no es trabajo pendiente, es historia descartada.

---

## 11. Recomendaciones para la nueva conversación

### Antes que nada: confirmar cuál es la versión vigente

Las sesiones que reconciliaron v5.0 vs. v5.1 (4.6.D) y v6.0 vs. v6.1 (4.9.A) perdieron tiempo real por no preguntar esto primero — en 4.9 el usuario probó dos veces un fix del mapa sobre una versión anterior a la corregida, y hubo que descartar hipótesis de bug que no existían. **Primer paso de la próxima sesión**: preguntar directamente qué versión está publicada en GitHub Pages y si coincide con el archivo de la carpeta, antes de diagnosticar cualquier comportamiento reportado. Ante un síntoma visual que "no se corrigió", descartar caché del navegador (`Ctrl+Shift+R`) y versión publicada **antes** de tocar código.

### Prioridad inmediata

La i18n del Modo Cálculo sigue **completa** (los 6 módulos, incluido Posicionamiento desde 4.7/4.8). El simulador heterogéneo de CBC (antes prioridad #1) **ya está resuelto** en v5.1 — ver 4.6.E. Líneas de trabajo abiertas, en orden sugerido:

1. **Prueba manual en navegador de los motores reescritos (bloqueante antes de publicar).** Las validaciones de 4.9.D se hicieron sobre el núcleo numérico ejecutado en Node, no sobre el wizard completo. Verificar: (a) que los resultados de MaxDiff rendericen bien con la **nueva escala exponencial** de puntajes —los números difieren de corridas previas, ver D30—; (b) que los Excel exportados abran sin problemas, incluida la hoja nueva "Ajuste del modelo" y las columnas RLH; (c) que el **simulador de CBC** y las elasticidades se comporten con las utilidades nuevas; (d) tiempos reales de cómputo en el navegador del usuario con un estudio de tamaño realista.
2. **Mapa de Posicionamiento** — **cerrado**, con las correcciones de 4.9.A validadas contra archivos reales del usuario en los tres formatos de entrada. Sin script R, por decisión explícita (D22), no por pendiente.
3. **Commit + push de v6.1** y actualización de `CAMBIOS.md`. El sitio en vivo puede estar desfasado — confirmar antes (ver la guarda de arriba).
4. ~~Actualizar los scripts R exportables~~ — **resuelto en 4.9.G / D31.** Ambos scripts son ahora implementaciones de referencia validadas contra el motor JS. Pendiente menor: probar el script generado sobre un Excel real exportado por el kit (la validación se hizo con CSV, porque el entorno no tenía `readxl`), y confirmar que los nombres de columna del diseño (`TAREA`, `OPCIÓN`, `TARJETA`, `Item_1..K`) coinciden exactamente con los que produce la exportación.
5. **Registro citable (Zenodo + `CITATION.cff`).** El usuario planteó obtener un DOI. Ruta acordada: integración GitHub↔Zenodo, que asigna un DOI de concepto (fijo, para citar el proyecto) y uno por release (para reproducibilidad). Requiere `LICENSE` explícito (ya existe, MIT) y `CITATION.cff` con autoría y afiliación (USMP), idealmente con ORCID. Sobre publicación arbitrada: **JOSS restringió en enero de 2026 el alcance para aplicaciones web** (exige librería central reusable o alto rigor de diseño tipo MVC/framework, más 6 meses de historial público y declaración de uso de IA generativa); **JOSE está cerrada** a nuevos envíos mientras su comité delibera. El núcleo numérico compartido de 4.9.D acerca al criterio de "librería central" de JOSS. Ruta paralela más realista a corto plazo: paper metodológico/pedagógico en una revista de educación en marketing, citando el software archivado en Zenodo.
4. **Único minor observation de la crítica de diseño (4.6.B) que sigue pendiente**: los 6 `transition:width` (CBC/VW/NMS bar fills) deberían migrar a `transform` para evitar jank. Es el más laborioso de los 5 encontrados — el texto (%) va *dentro* del mismo elemento que se anima, así que animar por `transform:scaleX()` en vez de `width` requiere primero separar la etiqueta de texto de la barra que se escala, en las ~4 funciones de render afectadas (CBC, MaxDiff, TURF/Shapley). Los otros 4 (badge "Retrocedió" sin matiz, botones de export sin distinguir, `role="radio"` faltante, naming `_geminiKey`) se corrigieron en la sesión del 19 de julio, ver 4.6.F.
5. **Configurar un servidor MCP de navegador** (Playwright/Puppeteer/chrome-devtools) si se quiere una crítica de diseño con evidencia visual real — las sesiones anteriores corrieron con la limitación declarada de "sin navegador disponible", basadas en lectura de código fuente únicamente (la prueba manual de Posicionamiento en 4.8 sí se hizo en navegador real, pero por fuera de esta conversación, sin evidencia capturada aquí).

### Módulo más valioso para agregar primero (nuevo módulo, no mejora de existente)

El Mapa de Posicionamiento, que ocupaba este lugar en versiones anteriores del HANDOFF, **ya está implementado y cerrado** (ver 7.1). Los candidatos vigentes, en orden:

1. **Segmentación de Mercados** (ver 7.2) — el más pedido en docencia de investigación de mercados y el que completa el arco "qué valoran / cuánto pagan / quiénes son". Es también el de mayor complejidad (ver abajo).
2. **Extensiones de 7.3** — menor esfuerzo, menor impacto.

**Criterio de selección heredado** de la elección del Mapa de Posicionamiento, útil para evaluar candidatos: (a) que el output sea visualmente reconocible para gerentes y estudiantes, (b) que no exista herramienta libre equivalente en español para docencia universitaria, (c) que el algoritmo sea implementable en Vanilla JS sin librerías externas.

**Nota nueva tras v6.1**: el núcleo numérico de elección discreta (sección 6) ya provee álgebra lineal (`cbcSolve`, `cbcInvDiag`) y optimización por Newton-Raphson reutilizables. Cualquier módulo nuevo que requiera regresión logística —la Logística del flujo de Segmentación, por ejemplo— puede apoyarse en ese núcleo en vez de reimplementarlo.

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
- Verificar los scripts R contra un Excel real exportado por el kit (nombres de hoja y de columna). La lógica está validada; lo que falta es confirmar el contrato de lectura del archivo.
- **Sesgo de encogimiento en la importancia de atributos de señal débil** (CBC): documentado en 4.9.E. No es corregible — es el compromiso sesgo-varianza inherente a cualquier estimador con shrinkage, HB incluido. Anotado aquí para que nadie lo trate como bug en una sesión futura.
- ~~Posicionamiento, TURF, VW y NMS sin auditar~~ — **resuelto en 4.10 / D32.** Los seis motores del kit están auditados, incluidos `calcShapleyGeneral` y el Modo Aprendizaje (D35).
- ~~Intervalos de confianza (bootstrap) en VW/NMS~~ — **implementados en D36. La auditoría de D32 queda cerrada en sus 8 puntos.**
- ~~Umbral por defecto y contrato del modo anclado en TURF~~ — **resueltos en D33.**
- ~~Calibración de intención de compra de NMS~~ — **resuelta en D34** con tres presets y lectura de sensibilidad. El valor por defecto sigue siendo la calibración histórica del kit (moderada), así que los resultados de estudios previos no cambian salvo que se elija otro preset.
- **Sin intervalos de confianza en VW/NMS.** Los cuatro puntos de precio son estimaciones puntuales. Un bootstrap sobre encuestados daría rangos y sería pedagógicamente valioso (enseña que el "precio óptimo" no es un número exacto). Extensión, no corrección.
