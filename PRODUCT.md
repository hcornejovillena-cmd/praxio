# Product

## Register

product

## Platform

web

## Users

Dos roles con el mismo peso: **profesores** universitarios que enseñan investigación cuantitativa de mercados en Latinoamérica y adoptan Praxio como herramienta de curso (deciden si se usa, y también la usan en clase para demostrar y explicar), y **estudiantes** que la usan directamente en el Modo Cálculo y el Modo Aprendizaje para resolver casos guiados. El diseño debe servir ambos roles: suficientemente riguroso para que un profesor lo valide como material de curso, y suficientemente guiado para que un estudiante lo resuelva sin supervisión constante.

## Product Purpose

Praxio es una plataforma educativa de investigación cuantitativa de mercados (bilingüe ES/EN, single-file, sin backend) con dos modos: Modo Cálculo (herramienta técnica libre sobre CBC Conjoint, MaxDiff, Van Westendorp, NMS y TURF) y Modo Aprendizaje (casos pedagógicos guiados con pretest, diagnóstico, análisis, interpretación y reporte). El éxito se mide en dos horizontes que se alimentan entre sí: que los estudiantes aprendan e interpreten correctamente cada técnica, y que eso impulse la adopción por más profesores y universidades de la región.

## Positioning

Ofrece el mismo poder analítico que herramientas comerciales de investigación de mercados (miles de USD/año de licencia), sin costo, para universidades sin ese presupuesto.

## Brand Personality

Profesional, confiable, pedagógico.

## Anti-references

Software estadístico clásico (SPSS, Sawtooth Lighthouse Studio): evitar su estética densa, gris, de menús anidados y tablas sin jerarquía visual.

## Design Principles

- **Rigor sin intimidar**: profesional y confiable, pero nunca tan denso como el software estadístico clásico que es su anti-referencia.
- **Mismo estándar que las herramientas pagadas, sin excusas por ser gratis**: metodología citada (papers de Orme, Sawtooth Software), WCAG AA, i18n completo en los 5 módulos — gratis no es sinónimo de menor cuidado.
- **Sirve a dos roles a la vez**: cada pantalla debe funcionar tanto para el profesor que evalúa si adoptarla como para el estudiante que la resuelve sin ayuda.
- **Enseña haciendo, no explicando**: el Modo Aprendizaje prioriza que el estudiante ejecute el caso real (datos reales, instrumento real) antes de leerlo en abstracto.

## Accessibility & Inclusion

Nivel objetivo: WCAG AA. Ya implementado: contraste ≥4.5:1 en texto normal y ≥3:1 en texto grande, encabezados semánticos (`<h1>`/`<h3>`), navegación completa por teclado (tabindex + role="button" + Enter/Space en elementos interactivos dinámicos), `aria-live="polite"` en las zonas donde la IA genera conclusiones, y `aria-label` en botones de solo ícono. Sin requisitos adicionales confirmados por ahora.
