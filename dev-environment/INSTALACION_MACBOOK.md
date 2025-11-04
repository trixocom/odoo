# 📦 Instrucciones para Transferir a tu MacBook

Guía paso a paso para llevar este entorno de desarrollo a tu MacBook.

## 🎯 Opción 1: Transferencia Directa (Recomendado)

### Paso 1: Preparar el paquete en este servidor

```bash
# Ir al directorio padre
cd /home/user/odoo

# Crear un archivo comprimido con todo lo necesario
tar -czf odoo-dev-environment.tar.gz \
  dev-environment/ \
  custom_addons/pos_hide_payment_button/ \
  ANALISIS_POS_MODULO.md

# Verificar el tamaño
ls -lh odoo-dev-environment.tar.gz
```

### Paso 2: Transferir a tu MacBook

**Opción A - Con SCP (si tienes acceso SSH):**

```bash
# Desde tu MacBook
scp usuario@servidor:/home/user/odoo/odoo-dev-environment.tar.gz ~/Desktop/
```

**Opción B - Con SFTP/FTP:**

Usa un cliente como FileZilla o Cyberduck para descargar el archivo.

**Opción C - Con Git:**

Si tienes el repo en GitHub privado:
```bash
# En tu MacBook
git clone git@github.com:trixocom/odoo.git
cd odoo
git checkout claude/analyze-odoo-pos-module-011CUnmSx57biy1WbqSC3dF4
```

### Paso 3: Extraer en tu MacBook

```bash
# Ir a donde quieras trabajar
cd ~/Documents  # o ~/Desktop, o donde prefieras

# Crear directorio del proyecto
mkdir odoo-development
cd odoo-development

# Extraer el archivo
tar -xzf ~/Desktop/odoo-dev-environment.tar.gz

# Verificar estructura
tree -L 2
```

## 🎯 Opción 2: Clonar desde GitHub

Si pusheaste los cambios a GitHub:

```bash
# En tu MacBook
cd ~/Documents  # o donde prefieras

# Clonar el repositorio
git clone git@github.com:trixocom/odoo.git odoo-development
cd odoo-development

# Cambiar a la rama correcta
git checkout claude/analyze-odoo-pos-module-011CUnmSx57biy1WbqSC3dF4
```

## 🚀 Configuración en MacBook

### 1. Instalar Docker Desktop

```bash
# Descargar desde:
open https://www.docker.com/products/docker-desktop

# O con Homebrew:
brew install --cask docker
```

**Iniciar Docker Desktop** y esperar a que esté completamente activo.

### 2. Verificar instalación

```bash
# Verificar Docker
docker --version
docker-compose --version

# Debería mostrar algo como:
# Docker version 24.0.x
# Docker Compose version v2.x.x
```

### 3. Dar permisos a los scripts

```bash
cd dev-environment
chmod +x scripts/*.sh
```

### 4. Iniciar el entorno

```bash
./scripts/start.sh
```

### 5. Acceder a Odoo

Abrir navegador en: **http://localhost:8069**

## 📝 Estructura Final en tu MacBook

```
~/Documents/odoo-development/
├── dev-environment/
│   ├── docker-compose.yml
│   ├── config/
│   ├── data/
│   ├── logs/
│   └── scripts/
├── custom_addons/
│   └── pos_hide_payment_button/
└── ANALISIS_POS_MODULO.md
```

## 🔧 Configuración Específica de MacBook

### Recursos de Docker Desktop

1. Abrir **Docker Desktop**
2. Ir a **Settings** (⚙️) > **Resources**
3. Configurar:
   - **CPUs**: 2-4 (dependiendo de tu Mac)
   - **Memory**: 4-8 GB
   - **Swap**: 1-2 GB
   - **Disk**: 20-50 GB

### Rendimiento en Mac M1/M2/M3

Si tienes Mac con chip Apple Silicon (M1/M2/M3):

```yaml
# En docker-compose.yml, agregar platform para cada servicio:
services:
  db:
    platform: linux/amd64  # Agregar esta línea
    image: postgres:15
    # ...

  odoo:
    platform: linux/amd64  # Agregar esta línea
    image: odoo:18.0
    # ...
```

**Nota**: Los chips Apple Silicon usan arquitectura ARM, pero Docker puede emular x86_64.

## 🐛 Problemas Comunes en Mac

### 1. "Docker daemon is not running"

**Solución**:
- Abre Docker Desktop
- Espera a que el ícono de la ballena en la barra superior esté quieto (sin animación)

### 2. Puerto 8069 ocupado

```bash
# Ver qué proceso usa el puerto
lsof -ti:8069

# Matar el proceso
lsof -ti:8069 | xargs kill -9
```

### 3. Problemas de permisos

```bash
# En Mac normalmente no es problema, pero si hay errores:
chmod -R 755 dev-environment/data/
```

### 4. Lentitud en Mac Intel

Si tu Mac con Intel va lento:

```yaml
# En docker-compose.yml, reducir workers:
# environment:
#   - WORKERS=0  # Usar solo 1 worker
```

### 5. Disco lleno

```bash
# Limpiar imágenes no usadas
docker system prune -a

# Limpiar volúmenes no usados
docker volume prune
```

## 📊 Monitoreo en Mac

### Ver uso de recursos en tiempo real

```bash
# Terminal 1: Docker stats
docker stats

# Terminal 2: Activity Monitor
open -a "Activity Monitor"
```

### Ver logs de Docker Desktop

```
Docker Desktop > Settings > Troubleshoot > View Logs
```

## 🔄 Workflow de Desarrollo

### 1. Cada día al comenzar

```bash
cd ~/Documents/odoo-development/dev-environment
./scripts/start.sh
```

### 2. Durante el desarrollo

- Editar archivos en `../custom_addons/pos_hide_payment_button/`
- Usar VS Code, Sublime, o tu editor favorito
- Actualizar módulo: `./scripts/update-module.sh`

### 3. Ver cambios

- Refrescar Odoo en el navegador
- Ver logs: `./scripts/logs.sh`

### 4. Al terminar el día

```bash
./scripts/stop.sh
```

**Nota**: Los datos se mantienen, al día siguiente solo hacer `start.sh`

## 🎨 Herramientas Recomendadas para Mac

### Editores de Código

```bash
# VS Code (recomendado)
brew install --cask visual-studio-code

# Sublime Text
brew install --cask sublime-text

# PyCharm Community
brew install --cask pycharm-ce
```

### Extensiones de VS Code para Odoo

- Python
- XML Tools
- Odoo Snippets
- Docker
- GitLens

### Cliente de Base de Datos

```bash
# Postico (PostgreSQL GUI para Mac)
brew install --cask postico

# O usar pgAdmin que viene incluido:
# http://localhost:8080
```

### Terminal

```bash
# iTerm2 (mejor que Terminal.app)
brew install --cask iterm2

# Oh My Zsh para mejor experiencia
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## 📱 Acceso desde otros dispositivos

### Acceder desde iPad/iPhone en la misma red

1. Averiguar la IP de tu Mac:
   ```bash
   ifconfig | grep "inet " | grep -v 127.0.0.1
   ```

2. Desde iPad/iPhone, abrir Safari:
   ```
   http://[IP-DE-TU-MAC]:8069
   ```

### Acceder desde otra computadora

Misma red WiFi:
```
http://[IP-DE-TU-MAC]:8069
```

## 🔐 Seguridad

### Cambiar contraseñas por defecto

En `config/odoo.conf`:
```ini
# Cambiar el admin_passwd
admin_passwd = tu_nueva_contraseña_segura
```

En `docker-compose.yml`:
```yaml
environment:
  - POSTGRES_PASSWORD=tu_contraseña_segura
```

**Importante**: Si cambias estas contraseñas, anótalas en un lugar seguro.

## 📦 Backup de tu Trabajo

### Backup manual

```bash
# Backup de la base de datos
docker-compose exec db pg_dump -U odoo odoo_dev > backup_$(date +%Y%m%d).sql

# Backup de filestore
tar -czf filestore_backup_$(date +%Y%m%d).tar.gz dev-environment/data/addons/
```

### Backup automático con Time Machine

Asegúrate de que tu carpeta del proyecto esté incluida en Time Machine:
```
System Preferences > Time Machine > Options
```

## 🎯 Próximos Pasos

1. ✅ Transferir archivos a MacBook
2. ✅ Instalar Docker Desktop
3. ✅ Iniciar entorno: `./scripts/start.sh`
4. ✅ Acceder a Odoo: http://localhost:8069
5. ✅ Crear base de datos
6. ✅ Instalar módulo POS Hide Payment Button
7. 🎨 Comenzar a desarrollar

## 🆘 Soporte

Si tienes problemas:

1. Revisar logs: `./scripts/logs.sh`
2. Revisar Docker Desktop logs
3. Consultar `README.md` en dev-environment/
4. Consultar documentación oficial de Docker para Mac

---

**¡Listo para desarrollar en tu MacBook! 🚀**
