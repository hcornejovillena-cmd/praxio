# Praxio — Kit de Investigación de Mercados

Plataforma educativa bilingüe (ES/EN) de investigación cuantitativa de mercados. Sin backend, sin instalación: un solo archivo HTML que corre en el navegador.

**Demo en vivo**: https://hcornejovillena-cmd.github.io/praxio/

## Qué incluye

**Modo Cálculo** — herramienta técnica libre, un módulo por técnica:

- CBC Conjoint
- MaxDiff (Best-Worst Scaling)
- Van Westendorp PSM
- Van Westendorp + Newton-Miller-Smith
- TURF Analysis
- Mapa de Posicionamiento (Análisis de Correspondencias)

Cada módulo: wizard de carga y validación de datos → análisis → resultados → exportación a Excel → script R equivalente → conclusiones generadas por IA (con fallback automático basado en reglas si no se configura una API key). El Mapa de Posicionamiento sigue el mismo flujo con exportación a Excel (coordenadas, residuos estandarizados, inercia por dimensión) y CSV de coordenadas; no incluye script R (solo CBC Conjoint y MaxDiff lo tienen, decisión explícita para no duplicar el parser de 3 formatos de entrada en otro lenguaje).

**Modo Aprendizaje** — casos pedagógicos guiados de principio a fin: problema de negocio → caso → selección metodológica → pretest → diagnóstico de datos → análisis → interpretación → postest → reporte descargable.

## Para quién es

Profesores universitarios que enseñan investigación cuantitativa de mercados y estudiantes que la practican, sin depender de licencias comerciales (Sawtooth, Qualtrics XM) fuera del alcance de la mayoría de universidades. Ver `PRODUCT.md` para el contexto completo de producto.

## Uso

Abrir directamente `index.html` en un navegador (local o vía la demo en vivo). No requiere instalación, servidor ni build. La URL de la demo en vivo es fija y siempre sirve la última versión — no cambia entre releases.

Los archivos `kit_investigacion_mercados_v*.html` (incluido `v6.1.html`, idéntico al `index.html` actual) se conservan en el repo como snapshots de cada versión publicada, no como el punto de entrada.

## Documentación del proyecto

- `PRODUCT.md` — contexto de producto: usuarios, propósito, principios de diseño.
- `HANDOFF_Kit_v6_Estado_y_Roadmap.md` — estado técnico, arquitectura, roadmap.
- `CAMBIOS.md` — registro de cambios.
- `CHANGELOG_Corr_v6.1.md` — ajustes al módulo de Análisis de Correspondencias en v6.1.

## Licencia

MIT — ver [LICENSE](LICENSE). Se agradece atribución si lo adaptas para tu curso o institución.

---

v6.1 · por Hugo Cornejo Villena
