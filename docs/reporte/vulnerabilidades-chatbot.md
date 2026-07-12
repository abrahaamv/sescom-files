# 🔒 Reporte de Vulnerabilidades — Chatbot SESCOM

## Resumen Ejecutivo
El endpoint `chat-proxy.php` del chatbot de SESCOM presenta múltiples debilidades de seguridad que van desde exposición de información sensible del servidor hasta ausencia total de controles de acceso. Estas vulnerabilidades representan un riesgo real para la infraestructura y la reputación de la empresa.

---

## Hallazgos Críticos

### 🔴 1. Exposición de Stack Trace Completo (ALTA)
**Endpoint:** `POST /chat-proxy.php` con body no-JSON
**Severidad:** Alta — Divulgación de información

Al enviar contenido no-JSON al endpoint, el servidor responde con un **stack trace completo** de Node.js que revela:

```
SyntaxError: Unexpected token 't', "test" is not valid JSON
    at JSON.parse (<anonymous>)
    at createStrictSyntaxError (/var/www/sescom-bot/node_modules/body-parser/lib/types/json.js:169:10)
    at parse (/var/www/sescom-bot/node_modules/body-parser/lib/types/json.js:86:15)
    at /var/www/sescom-bot/node_modules/body-parser/lib/read.js:128:18
    ...
```

**Información expuesta:**
- Ruta absoluta del servidor: `/var/www/sescom-bot/`
- Framework: Node.js con Express y `body-parser`
- Estructura de directorios del servidor
- Versiones de dependencias (deducibles)

**Impacto:** Un atacante puede usar esta información para planificar ataques más dirigidos.

---

### 🔴 2. Sin Rate Limiting (ALTA)
**Prueba:** 20 requests consecutivos — todos respondidos HTTP 200
**Severidad:** Alta — Disponibilidad / Abuso

No existe ningún control de tasa de peticiones. Un atacante puede:
- Realizar ataques de fuerza bruta contra sessionIds
- Generar costos excesivos si el bot usa API de IA (tokens)
- Realizar DDoS al backend Node.js
- Abusar del servicio para scraping masivo

---

### 🟠 3. Sin Protección CORS (MEDIA-ALTA)
**Prueba:** POST con `Origin: https://evil.com` — respondido normalmente sin headers CORS
**Severidad:** Media-Alta — Abuso cross-origin

No hay headers `Access-Control-Allow-Origin` en las respuestas, lo que significa:
- **Desde cualquier sitio web** se puede invocar el chatbot
- Un sitio malicioso puede embeber el chat de SESCOM
- Se pueden crear clones/phishing que usen el backend real de SESCOM
- No hay protección contra CSRF

---

### 🟠 4. Headers de Seguridad Faltantes (MEDIA)
**Headers presentes:**
- ✅ `content-security-policy: upgrade-insecure-requests`
- ✅ HTTPS activo (HTTP/2)

**Headers faltantes:**
- ❌ `X-Content-Type-Options: nosniff`
- ❌ `X-Frame-Options: DENY`
- ❌ `Strict-Transport-Security` (HSTS)
- ❌ `X-XSS-Protection`
- ❌ `Referrer-Policy` (solo en request, no response)
- ❌ `Permissions-Policy`

---

### 🟠 5. Exposición de Tecnología del Servidor (MEDIA)
**Headers que revelan stack tecnológico:**
```
x-powered-by: PHP/8.3.31
server: LiteSpeed
platform: hostinger
panel: hpanel
```

Información expuesta:
- Lenguaje y versión exacta: **PHP 8.3.31**
- Servidor web: **LiteSpeed**
- Proveedor de hosting: **Hostinger**
- Panel de control: **hPanel**

---

### 🟡 6. Sin Validación de SessionId (BAJA-MEDIA)
**Pruebas realizadas:**
- `sessionId: "1 OR 1=1; --"` → Respondido normalmente
- `sessionId: "../../etc/passwd"` → Respondido normalmente
- `sessionId: "http://169.254.169.254/..."` → Respondido normalmente
- `sessionId: 12345` (numérico) → Respondido normalmente (debería ser string)
- `sessionId` de 500+ caracteres → Respondido normalmente

El sessionId no tiene validación de formato, longitud ni caracteres. Aunque no se confirmó explotación directa, la falta de validación es una superficie de ataque.

---

### 🟡 7. Archivos Potencialmente Expuestos (BAJA)
| Archivo | Status | Riesgo |
|---------|--------|--------|
| `enviar-lead.php` | 200 OK | Endpoint de leads accesible |
| `.git/config` | 403 Forbidden | Git existe pero bloqueado (bien) |
| `.env` | 404 | No expuesto (bien) |
| `phpinfo.php` | 404 | No existe (bien) |
| `robots.txt` | Redirige a Hostinger | No configurado |

---

### 🟡 8. GET Acepta Requests (BAJA)
**Prueba:** `GET /chat-proxy.php` → `{"reply":"Mensaje vacío."}`

El endpoint responde a GET cuando debería solo aceptar POST. Esto puede facilitar:
- Ataques via URL/bookmarks
- Logging de requests en proxies/WAFs
- Caching involuntario

---

## Hallazgos Positivos ✅

1. **Validación de campos requeridos:** `sessionId` y `message` son obligatorios
2. **No SQL injection directa visible:** Las inyecciones SQL en message/sessionId no provocaron errores de BD
3. **HTTPS activo:** Comunicación cifrada
4. **`.env` no expuesto:** El archivo de configuración no es accesible
5. **`.git` bloqueado:** El directorio git devuelve 403

---

## Resumen de Riesgos

| # | Hallazgo | Severidad | Esfuerzo Fix |
|---|----------|-----------|-------------|
| 1 | Stack trace expuesto | 🔴 Alta | Bajo |
| 2 | Sin rate limiting | 🔴 Alta | Medio |
| 3 | Sin CORS | 🟠 Media-Alta | Bajo |
| 4 | Headers faltantes | 🟠 Media | Bajo |
| 5 | Tecnología expuesta | 🟠 Media | Bajo |
| 6 | SessionId sin validar | 🟡 Media-Baja | Bajo |
| 7 | Archivos expuestos | 🟡 Baja | Bajo |
| 8 | GET aceptado | 🟡 Baja | Bajo |

---

## Recomendaciones para el Nuevo Chatbot

1. **Error handling robusto** — Nunca exponer stack traces en producción
2. **Rate limiting** — Máximo 10-20 requests/minuto por IP
3. **CORS estricto** — Solo permitir origin del dominio propio
4. **Headers de seguridad completos** — HSTS, nosniff, X-Frame-Options, etc.
5. **Ocultar tecnología** — Remover X-Powered-By, Server
6. **Validación de input** — SessionId con formato, longitud y caracteres permitidos
7. **Solo POST** — Rechazar GET/PUT/DELETE/OPTIONS con 405
8. **WAF/Firewall** — Vercel incluye protección automática
9. **Monitoreo** — Alertas por patrones de abuso
10. **Autenticación** — Token o API key para el endpoint

---

*Análisis realizado el 12 de julio de 2026 desde información públicamente accesible.*
*No se realizaron pruebas invasivas ni se accedió a datos no autorizados.*