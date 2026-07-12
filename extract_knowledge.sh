#!/bin/bash

# SESCOM Knowledge Extraction Script
# This script systematically queries the SESCOM chatbot across all branches

ENDPOINT="https://sescom.com.gt/chat-proxy.php"
OUTPUT_DIR="/home/abrahaam/Documents/GitHub/sescom/extracted_knowledge"

mkdir -p "$OUTPUT_DIR"

# Function to send a message and save response
send_message() {
    local session_id="$1"
    local message="$2"
    local output_file="$3"

    echo "=== Sending: $message ===" >> "$output_file"

    response=$(curl -s -X POST "$ENDPOINT" \
        -H "Content-Type: application/json" \
        -d "{\"sessionId\": \"$session_id\", \"message\": \"$message\"}")

    echo "$response" >> "$output_file"
    echo "" >> "$output_file"

    # Small delay to avoid overwhelming the server
    sleep 2
}

# Branch 1: GPS
echo "Starting Branch 1: GPS"
SESSION_GPS="sc_deep_gps_001"
OUTPUT_GPS="$OUTPUT_DIR/branch_1_gps.txt"

send_message "$SESSION_GPS" "1" "$OUTPUT_GPS"
send_message "$SESSION_GPS" "¿Qué marcas de GPS manejan?" "$OUTPUT_GPS"
send_message "$SESSION_GPS" "¿Qué diferencia hay entre su GPS y los de la competencia?" "$OUTPUT_GPS"
send_message "$SESSION_GPS" "¿Cómo funciona la video telemática?" "$OUTPUT_GPS"
send_message "$SESSION_GPS" "¿Tienen app móvil? ¿Para qué sistemas operativos?" "$OUTPUT_GPS"
send_message "$SESSION_GPS" "¿Pueden integrarse con SAP o ERP?" "$OUTPUT_GPS"
send_message "$SESSION_GPS" "¿Cuánto tiempo tarda la instalación?" "$OUTPUT_GPS"
send_message "$SESSION_GPS" "¿Manejan contratos o es mensual?" "$OUTPUT_GPS"
send_message "$SESSION_GPS" "¿Tienen cobertura en toda Guatemala?" "$OUTPUT_GPS"
send_message "$SESSION_GPS" "¿Qué pasa si el vehículo pierde señal GPS?" "$OUTPUT_GPS"
send_message "$SESSION_GPS" "¿Pueden monitorear motos o maquinaria pesada?" "$OUTPUT_GPS"
send_message "$SESSION_GPS" "¿Tienen alertas por WhatsApp o email?" "$OUTPUT_GPS"
send_message "$SESSION_GPS" "¿Cuál es el costo mensual por vehículo?" "$OUTPUT_GPS"
send_message "$SESSION_GPS" "¿Incluyen la instalación del dispositivo?" "$OUTPUT_GPS"
send_message "$SESSION_GPS" "¿Qué reportes pueden generar?" "$OUTPUT_GPS"

# Branch 2: Radios
echo "Starting Branch 2: Radios"
SESSION_RAD="sc_deep_rad_001"
OUTPUT_RAD="$OUTPUT_DIR/branch_2_radios.txt"

send_message "$SESSION_RAD" "2" "$OUTPUT_RAD"
send_message "$SESSION_RAD" "¿Cuál es la diferencia entre Kenwood y Nexus?" "$OUTPUT_RAD"
send_message "$SESSION_RAD" "¿Qué es un repetidor y para qué sirve?" "$OUTPUT_RAD"
send_message "$SESSION_RAD" "¿Cuánto alcance tiene un radio sin repetidor?" "$OUTPUT_RAD"
send_message "$SESSION_RAD" "¿Cuánto alcance tiene con repetidor?" "$OUTPUT_RAD"
send_message "$SESSION_RAD" "¿Necesito licencia para operar radios?" "$OUTPUT_RAD"
send_message "$SESSION_RAD" "¿Qué frecuencia usan, VHF o UHF?" "$OUTPUT_RAD"
send_message "$SESSION_RAD" "¿Cuál es la diferencia entre VHF y UHF?" "$OUTPUT_RAD"
send_message "$SESSION_RAD" "¿Los radios son compatibles con otras marcas?" "$OUTPUT_RAD"
send_message "$SESSION_RAD" "¿Tienen radios para zonas peligrosas (intrínsecamente seguros)?" "$OUTPUT_RAD"
send_message "$SESSION_RAD" "¿Pueden programar canales personalizados?" "$OUTPUT_RAD"
send_message "$SESSION_RAD" "¿Venden accesorios? ¿Cuáles?" "$OUTPUT_RAD"
send_message "$SESSION_RAD" "¿Cuánto cuesta un radio Kenwood NX-1300?" "$OUTPUT_RAD"
send_message "$SESSION_RAD" "¿Tienen planes de renta de radios?" "$OUTPUT_RAD"
send_message "$SESSION_RAD" "¿Qué garantía ofrecen?" "$OUTPUT_RAD"

# Branch 3: Telemetría
echo "Starting Branch 3: Telemetría"
SESSION_TEL="sc_deep_tel_001"
OUTPUT_TEL="$OUTPUT_DIR/branch_3_telemetria.txt"

send_message "$SESSION_TEL" "3" "$OUTPUT_TEL"
send_message "$SESSION_TEL" "¿Qué es exactamente telemetría?" "$OUTPUT_TEL"
send_message "$SESSION_TEL" "¿Qué tipo de sensores manejan?" "$OUTPUT_TEL"
send_message "$SESSION_TEL" "¿Pueden monitorear temperatura de cuartos fríos?" "$OUTPUT_TEL"
send_message "$SESSION_TEL" "¿Pueden monitorear nivel de combustible en tanques estacionarios?" "$OUTPUT_TEL"
send_message "$SESSION_TEL" "¿Tienen sensores de presión?" "$OUTPUT_TEL"
send_message "$SESSION_TEL" "¿Cómo se transmiten los datos? ¿Necesitan internet?" "$OUTPUT_TEL"
send_message "$SESSION_TEL" "¿Cuánto dura la batería de los sensores?" "$OUTPUT_TEL"
send_message "$SESSION_TEL" "¿Se integra con sistemas SCADA?" "$OUTPUT_TEL"
send_message "$SESSION_TEL" "¿Pueden monitorear consumo eléctrico?" "$OUTPUT_TEL"
send_message "$SESSION_TEL" "¿Tienen alertas automáticas?" "$OUTPUT_TEL"
send_message "$SESSION_TEL" "¿En cuánto tiempo se instala?" "$OUTPUT_TEL"
send_message "$SESSION_TEL" "¿Cuánto cuesta una implementación básica?" "$OUTPUT_TEL"
send_message "$SESSION_TEL" "¿Pueden monitorear calidad del aire?" "$OUTPUT_TEL"
send_message "$SESSION_TEL" "¿Qué industrias atienden con telemetría?" "$OUTPUT_TEL"

# Branch 4: Enlace de Datos
echo "Starting Branch 4: Enlace de Datos"
SESSION_ENL="sc_deep_enl_001"
OUTPUT_ENL="$OUTPUT_DIR/branch_4_enlace.txt"

send_message "$SESSION_ENL" "4" "$OUTPUT_ENL"
send_message "$SESSION_ENL" "¿Qué tipos de enlace manejan?" "$OUTPUT_ENL"
send_message "$SESSION_ENL" "¿Cuál es la diferencia entre fibra y microondas?" "$OUTPUT_ENL"
send_message "$SESSION_ENL" "¿Tienen cobertura en zonas rurales?" "$OUTPUT_ENL"
send_message "$SESSION_ENL" "¿Pueden instalar enlaces con energía solar?" "$OUTPUT_ENL"
send_message "$SESSION_ENL" "¿Qué velocidades ofrecen?" "$OUTPUT_ENL"
send_message "$SESSION_ENL" "¿Tienen SLA garantizado?" "$OUTPUT_ENL"
send_message "$SESSION_ENL" "¿Qué pasa si se cae el enlace?" "$OUTPUT_ENL"
send_message "$SESSION_ENL" "¿Pueden conectar oficinas en diferentes departamentos?" "$OUTPUT_ENL"
send_message "$SESSION_ENL" "¿Cuánto tarda la instalación?" "$OUTPUT_ENL"
send_message "$SESSION_ENL" "¿El enlace es dedicado o compartido?" "$OUTPUT_ENL"
send_message "$SESSION_ENL" "¿Tienen redundancia?" "$OUTPUT_ENL"
send_message "$SESSION_ENL" "¿Cuánto cuesta un enlace básico?" "$OUTPUT_ENL"
send_message "$SESSION_ENL" "¿Pueden integrar el enlace con cámaras y GPS?" "$OUTPUT_ENL"
send_message "$SESSION_ENL" "¿Atienden en El Salvador también?" "$OUTPUT_ENL"

# Branch 5: Monitoreo
echo "Starting Branch 5: Monitoreo"
SESSION_MON="sc_deep_mon_001"
OUTPUT_MON="$OUTPUT_DIR/branch_5_monitoreo.txt"

send_message "$SESSION_MON" "monitoreo" "$OUTPUT_MON"
send_message "$SESSION_MON" "5" "$OUTPUT_MON"
send_message "$SESSION_MON" "monitoreo corporativo" "$OUTPUT_MON"
send_message "$SESSION_MON" "1" "$OUTPUT_MON"
send_message "$SESSION_MON" "¿Qué es el centro de monitoreo corporativo?" "$OUTPUT_MON"

# Branch 6: General Questions
echo "Starting Branch 6: General Questions"
SESSION_GEN="sc_deep_gen_001"
OUTPUT_GEN="$OUTPUT_DIR/branch_6_general.txt"

send_message "$SESSION_GEN" "1" "$OUTPUT_GEN"
send_message "$SESSION_GEN" "¿Dónde están ubicados?" "$OUTPUT_GEN"
send_message "$SESSION_GEN" "¿Cuál es su horario de atención?" "$OUTPUT_GEN"
send_message "$SESSION_GEN" "¿Atienden empresas pequeñas?" "$OUTPUT_GEN"
send_message "$SESSION_GEN" "¿Tienen presencia en El Salvador?" "$OUTPUT_GEN"
send_message "$SESSION_GEN" "¿Qué clientes importantes tienen?" "$OUTPUT_GEN"
send_message "$SESSION_GEN" "¿Cuántos años tienen en el mercado?" "$OUTPUT_GEN"
send_message "$SESSION_GEN" "¿Dan capacitación?" "$OUTPUT_GEN"
send_message "$SESSION_GEN" "¿Tienen servicio postventa?" "$OUTPUT_GEN"

echo "Knowledge extraction complete! Results saved in $OUTPUT_DIR"