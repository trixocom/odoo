# -*- coding: utf-8 -*-
from odoo import fields, models


class PosConfig(models.Model):
    _inherit = 'pos.config'

    hide_payment_button = fields.Boolean(
        string='Ocultar Botón de Pago',
        help='Oculta el botón de pago y muestra solo el botón de acciones en la interfaz del POS',
        default=False
    )
