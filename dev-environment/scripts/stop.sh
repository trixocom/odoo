#!/bin/bash

echo "🛑 Deteniendo entorno de desarrollo Odoo 18..."
echo ""

cd ..

# Detener los contenedores
docker-compose down

echo ""
echo "✅ Entorno detenido correctamente!"
echo ""
echo "📝 Nota: Los datos se mantienen en ./data/"
echo "   Para eliminar completamente todo (incluyendo datos):"
echo "   docker-compose down -v"
echo ""
