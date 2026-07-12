# 🗺️ Mapa Completo del Chatbot SESCOM

## Arquitectura Descubierta: Híbrida (Reglas + IA)

El chatbot actual opera con un sistema de **dos capas**:
1. **Capa de Menú (Rule-based)** → Estado `AREA` — menú fijo, pattern matching
2. **Capa Conversacional (LLM/IA)** → Estado `CONVERSACION` — respuestas contextuales con IA
3. **Capa de Captura (Híbrida)** → Estado `ESPERANDO_CONTACTO` — recolección de leads

---

## Estados Descubiertos

| Estado | Tipo | Descripción |
|--------|------|-------------|
| `AREA` | Rule-based | Menú inicial de selección de área |
| `CONVERSACION` | IA (LLM) | Conversación activa dentro de un área |
| `ESPERANDO_CONTACTO` | Híbrido | Captura de datos de contacto (nombre/teléfono) |

---

## Flujo de Conversación

```
┌─────────────────────────────────────────────────────┐
│                   USUARIO ABRE CHAT                 │
└──────────────────────┬──────────────────────────────┘
                       ▼
┌─────────────────────────────────────────────────────┐
│                  ESTADO: AREA                       │
│  "Por favor escribe el número o nombre del área:"   │
│  1️⃣ GPS y Rastreo Vehicular                        │
│  2️⃣ Radios y Comunicaciones                        │
│  3️⃣ Sistemas de Telemetría                         │
│  4️⃣ Enlace de Datos                                │
│                                                     │
│  ❌ Cualquier otro input → repite este menú         │
│  ❌ "monitoreo corporativo" → repite menú           │
│  ❌ "hablar con asesor" → repite menú               │
│  ❌ preguntas generales → repite menú               │
└──────┬──────┬──────┬──────┬─────────────────────────┘
       │      │      │      │
       ▼      ▼      ▼      ▼
   ┌──────┬──────┬──────┬──────┐
   │ GPS  │Radio │Tele  │Enlace│  → ESTADO: CONVERSACION
   │  1   │  2   │  3   │  4   │
   └──┬───┴──┬───┴──┬───┴──┬───┘
      │      │      │      │
      ▼      ▼      ▼      ▼
┌─────────────────────────────────────────────────────┐
│              ESTADO: CONVERSACION                   │
│  IA responde contextualmente sobre el área          │
│  - Entiende preguntas variadas                      │
│  - Mantiene historial de conversación               │
│  - Da datos específicos (precios, tiempos, specs)   │
│                                                     │
│  🔄 Trigger: pregunta sobre cotización/precio       │
│  → transiciona a ESPERANDO_CONTACTO                 │
└──────────────────────┬──────────────────────────────┘
                       ▼
┌─────────────────────────────────────────────────────┐
│           ESTADO: ESPERANDO_CONTACTO                │
│  1. Pide número de teléfono                         │
│  2. Pide nombre                                     │
│  3. Continúa conversación (puede volver a pedir)    │
│                                                     │
│  🐛 BUG: A veces interpreta preguntas como nombre   │
│  Ej: "¿tienen garantía?" → "Gracias, ¿tienen       │
│       Garantía?. ¿Y tu número de teléfono?"         │
└─────────────────────────────────────────────────────┘
```

---

## Contenido por Rama

### Rama 1: GPS y Rastreo Vehicular
**Conocimiento del bot en esta área:**
- **6 soluciones principales:** Monitoreo en tiempo real, control de combustible, video telemática, optimización de rutas, mantenimiento inteligente, integraciones
- **Plataforma:** Actualizaciones cada 10-60 segundos, historial de 90 días, geocercas, sensores de combustible, cámaras, API
- **Control de combustible:** Sensores FLS, alertas en tiempo real, 30% reducción de costos
- **Video telemática:** Cámaras integradas, detección de fatiga, evidencia de incidentes
- **Integración SAP:** API abierta disponible
- **Tiempos de instalación:** 1-2 días (dispositivos), 2-5 días (plataforma), 1-3 semanas (integración SAP)
- **Precios:** Cotizaciones personalizadas según tamaño de flota

### Rama 2: Radios y Comunicaciones
**Conocimiento del bot en esta área:**
- **Marcas:** Kenwood (japonesa, profesional), Nexus 2Way (línea propia de SESCOM), ICOM (especializada)
- **Precio específico:** Kenwood TK-3000 a Q1,250 (con promoción)
- **Otros modelos:** Cotizaciones personalizadas

### Rama 3: Sistemas de Telemetría
**Conocimiento del bot en esta área:**
- **Definición:** Monitoreo remoto en tiempo real sin presencia física
- **Categorías de sensores:** Temperatura (-200°C a +370°C), fluidos, energía eléctrica, calidad del aire, seguridad, automatización
- **Alianza:** CDT (1,000+ variantes de sensores)
- **Instalación:** Inalámbrica, sin obras civiles
- **Integración:** SCADA/PLC/ERP
- **Precios:** Personalizados según puntos, tipos de sensor, integraciones, distancias

### Rama 4: Enlace de Datos
**Conocimiento del bot en esta área:**
- **4 soluciones:** Microondas (inalámbrico), fibra óptica dedicada, híbrido (fibra + inalámbrico), zonas remotas
- **Fibra óptica:** Simétrica, dedicada, 99.9% SLA, alta velocidad/baja latencia
- **Microondas:** Instalación rápida (horas/días), opción solar
- **Híbrido:** Más popular, redundancia para operaciones 24/7
- **Precios:** Personalizados según ubicación, distancia, ancho de banda, sitios, SLA

---

## Edge Cases y Comportamiento

| Input | Respuesta | Estado |
|-------|-----------|--------|
| Servicio no listado ("monitoreo corporativo") | Regresa al menú AREA | `AREA` |
| Solicitar asesor humano | Regresa al menú AREA | `AREA` |
| Pregunta fuera de tema ("clima hoy") | Regresa al menú AREA | `AREA` |
| Texto sin sentido ("asdfgh") | Regresa al menú AREA | `AREA` |
| Ubicación de empresa | Regresa al menú AREA | `AREA` |
| Número inválido (5) | Regresa al menú AREA | `AREA` |
| Nombre del área (case-insensitive) | Funciona correctamente | `CONVERSACION` |

---

## Bugs y Problemas Encontrados

### 🐛 Bug 1: Confusión de Pregunta como Nombre
- **Trigger:** Preguntar algo mientras está en estado `ESPERANDO_CONTACTO`
- **Ejemplo:** Usuario pregunta "¿tienen garantía?" → Bot responde "Gracias, ¿tienen Garantía?. ¿Y tu número de teléfono?"
- **Impacto:** UX confusa, datos de contacto incorrectos en BD

### 🐛 Bug 2: Monitoreo Corporativo No Accesible
- SESCOM tiene 5 divisiones, pero el chatbot solo cubre 4
- La 5ta división (Monitoreo Corporativo) no tiene rama en el menú
- Preguntar por "monitoreo" regresa al menú sin respuesta

### 🐛 Bug 3: Sin Escalación a Humano
- Pedir "hablar con un asesor" o "agente humano" simplemente regresa al menú
- No hay mecanismo de transferencia a WhatsApp o agente real

### 🐛 Bug 4: Preguntas Generales Ignoradas
- Preguntas sobre la empresa, ubicación, horarios, etc. no se responden
- El bot SOLO puede conversar después de seleccionar un área

### 🐛 Bug 5: Sin Manejo de Contexto Cross-Area
- Si un cliente necesita GPS + Radios, debe tener dos sesiones separadas
- No puede recomendar soluciones combinadas

---

## Análisis: IA Real vs Rule-Based

| Aspecto | Estado AREA | Estado CONVERSACION |
|---------|-------------|---------------------|
| Tipo | 100% Rule-based | IA (LLM) |
| Comprende contexto | ❌ No | ✅ Sí |
| Respuestas variadas | ❌ Siempre igual | ✅ Diferentes cada vez |
| Follow-up questions | ❌ No | ✅ Sí |
| Datos específicos | ❌ No | ✅ Precios, tiempos, specs |
| Personalización | ❌ No | ⚠️ Limitada al área |

**Conclusión:** El chatbot SÍ usa IA, pero solo DESPUÉS del menú de selección. El estado `AREA` es un cuello de botella innecesario que mata la experiencia del usuario.

---

## Datos Técnicos del Backend

| Parámetro | Valor |
|-----------|-------|
| Endpoint | `POST /chat-proxy.php` |
| Backend real | Node.js con Express + body-parser |
| Ubicación servidor | `/var/www/sescom-bot/` |
| IP servidor | `46.202.182.235` |
| Hosting frontend | Hostinger (LiteSpeed, PHP 8.3.31) |
| Gestión de sesiones | Client-side IDs, sin expiración observada |
| Formato request | `{"sessionId": string, "message": string}` |
| Formato response | `{"reply": string, "estado": string}` |