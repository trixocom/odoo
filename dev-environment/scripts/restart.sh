#!/bin/bash

echo "🔄 Reiniciando entorno de desarrollo Odoo 18..."
echo ""

cd ..

# Reiniciar los contenedores
docker-compose restart

echo ""
echo "⏳ Esperando a que los servicios estén listos..."
sleep 5

# Verificar estado
echo ""
echo "📊 Estado de los servicios:"
docker-compose ps

echo ""
echo "✅ Entorno reiniciado correctamente!"
echo ""
