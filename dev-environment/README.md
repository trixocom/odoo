# 🚀 Entorno de Desarrollo Odoo 18 CE con Docker

Entorno de desarrollo completo para Odoo 18.0 Community Edition con el módulo `pos_hide_payment_button` preinstalado.

## 📋 Requisitos Previos

### En tu MacBook debes tener instalado:

1. **Docker Desktop para Mac**
   - Descargar de: https://www.docker.com/products/docker-desktop
   - Versión mínima: 4.0+
   - Asegúrate de que Docker Desktop esté corriendo

2. **Git** (para clonar el repositorio)
   - Viene preinstalado en macOS
   - Verificar: `git --version`

3. **Recursos mínimos recomendados**:
   - RAM: 4GB disponibles (8GB recomendado)
   - Disco: 10GB libres
   - CPU: 2 cores

## 📁 Estructura del Proyecto

```
odoo/
├── dev-environment/              # 👈 Entorno de desarrollo Docker
│   ├── docker-compose.yml        # Configuración de servicios
│   ├── config/
│   │   └── odoo.conf            # Configuración de Odoo
│   ├── data/                     # Datos persistentes
│   │   ├── postgresql/          # Base de datos PostgreSQL
│   │   └── addons/              # Filestore de Odoo
│   ├── logs/                     # Logs de Odoo
│   ├── scripts/                  # Scripts de gestión
│   │   ├── start.sh             # Iniciar entorno
│   │   ├── stop.sh              # Detener entorno
│   │   ├── restart.sh           # Reiniciar entorno
│   │   ├── logs.sh              # Ver logs en tiempo real
│   │   └── update-module.sh     # Actualizar módulo
│   └── README.md                 # Este archivo
│
├── custom_addons/                # 👈 Módulos personalizados
│   └── pos_hide_payment_button/  # Nuestro módulo
│       ├── __init__.py
│       ├── __manifest__.py
│       ├── README.md
│       ├── models/
│       ├── views/
│       └── static/
│
└── ANALISIS_POS_MODULO.md       # Documentación del análisis

```

## 🚀 Inicio Rápido

### 1. Preparar el entorno en tu MacBook

```bash
# Clonar o copiar el proyecto
cd ~/Desktop
git clone <tu-repositorio> odoo-dev
cd odoo-dev/dev-environment

# O si ya tienes el proyecto:
cd /ruta/a/tu/proyecto/odoo/dev-environment
```

### 2. Iniciar el entorno

```bash
# Iniciar todos los servicios
./scripts/start.sh
```

Este comando hará:
- ✅ Descargar las imágenes de Docker (solo la primera vez)
- ✅ Crear la base de datos PostgreSQL
- ✅ Iniciar Odoo 18.0
- ✅ Iniciar pgAdmin (gestor de base de datos)
- ✅ Montar el módulo personalizado

**Tiempo estimado primera vez**: 2-5 minutos (dependiendo de tu conexión)

### 3. Acceder a Odoo

Abre tu navegador y ve a: **http://localhost:8069**

#### Primera configuración (solo una vez):

1. Se mostrará la pantalla de creación de base de datos
2. Completa los datos:
   - **Master Password**: `admin` (configurado en odoo.conf)
   - **Database Name**: `odoo_dev` (o el nombre que prefieras)
   - **Email**: tu email
   - **Password**: tu contraseña
   - **Language**: Español
   - **Country**: España (o tu país)
   - **Demo data**: ✅ Activar (recomendado para desarrollo)

3. Clic en "Create Database"

4. Esperar a que se cree la base de datos (1-2 minutos)

### 4. Instalar el módulo POS Hide Payment Button

Una vez dentro de Odoo:

1. Ir a **Apps** (Aplicaciones)
2. Activar el **modo desarrollador**:
   - Ir a Ajustes > Activar modo desarrollador
   - O usar el atajo: `?debug=1` en la URL
3. Clic en "Update Apps List" (Actualizar lista de aplicaciones)
4. Buscar "**POS Hide Payment Button**"
5. Clic en **Install**

### 5. Instalar Point of Sale

Si no está instalado:

1. Buscar "**Point of Sale**" en Apps
2. Clic en **Install**
3. Esperar a que se instale (incluye dependencias)

### 6. Configurar el POS

1. Ir a **Point of Sale** > **Configuration** > **Point of Sale**
2. Crear un nuevo POS o editar el existente
3. Activar la opción **"Ocultar Botón de Pago"**
4. Guardar
5. Abrir el POS para ver el cambio

## 🛠️ Gestión del Entorno

### Ver logs en tiempo real

```bash
./scripts/logs.sh
```

### Reiniciar el entorno

```bash
./scripts/restart.sh
```

### Detener el entorno

```bash
./scripts/stop.sh
```

### Actualizar el módulo después de cambios

```bash
# Sintaxis: ./scripts/update-module.sh [nombre_modulo] [nombre_db]
./scripts/update-module.sh pos_hide_payment_button odoo_dev
```

## 🔧 Servicios Disponibles

| Servicio | URL | Usuario | Password |
|----------|-----|---------|----------|
| **Odoo** | http://localhost:8069 | admin | (el que configuraste) |
| **pgAdmin** | http://localhost:8080 | admin@odoo.local | admin |
| **PostgreSQL** | localhost:5432 | odoo | odoo |

## 📝 Desarrollo del Módulo

### Editar archivos del módulo

Los archivos del módulo están en:
```
../custom_addons/pos_hide_payment_button/
```

Puedes editarlos con tu editor favorito (VS Code, Sublime, etc.)

### Aplicar cambios

#### Cambios en Python (.py):

```bash
# Opción 1: Actualizar el módulo
./scripts/update-module.sh pos_hide_payment_button odoo_dev

# Opción 2: Reiniciar Odoo
./scripts/restart.sh
```

#### Cambios en XML/JS/CSS:

1. Actualizar el módulo desde Odoo:
   - Apps > POS Hide Payment Button > Upgrade
2. O usar el script:
   ```bash
   ./scripts/update-module.sh pos_hide_payment_button odoo_dev
   ```

### Ver errores

```bash
# Ver logs en tiempo real
./scripts/logs.sh

# O revisar el archivo de logs
cat logs/odoo.log
```

## 🐛 Solución de Problemas

### Docker no está corriendo

```
❌ Error: Docker no está corriendo
```

**Solución**: Abre Docker Desktop y espera a que inicie completamente.

### Puerto 8069 ya en uso

```
Error: port is already allocated
```

**Solución**:
```bash
# Detener el servicio que está usando el puerto
lsof -ti:8069 | xargs kill -9

# O cambiar el puerto en docker-compose.yml
# ports:
#   - "8070:8069"  # usar puerto 8070 en vez de 8069
```

### No se ve el módulo en la lista de Apps

**Solución**:
```bash
# 1. Actualizar la lista de aplicaciones
# Desde Odoo: Apps > Update Apps List

# 2. Verificar que el módulo esté montado
docker-compose exec odoo ls -la /mnt/extra-addons/

# 3. Verificar los logs
./scripts/logs.sh
```

### Error al conectar con PostgreSQL

**Solución**:
```bash
# Reiniciar todo el entorno
docker-compose down
./scripts/start.sh
```

### Módulo no se actualiza

**Solución**:
```bash
# Forzar actualización
docker-compose exec odoo odoo -d odoo_dev -u pos_hide_payment_button --stop-after-init
./scripts/restart.sh
```

### Problemas de permisos en Mac

**Solución**:
```bash
# Dar permisos a las carpetas de datos
chmod -R 755 data/
```

## 🔄 Resetear el Entorno Completamente

Si quieres empezar de cero:

```bash
# Detener y eliminar todo (incluyendo volúmenes)
docker-compose down -v

# Eliminar datos locales
rm -rf data/postgresql/*
rm -rf data/addons/*
rm -rf logs/*

# Iniciar de nuevo
./scripts/start.sh
```

## 📊 Monitoreo de Recursos

### Ver uso de recursos

```bash
docker stats
```

### Ver contenedores activos

```bash
docker-compose ps
```

## 🎯 Próximos Pasos

1. ✅ Entorno funcionando
2. ✅ Módulo instalado
3. 📝 Personalizar el módulo según tus necesidades
4. 🧪 Probar en diferentes escenarios
5. 📦 Exportar el módulo para producción

## 📚 Recursos Adicionales

- [Documentación oficial de Odoo 18](https://www.odoo.com/documentation/18.0/)
- [Odoo Developer Documentation](https://www.odoo.com/documentation/18.0/developer.html)
- [Docker Documentation](https://docs.docker.com/)

## 🆘 Soporte

Para problemas o preguntas:

1. Revisar la sección de Solución de Problemas
2. Revisar los logs: `./scripts/logs.sh`
3. Consultar el análisis completo: `../ANALISIS_POS_MODULO.md`

## 📝 Notas Importantes

- ⚠️ Este es un entorno de **desarrollo**, no usar en producción
- 💾 Los datos se guardan en `./data/` y persisten entre reinicios
- 🔒 Las contraseñas por defecto son débiles, cambiarlas en producción
- 🚀 El modo de desarrollo (`--dev=all`) está activo para recarga automática

## 🎉 ¡Listo!

Tu entorno de desarrollo Odoo 18 está configurado y listo para usar.

**Happy coding! 🚀**
