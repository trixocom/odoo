# 🛠️ Comandos Útiles para Desarrollo con Odoo

Referencia rápida de comandos útiles para el día a día.

## 🚀 Gestión Básica

### Iniciar entorno
```bash
./scripts/start.sh
```

### Detener entorno
```bash
./scripts/stop.sh
```

### Reiniciar entorno
```bash
./scripts/restart.sh
```

### Ver logs en tiempo real
```bash
./scripts/logs.sh
```

### Actualizar módulo
```bash
./scripts/update-module.sh pos_hide_payment_button odoo_dev
```

## 🐳 Docker

### Ver contenedores activos
```bash
docker-compose ps
```

### Ver uso de recursos
```bash
docker stats
```

### Entrar a un contenedor

```bash
# Entrar a Odoo
docker-compose exec odoo bash

# Entrar a PostgreSQL
docker-compose exec db bash
```

### Reiniciar un servicio específico

```bash
# Solo Odoo
docker-compose restart odoo

# Solo PostgreSQL
docker-compose restart db

# Solo pgAdmin
docker-compose restart pgadmin
```

### Ver logs de un servicio específico

```bash
# Logs de Odoo
docker-compose logs -f odoo

# Logs de PostgreSQL
docker-compose logs -f db

# Últimas 50 líneas
docker-compose logs --tail=50 odoo
```

## 🗄️ PostgreSQL

### Conectar a PostgreSQL desde línea de comandos

```bash
docker-compose exec db psql -U odoo -d odoo_dev
```

### Listar bases de datos

```bash
docker-compose exec db psql -U odoo -c "\l"
```

### Backup de base de datos

```bash
# Backup completo
docker-compose exec db pg_dump -U odoo odoo_dev > backup.sql

# Backup comprimido
docker-compose exec db pg_dump -U odoo odoo_dev | gzip > backup.sql.gz

# Backup con fecha
docker-compose exec db pg_dump -U odoo odoo_dev > backup_$(date +%Y%m%d_%H%M%S).sql
```

### Restaurar base de datos

```bash
# Restaurar desde backup
cat backup.sql | docker-compose exec -T db psql -U odoo odoo_dev

# Restaurar desde backup comprimido
gunzip -c backup.sql.gz | docker-compose exec -T db psql -U odoo odoo_dev
```

### Crear nueva base de datos

```bash
docker-compose exec db createdb -U odoo nueva_db
```

### Eliminar base de datos

```bash
docker-compose exec db dropdb -U odoo nombre_db
```

## 📦 Odoo CLI

### Actualizar módulo desde CLI

```bash
docker-compose exec odoo odoo -d odoo_dev -u pos_hide_payment_button --stop-after-init
```

### Instalar módulo desde CLI

```bash
docker-compose exec odoo odoo -d odoo_dev -i pos_hide_payment_button --stop-after-init
```

### Crear nueva base de datos desde CLI

```bash
docker-compose exec odoo odoo -d nueva_db --init=point_of_sale,pos_hide_payment_button --stop-after-init
```

### Modo shell (Python interactivo)

```bash
docker-compose exec odoo odoo shell -d odoo_dev
```

Dentro del shell:
```python
# Ejemplo: listar usuarios
self.env['res.users'].search([])

# Ejemplo: crear un producto
product = self.env['product.product'].create({
    'name': 'Test Product',
    'list_price': 100.0,
})
```

### Ejecutar tests

```bash
docker-compose exec odoo odoo -d odoo_dev --test-enable --stop-after-init
```

## 🔧 Desarrollo

### Reiniciar Odoo (modo desarrollo)

```bash
# Reinicio rápido (sin reconstruir)
docker-compose restart odoo

# Reinicio completo
docker-compose down && docker-compose up -d
```

### Limpiar caché de Python

```bash
# Dentro del contenedor
docker-compose exec odoo bash
find /mnt/extra-addons -type d -name __pycache__ -exec rm -r {} +
find /mnt/extra-addons -type f -name "*.pyc" -delete
```

### Ver configuración de Odoo

```bash
docker-compose exec odoo cat /etc/odoo/odoo.conf
```

### Editar configuración en vivo

```bash
# Editar el archivo local
nano config/odoo.conf

# Reiniciar para aplicar cambios
docker-compose restart odoo
```

## 📊 Monitoreo

### Espacio en disco

```bash
# Espacio usado por Docker
docker system df

# Espacio usado por volúmenes
docker system df -v

# Espacio del proyecto
du -sh dev-environment/
du -sh dev-environment/data/
```

### Procesos de Python dentro de Odoo

```bash
docker-compose exec odoo ps aux | grep python
```

### Memoria usada

```bash
# Memoria de contenedores
docker stats --no-stream

# Memoria en MacOS
top -l 1 | grep PhysMem
```

## 🧹 Limpieza

### Limpiar imágenes no usadas

```bash
docker image prune -a
```

### Limpiar volúmenes no usados

```bash
docker volume prune
```

### Limpiar todo Docker

```bash
# ⚠️ CUIDADO: Esto elimina TODO (contenedores, imágenes, volúmenes, redes)
docker system prune -a --volumes
```

### Limpiar solo este proyecto

```bash
# Detener y eliminar contenedores
docker-compose down

# Eliminar volúmenes
docker-compose down -v

# Eliminar datos locales
rm -rf data/postgresql/*
rm -rf data/addons/*
rm -rf logs/*
```

## 🔍 Debugging

### Ver errores de Python

```bash
# Logs en tiempo real con filtro
docker-compose logs -f odoo | grep ERROR

# Logs con filtro de WARNING
docker-compose logs -f odoo | grep -E "ERROR|WARNING"
```

### Activar modo debug en Odoo

En el navegador, agregar a la URL:
```
?debug=1          # Debug normal
?debug=assets     # Debug de assets (JS/CSS)
?debug=tests      # Debug para tests
```

### Ver consultas SQL

Editar `config/odoo.conf`:
```ini
log_level = debug_sql
```

Reiniciar:
```bash
docker-compose restart odoo
```

### Verificar módulo está montado

```bash
docker-compose exec odoo ls -la /mnt/extra-addons/
docker-compose exec odoo ls -la /mnt/extra-addons/pos_hide_payment_button/
```

## 📝 Git

### Guardar cambios

```bash
cd /path/to/project

# Ver cambios
git status

# Agregar archivos
git add custom_addons/pos_hide_payment_button/

# Commit
git commit -m "Descripción de cambios"

# Push
git push origin tu-rama
```

### Crear nueva rama

```bash
git checkout -b feature/nueva-funcionalidad
```

### Ver diferencias

```bash
git diff custom_addons/pos_hide_payment_button/
```

## 🎨 Assets Frontend

### Actualizar assets (JS/CSS)

Desde Odoo web:
```
Settings > Technical > User Interface > Update Asset
```

O desde CLI:
```bash
docker-compose exec odoo odoo -d odoo_dev -u pos_hide_payment_button --stop-after-init
```

### Limpiar caché del navegador

```
Chrome/Firefox: Ctrl + Shift + R (Mac: Cmd + Shift + R)
```

## 📱 URLs Útiles

### Odoo
```
http://localhost:8069                    # Odoo principal
http://localhost:8069/web/database/manager  # Gestor de bases de datos
http://localhost:8069/web?debug=1       # Modo debug
```

### pgAdmin
```
http://localhost:8080                    # pgAdmin
Usuario: admin@odoo.local
Password: admin
```

### Conectar pgAdmin a PostgreSQL
```
Host: db
Port: 5432
Database: odoo_dev
Username: odoo
Password: odoo
```

## 🔑 Credenciales por Defecto

```
# Odoo
URL: http://localhost:8069
Usuario: admin
Password: (el que configuraste al crear la DB)

# PostgreSQL
Host: localhost
Port: 5432
Usuario: odoo
Password: odoo
Database: odoo_dev

# pgAdmin
URL: http://localhost:8080
Usuario: admin@odoo.local
Password: admin

# Master Password (para gestionar DBs)
Password: admin (configurado en odoo.conf)
```

## 🚨 Emergencias

### Odoo no inicia

```bash
# Ver logs
docker-compose logs odoo

# Reiniciar todo
docker-compose down
docker-compose up -d

# Si sigue sin funcionar, recrear contenedores
docker-compose down
docker-compose up -d --force-recreate
```

### Base de datos corrupta

```bash
# Conectar y verificar
docker-compose exec db psql -U odoo odoo_dev

# Si está corrupta, restaurar desde backup
cat backup.sql | docker-compose exec -T db psql -U odoo odoo_dev
```

### Puerto ocupado

```bash
# Mac: Ver qué usa el puerto 8069
lsof -ti:8069

# Matar proceso
lsof -ti:8069 | xargs kill -9
```

### Resetear todo

```bash
# CUIDADO: Esto elimina TODO
docker-compose down -v
rm -rf data/postgresql/*
rm -rf data/addons/*
./scripts/start.sh
```

## 💡 Tips

### Alias útiles para .bashrc o .zshrc

```bash
# Agregar a ~/.zshrc o ~/.bashrc
alias odoo-start="cd ~/Documents/odoo-development/dev-environment && ./scripts/start.sh"
alias odoo-stop="cd ~/Documents/odoo-development/dev-environment && ./scripts/stop.sh"
alias odoo-logs="cd ~/Documents/odoo-development/dev-environment && ./scripts/logs.sh"
alias odoo-restart="cd ~/Documents/odoo-development/dev-environment && ./scripts/restart.sh"
alias odoo-update="cd ~/Documents/odoo-development/dev-environment && ./scripts/update-module.sh"
```

Luego:
```bash
source ~/.zshrc  # o source ~/.bashrc
```

### Script para backup automático diario

```bash
#!/bin/bash
# Guardar como: ~/scripts/odoo-backup.sh

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR=~/odoo-backups
mkdir -p $BACKUP_DIR

cd ~/Documents/odoo-development/dev-environment

# Backup de base de datos
docker-compose exec db pg_dump -U odoo odoo_dev | gzip > $BACKUP_DIR/odoo_dev_$DATE.sql.gz

# Backup de filestore
tar -czf $BACKUP_DIR/filestore_$DATE.tar.gz data/addons/

echo "Backup completado: $BACKUP_DIR/odoo_dev_$DATE.sql.gz"

# Limpiar backups antiguos (más de 7 días)
find $BACKUP_DIR -name "*.sql.gz" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete
```

Automatizar con cron (Mac):
```bash
# Editar crontab
crontab -e

# Agregar línea (backup diario a las 2 AM)
0 2 * * * /Users/tu-usuario/scripts/odoo-backup.sh
```

---

**¡Guarda este archivo para referencia rápida! 📌**
