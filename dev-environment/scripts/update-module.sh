#!/bin/bash

MODULE_NAME=${1:-pos_hide_payment_button}
DB_NAME=${2:-odoo_dev}

echo "🔄 Actualizando módulo: $MODULE_NAME en base de datos: $DB_NAME"
echo ""

cd ..

# Reiniciar Odoo con actualización del módulo
docker-compose exec odoo odoo -d $DB_NAME -u $MODULE_NAME --stop-after-init

echo ""
echo "🔄 Reiniciando Odoo..."
docker-compose restart odoo

echo ""
echo "✅ Módulo actualizado correctamente!"
echo ""
echo "📝 Si ves errores, revisa los logs con:"
echo "   ./scripts/logs.sh"
echo ""
