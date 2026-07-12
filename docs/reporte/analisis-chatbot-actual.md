# Análisis del Chatbot Actual de SESCOM

## Resumen Ejecutivo
El chatbot actual de SESCOM es un **bot basado en estados** (state machine) implementado en PHP como proxy hacia un backend Node.js en un VPS. No posee inteligencia artificial real — opera con un flujo de menú fijo que dirige al usuario a seleccionar un área antes de procesar cualquier consulta.

## Arquitectura Técnica

### Frontend
- **Widget:** Burbuja flotante con ventana de chat embebida en el sitio
- **Archivo:** `js/sescom-chat.js` (IIFE autocontenido)
- **Estilos:** `css/sescom-chat.css`
- **Interacción:** Input de texto + botón enviar, soporte Enter key

### Backend
- **Endpoint público:** `https://sescom.com.gt/chat-proxy.php`
- **Método:** POST con JSON `{sessionId, message}`
- **Respuesta:** JSON `{reply, estado}`
- **Stack:** PHP 8.3 en Hostinger (LiteSpeed) → Proxy al VPS del bot
- **Modo local:** Apunta a `/chat` directo (puerto 4001)

### Sesión
- `sessionId` generado en frontend: `sc_` + 9 chars random (base36)
- No hay autenticación, headers especiales, CAPTCHA ni protección CORS

## Flujo de Conversación Descubierto

### Estado Inicial: `AREA`
**Trigger:** Cualquier mensaje cuando no hay sesión activa
**Respuesta fija (siempre la misma):**
```
Por favor escribe el número o nombre del área:

1️⃣  GPS y Rastreo Vehicular
2️⃣  Radios y Comunicaciones
3️⃣  Sistemas de Telemetría
4️⃣  Enlace de Datos
```

**Problema crítico:** Ignora completamente la pregunta del usuario. Ya sea "Hola", "¿Qué servicios ofrecen?" o "¿Cuáles son sus precios?" — siempre responde con el mismo menú.

### Estados por descubrir (en proceso de mapeo)
- Estado después de seleccionar área 1 (GPS)
- Estado después de seleccionar área 2 (Radios)
- Estado después de seleccionar área 3 (Telemetría)
- Estado después de seleccionar área 4 (Enlace de Datos)
- Manejo de solicitud de asesor humano
- Manejo de preguntas fuera de tema
- Manejo de Monitoreo Corporativo (no aparece en menú)

## Debilidades Identificadas

### UX / Experiencia de Usuario
1. **No saluda naturalmente** — Fuerza selección de menú sin importar qué escriba el usuario
2. **No entiende lenguaje natural** — "Quiero GPS" debería llevarte directo, no al menú
3. **Menú incompleto** — Falta "Monitoreo Corporativo" (5ta división de SESCOM)
4. **No maneja contexto** — Cada interacción parece ser procesada de forma aislada
5. **No ofrece escalación visible** — No es claro cómo llegar a un humano

### Técnicas
1. **Sin protección** — No CORS, no CAPTCHA, no rate limiting visible
2. **Proxy innecesario** — Doble hop (Hostinger PHP → VPS Node.js)
3. **Sin websockets** — No hay streaming ni typing real
4. **Sin persistencia visible** — No recuerda conversaciones previas

### Contenido
1. **Respuestas genéricas** — No aprovecha todo el contenido rico del sitio web
2. **Sin personalización** — No adapta respuestas al contexto del usuario
3. **Sin multimedia** — Solo texto plano, no imágenes/enlaces/botones

## Oportunidades para el Nuevo Chatbot

### Mejoras Inmediatas
- IA conversacional real (Claude/GPT) que entienda lenguaje natural
- Respuesta inteligente desde la primera interacción
- Cobertura de las 5 divisiones completas
- Escalación suave a WhatsApp/asesor humano
- Rich responses (botones, carruseles, imágenes)

### Diferenciadores con MCP
- Integración con sistemas internos (CRM, tickets)
- Consulta de estado de servicios en tiempo real
- Generación de cotizaciones automáticas
- Agendamiento de demos
- Seguimiento de leads

---
*Documento en progreso — se actualizará con los resultados del mapeo completo del chatbot.*