# Análisis del Módulo POS de Odoo - Guía para Ocultar Botón de Pago

## 📋 Resumen Ejecutivo

Este documento proporciona un análisis completo del módulo Point of Sale (POS) de Odoo, con enfoque específico en cómo desarrollar un módulo personalizado que permita ocultar el botón "Pago" y mostrar solo el botón "Acciones" mediante una configuración.

## 🏗️ Arquitectura del Módulo POS

### Ubicación del Módulo
```
/home/user/odoo/addons/point_of_sale/
├── models/           # Modelos Python (pos_config.py, pos_order.py, etc.)
├── views/            # Vistas XML para la interfaz de administración
├── static/
│   └── src/
│       ├── app/
│       │   ├── screens/
│       │   │   └── product_screen/
│       │   │       ├── action_pad/
│       │   │       │   ├── action_pad.xml    # Template del botón de pago
│       │   │       │   └── action_pad.js     # Componente ActionpadWidget
│       │   │       ├── product_screen.xml    # Pantalla principal del POS
│       │   │       └── product_screen.js
│       │   └── store/
│       │       └── pos_store.js              # Store principal con this.config
│       └── models/
└── controllers/
```

## 🎯 Componentes Clave Identificados

### 1. Botón de Pago (Payment Button)

#### Ubicación en el XML
**Archivo**: `/home/user/odoo/addons/point_of_sale/static/src/app/screens/product_screen/action_pad/action_pad.xml`

```xml
<!-- Líneas 18-24 -->
<div t-if="props.showActionButton" class="validation d-flex gap-2">
    <BackButton t-if="pos.showBackButton()" onClick="() => pos.onClickBackButton()"/>
    <button class="pay pay-order-button button btn btn-primary btn-lg py-3 d-flex align-items-center justify-content-center flex-fill"
        t-on-click="props.actionToTrigger"
        t-esc="props.actionName"
    />
</div>
```

**Características importantes**:
- Se muestra cuando `props.showActionButton` es `true`
- Clases CSS: `pay`, `pay-order-button`, `button`, `btn`, `btn-primary`
- Se activa con `props.actionToTrigger` (que llama a `pos.pay()`)

#### Uso en ProductScreen
**Archivo**: `/home/user/odoo/addons/point_of_sale/static/src/app/screens/product_screen/product_screen.xml`

```xml
<!-- Líneas 14-20 -->
<ActionpadWidget
    partner="currentOrder?.get_partner()"
    onClickMore.bind="displayAllControlPopup"
    actionName.translate="Payment"
    actionToTrigger="() => pos.pay()"
    showActionButton="!currentOrder?.is_empty()"
/>
```

**Nota**: El botón solo se muestra cuando la orden NO está vacía (`showActionButton="!currentOrder?.is_empty()"`)

### 2. Botón de Acciones (Actions Button)

#### Ubicación en el XML
**Archivo**: `/home/user/odoo/addons/point_of_sale/static/src/app/screens/product_screen/action_pad/action_pad.xml`

```xml
<!-- Líneas 6-16 -->
<div t-if="ui.isSmall" class="d-flex gap-2">
    <BackButton t-if="!props.showActionButton and pos.showBackButton()" onClick="() => pos.onClickBackButton()"/>
    <t t-if="props.onClickMore">
        <SelectPartnerButton partner="props.partner"/>
        <button t-if="this.pos.showSaveOrderButton" t-att-disabled="this.pos.get_order().is_empty()" class="btn btn-light btn-lg" t-on-click="() => this.pos.clickSaveOrder()">
            <i class="fa fa-upload"/>
        </button>
        <button class="button mobile-more-button btn btn-light btn-lg flex-fill" t-on-click="props.onClickMore">
            <span>Actions</span>
        </button>
    </t>
</div>
```

**Características importantes**:
- Se muestra solo en pantallas pequeñas (`t-if="ui.isSmall"`)
- Clases CSS: `button`, `mobile-more-button`, `btn`, `btn-light`
- Se activa con `props.onClickMore`

### 3. Botón de Pago en Mobile (Switchpane)

Existe un botón adicional de pago para dispositivos móviles en el área de switchpane:

**Archivo**: `/home/user/odoo/addons/point_of_sale/static/src/app/screens/product_screen/product_screen.xml`

```xml
<!-- Líneas 55-68 -->
<t t-if="ui.isSmall">
    <div class="switchpane d-flex gap-2 p-2 border-top bg-view">
        <button t-if="!pos.scanning" class="btn-switchpane pay-button btn btn-lg w-50"
                t-attf-class="{{ currentOrder.is_empty() ? 'btn-secondary' : 'btn-primary' }}"
                t-on-click="() => this.pos.pay()">
            <span class="d-block">Pay</span>
            <span t-esc="total" />
        </button>
        <!-- ... -->
    </div>
</t>
```

## 🔧 Sistema de Configuración del POS

### Modelo pos.config

**Archivo**: `/home/user/odoo/addons/point_of_sale/models/pos_config.py`

El modelo `pos.config` contiene todas las configuraciones del punto de venta. Ejemplos de campos booleanos existentes:

```python
# Línea 100-106
iface_cashdrawer = fields.Boolean(string='Cashdrawer', help="Automatically open the cashdrawer.")
iface_electronic_scale = fields.Boolean(string='Electronic Scale', help="Enables Electronic Scale integration.")
iface_print_via_proxy = fields.Boolean(string='Print via Proxy', help="Bypass browser printing and prints via the hardware proxy.")
iface_scan_via_proxy = fields.Boolean(string='Scan via Proxy', help="Enable barcode scanning with a remotely connected barcode scanner and card swiping with a Vantiv card reader.")
iface_big_scrollbars = fields.Boolean('Large Scrollbars', help='For imprecise industrial touchscreens.')
iface_print_auto = fields.Boolean(string='Automatic Receipt Printing', default=False, help='The receipt will automatically be printed at the end of each order.')
```

### Acceso a la Configuración en el Frontend

**Archivo**: `/home/user/odoo/addons/point_of_sale/static/src/app/store/pos_store.js`

```javascript
// Línea 303
this.config = this.data.models["pos.config"].getFirst();

// Uso de la configuración:
// Línea 172
if (!this.config.module_pos_hr) { ... }

// Línea 242-246
this.config.is_posbox &&
(this.config.iface_electronic_scale ||
 this.config.iface_print_via_proxy ||
 this.config.iface_scan_via_proxy || ...)
```

## 🚀 Guía para Desarrollar el Módulo Personalizado

### Estructura del Módulo

```
pos_hide_payment_button/
├── __init__.py
├── __manifest__.py
├── models/
│   ├── __init__.py
│   └── pos_config.py
├── static/
│   └── src/
│       ├── app/
│       │   └── screens/
│       │       └── product_screen/
│       │           └── action_pad/
│       │               ├── action_pad.xml
│       │               └── action_pad.js
│       └── xml/
│           └── assets.xml
└── views/
    └── pos_config_view.xml
```

### 1. Archivo __manifest__.py

```python
{
    'name': 'POS Hide Payment Button',
    'version': '18.0.1.0.0',
    'category': 'Point of Sale',
    'summary': 'Permite ocultar el botón de pago en el POS mediante configuración',
    'description': """
        Este módulo permite ocultar el botón "Pago" del punto de venta
        y mostrar solo el botón de acciones mediante una opción de configuración.
    """,
    'author': 'Tu Nombre',
    'depends': ['point_of_sale'],
    'data': [
        'views/pos_config_view.xml',
    ],
    'assets': {
        'point_of_sale.assets': [
            'pos_hide_payment_button/static/src/app/screens/product_screen/action_pad/action_pad.xml',
            'pos_hide_payment_button/static/src/app/screens/product_screen/action_pad/action_pad.js',
        ],
    },
    'installable': True,
    'auto_install': False,
    'license': 'LGPL-3',
}
```

### 2. models/__init__.py

```python
from . import pos_config
```

### 3. models/pos_config.py

```python
# -*- coding: utf-8 -*-
from odoo import fields, models

class PosConfig(models.Model):
    _inherit = 'pos.config'

    hide_payment_button = fields.Boolean(
        string='Ocultar Botón de Pago',
        help='Oculta el botón de pago y muestra solo el botón de acciones',
        default=False
    )
```

### 4. views/pos_config_view.xml

```xml
<?xml version="1.0" encoding="utf-8"?>
<odoo>
    <record id="pos_config_view_form_inherit" model="ir.ui.view">
        <field name="name">pos.config.form.inherit</field>
        <field name="model">pos.config</field>
        <field name="inherit_id" ref="point_of_sale.pos_config_view_form"/>
        <field name="arch" type="xml">
            <!-- Agregar el campo en la sección de configuraciones -->
            <xpath expr="//div[@class='row mt16 o_settings_container'][@invisible]" position="inside">
                <setting string="Interfaz" help="Configuraciones de la interfaz del POS">
                    <field name="hide_payment_button"/>
                    <label for="hide_payment_button" string="Ocultar Botón de Pago"/>
                    <div class="text-muted">
                        Oculta el botón de pago y muestra solo el botón de acciones
                    </div>
                </setting>
            </xpath>
        </field>
    </record>
</odoo>
```

### 5. static/src/app/screens/product_screen/action_pad/action_pad.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<templates id="template" xml:space="preserve">

    <!-- Herencia del template ActionpadWidget -->
    <t t-name="point_of_sale.ActionpadWidget" t-inherit="point_of_sale.ActionpadWidget" t-inherit-mode="extension">

        <!-- Ocultar el botón de pago cuando hide_payment_button está activado -->
        <xpath expr="//div[@class='validation d-flex gap-2']" position="attributes">
            <attribute name="t-if">props.showActionButton and !pos.config.hide_payment_button</attribute>
        </xpath>

        <!-- Agregar el botón de acciones para pantallas grandes cuando hide_payment_button está activado -->
        <xpath expr="//div[@class='validation d-flex gap-2']" position="after">
            <div t-if="pos.config.hide_payment_button and !ui.isSmall" class="d-flex gap-2">
                <BackButton t-if="pos.showBackButton()" onClick="() => pos.onClickBackButton()"/>
                <t t-if="props.onClickMore">
                    <SelectPartnerButton partner="props.partner"/>
                    <button t-if="this.pos.showSaveOrderButton"
                            t-att-disabled="this.pos.get_order().is_empty()"
                            class="btn btn-light btn-lg"
                            t-on-click="() => this.pos.clickSaveOrder()">
                        <i class="fa fa-upload"/>
                    </button>
                    <button class="button actions-button btn btn-primary btn-lg flex-fill"
                            t-on-click="props.onClickMore">
                        <span>Acciones</span>
                    </button>
                </t>
            </div>
        </xpath>

        <!-- Ocultar el botón de pago en mobile cuando hide_payment_button está activado -->
        <!-- Esto se hace en el ProductScreen, ver siguiente archivo -->
    </t>

</templates>
```

### 6. static/src/app/screens/product_screen/action_pad/action_pad.js

```javascript
/** @odoo-module */

import { ActionpadWidget } from "@point_of_sale/app/screens/product_screen/action_pad/action_pad";
import { patch } from "@web/core/utils/patch";

// No se necesitan cambios en el JS para este caso específico,
// pero se mantiene el archivo por si necesitas agregar lógica adicional

patch(ActionpadWidget.prototype, {
    // Puedes agregar métodos personalizados aquí si lo necesitas
});
```

### 7. Alternativa: Ocultar también el botón de pago en mobile

Si también quieres ocultar el botón de pago en mobile (switchpane), necesitarás crear otro archivo:

**static/src/app/screens/product_screen/product_screen.xml**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<templates id="template" xml:space="preserve">

    <t t-name="point_of_sale.ProductScreen" t-inherit="point_of_sale.ProductScreen" t-inherit-mode="extension">

        <!-- Ocultar el botón de pago en mobile switchpane -->
        <xpath expr="//button[hasclass('pay-button')]" position="attributes">
            <attribute name="t-if">!pos.scanning and !pos.config.hide_payment_button</attribute>
        </xpath>

        <!-- Agregar botón de acciones en su lugar -->
        <xpath expr="//button[hasclass('pay-button')]" position="after">
            <button t-if="!pos.scanning and pos.config.hide_payment_button"
                    class="btn-switchpane actions-button btn btn-primary btn-lg w-50"
                    t-on-click="displayAllControlPopup">
                <span class="d-block">Acciones</span>
            </button>
        </xpath>

    </t>

</templates>
```

Y agregarlo al __manifest__.py en la sección de assets:

```python
'assets': {
    'point_of_sale.assets': [
        'pos_hide_payment_button/static/src/app/screens/product_screen/action_pad/action_pad.xml',
        'pos_hide_payment_button/static/src/app/screens/product_screen/action_pad/action_pad.js',
        'pos_hide_payment_button/static/src/app/screens/product_screen/product_screen.xml',
    ],
},
```

## 📝 Pasos para Instalar el Módulo

1. **Crear la estructura del módulo** en `/home/user/odoo/addons/pos_hide_payment_button/`

2. **Actualizar la lista de módulos** en Odoo:
   - Ir a Apps (Aplicaciones)
   - Activar modo desarrollador
   - Actualizar lista de aplicaciones

3. **Instalar el módulo**:
   - Buscar "POS Hide Payment Button"
   - Hacer clic en Instalar

4. **Configurar el POS**:
   - Ir a Punto de Venta > Configuración > Puntos de Venta
   - Seleccionar tu punto de venta
   - Activar la opción "Ocultar Botón de Pago"
   - Guardar

5. **Probar**:
   - Abrir el POS
   - Verificar que el botón de pago esté oculto
   - Verificar que el botón de acciones sea visible

## 🎨 Personalización Adicional

### Cambiar el texto del botón

Modifica la línea en el XML:
```xml
<span>Acciones</span>
```

### Cambiar el estilo del botón

Puedes agregar CSS personalizado creando un archivo:

**static/src/css/pos_hide_payment.css**

```css
.pos .actions-button {
    background-color: #00A09D !important;
    border-color: #00A09D !important;
}

.pos .actions-button:hover {
    background-color: #008B88 !important;
}
```

Y agregarlo al __manifest__.py:

```python
'assets': {
    'point_of_sale.assets': [
        'pos_hide_payment_button/static/src/css/pos_hide_payment.css',
        # ... otros archivos
    ],
},
```

## 🔍 Componentes del ActionpadWidget

### Props del Componente

```javascript
static props = {
    partner: { type: [Object, { value: null }], optional: true },
    onClickMore: { type: Function, optional: true },
    actionName: String,
    actionToTrigger: Function,
    showActionButton: { type: Boolean, optional: true },
};

static defaultProps = {
    showActionButton: true,
};
```

### Lógica de Visibilidad

1. **Pantallas grandes**:
   - Muestra el botón de pago cuando `showActionButton` es `true`
   - No muestra el botón de acciones por defecto

2. **Pantallas pequeñas**:
   - Muestra el botón de acciones cuando `ui.isSmall` es `true`
   - Oculta el botón de pago en el ActionpadWidget
   - Muestra un botón de pago separado en el switchpane

## 🔄 Flujo de Datos

```
pos_config.py (Backend)
    ↓
    │ Campo: hide_payment_button (Boolean)
    ↓
pos_store.js (Frontend)
    ↓
    │ Cargado en: this.config.hide_payment_button
    ↓
action_pad.xml (Template)
    ↓
    │ Evaluación: t-if="!pos.config.hide_payment_button"
    ↓
Renderizado del botón en la interfaz
```

## ⚠️ Consideraciones Importantes

1. **Sesiones Activas**: No se puede cambiar la configuración mientras hay una sesión activa del POS

2. **Compatibilidad**: Este módulo está diseñado para Odoo 18.0. Para otras versiones, verifica la compatibilidad de los archivos heredados

3. **Módulos Adicionales**: Si tienes otros módulos que modifican el ActionpadWidget, puede haber conflictos. Usa `t-inherit-mode="extension"` para evitar problemas

4. **Pruebas**: Asegúrate de probar en:
   - Pantallas grandes (desktop)
   - Pantallas pequeñas (tablets)
   - Móviles
   - Diferentes navegadores

## 🐛 Solución de Problemas

### El botón no se oculta

1. Verifica que el módulo esté instalado correctamente
2. Asegúrate de que la configuración esté activada
3. Limpia el caché del navegador (Ctrl + Shift + R)
4. Verifica la consola del navegador por errores JavaScript

### Error al cargar los assets

1. Verifica la ruta de los archivos en __manifest__.py
2. Actualiza los assets de Odoo: `./odoo-bin --update=pos_hide_payment_button`
3. Reinicia el servidor de Odoo

### El botón de acciones no funciona

1. Verifica que `props.onClickMore` esté definido
2. Asegúrate de que el método `displayAllControlPopup` esté disponible en ProductScreen

## 📚 Referencias de Archivos Clave

- **pos_config.py**: `/home/user/odoo/addons/point_of_sale/models/pos_config.py`
- **action_pad.xml**: `/home/user/odoo/addons/point_of_sale/static/src/app/screens/product_screen/action_pad/action_pad.xml`
- **action_pad.js**: `/home/user/odoo/addons/point_of_sale/static/src/app/screens/product_screen/action_pad/action_pad.js`
- **product_screen.xml**: `/home/user/odoo/addons/point_of_sale/static/src/app/screens/product_screen/product_screen.xml`
- **pos_store.js**: `/home/user/odoo/addons/point_of_sale/static/src/app/store/pos_store.js`
- **pos_config_view.xml**: `/home/user/odoo/addons/point_of_sale/views/pos_config_view.xml`

## 🎯 Resumen de la Solución

Para ocultar el botón "Pago" y mostrar solo el botón "Acciones":

1. ✅ Agregar campo booleano `hide_payment_button` en `pos.config`
2. ✅ Crear vista XML para mostrar la configuración
3. ✅ Heredar el template `ActionpadWidget` en el frontend
4. ✅ Condicionar la visibilidad del botón de pago con `t-if="!pos.config.hide_payment_button"`
5. ✅ Agregar botón de acciones para pantallas grandes cuando la opción esté activada
6. ✅ (Opcional) Ocultar también el botón de pago en mobile

---

**Fecha de análisis**: 2025-11-04
**Versión de Odoo**: 18.0
**Estado**: ✅ Análisis Completo
