# -*- coding: utf-8 -*-
{
    'name': 'POS Hide Payment Button',
    'version': '18.0.1.0.0',
    'category': 'Point of Sale',
    'summary': 'Permite ocultar el botón de pago en el POS mediante configuración',
    'description': """
        POS Hide Payment Button
        =======================

        Este módulo permite ocultar el botón "Pago" del punto de venta
        y mostrar solo el botón de acciones mediante una opción de configuración.

        Características:
        ---------------
        * Agrega un checkbox en la configuración del POS
        * Oculta el botón "Payment" cuando está activado
        * Muestra el botón "Acciones" en su lugar
        * Funciona tanto en desktop como en mobile

        Uso:
        ----
        1. Ir a Punto de Venta > Configuración > Puntos de Venta
        2. Seleccionar tu punto de venta
        3. Activar la opción "Ocultar Botón de Pago"
        4. Guardar y abrir el POS
    """,
    'author': 'Trixocom',
    'website': 'https://trixocom.com',
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
    'application': False,
    'license': 'LGPL-3',
}
