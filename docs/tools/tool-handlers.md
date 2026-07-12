# Implementación de Tool Handlers — Referencia

Cada tool handler recibe los parámetros definidos en `tool-definitions.json` y devuelve un resultado que el agente usa para componer su respuesta al usuario.

---

## 1. `capture_lead` Handler

```javascript
async function captureLeadHandler({ name, phone, email, company, industry, interest_divisions, fleet_size, conversation_summary, urgency }) {
  // Guardar en BD (Neon Postgres / Supabase / lo que use el chatbot RAG)
  const lead = await db.leads.create({
    name: name || null,
    phone: phone || null,
    email: email || null,
    company: company || null,
    industry: industry || null,
    interest_divisions,
    fleet_size: fleet_size || null,
    conversation_summary,
    urgency,
    source: 'chatbot',
    created_at: new Date().toISOString(),
    status: 'new'
  });

  // Si urgencia alta, notificar al asesor
  if (urgency === 'high' && phone) {
    // Enviar notificación (webhook, email, o WhatsApp)
  }

  return {
    success: true,
    lead_id: lead.id,
    message: `Lead guardado exitosamente. ${urgency === 'high' ? 'Se notificó al equipo de ventas por la urgencia.' : ''}`
  };
}
```

**Resultado para el agente:** El agente recibe confirmación y puede decir algo como "Perfecto, ya tengo sus datos. Un asesor especializado en GPS se pondrá en contacto con usted pronto."

---

## 2. `generate_quote_request` Handler

```javascript
async function generateQuoteRequestHandler({ lead_id, division, products, requirements, timeline, budget_indication, delivery_method }) {
  const quoteRequest = await db.quote_requests.create({
    lead_id: lead_id || null,
    division,
    products: JSON.stringify(products),
    requirements,
    timeline: timeline || 'Sin plazo específico',
    budget_indication: budget_indication || 'No indicado',
    delivery_method: delivery_method || 'whatsapp',
    status: 'pending',
    created_at: new Date().toISOString()
  });

  // Calcular estimación rápida si es posible
  let estimate = null;
  for (const product of products) {
    const pricing = CATALOG_PRICES[product.model];
    if (pricing) {
      estimate = (estimate || 0) + pricing * product.quantity;
    }
  }

  return {
    success: true,
    quote_request_id: quoteRequest.id,
    has_estimate: estimate !== null,
    estimate_gtq: estimate,
    message: estimate
      ? `Solicitud de cotización #${quoteRequest.id} creada. Estimación preliminar: Q${estimate.toLocaleString()}. Un asesor enviará la cotización formal en menos de 1 hora.`
      : `Solicitud de cotización #${quoteRequest.id} creada. Un asesor preparará la cotización personalizada y se la enviará por ${delivery_method === 'whatsapp' ? 'WhatsApp' : 'email'} en menos de 1 hora.`
  };
}

const CATALOG_PRICES = {
  'kenwood-tk3000': 399,
  'nexus-nt400': 399,
  'nexus-nt450': 720,
  'nexus-nt500u': 1200,
  'nexus-nt500v': 1200,
};
```

---

## 3. `schedule_demo` Handler

```javascript
async function scheduleDemoHandler({ lead_id, demo_type, division, preferred_dates, location, attendees, notes }) {
  const DEMO_TYPES = {
    platform_demo: { label: 'Demo de Plataforma', duration: '30 minutos', mode: 'Remota (Zoom/Meet)' },
    site_visit: { label: 'Visita Técnica', duration: '1-2 horas', mode: 'En sitio' },
    radio_demo: { label: 'Demo de Radios', duration: '45 minutos', mode: 'Showroom o en sitio' },
    free_diagnostic: { label: 'Diagnóstico Gratuito', duration: '2-3 horas', mode: 'En sitio' },
    general_consultation: { label: 'Consulta General', duration: '30 minutos', mode: 'Presencial o virtual' }
  };

  const demoInfo = DEMO_TYPES[demo_type];

  // Para demo: simular disponibilidad
  // Para producción: Google Calendar API
  const suggestedSlots = generateAvailableSlots(preferred_dates);

  const appointment = await db.appointments.create({
    lead_id,
    demo_type,
    division,
    preferred_dates,
    location: location || 'Por definir',
    attendees: attendees || 1,
    notes,
    status: 'pending_confirmation',
    created_at: new Date().toISOString()
  });

  return {
    success: true,
    appointment_id: appointment.id,
    demo_info: demoInfo,
    suggested_slots: suggestedSlots,
    message: `Se solicitó una ${demoInfo.label} (${demoInfo.duration}, ${demoInfo.mode}). Un asesor confirmará el horario y le enviará la invitación.`
  };
}
```

---

## 4. `escalate_to_whatsapp` Handler

```javascript
async function escalateToWhatsappHandler({ reason, division, conversation_summary, prospect_info, specific_questions }) {
  const ADVISOR_PHONES = {
    gps: '+50255551001',
    radios: '+50255551002',
    telemetria: '+50255551003',
    enlace_datos: '+50255551004',
    monitoreo: '+50255551005',
    general: '+50224292429'
  };

  const advisorPhone = ADVISOR_PHONES[division] || ADVISOR_PHONES.general;

  // Construir mensaje pre-llenado para WhatsApp
  const prefilledMessage = [
    `Hola, soy ${prospect_info?.name || 'un prospecto'} de ${prospect_info?.company || 'una empresa'}.`,
    `Estuve conversando con el asistente virtual sobre ${division}.`,
    `Resumen: ${conversation_summary}`,
    specific_questions?.length ? `\nPreguntas pendientes:\n${specific_questions.map(q => `• ${q}`).join('\n')}` : ''
  ].filter(Boolean).join('\n');

  const encodedMessage = encodeURIComponent(prefilledMessage);
  const whatsappLink = `https://wa.me/${advisorPhone.replace('+', '')}?text=${encodedMessage}`;

  // Notificar al asesor internamente (webhook/SMS/email)
  await notifyAdvisor(advisorPhone, {
    reason,
    division,
    conversation_summary,
    prospect_info,
    specific_questions
  });

  return {
    success: true,
    whatsapp_link: whatsappLink,
    advisor_division: division,
    reason,
    message: `Le conecto con un asesor especializado en ${division}. Haga clic aquí para abrir WhatsApp con el contexto de nuestra conversación.`
  };
}
```

**NOTA CLAVE:** Para la demo, el link `wa.me` funciona sin necesidad de WhatsApp Business API. Es la forma más rápida y visual de demostrar la escalación.

---

## 5. `compare_products` Handler

```javascript
async function compareProductsHandler({ products, focus_aspects, use_case }) {
  const PRODUCT_DB = {
    'kenwood-tk3000': {
      name: 'Kenwood TK-3000', brand: 'Kenwood', type: 'Analógico UHF',
      power: '4W', ip_rating: 'IP54', channels: 16, price: 399,
      pros: ['Marca japonesa reconocida', 'Calidad comprobada', 'Buen precio'],
      cons: ['Solo analógico', 'Sin LCD', 'Menos canales'],
      ideal_for: 'Operaciones básicas, seguridad, retail'
    },
    'nexus-nt400': {
      name: 'Nexus NT400', brand: 'Nexus', type: 'Analógico',
      power: '5W', ip_rating: 'IP54', channels: 16, price: 399,
      pros: ['Mismo precio que TK-3000', 'Mayor potencia (5W)', 'Marca propia SESCOM'],
      cons: ['Marca menos conocida', 'Solo analógico'],
      ideal_for: 'Presupuestos ajustados, operaciones básicas'
    },
    'nexus-nt450': {
      name: 'Nexus NT450', brand: 'Nexus', type: 'Analógico',
      power: '10W', ip_rating: 'IP54', channels: 16, price: 720,
      pros: ['10W de potencia (mayor alcance)', 'Antimagnético', 'Batería 2700mAh'],
      cons: ['Sin LCD', 'Solo analógico'],
      ideal_for: 'Campo abierto, fincas, construcción'
    },
    'nexus-nt500u': {
      name: 'Nexus NT500U', brand: 'Nexus', type: 'Analógico UHF',
      power: '10W', ip_rating: 'IP54', channels: 199, price: 1200,
      pros: ['199 canales', 'LCD display', '10W potencia', 'UHF para edificios'],
      cons: ['Precio más alto en línea Nexus'],
      ideal_for: 'Operaciones grandes, múltiples departamentos'
    },
    'kenwood-nx1300nk4': {
      name: 'Kenwood NX-1300-NK4', brand: 'Kenwood', type: 'Digital NXDN/DMR',
      power: '5W', ip_rating: 'IP54', channels: 64, price: null,
      pros: ['Digital (35% más cobertura)', 'Encriptación de voz', 'Llamadas individuales'],
      cons: ['Precio más alto', 'Requiere cotización'],
      ideal_for: 'Seguridad, operaciones que requieren privacidad'
    },
    'kenwood-nx3320k': {
      name: 'Kenwood NX-3320-K', brand: 'Kenwood', type: 'Digital Premium',
      power: '5W', ip_rating: 'IP67', channels: 260, price: null,
      pros: ['IP67 (sumergible)', 'GPS integrado', 'Bluetooth', 'Reducción activa de ruido'],
      cons: ['Precio premium', 'Requiere cotización'],
      ideal_for: 'Ambientes extremos, minería, construcción, marina'
    },
    'fibra_optica': {
      name: 'Fibra Óptica Dedicada', brand: 'SESCOM', type: 'Enlace de datos',
      speed: '100Mbps - 10Gbps', sla: '99.95%', latency: '<5ms', price: null,
      pros: ['Máxima velocidad', 'Mejor SLA', 'Mínima latencia'],
      cons: ['Instalación 1-4 semanas', 'Requiere infraestructura'],
      ideal_for: 'Oficinas, centros de monitoreo, operaciones 24/7'
    },
    'inalambrico_solar': {
      name: 'Enlace Inalámbrico Solar', brand: 'SESCOM', type: 'Enlace de datos',
      speed: 'Hasta 1Gbps', sla: '99.9%', latency: 'Variable', price: null,
      pros: ['Sin electricidad requerida', 'Instalación 1-3 días', 'Zonas remotas'],
      cons: ['Menor SLA que fibra', 'Latencia variable'],
      ideal_for: 'Fincas, represas, minería, sitios sin electricidad'
    }
  };

  const comparison = products.map(p => {
    const key = p.toLowerCase().replace(/\s+/g, '-').replace(/[^a-z0-9-]/g, '');
    return PRODUCT_DB[key] || { name: p, note: 'Producto no encontrado en catálogo — solicitar cotización' };
  });

  // Generar recomendación basada en use_case
  let recommendation = null;
  if (use_case) {
    recommendation = generateRecommendation(comparison, use_case);
  }

  return {
    success: true,
    comparison,
    recommendation,
    note: comparison.some(p => p.price === null) ? 'Algunos productos requieren cotización personalizada.' : null
  };
}
```

---

## 6. `check_coverage` Handler

```javascript
async function checkCoverageHandler({ location, service_type, details }) {
  // Datos de cobertura (en producción, sería una BD geográfica)
  const COVERAGE_DATA = {
    // Departamentos de Guatemala
    guatemala: { gps: 'full', radio: 'full', data_link: 'full', telemetry: 'full', monitoring: 'full' },
    sacatepequez: { gps: 'full', radio: 'full', data_link: 'full', telemetry: 'full', monitoring: 'full' },
    escuintla: { gps: 'full', radio: 'full', data_link: 'partial', telemetry: 'full', monitoring: 'full' },
    quetzaltenango: { gps: 'full', radio: 'full', data_link: 'partial', telemetry: 'full', monitoring: 'full' },
    peten: { gps: 'full', radio: 'partial', data_link: 'solar_wireless', telemetry: 'partial', monitoring: 'remote' },
    alta_verapaz: { gps: 'full', radio: 'partial', data_link: 'solar_wireless', telemetry: 'partial', monitoring: 'remote' },
    izabal: { gps: 'full', radio: 'partial', data_link: 'partial', telemetry: 'partial', monitoring: 'remote' },
    // El Salvador
    san_salvador: { gps: 'full', radio: 'full', data_link: 'full', telemetry: 'full', monitoring: 'full' },
    el_salvador_other: { gps: 'full', radio: 'partial', data_link: 'expanding', telemetry: 'partial', monitoring: 'expanding' },
  };

  const COVERAGE_LABELS = {
    full: '✅ Cobertura completa — servicio disponible sin restricciones',
    partial: '⚠️ Cobertura parcial — se requiere diagnóstico técnico en sitio (gratuito)',
    solar_wireless: '✅ Disponible con enlace inalámbrico solar (ideal para zonas sin electricidad)',
    remote: '⚠️ Disponible vía enlace remoto — se requiere evaluación de factibilidad',
    expanding: '🔄 Zona en expansión — consultar disponibilidad actual con un asesor',
    unavailable: '❌ No disponible actualmente en esta zona'
  };

  // Normalizar ubicación
  const normalizedLocation = location.toLowerCase()
    .normalize('NFD').replace(/[̀-ͯ]/g, '')
    .replace(/\s+/g, '_');

  // Buscar cobertura (simplificado — en producción usaría geocoding)
  let coverageInfo = null;
  for (const [key, data] of Object.entries(COVERAGE_DATA)) {
    if (normalizedLocation.includes(key) || key.includes(normalizedLocation)) {
      coverageInfo = data;
      break;
    }
  }

  if (!coverageInfo) {
    return {
      success: true,
      location,
      coverage: 'unknown',
      message: `No tenemos datos de cobertura precargados para "${location}". Le recomendamos solicitar un diagnóstico gratuito — nuestro equipo técnico evalúa la factibilidad sin compromiso.`,
      offer_diagnostic: true
    };
  }

  const serviceKey = service_type === 'all' ? null : service_type.replace('radio_repeater', 'radio');
  
  if (serviceKey && coverageInfo[serviceKey]) {
    return {
      success: true,
      location,
      service_type,
      coverage: coverageInfo[serviceKey],
      coverage_label: COVERAGE_LABELS[coverageInfo[serviceKey]],
      offer_diagnostic: coverageInfo[serviceKey] !== 'full'
    };
  }

  // Retornar todas las coberturas
  return {
    success: true,
    location,
    coverage_by_service: Object.entries(coverageInfo).map(([service, status]) => ({
      service,
      status,
      label: COVERAGE_LABELS[status]
    })),
    offer_diagnostic: true
  };
}
```

---

## 7. `calculate_roi` Handler

```javascript
async function calculateRoiHandler({ solution_type, fleet_size, current_fuel_cost_monthly, current_security_guards, guard_monthly_cost, current_downtime_hours_monthly, downtime_cost_per_hour, current_communication_cost_monthly, num_users }) {
  const calculations = {};

  switch (solution_type) {
    case 'gps_fuel_control': {
      const fuelCost = current_fuel_cost_monthly || (fleet_size || 20) * 3000; // Est. Q3,000/vehículo/mes
      const savingsLow = fuelCost * 0.15;  // 15%
      const savingsHigh = fuelCost * 0.25; // 25%
      const estimatedInvestment = (fleet_size || 20) * 800; // ~Q800/vehículo (dispositivo + instalación)
      const monthlyServiceCost = (fleet_size || 20) * 150; // ~Q150/vehículo/mes plataforma
      const netSavingsLow = savingsLow - monthlyServiceCost;
      const netSavingsHigh = savingsHigh - monthlyServiceCost;
      const paybackMonths = Math.ceil(estimatedInvestment / ((netSavingsLow + netSavingsHigh) / 2));

      calculations.current_cost = fuelCost;
      calculations.savings_range = { low: savingsLow, high: savingsHigh };
      calculations.net_monthly_savings = { low: netSavingsLow, high: netSavingsHigh };
      calculations.initial_investment = estimatedInvestment;
      calculations.payback_months = paybackMonths;
      calculations.annual_savings = { low: netSavingsLow * 12, high: netSavingsHigh * 12 };
      calculations.summary = `Con ${fleet_size || 20} vehículos gastando Q${fuelCost.toLocaleString()}/mes en combustible, el sistema de control de combustible SESCOM puede generar un ahorro de Q${Math.round(netSavingsLow).toLocaleString()} a Q${Math.round(netSavingsHigh).toLocaleString()}/mes (neto). La inversión inicial se recupera en aproximadamente ${paybackMonths} meses.`;
      break;
    }

    case 'monitoring_center': {
      const guards = current_security_guards || 50;
      const costPerGuard = guard_monthly_cost || 3500; // Q3,500/guardia/mes promedio GT
      const currentTotal = guards * costPerGuard;
      const reduction = 0.60; // 60% reducción (caso real)
      const savings = currentTotal * reduction;
      const estimatedMonitoringCost = 25000 + (fleet_size || 0) * 150; // Centro + GPS

      calculations.current_cost = currentTotal;
      calculations.guards_eliminated = Math.round(guards * reduction);
      calculations.monthly_savings = savings - estimatedMonitoringCost;
      calculations.annual_savings = (savings - estimatedMonitoringCost) * 12;
      calculations.summary = `Con ${guards} guardias a Q${costPerGuard.toLocaleString()}/mes, su gasto actual es Q${currentTotal.toLocaleString()}/mes. Un Centro de Monitoreo SESCOM puede reducir hasta 60% de estos costos, eliminando ~${Math.round(guards * reduction)} guardias. Ahorro neto estimado: Q${Math.round(savings - estimatedMonitoringCost).toLocaleString()}/mes. Caso real: una cadena de restaurantes eliminó 200+ guardias con un solo centro de control.`;
      break;
    }

    case 'radio_replacement': {
      const users = num_users || 30;
      const cellCost = current_communication_cost_monthly || users * 150; // Q150/línea/mes
      const radioInvestment = users * 500; // Q500/radio promedio (una sola vez)
      const radioMonthlyCost = 0; // Sin cuota mensual
      const monthlySavings = cellCost - radioMonthlyCost;
      const paybackMonths = Math.ceil(radioInvestment / monthlySavings);

      calculations.current_cost = cellCost;
      calculations.initial_investment = radioInvestment;
      calculations.monthly_savings = monthlySavings;
      calculations.payback_months = paybackMonths;
      calculations.annual_savings = monthlySavings * 12;
      calculations.summary = `Con ${users} usuarios pagando ~Q${Math.round(cellCost / users)}/línea celular/mes (Q${cellCost.toLocaleString()}/mes total), los radios eliminan el 100% del gasto recurrente. Inversión única: Q${radioInvestment.toLocaleString()}. Se paga solo en ${paybackMonths} meses. Además: comunicación instantánea PTT, funciona sin señal celular, y cero vulnerabilidad de hackeo de WhatsApp.`;
      break;
    }

    case 'telemetry': {
      const downtimeHours = current_downtime_hours_monthly || 10;
      const costPerHour = downtime_cost_per_hour || 5000; // Q5,000/hora
      const currentLoss = downtimeHours * costPerHour;
      const reductionRate = 0.70; // 70% reducción de downtime
      const monthlySavings = currentLoss * reductionRate;
      const investment = 15000; // Implementación base

      calculations.current_loss = currentLoss;
      calculations.monthly_savings = monthlySavings;
      calculations.payback_months = Math.ceil(investment / monthlySavings);
      calculations.annual_savings = monthlySavings * 12;
      calculations.summary = `Con ${downtimeHours} horas de inactividad/mes a Q${costPerHour.toLocaleString()}/hora, su pérdida mensual es Q${currentLoss.toLocaleString()}. La telemetría SESCOM reduce el downtime no planificado hasta 70%, generando un ahorro de Q${Math.round(monthlySavings).toLocaleString()}/mes. ROI en ${Math.ceil(investment / monthlySavings)} meses.`;
      break;
    }

    default:
      calculations.summary = 'Solicite un diagnóstico gratuito para calcular el ROI específico de su operación.';
  }

  return {
    success: true,
    solution_type,
    calculations,
    disclaimer: 'Estimaciones basadas en datos promedio del mercado guatemalteco y casos reales de clientes SESCOM. Los resultados reales pueden variar según la operación específica.'
  };
}
```

---

## 8. `search_knowledge_base` Handler

```javascript
async function searchKnowledgeBaseHandler({ query, division, content_type }) {
  // Opción A: Búsqueda por keywords en los archivos markdown (simple)
  // Opción B: RAG con embeddings (ya existe en el chatbot base)
  
  // El chatbot RAG base ya tiene esta funcionalidad.
  // Este handler es un wrapper que agrega filtros por división y tipo de contenido.
  
  const results = await ragSearch(query, {
    filter: {
      ...(division && division !== 'all' ? { division } : {}),
      ...(content_type ? { content_type } : {})
    },
    topK: 5
  });

  return {
    success: true,
    query,
    results: results.map(r => ({
      content: r.text,
      source: r.metadata.source,
      division: r.metadata.division,
      relevance: r.score
    })),
    total_results: results.length
  };
}
```

---

## 9. `send_brochure` Handler

```javascript
async function sendBrochureHandler({ division, product, delivery_channel, recipient }) {
  const BROCHURE_URLS = {
    gps: 'https://sescom.com.gt/brochures/gps-tracking-2026.pdf',
    radios: 'https://sescom.com.gt/brochures/radios-profesionales-2026.pdf',
    telemetria: 'https://sescom.com.gt/brochures/telemetria-iot-2026.pdf',
    enlace_datos: 'https://sescom.com.gt/brochures/enlace-datos-2026.pdf',
    monitoreo: 'https://sescom.com.gt/brochures/monitoreo-corporativo-2026.pdf',
    corporativo: 'https://sescom.com.gt/brochures/sescom-corporativo-2026.pdf',
  };

  const brochureUrl = BROCHURE_URLS[division];

  if (delivery_channel === 'whatsapp') {
    const message = `Hola, le comparto el brochure de ${division} de SESCOM: ${brochureUrl}`;
    const link = `https://wa.me/${recipient.replace(/[^0-9]/g, '')}?text=${encodeURIComponent(message)}`;
    return { success: true, whatsapp_link: link, brochure_url: brochureUrl };
  } else {
    // Enviar por email (Resend, SendGrid, etc.)
    await sendEmail({ to: recipient, subject: `Brochure SESCOM - ${division}`, body: `...`, attachment: brochureUrl });
    return { success: true, sent_to: recipient, brochure_url: brochureUrl };
  }
}
```

---

## 10. `recommend_integrated_solution` Handler ⭐

```javascript
async function recommendIntegratedSolutionHandler({ industry, pain_points, current_solutions, locations, employees_in_field, vehicles, budget_range }) {
  // Mapeo de pain points a divisiones
  const PAIN_TO_DIVISION = {
    // GPS
    'robo de combustible': 'gps', 'fuel theft': 'gps', 'control combustible': 'gps',
    'rastreo': 'gps', 'tracking': 'gps', 'flota': 'gps', 'vehículos': 'gps',
    'rutas': 'gps', 'velocidad': 'gps', 'conductores': 'gps',
    // Radios
    'comunicación': 'radios', 'campo': 'radios', 'sin señal': 'radios',
    'celular': 'radios', 'coordinación': 'radios', 'ptt': 'radios',
    // Telemetría
    'temperatura': 'telemetria', 'sensores': 'telemetria', 'monitoreo remoto': 'telemetria',
    'nivel': 'telemetria', 'presión': 'telemetria', 'consumo eléctrico': 'telemetria',
    'cadena de frío': 'telemetria', 'downtime': 'telemetria',
    // Enlace de datos
    'conectividad': 'enlace_datos', 'internet': 'enlace_datos', 'sin señal': 'enlace_datos',
    'fibra': 'enlace_datos', 'remoto': 'enlace_datos', 'sin electricidad': 'enlace_datos',
    // Monitoreo
    'cámaras': 'monitoreo', 'guardias': 'monitoreo', 'seguridad': 'monitoreo',
    'vigilancia': 'monitoreo', 'cctv': 'monitoreo', 'video': 'monitoreo',
    'incidentes': 'monitoreo', '24/7': 'monitoreo',
  };

  // Identificar divisiones relevantes
  const relevantDivisions = new Set();
  for (const pain of pain_points) {
    const painLower = pain.toLowerCase();
    for (const [keyword, division] of Object.entries(PAIN_TO_DIVISION)) {
      if (painLower.includes(keyword)) {
        relevantDivisions.add(division);
      }
    }
  }

  // Si hay vehículos, agregar GPS
  if (vehicles && vehicles > 0) relevantDivisions.add('gps');
  // Si hay empleados en campo, agregar radios
  if (employees_in_field && employees_in_field > 5) relevantDivisions.add('radios');
  // Si hay múltiples locales, considerar monitoreo
  if (locations && locations > 2) relevantDivisions.add('monitoreo');

  const DIVISION_DETAILS = {
    gps: {
      name: 'GPS y Rastreo Vehicular',
      for_this_case: 'Monitoreo en tiempo real de su flota con control de combustible y alertas inteligentes',
      key_benefit: 'Ahorro de 15-25% en combustible + visibilidad total de rutas'
    },
    radios: {
      name: 'Radios Profesionales',
      for_this_case: 'Comunicación instantánea PTT para su equipo en campo — funciona sin señal celular',
      key_benefit: 'Q0/mes de costo recurrente vs Q100-200/línea celular'
    },
    telemetria: {
      name: 'Telemetría Industrial IoT',
      for_this_case: 'Sensores inalámbricos para monitorear variables críticas en tiempo real',
      key_benefit: 'Reducción de 70% en downtime no planificado, ROI en 6-8 meses'
    },
    enlace_datos: {
      name: 'Enlace de Datos',
      for_this_case: 'Conectividad dedicada para sus sitios — incluso con energía solar en zonas remotas',
      key_benefit: 'SLA 99.9%+ garantizado, funciona donde Tigo/Claro no llegan'
    },
    monitoreo: {
      name: 'Centro de Monitoreo 24/7',
      for_this_case: 'Unificar video, GPS y radio en una sola consola operativa para todos sus locales',
      key_benefit: 'Hasta 60% reducción en costos de seguridad física'
    }
  };

  const recommendation = {
    industry,
    divisions_count: relevantDivisions.size,
    divisions: Array.from(relevantDivisions).map(d => DIVISION_DETAILS[d]),
    is_integrated: relevantDivisions.size >= 2,
    sescom_advantage: relevantDivisions.size >= 2
      ? `SESCOM es el ÚNICO proveedor en Guatemala que integra estas ${relevantDivisions.size} soluciones bajo un mismo equipo. Esto significa: un solo contrato, una sola factura, un solo equipo de soporte 24/7, y una sola consola donde todo se integra.`
      : 'SESCOM cuenta con 34 años de experiencia y la infraestructura propia más grande de Guatemala para este servicio.',
    next_steps: [
      'Diagnóstico gratuito en sitio para evaluar su operación específica',
      'Demo personalizada de la plataforma integrada',
      'Cotización detallada sin compromiso'
    ]
  };

  return {
    success: true,
    recommendation,
    pain_points_addressed: pain_points.length,
    current_solutions_replaced: current_solutions || []
  };
}
```

---

## Notas de Implementación

### Para integrar en el chatbot RAG existente:

1. **Registrar las tools** en el sistema de function calling del modelo (Claude API `tools` parameter o equivalente)
2. **Crear handlers** como funciones async que se ejecutan cuando el modelo invoca una tool
3. **Los resultados** se pasan de vuelta al modelo como `tool_result` para que componga la respuesta final
4. **El system prompt** (`system-prompt.md`) ya incluye instrucciones sobre cuándo usar cada tool

### Orden de implementación sugerido:
1. `compare_products` y `calculate_roi` — solo lógica local, sin APIs externas
2. `recommend_integrated_solution` — solo lógica local, máximo impacto en demo
3. `escalate_to_whatsapp` — solo genera link, sin API
4. `check_coverage` — datos estáticos, sin API
5. `capture_lead` — requiere BD
6. `search_knowledge_base` — ya existe en el RAG
7. `generate_quote_request` — requiere BD + notificaciones
8. `schedule_demo` — requiere Google Calendar API
9. `send_brochure` — requiere PDFs + canal de envío