# 🚀 Propuesta: Chatbot Inteligente SESCOM v2.0

## El Problema Actual

El chatbot actual de SESCOM tiene una barrera de entrada que destruye conversiones:

```
Usuario: "¿Cuánto cuesta el GPS para mi flota de 20 camiones?"
Bot:     "Por favor escribe el número del área: 1️⃣ GPS  2️⃣ Radios..."
```

**El usuario ya dijo lo que necesita, pero el bot lo ignora.** Esto genera:
- Abandono inmediato de usuarios impacientes
- Leads perdidos que nunca llegan a la conversación real
- Imagen de tecnología obsoleta para una empresa de tecnología

## La Solución: IA Conversacional desde el Primer Mensaje

### Arquitectura Propuesta

```
┌─────────────────────────────────────────────────────────────┐
│                    FRONTEND                                 │
│  Widget embebido (React/Vanilla JS)                         │
│  • Streaming de respuestas (efecto typing real)             │
│  • Botones de acción rápida                                 │
│  • Markdown rendering                                       │
│  • Carrusel de productos                                    │
│  • Indicador de "escribiendo..."                            │
│  • Modo oscuro/claro                                        │
└──────────────────────┬──────────────────────────────────────┘
                       │ HTTPS (WebSocket o SSE)
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                   API BACKEND                               │
│  Next.js / Vercel Functions (Fluid Compute)                 │
│  • Rate limiting (10-20 req/min por IP)                     │
│  • CORS estricto (solo sescom.com.gt)                       │
│  • Validación de input                                      │
│  • Session management (server-side)                         │
│  • Error handling (sin stack traces)                        │
│  • Logging y analytics                                      │
└──────────────────────┬──────────────────────────────────────┘
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
┌──────────────┐ ┌──────────┐ ┌──────────────┐
│  Claude API  │ │   MCP    │ │   Base de    │
│  (Opus/      │ │ Servers  │ │ Conocimiento │
│   Sonnet)    │ │          │ │              │
│              │ │ • CRM    │ │ • empresa.md │
│ System       │ │ • WhatsApp│ │ • gps.md     │
│ Prompt con   │ │ • Calendar│ │ • radios.md  │
│ KB completa  │ │ • Email  │ │ • telemetria │
│              │ │ • Tickets│ │ • enlace.md  │
│              │ │          │ │ • monitoreo  │
└──────────────┘ └──────────┘ └──────────────┘
```

### Diferenciadores vs Chatbot Actual

| Característica | Chatbot Actual | Chatbot Propuesto |
|---------------|----------------|-------------------|
| Primera respuesta | Menú fijo siempre | Respuesta inteligente contextual |
| Entiende lenguaje natural | ❌ Solo en sub-menú | ✅ Desde el primer mensaje |
| Áreas cubiertas | 4 de 5 | 5 de 5 + preguntas generales |
| Escalación a humano | ❌ No funciona | ✅ WhatsApp / Agente con contexto |
| Preguntas generales | ❌ Ignoradas | ✅ Respondidas (ubicación, horarios, etc.) |
| Multi-servicio | ❌ Un área por sesión | ✅ Puede recomendar soluciones combinadas |
| Multimedia | ❌ Solo texto | ✅ Imágenes, botones, links, carrusel |
| Streaming | ❌ Respuesta completa | ✅ Token por token (typing real) |
| Seguridad | 🔴 8 vulnerabilidades | ✅ Seguro por diseño |
| Rate limiting | ❌ Ninguno | ✅ Por IP y por sesión |
| Analytics | ❌ Ninguno | ✅ Dashboard de conversaciones |
| Captura de leads | ⚠️ Agresiva/buggy | ✅ Natural y precisa |
| MCP integrations | ❌ No | ✅ CRM, WhatsApp, Calendar |

### Funcionalidades MCP (Model Context Protocol)

#### MCP Server: CRM
- Guardar leads automáticamente cuando el usuario proporciona datos
- Consultar historial de interacciones previas
- Asignar leads al vendedor correcto según área de interés

#### MCP Server: WhatsApp
- Transferir conversación a WhatsApp con contexto completo
- Enviar cotizaciones formateadas por WhatsApp
- Notificar al asesor con resumen de la conversación

#### MCP Server: Calendario
- Agendar demos directamente desde el chat
- Mostrar disponibilidad del equipo de ventas
- Enviar confirmación y recordatorios

#### MCP Server: Cotizador
- Generar cotizaciones preliminares basadas en las necesidades
- Calcular costos estimados según tamaño de flota/instalación
- Enviar PDF de cotización por email

### System Prompt Propuesto

```
Eres el Asistente Virtual de SESCOM, la empresa líder en comunicaciones
críticas en Guatemala con 34 años de experiencia.

PERSONALIDAD:
- Profesional pero cercano
- Técnicamente competente
- Orientado a resolver necesidades
- Proactivo en ofrecer soluciones integradas

CONOCIMIENTO:
[Se inyecta la base de conocimiento completa de docs/conocimiento/]

REGLAS:
1. SIEMPRE responde la pregunta del usuario primero, sin importar qué pregunte
2. Si la pregunta es sobre un servicio específico, da información detallada
3. Si la pregunta es general, responde y sugiere servicios relevantes
4. Si el usuario necesita múltiples servicios, recomienda solución integral
5. Ofrece agendar demo cuando detectes interés genuino (no forzar)
6. Si no sabes algo, di que transferirás a un asesor especializado
7. Nunca inventes precios — usa los del catálogo o sugiere cotización
8. Menciona clientes de referencia cuando sea relevante
9. Destaca las ventajas competitivas (infraestructura propia, 34 años, etc.)
10. Si detectas urgencia o proyecto grande, escalación inmediata a WhatsApp
```

### Stack Tecnológico Recomendado

| Componente | Tecnología | Razón |
|-----------|-----------|-------|
| Frontend | React widget embebible | Ligero, adaptable a cualquier sitio |
| Backend | Next.js en Vercel | Serverless, escalable, seguro |
| IA | Claude API (Sonnet) | Mejor relación costo/calidad en español |
| Streaming | Vercel AI SDK | SSE nativo, typing real |
| Base de conocimiento | Markdown files | Fácil de actualizar por el cliente |
| MCP | Protocol estándar | Extensible, futuro-proof |
| Base de datos | Vercel Postgres / Neon | Serverless, sin mantenimiento |
| Analytics | Custom dashboard | Métricas de conversación |
| Hosting | Vercel | CDN global, HTTPS, headers seguros |

### Costos Estimados

| Concepto | Mensual |
|----------|---------|
| Vercel Pro | $20 |
| Claude API (Sonnet, ~5K conversaciones) | $30-80 |
| Neon Postgres (Free tier) | $0 |
| Dominio/DNS | Ya tienen |
| **Total estimado** | **$50-100/mes** |

*vs. costo actual: VPS Node.js + Hostinger + potencial API de IA = similar o más*

### Timeline de Implementación

| Fase | Duración | Entregable |
|------|----------|-----------|
| 1. Prototipo funcional | 1 semana | Chat con IA + KB completa |
| 2. Widget embebible | 1 semana | Integración en sescom.com.gt |
| 3. MCP: WhatsApp + CRM | 1 semana | Escalación + leads automáticos |
| 4. MCP: Calendario + Cotizador | 1 semana | Demos + cotizaciones |
| 5. Dashboard + Analytics | 1 semana | Panel de métricas |
| **Total** | **5 semanas** | Sistema completo |

### Demo para el Cliente

Para la presentación, construiremos un **prototipo funcional** que demuestre:

1. **Conversación natural desde el primer mensaje:**
   - "¿Cuánto cuesta GPS para 20 camiones?" → Respuesta directa con detalles
   
2. **Conocimiento profundo:**
   - Especificaciones técnicas de cada producto
   - Precios donde estén disponibles
   - Casos de éxito relevantes
   
3. **Inteligencia multi-servicio:**
   - "Necesito comunicación en finca remota" → Recomienda radios + enlace de datos
   
4. **Escalación suave:**
   - Transferencia a WhatsApp con resumen de conversación
   
5. **Seguridad:**
   - Sin stack traces, con rate limiting, CORS correcto

---

## Cómo Presentar al Cliente

### Estructura de la Demo (30 min)

1. **"Miren qué hace su chat actual"** (5 min)
   - Mostrar las limitaciones en vivo
   - Mostrar las vulnerabilidades (sin ser invasivo)

2. **"Ahora miren qué podría hacer"** (10 min)
   - Demo del prototipo con IA real
   - Conversaciones naturales
   - Multi-servicio

3. **"Además, se integra con sus herramientas"** (5 min)
   - MCP: WhatsApp, CRM, Calendario
   - Dashboard de analytics

4. **"Seguro por diseño"** (5 min)
   - Comparativa de seguridad
   - Headers, rate limiting, validación

5. **"Inversión y timeline"** (5 min)
   - Costos vs. beneficios
   - Timeline de 5 semanas
   - ROI esperado (más leads, mejor conversión)