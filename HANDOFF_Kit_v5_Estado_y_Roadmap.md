# HANDOFF — Kit de Investigación de Mercados
## Estado al cierre de conversación · Julio 2026

---

## 1. Descripción general del proyecto

Plataforma educativa de investigación cuantitativa de mercados.
Single-file HTML + Vanilla JS, sin backend, ejecutable desde GitHub Pages.
Dos modos: **Modo Cálculo** (herramienta técnica libre) y **Modo Aprendizaje** (casos guiados pedagógicos).

**Archivo activo**: `kit_investigacion_mercados_v5.html` — 6.764 líneas

---

## 2. Módulos del Modo Cálculo

| Módulo | Motor (`engine`) | Estado |
|--------|-----------------|--------|
| CBC Conjoint | `conjoint` | ✅ Activo |
| MaxDiff (Best-Worst Scaling) | `maxdiff` | ✅ Activo |
| Van Westendorp PSM | `vw` | ✅ Activo |
| Van Westendorp + NMS | `nms` | ✅ Activo |
| TURF Analysis | `turf` | ✅ Activo |

Cada módulo tiene: wizard de 3 pasos → carga/validación datos → análisis → resultados → exportación Excel → script R → IA generativa (fallback si sin API).

---

## 3. Modo Aprendizaje — Casos pedagógicos activos

| Caso | Módulo | Categoría | Estado |
|------|--------|-----------|--------|
| `cafe` | Van Westendorp | `precio` | ✅ |
| `seguro` | NMS | `precio` | ✅ |
| `yogurt` | MaxDiff | `criterios` | ✅ |
| `cafe_nms` | NMS | `precio` | ✅ |
| `yogurt_turf` | TURF | `portfolio` | ✅ |
| `plan_salud` | CBC Conjoint | `diseno` | ✅ Nuevo |

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

---

## 5. Estado de la i18n del Modo Cálculo

| Módulo | HTML estático | JS dinámico | Excel | AI prompt | AI fallback | Estado |
|--------|--------------|-------------|-------|-----------|-------------|--------|
| Van Westendorp | ✅ 41 attrs | ✅ 5 funciones | ✅ | ✅ | ✅ (corregido esta sesión) | **Completo** |
| NMS | ✅ 34 attrs | ✅ | ✅ | ✅ | ✅ (corregido esta sesión) | **Completo** |
| MaxDiff | ✅ | ✅ | ✅ + shrinkage | ✅ | ✅ (corregido esta sesión) | **Completo** |
| CBC Conjoint | ✅ | ✅ | ✅ + utilidades individuales | ✅ | ✅ (corregido esta sesión) | **Completo** |
| TURF | ✅ | ✅ (incluye Shapley Values) | ✅ | ✅ | — (usa fallback inline, ya bilingüe) | **Completo** |

**El Modo Cálculo completo es bilingüe ES/EN.** No queda i18n pendiente en ninguno de los 5 módulos.

**Infraestructura reutilizable construida**: las claves `calc.*` compartidas (botones, export, outliers, AI loading, `calc.version`, `calc.md.total`, `calc.md.ver1/ver2`) se comparten entre módulos. Si se agrega un módulo nuevo, revisar primero qué claves ya existen antes de crear nuevas.

**Lecciones para futuros módulos** (ver 4.5.A para detalle): revisar colisión de variable local `t` antes de traducir cualquier función; los fallbacks de IA deben ser bilingües desde el inicio, no solo el prompt.

---

## 6. Arquitectura técnica clave

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
  c:   { attrs, vers, design, data, res, priceAttr, simN },  // CBC Conjoint — res.indivUtils: utilidades individuales suavizadas (nuevo)
  m:   { items, vers, design, data, res },                    // MaxDiff — res.indivScores: net/norm ya suavizados con Empirical Bayes (nuevo)
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

### 7.1 Mapa de Posicionamiento (Análisis de Correspondencias)

- **Problema gerencial**: ¿Cómo se percibe nuestra marca en relación a la competencia y los atributos del mercado?
- **Input**: tabla de frecuencias marca × atributo (percepción del consumidor)
- **Algoritmo**: SVD de la matriz chi-cuadrado estandarizada → coordenadas 2D para marcas y atributos
- **Output**: mapa perceptual interactivo en Canvas con marcas y atributos en el mismo espacio bidimensional
- **Decisión gerencial**: identificar huecos de posicionamiento, detectar atributos diferenciadores, estrategia de reposicionamiento
- **Caso pedagógico sugerido**: categoría de bebidas energizantes o tarjetas de crédito en Lima
- **Viabilidad técnica**: implementable en Vanilla JS sin librerías (SVD es ~60 líneas en JS)

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
| D2 | Sin re-render automático al cambiar idioma | Los resultados ya renderizados permanecen hasta el próximo análisis |
| D3 | Exclusión del scope i18n | Script R (comentarios en ES), nombres de hojas Excel internas, genXAI en ES salvo solicitud |
| D4 | Simulador CBC en Modo Aprendizaje | Escenarios pre-configurados, no simulador interactivo |
| D5 | "Salud Directa" bilingüe | Nombre de empresa igual en ES y EN |
| D6 | 2 productos por defecto en simulador | El simulador CBC del Modo Cálculo inicia con 2 productos |
| D7 | Gumbel noise scale=1.0 | Para `loadCDemo()` y `genData()` de casos pedagógicos CBC |
| D8 | Estrategia i18n mixta | HTML estático → `data-i18n`; JS dinámico → ternarios `_lang==='es'?...:...` |
| D9 | Bayesian smoothing: Empirical Bayes cerrado, no MCMC completo | HB-MNL con Metropolis-Hastings evaluado y descartado por costo de complejidad/mantenimiento; se implementó el espíritu del paper de Orme (2026) con fórmula cerrada precision-weighted |
| D10 | Simulador de market share CBC sigue homogéneo por ahora | `S.c.res.indivUtils` ya existe y está calculado, pero el simulador (Modo Cálculo) no lo usa todavía — heterogeneidad real es trabajo futuro explícitamente diferido |
| D11 | Nunca nombrar una variable local `t` en funciones a traducir | Colisión con la función global `t()` de i18n; encontrado y corregido en `renderMC()` y `renderCC()` |

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
| `CONTEXTO_Kit_Investigacion_Mercados.md` | System context y principios del proyecto | Alta — subir como instrucciones del proyecto |
| `HANDOFF_Kit_v5_Estado_y_Roadmap.md` | Este documento | Alta — subir al proyecto |
| `kit_investigacion_mercados_v5.html` | Código fuente completo (6.764 líneas) | Alta — subir al proyecto |

---

## 11. Recomendaciones para la nueva conversación

### Prioridad inmediata

La i18n del Modo Cálculo está **completa** (los 5 módulos). Las tres líneas de trabajo abiertas al cierre de esta conversación, en orden sugerido:

1. **Simulador de market share heterogéneo en CBC (Modo Cálculo)** — `S.c.res.indivUtils` ya existe (utilidades individuales suavizadas con Empirical Bayes). Falta rediseñar `initSim()`/`updateSim()` para que cada "encuestado sintético" vote con sus propias utilidades en vez de usar las agregadas para todo el mercado. Es la continuación natural del trabajo de shrinkage de esta sesión.
2. **Mapa de Posicionamiento (Análisis de Correspondencias)** — ver 7.1, sigue siendo el módulo nuevo de mayor prioridad.
3. **Aplicar Empirical Bayes shrinkage también al script R exportable** (`buildMScript`, `buildCScript`) — hoy los scripts R usan `mlogit`/conteo simple sin ningún smoothing; sería consistente ofrecer también ahí una versión con `bayesm` o `ChoiceModelR` (HB real) como alternativa avanzada, ya que el usuario de R típicamente tiene más tiempo de cómputo disponible que el navegador.

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
