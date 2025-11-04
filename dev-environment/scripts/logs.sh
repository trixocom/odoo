#!/bin/bash

echo "📋 Mostrando logs de Odoo en tiempo real..."
echo "   Presiona Ctrl+C para salir"
echo ""

cd ..

# Ver logs en tiempo real
docker-compose logs -f odoo
