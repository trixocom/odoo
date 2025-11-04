# POS Hide Payment Button

Módulo para Odoo 18.0 que permite ocultar el botón de pago en el Point of Sale.

## Descripción

Este módulo agrega una opción de configuración en el POS que permite ocultar el botón "Pago" (Payment) y mostrar solo el botón "Acciones" en su lugar.

## Características

- ✅ Checkbox simple en la configuración del POS
- ✅ Oculta el botón "Payment" cuando está activado
- ✅ Muestra el botón "Acciones" tanto en desktop como en mobile
- ✅ No requiere modificar código del core de Odoo
- ✅ Compatible con Odoo 18.0 Community Edition

## Instalación

### Método 1: Manual

1. Copiar este módulo a la carpeta `addons` o `custom_addons` de tu instalación de Odoo
2. Actualizar la lista de aplicaciones en Odoo
3. Buscar "POS Hide Payment Button" e instalar

### Método 2: Con Docker (ver docker-compose.yml incluido)

```bash
docker-compose up -d
```

## Configuración

1. Ir a **Punto de Venta** → **Configuración** → **Puntos de Venta**
2. Seleccionar el punto de venta que deseas configurar
3. Activar la opción **"Ocultar Botón de Pago"**
4. Guardar los cambios
5. Abrir el POS y verificar que el botón de pago esté oculto

## Estructura del Módulo

```
pos_hide_payment_button/
├── __init__.py
├── __manifest__.py
├── README.md
├── models/
│   ├── __init__.py
│   └── pos_config.py          # Modelo extendido con campo hide_payment_button
├── views/
│   └── pos_config_view.xml    # Vista de configuración
└── static/
    └── src/
        └── app/
            └── screens/
                └── product_screen/
                    └── action_pad/
                        ├── action_pad.xml  # Template heredado
                        └── action_pad.js   # Componente extendido
```

## Archivos Clave

### Backend (Python)

- **models/pos_config.py**: Agrega el campo `hide_payment_button` al modelo `pos.config`

### Frontend (JavaScript/XML)

- **static/src/app/screens/product_screen/action_pad/action_pad.xml**: Hereda y modifica el template del ActionpadWidget
- **static/src/app/screens/product_screen/action_pad/action_pad.js**: Patch del componente (reservado para lógica futura)

### Vistas (XML)

- **views/pos_config_view.xml**: Agrega el checkbox en la configuración del POS

## Funcionamiento Técnico

1. **Backend**: El campo `hide_payment_button` se agrega a `pos.config` y se carga automáticamente en el frontend
2. **Frontend**: El template XML evalúa `pos.config.hide_payment_button` para decidir qué botón mostrar
3. **Lógica**: Cuando está activado:
   - Se oculta el botón "Payment" (`t-if="!pos.config.hide_payment_button"`)
   - Se muestra el botón "Acciones" en pantallas grandes
   - El botón de acciones mantiene toda su funcionalidad original

## Compatibilidad

- ✅ Odoo 18.0 Community Edition
- ✅ Odoo 18.0 Enterprise Edition
- ⚠️ No probado en versiones anteriores (requiere adaptación)

## Dependencias

- `point_of_sale` (módulo core de Odoo)

## Licencia

LGPL-3

## Autor

Trixocom

## Soporte

Para reportar bugs o solicitar features, crear un issue en el repositorio.

## Changelog

### Version 1.0.0 (2025-11-04)

- ✨ Primera versión
- ✅ Funcionalidad básica de ocultar botón de pago
- ✅ Mostrar botón de acciones en su lugar
- ✅ Compatible con desktop y mobile
