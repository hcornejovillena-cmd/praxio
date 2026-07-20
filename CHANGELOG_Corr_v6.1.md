# Changelog — Módulo Análisis de Correspondencias (post-lanzamiento v6)

Corrección de 3 inconsistencias detectadas en pruebas manuales sobre los 3 formatos de entrada, más un ajuste de layout. Ninguna toca el algoritmo estadístico de CA (Jacobi, residuos estandarizados, proyección de suplementarios) ni otros módulos del kit.

---

## Fix 1 — Bug: token "NONE" se colaba como marca en celdas conflictivas (formato Forms)

**Síntoma:** al cargar un archivo Forms con celdas conflictivas tipo `"Marca, NONE"` (una marca elegida junto con el marcador de "ninguna" en la misma celda), "NONE" aparecía en el mapa como una marca suplementaria más (0 menciones, punteada).

**Causa raíz:** el parser real de respuestas (`corrResolveCellForms`) sí aplicaba correctamente la regla de limpieza documentada ("conserva la marca, descarta solo el 'ninguna' de esa celda puntual"). El problema estaba en una función distinta, `confirmCorrConfig` — la que arma la lista de códigos de marca a mostrarle al usuario para asignarles nombre — que solo descartaba `"NONE"` cuando era el valor **completo** de la celda, no cuando aparecía como **token** dentro de una lista separada por comas. Dos piezas de lógica que debían aplicar la misma regla, y solo una lo hacía.

**Fix:** en `confirmCorrConfig`, separar por coma primero y luego filtrar el token `NONE` por elemento — igual que ya hace `corrResolveCellForms`. Sin cambios en el parser de respuestas (ya era correcto).

**Ubicación:** `confirmCorrConfig`, rama `else` (formato Forms), ~línea 8058 del HTML.

**Validado con el archivo real del usuario** (`ACorr_Forms.xlsx`, fila 10, celda `P1_7 = "Omnifit (Omnilife), NONE"`): tras el fix, las marcas detectadas son exactamente `Biopro+tect (Fuxion), Herbalife nutrition, Omnifit (Omnilife), PVM, Whellness` — sin "NONE".

---

## Fix 2 — Gap de diseño: columna "NONE"/"Ninguna" no reconocida en tabla de contingencia

**Síntoma:** al cargar una tabla de contingencia ya agregada que incluía una columna `"NONE"` con conteos reales (no ceros), esa columna se trataba como una marca más — con vector, color y posición propia en el mapa, distorsionando la inercia total.

**Causa raíz:** a diferencia de P&P (`99`) y Forms (`'NONE'`), nunca se especificó una regla para este caso en el formato de contingencia — se asumió que una tabla ya agregada no traería columna de "ninguna". El parser (`corrDetectContingencyFormat`) solo excluía columnas que calzaran con el patrón de "Total"; cualquier otra columna del encabezado se trataba como marca.

**Decisión de diseño (confirmada con el usuario):** exclusión automática de una columna que calce con `/^(NONE|NINGUNA)$/i` — mismo trato que la columna "Total" — con constancia visible en el diagnóstico de calidad (nunca ocultar silenciosamente). Se agrega un renglón en el diagnóstico: `Columna "NONE" excluida (no es una marca) — N menciones`.

**Fix:** nueva constante `CORR_NONE_RE`; `corrDetectContingencyFormat` ahora separa `noneCols` de `brandCols`; `corrParseContingency` sigue excluyéndolas del análisis pero suma sus conteos para reportarlos en `diag.excludedNoneCols`; el panel de diagnóstico de Modo Cálculo muestra esa línea cuando aplica.

**Ubicación:** `CORR_NONE_RE`, `corrDetectContingencyFormat`, `corrParseContingency` (~línea 5363-5420); panel de diagnóstico en `corrRunDiagCalc` (~línea 8110).

**Validado con el archivo real del usuario** (`ACorr_TablaConting.xlsx`): la columna "NONE" (368 menciones totales) queda excluida de las 6 marcas del análisis (Nescafé, Kirma, Altomayo, Juan Valdez, Cafetal, Colcafé) y se reporta en el diagnóstico.

---

## No-fix — Atributos suplementarios: comportamiento correcto, no se modifica

El usuario cuestionó por qué los atributos también pueden quedar como "suplementarios" (punto punteado, excluido del cálculo de ejes) cuando, a diferencia de las marcas, todos los encuestados evalúan todos los atributos. Se revisó contra el HANDOFF: la regla de categorías raras (umbral de 5% de menciones totales, método de puntos suplementarios de Greenacre, base en Le Roux & Rouanet) se documentó explícitamente como aplicable a **marcas y atributos por igual** — es una propiedad simétrica de filas/columnas en Análisis de Correspondencias, no un descuido de implementación. La "oportunidad de respuesta" no es lo que determina la masa de un atributo en la matriz final; un atributo puede ser evaluado por todos los encuestados y aun así acumular pocas menciones reales si la mayoría respondió "ninguna" para él. **Sin cambios de código.** Queda registrado por si se decide reabrir esta discusión de diseño más adelante (requeriría discusión explícita, por regla del proyecto).

---

## Fix 4 — Layout: canvas del mapa con tope fijo de 560px

**Síntoma:** el mapa perceptual se veía pequeño en los 3 formatos, con etiquetas de atributo apretadas/solapadas en datasets con muchos atributos (ej. 15 atributos en el caso P&P).

**Causa raíz:** tanto el `<div>` contenedor como el cálculo JS del lado del canvas (`drawCorrespondenceMap`) tenían un tope fijo de 560px, sin relación con el ancho real disponible de la tarjeta (`.card`), que en escritorio suele medir 900-1000px. A diferencia de otros charts del kit (ej. `shapley-scatter-canvas`), que sí escalan con el contenedor.

**Decisión confirmada con el usuario:** escalar con el ancho del contenedor, con un tope alto de 960px (en vez de tope fijo bajo).

**Fix:** `max-width:560px` → `max-width:960px` en los wrappers HTML de Modo Cálculo (`calc-corr-canvas`) y Modo Aprendizaje (`edu-corr-canvas`); en `drawCorrespondenceMap`, el cálculo de `side` ahora usa `Math.min(canvas.parentElement?.offsetWidth||560, 960)` en vez de un tope duro en 560.

**Ubicación:** líneas ~1250 y ~4266 (wrappers HTML); `drawCorrespondenceMap` ~línea 5658 del HTML.

---

## Fix 5 — Claridad: etiqueta combinada "893+2" en el diagnóstico no se autoexplicaba

**Síntoma:** el panel de diagnóstico mostraba una sola línea `"Respuestas 'ninguna'" → 893+2`, sumando dos conceptos distintos sin explicarlos por separado.

**Fix:** se separó en dos líneas independientes y autoexplicativas, en Modo Cálculo y Modo Aprendizaje:
- `"Celdas marcadas explícitamente como 'ninguna marca'"` → cuenta de `diag.explicitNone` (código `99` / string `'NONE'`).
- `"Celdas vacías sin marcador (ningún atributo asociado, ni siquiera 'ninguna')"` → cuenta de `diag.blankAsNone`, resaltada en amarillo/advertencia cuando es mayor a 0 (puede indicar un problema de digitación, no solo desinterés real — consistente con la razón de ser de esta distinción, ya documentada en el HANDOFF).

**Ubicación:** panel de diagnóstico en `renderCorrConfigStep`/diagnóstico edu (~línea 3968) y `corrRunDiagCalc` (~línea 8124).

---

## Nota de validación del usuario

La captura de "gráfico pequeño / apiñado" enviada después del Fix 4 correspondía a una prueba hecha con la versión **anterior** a estas correcciones (v6, no v6.1) — no reveló un bug nuevo. Queda pendiente que el usuario valide el tamaño del mapa con el archivo v6.1 ya corregido.


- Los 3 parsers corregidos se probaron de forma aislada (extraídos y ejecutados en Node) contra los 3 archivos reales aportados por el usuario (`ACorr_Forms.xlsx`, `ACorr_TablaConting.xlsx`, `ACorr_P_P.xlsx`).
- Se verificó que los 3 bloques `<script>` del HTML completo siguen parseando sin errores de sintaxis tras las ediciones.
- No se modificó ningún otro módulo (CBC, MaxDiff, Van Westendorp, Van Westendorp+NMS, TURF).

## Pendiente para discusión futura

- El caso "atributos suplementarios" queda documentado como comportamiento correcto pero abierto a reconsideración si el usuario insiste tras esta explicación.
