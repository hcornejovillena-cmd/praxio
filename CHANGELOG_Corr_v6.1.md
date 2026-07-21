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

## Fix 6 — El canvas cuadrado dejaba la mitad del mapa en blanco con inercia muy asimétrica

**Síntoma (reportado tras validar el Fix 4 en producción):** con el canvas ya escalando correctamente al ancho del contenedor (confirmado en consola: `canvas.width=960`, `parentElement.offsetWidth=960`), el mapa seguía viéndose "apiñado" con mucho espacio en blanco arriba y abajo, en un dataset con Dimensión 1 = 91.6% de inercia y Dimensión 2 = 8.4%.

**Causa raíz:** el canvas se forzaba a ser siempre **cuadrado** (`canvas.width=canvas.height=side`). Al mantener la misma escala en ambos ejes (correcto, para no distorsionar el mapa), un dataset donde el rango real de la Dimensión 2 es mucho menor que el de la Dimensión 1 termina graficado en una banda horizontal delgada dentro de un cuadrado — con la mayor parte del cuadrado vacía arriba y abajo. Esto no era un bug de "tamaño insuficiente" (el Fix 4 sí funcionaba), sino de **forma** fija e inadecuada para la proporción real de los datos.

**Fix:** el alto del canvas ahora se calcula en función de la proporción real `rangeY/rangeX` de los datos (mismo ancho disponible del contenedor, tope 960px), de modo que los puntos ocupen un porcentaje similar del área disponible en ambos ejes — sin tocar la escala (que sigue siendo idéntica en X e Y, preservando la representación fiel del mapa). Se aplican un piso (`max(320, 0.35×ancho)`) y un techo (`1.2×ancho`) para evitar formas extremas (una franja inservible o una torre angosta) en casos límite.

**Ubicación:** `drawCorrespondenceMap`, recálculo de `W`/`H` (~línea 5654-5680 del HTML). Sin cambios en la lógica de escala, ejes, ni en el algoritmo de CA.

**Validado con fórmula aislada** contra el caso reportado (inercia ~91.6%/8.4%): pasa de un cuadrado 960×960 (con ~65% de área en blanco) a un rectángulo 960×336 que aprovecha el espacio real. Casos balanceados (inercia repartida entre ambas dimensiones) no cambian de comportamiento (siguen dando un cuadrado).



## Fix 7 — Números de atributo casi invisibles dentro de los cuadrados

**Síntoma (reportado tras validar el Fix 6):** con el canvas ya proporcionado correctamente, se notó que los números dentro de los cuadrados de atributo (1, 2, 3...) casi no se distinguían.

**Causa raíz:** el número se dibujaba en blanco **dentro** del cuadrado, y tanto el cuadrado como el número compartían la misma opacidad reducida por `cos²` (calidad de representación) — en atributos con `cos²` bajo (opacidad mínima 0.35), el conjunto quedaba muy tenue y el contraste blanco-sobre-gris-tenue se volvía casi ilegible, agravado en cuadrados pequeños (tamaño proporcional a la masa del atributo).

**Fix:** replicando el tratamiento que ya usan las marcas (nombre en negro sólido junto al círculo, a opacidad plena, independientemente del `cos²` del punto): el cuadrado se sigue dibujando atenuado por `cos²` (esa información sigue siendo válida y visible), pero el número ahora se dibuja **afuera** del cuadrado, en negro sólido (`#1a1714`) y a opacidad plena — igual que el nombre de marca.

**Ubicación:** bloque de dibujo de atributos en `drawCorrespondenceMap` (~línea 5720-5734 del HTML). Sin cambios en `corrPlaceLabels` (colocación/anticolisión de etiquetas) ni en el algoritmo de CA.



La primera captura de "gráfico pequeño / apiñado" (enviada justo después del Fix 4) correspondía a una prueba hecha con la versión **anterior** a estas correcciones (v6, no v6.1) — no reveló un bug nuevo.

Una segunda captura, ya sobre v6.1 publicada, mostró el mismo síntoma visual. Se verificó en la consola del navegador del usuario (`canvas.width=960`, `parentElement.offsetWidth=960`, `max-width=960px`) que el Fix 4 sí estaba funcionando correctamente — el canvas medía el ancho real del contenedor sin problema. El síntoma remanente era otra causa distinta: la forma cuadrada forzada del canvas, no apta para datasets con inercia muy asimétrica entre dimensiones. Esto se resolvió en el **Fix 6**.


- Los 3 parsers corregidos se probaron de forma aislada (extraídos y ejecutados en Node) contra los 3 archivos reales aportados por el usuario (`ACorr_Forms.xlsx`, `ACorr_TablaConting.xlsx`, `ACorr_P_P.xlsx`).
- Se verificó que los 3 bloques `<script>` del HTML completo siguen parseando sin errores de sintaxis tras las ediciones.
- No se modificó ningún otro módulo (CBC, MaxDiff, Van Westendorp, Van Westendorp+NMS, TURF).

## Pendiente para discusión futura

- El caso "atributos suplementarios" queda documentado como comportamiento correcto pero abierto a reconsideración si el usuario insiste tras esta explicación.
