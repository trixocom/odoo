/** @odoo-module */

import { ActionpadWidget } from "@point_of_sale/app/screens/product_screen/action_pad/action_pad";
import { patch } from "@web/core/utils/patch";

// Patch del ActionpadWidget para extender funcionalidad si es necesario
// Por ahora, la lógica está toda en el XML
patch(ActionpadWidget.prototype, {
    // Aquí puedes agregar métodos personalizados si lo necesitas en el futuro
    // Por ejemplo:
    // setup() {
    //     super.setup();
    //     // Lógica adicional
    // }
});
