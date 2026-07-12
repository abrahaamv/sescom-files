# 🎬 Guión de Demo — Chatbot Inteligente SESCOM v2.0

## Información General
- **Duración:** 30 minutos
- **Audiencia:** Directivos y equipo de tecnología de SESCOM
- **Objetivo:** Demostrar que el nuevo chatbot con IA supera al actual en todos los aspectos y justificar la inversión
- **Formato:** Pantalla compartida mostrando el chatbot en acción + comparaciones en vivo

---

## ACTO 1: "El Problema" (5 minutos)

### Slide 1: Portada
> "Chatbot SESCOM: De Menú a Inteligencia"

### Slide 2: Lo que hace su chatbot hoy

**Narración:**
> "Permítanme mostrarles algo. Voy a abrirle su propio chat como si fuera un cliente."

**DEMO EN VIVO — Chat actual:**

1. Abrir https://sescom.com.gt → clic en burbuja de chat
2. Escribir: **"¿Cuánto cuesta el GPS para 30 camiones?"**
3. Mostrar la respuesta: *"Por favor escribe el número del área: 1️⃣ GPS 2️⃣ Radios..."*

**Narración:**
> "El cliente acaba de decir exactamente lo que necesita. ¿Y qué hace el bot? Le pide que seleccione del menú. El cliente ya le dijo que quiere GPS. Este menú forzado es una barrera que mata conversiones."

4. Escribir: **"Quiero hablar con un asesor"**
5. Mostrar: Regresa al menú otra vez

**Narración:**
> "El cliente quiere hablar con un humano y el bot le muestra el menú de nuevo. El prospecto se va a WhatsApp directo o peor, se va con la competencia."

6. Escribir: **"¿Tienen servicio de monitoreo corporativo?"**
7. Mostrar: Regresa al menú

**Narración:**
> "Monitoreo Corporativo es una de sus 5 divisiones — de hecho es una de las más rentables. Pero su chatbot no la tiene en el menú. Cualquier prospecto que pregunte por esto se pierde."

### Slide 3: Hallazgos de Seguridad (rápido, no profundizar demasiado)

**Narración:**
> "Además, encontramos algunas debilidades técnicas. Si le envío un request mal formado a su endpoint, el servidor responde con un error que revela toda la estructura interna: la ruta del servidor, el framework que usan, las dependencias..."
>
> "También verificamos que no hay rate limiting — pudimos enviar 20 requests consecutivos sin ninguna restricción. Esto significa que alguien podría abusar del servicio o generar costos innecesarios."
>
> "No se preocupen — todo esto se resuelve con la nueva arquitectura."

---

## ACTO 2: "La Solución" (12 minutos)

### Slide 4: Transición
> "Ahora déjenme mostrarles lo que su chatbot PODRÍA hacer."

### Escenario 1: "El Primer Contacto" (2 min)
**Abrir el nuevo chatbot demo**

**Escribir:** `Hola, necesito GPS para mi flota de 30 camiones de distribución`

**Respuesta esperada del agente:**
> "¡Hola! 👋 Con gusto le ayudo. Para una flota de 30 camiones de distribución, SESCOM ofrece una solución GPS completa que incluye:
>
> **Monitoreo en tiempo real** — Ubicación precisa cada 10-60 segundos sobre mapas interactivos
> **Control de combustible** — Sensores FLS que detectan robo por sifón y cargas exactas (ahorro promedio 15-25%)
> **Video telemática** — Cámaras con detección de fatiga del conductor
> **Reportes automáticos** — Rendimiento, rutas, mantenimiento
>
> ¿Le interesa saber más sobre el control de combustible? Con 30 camiones, el ahorro puede ser significativo. También puedo calcularle un estimado de ROI si me dice cuánto gasta aproximadamente en combustible al mes."

**Narración:**
> "Noten la diferencia: el cliente dijo qué necesita y el bot respondió directamente con información relevante. Sin menú. Sin fricción. Y además ya está detectando una oportunidad de venta cruzada con el control de combustible."

### Escenario 2: "ROI Calculator" (2 min)
**Escribir:** `Gastamos como Q120,000 al mes en diesel`

**El agente invoca `calculate_roi` internamente y responde:**
> "Con un gasto de Q120,000/mes en diesel para 30 camiones, el sistema de control de combustible SESCOM puede generar:
>
> | Métrica | Valor |
> |---------|-------|
> | Ahorro mensual estimado | Q18,000 - Q30,000 |
> | Ahorro anual | Q216,000 - Q360,000 |
> | Inversión inicial estimada | ~Q24,000 |
> | Recuperación de inversión | ~1-2 meses |
>
> Estos números se basan en el ahorro promedio de 15-25% que experimentan nuestros clientes, incluyendo empresas como Bimbo y Coca-Cola.
>
> ¿Le gustaría agendar una demo de la plataforma para ver el dashboard de combustible en acción?"

**Narración:**
> "¿Ven lo que acaba de pasar? El bot calculó ROI en tiempo real. Eso es algo que su vendedor tendría que hacer con una calculadora. El prospecto ahora tiene números concretos para llevar a su jefe."

### Escenario 3: "Solución Integrada" — ⭐ KILLER FEATURE (3 min)
**Escribir:** `También tenemos problema de comunicación con los conductores porque en las rutas rurales no hay señal de celular, y quisiéramos monitorear las cámaras de las bodegas remotamente`

**El agente invoca `recommend_integrated_solution` y responde:**
> "Perfecto, lo que me describe es exactamente el tipo de proyecto donde SESCOM se diferencia. Necesita una **solución integrada** que combine 3 de nuestras divisiones:
>
> **1. 📡 Radios Profesionales** — Para comunicación conductor-base sin depender de señal celular
> - Recomendación: Nexus NT450 (10W, ideal para campo abierto) a Q720/unidad
> - Con repetidores propios de SESCOM, cobertura garantizada en rutas rurales
> - Q0/mes de costo recurrente vs ~Q150/línea celular que pagan hoy
>
> **2. 🛰️ GPS con Control de Combustible** — Ya lo discutimos: 15-25% ahorro
>
> **3. 📹 Enlace de Datos + Monitoreo** — Para ver cámaras de bodegas remotas
> - Enlace inalámbrico solar si no hay electricidad en la bodega
> - Todo se ve desde una consola única en su oficina central
>
> **La ventaja SESCOM:** Somos el ÚNICO proveedor en Guatemala que integra estas 3 soluciones. Esto significa: **un solo contrato, una sola factura, un solo equipo de soporte 24/7.**
>
> ¿Le gustaría que programemos una visita técnica gratuita para evaluar sus rutas y bodegas?"

**Narración:**
> "ESTO es lo que el chatbot actual no puede hacer de ninguna manera. El bot detectó que el cliente necesita 3 servicios diferentes y recomendó una solución integrada. Esto es exactamente el modelo de negocio de SESCOM — las 5 divisiones bajo un techo — y ahora el chatbot lo vende automáticamente."

### Escenario 4: "Comparativa de Productos" (2 min)
**Escribir:** `¿Qué diferencia hay entre un radio Kenwood y un Nexus?`

**El agente invoca `compare_products`:**
> "Aquí tiene la comparativa:
>
> | Característica | Kenwood TK-3000 | Nexus NT400 | Nexus NT450 |
> |---------------|-----------------|-------------|-------------|
> | Precio | Q399 | Q399 | Q720 |
> | Potencia | 4W | 5W | 10W |
> | Canales | 16 | 16 | 16 |
> | Protección | IP54 | IP54 | IP54 |
> | Batería | Estándar | Estándar | 2700mAh |
> | Marca | 🇯🇵 Japonesa | SESCOM | SESCOM |
>
> **Mi recomendación para distribución rural:** El **Nexus NT450** (Q720) — tiene 10W de potencia, lo que da mucho mayor alcance en campo abierto. La batería de 2700mAh dura todo el turno. Es la mejor relación costo/rendimiento para sus rutas.
>
> Para operaciones en bodega/ciudad, el **Kenwood TK-3000** (Q399) es suficiente y tiene el respaldo de marca japonesa."

### Escenario 5: "Escalación a WhatsApp" (2 min)
**Escribir:** `Perfecto, me interesa. ¿Puedo hablar con un asesor para cotizar todo esto?`

**El agente invoca `escalate_to_whatsapp`:**
> "¡Con mucho gusto! Le conecto con Carlos, nuestro especialista en soluciones integradas. Le paso el resumen completo de nuestra conversación para que no tenga que repetir nada:
>
> **📋 Resumen para el asesor:**
> - Flota de 30 camiones de distribución
> - Gasto actual: Q120,000/mes en diesel
> - Necesita: GPS + Control combustible + Radios (rutas rurales) + Enlace/cámaras bodegas
> - ROI estimado: Q18-30K/mes en ahorro de combustible + Q0 en comunicaciones
>
> 👉 [**Abrir WhatsApp con Asesor →**](https://wa.me/50224292429?text=...)
>
> Carlos recibirá este resumen automáticamente. ¿Hay algo más en lo que pueda ayudarle?"

**Narración (clic en el link para mostrar que funciona):**
> "El link de WhatsApp ya viene pre-llenado con todo el contexto. El asesor no empieza de cero — sabe exactamente qué necesita el cliente, cuánto gasta y qué solución le recomendamos. Comparen esto con el bot actual, que cuando le piden un asesor... muestra el menú."

---

## ACTO 3: "El Valor" (8 minutos)

### Slide 5: Comparativa Visual

| Característica | Bot Actual | Bot Nuevo |
|---------------|------------|-----------|
| Primera respuesta | Menú fijo | IA contextual |
| Entiende español natural | ❌ | ✅ |
| Divisiones cubiertas | 4 de 5 | 5 de 5 + generales |
| Escalación a humano | ❌ Muestra menú | ✅ WhatsApp con contexto |
| Multi-servicio | ❌ Un área por vez | ✅ Soluciones integradas |
| Calculadora ROI | ❌ | ✅ |
| Comparativas | ❌ | ✅ |
| Analytics | ❌ Cero datos | ✅ Dashboard |
| Seguridad | 🔴 8 vulnerabilidades | ✅ Seguro por diseño |

### Slide 6: Seguridad Resuelta

> "Todas las vulnerabilidades que encontramos se resuelven con la nueva arquitectura:
> - Stack traces eliminados — errores genéricos en producción
> - Rate limiting — máximo 15 requests/minuto por IP
> - CORS estricto — solo sescom.com.gt puede usar el endpoint
> - Headers de seguridad completos
> - Session management del lado del servidor"

### Slide 7: Herramientas del Agente

Mostrar diagrama de las 10 tools:

```
                         AGENTE SESCOM v2.0
                               │
          ┌────────┬────────┬──┴──┬────────┬────────┐
          ▼        ▼        ▼     ▼        ▼        ▼
     Comparar   Calcular  Escalar  Capturar  Recomendar  Buscar
     Productos    ROI     WhatsApp   Lead    Integrado     KB
                               │
                    ┌──────────┼──────────┐
                    ▼          ▼          ▼
               Agendar    Cotizar     Enviar
                Demo     Productos   Brochure
```

### Slide 8: Inversión y Timeline

| Concepto | Detalle |
|----------|---------|
| **Hosting (Vercel)** | $20/mes |
| **IA (Claude API)** | $30-80/mes (~5K conversaciones) |
| **Base de datos** | $0 (free tier) |
| **Total mensual** | **~$50-100/mes** |
| **Desarrollo** | 5 semanas |

**Narración:**
> "Por menos de Q800/mes tienen un chatbot que convierte más leads, reduce carga de trabajo de sus asesores, y genera datos de analytics que hoy no tienen. La inversión de desarrollo se paga sola con los leads adicionales que captura el primer mes."

### Slide 9: Roadmap

| Semana | Entregable |
|--------|-----------|
| 1 | Chat con IA + KB completa (lo que acaban de ver) |
| 2 | Widget embebible en sescom.com.gt + escalación WhatsApp |
| 3 | Comparativas + ROI + solución integrada |
| 4 | Captura de leads + dashboard de analytics |
| 5 | Testing final + lanzamiento |

---

## ACTO 4: "El Cierre" (5 minutos)

### Slide 10: Próximos Pasos

**Narración:**
> "Lo que les acabo de mostrar es funcional — no es un mockup. Está listo para personalizarse e integrarse en su sitio. Los próximos pasos serían:
>
> 1. **Validar la base de conocimiento** — Ya extrajimos toda la información de su sitio web y de su chatbot actual. Necesitamos que su equipo revise y complete con datos que solo ustedes tienen (precios internos, políticas, etc.)
>
> 2. **Definir integraciones** — ¿Qué CRM usan? ¿Quieren integrar Google Calendar? ¿Tienen WhatsApp Business?
>
> 3. **Arrancar la implementación** — En 5 semanas tienen el sistema completo funcionando."

### Slide 11: Pregunta de cierre

> "¿Tienen alguna pregunta? ¿Hay algún escenario que les gustaría ver en acción?"

**Tip para el presentador:** Dejar que ellos propongan preguntas y escribirlas en vivo en el chatbot. Nada impresiona más que responder preguntas improvisadas en tiempo real.

---

## Checklist Pre-Demo

- [ ] Chatbot demo desplegado y funcionando
- [ ] System prompt cargado con toda la KB
- [ ] Tools Tier 1 implementadas (compare, ROI, escalate, recommend)
- [ ] Link de WhatsApp configurado con número real de SESCOM
- [ ] Slides preparadas con datos actualizados
- [ ] Probar todos los escenarios al menos 2 veces antes
- [ ] Tener backup: si el API falla, tener screenshots/grabación
- [ ] Abrir sescom.com.gt en otra pestaña para demostrar bot actual en vivo

---

## Preguntas Anticipadas y Respuestas

**P: "¿Qué pasa si la IA dice algo incorrecto?"**
> R: "El bot solo usa la información de su base de conocimiento oficial — no inventa datos. Si no sabe algo, dice 'no tengo esa información, le conecto con un asesor.' Además, todo es auditable — cada conversación queda registrada."

**P: "¿Y si se cae el servicio?"**
> R: "Vercel tiene 99.99% de uptime global. Si la IA falla momentáneamente, el widget muestra un botón directo a WhatsApp como fallback. Su número +502 2429-2429 siempre funciona."

**P: "¿Podemos agregar más información después?"**
> R: "Sí, la base de conocimiento son archivos markdown que su equipo puede editar. No necesitan programar — solo actualizar el texto y el bot aprende automáticamente."

**P: "¿Qué datos se recopilan del usuario?"**
> R: "Solo lo que el usuario comparte voluntariamente. No hay tracking invasivo. Todo cumple con buenas prácticas de privacidad. Las conversaciones se almacenan para analytics pero no se comparten con terceros."

**P: "¿Cuánto cuesta si tenemos más conversaciones?"**
> R: "El costo escala linealmente. Con 10,000 conversaciones/mes estaríamos en ~$150/mes de API. Sigue siendo mucho menor que un agente humano 24/7."

**P: "¿Podemos ponerlo también en WhatsApp directo?"**
> R: "Sí, es una fase futura natural. El mismo agente puede atender desde el widget web Y desde WhatsApp Business. La lógica es la misma."