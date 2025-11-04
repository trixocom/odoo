#!/bin/bash

echo "🚀 Iniciando entorno de desarrollo Odoo 18..."
echo ""

# Verificar que Docker esté corriendo
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker no está corriendo"
    echo "   Por favor inicia Docker Desktop y vuelve a intentar"
    exit 1
fi

# Crear directorios necesarios si no existen
mkdir -p ../data/postgresql
mkdir -p ../data/addons
mkdir -p ../logs

# Dar permisos correctos (en Mac esto no suele ser problema)
chmod -R 755 ../data

cd ..

# Iniciar los contenedores
echo "📦 Levantando contenedores..."
docker-compose up -d

echo ""
echo "⏳ Esperando a que los servicios estén listos..."
sleep 10

# Verificar estado
echo ""
echo "📊 Estado de los servicios:"
docker-compose ps

echo ""
echo "✅ Entorno iniciado correctamente!"
echo ""
echo "🌐 Accede a:"
echo "   - Odoo:    http://localhost:8069"
echo "   - pgAdmin: http://localhost:8080 (usuario: admin@odoo.local, password: admin)"
echo ""
echo "📝 Para ver los logs en tiempo real:"
echo "   docker-compose logs -f odoo"
echo ""
echo "🛑 Para detener el entorno:"
echo "   ./scripts/stop.sh"
echo ""
