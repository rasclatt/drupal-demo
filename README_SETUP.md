# Drupal Docker Setup - Complete Guide

## 🎯 Overview

You now have a fully functional Drupal 10 Docker development environment with:

- **Drupal 10** running on Apache with PHP 8.4
- **MySQL 8.0** database server
- **phpMyAdmin** for database management
- **Composer** for PHP dependency management
- **Drush** for Drupal command-line management
- Proper volume mounts for code editing
- Automatic health checks

## 🚀 Quick Start (3 Steps)

### Step 1: Start Docker Containers

```bash
cd /Users/developer/Documents/Clients/Drupal
docker-compose up -d
```

Or use the quickstart script:

```bash
./quickstart.sh
```

### Step 2: Open Drupal Installer

Open your browser to: **http://localhost/core/install.php**

### Step 3: Complete the Installation

Follow the installer to choose language, profile, and configure your site.

**That's it!** Your Drupal site will be ready at **http://localhost**

## 📖 Detailed Installation Steps

The web-based installer will guide you through:

1. **Choose Language** - Select English (or preferred language)
2. **Choose Profile** - Select "Standard" for full-featured Drupal
3. **Verify Requirements** - All checks should pass ✓
4. **Set Up Database** - Already configured automatically:
   - Database: `drupal`
   - User: `drupal`
   - Password: `drupal_password`
   - Host: `mysql`
5. **Install Site** - Automated installation process (2-5 minutes)
6. **Configure Site** - Set site name, admin user, and password

## 🔗 Important URLs

| Purpose | URL |
|---------|-----|
| Drupal Home | http://localhost |
| Installer | http://localhost/core/install.php |
| Admin Login | http://localhost/user/login |
| phpMyAdmin | http://localhost:8081 |

## 📁 Project Structure

```
Drupal/
├── web/                          # Drupal web root
│   ├── core/ → symlink           # Drupal core files
│   ├── modules/                  # Contributed modules
│   ├── themes/                   # Contributed themes
│   ├── sites/
│   │   └── default/
│   │       ├── files/            # User uploads
│   │       └── settings.php      # Site config
│   ├── autoload.php              # PHP autoloader
│   └── index.php
├── modules/                       # Custom modules directory
├── themes/                        # Custom themes directory
├── vendor/                        # Composer dependencies
├── files/                         # Uploaded files (persistent)
├── docker-compose.yml             # Docker configuration
├── Dockerfile                     # Custom Docker image
├── composer.json                  # PHP dependencies
├── composer.lock                  # Dependency lock file
├── INSTALL_GUIDE.md               # Detailed installation guide
├── SETUP_STATUS.md                # Setup status report
├── quickstart.sh                  # Quick start script
└── README_SETUP.md                # This file
```

## 🐳 Docker Containers

### Drupal Web Server
- **Container**: drupal_web
- **Image**: drupal:10-apache (customized)
- **Port**: 80 (HTTP), 443 (HTTPS)
- **Services**: Apache, PHP 8.4, Composer, Drush

### MySQL Database
- **Container**: drupal_db
- **Image**: mysql:8.0
- **Port**: 3306
- **Database**: drupal
- **User**: drupal (password: drupal_password)

### phpMyAdmin
- **Container**: drupal_phpmyadmin
- **Image**: phpmyadmin:latest
- **Port**: 8081
- **Access**: http://localhost:8081

## 💻 Development Workflow

### Editing Code

1. Your local files are mounted into the container:
   - Local: `./web/` → Container: `/var/www/html/web`
   - Local: `./vendor/` → Container: `/var/www/html/vendor`
   - Local: `./modules/` → Container: `/var/www/html/modules`
   - Local: `./themes/` → Container: `/var/www/html/themes`

2. Edit files locally with your preferred editor
3. Changes are immediately visible in the browser

### Custom Modules

Place your modules in `./modules/custom/` directory:

```
modules/
└── custom/
    └── my_module/
        ├── my_module.info.yml
        ├── my_module.module
        └── src/
```

Then enable them in Drupal admin or via Drush:

```bash
docker exec drupal_web drush --root=/var/www/html/web en my_module
```

### Custom Themes

Place your themes in `./themes/custom/` directory:

```
themes/
└── custom/
    └── my_theme/
        ├── my_theme.info.yml
        ├── my_theme.theme
        ├── templates/
        └── css/
```

Then enable them in Drupal admin or via Drush:

```bash
docker exec drupal_web drush --root=/var/www/html/web theme:enable my_theme
```

## 🛠️ Common Commands

### Docker Compose Commands

```bash
# Start all containers
docker-compose up -d

# Stop all containers
docker-compose down

# View running containers
docker-compose ps

# View logs
docker-compose logs -f drupal_web

# Rebuild image
docker-compose build --no-cache

# Remove everything including volumes
docker-compose down -v
```

### Drush Commands

```bash
# Status
docker exec drupal_web drush --root=/var/www/html/web status

# Clear caches
docker exec drupal_web drush --root=/var/www/html/web cache:rebuild

# Run database updates
docker exec drupal_web drush --root=/var/www/html/web updatedb

# Enable module
docker exec drupal_web drush --root=/var/www/html/web en module_name

# Disable module
docker exec drupal_web drush --root=/var/www/html/web dis module_name

# List modules
docker exec drupal_web drush --root=/var/www/html/web pm:list
```

### Container Access

```bash
# Access web container shell
docker exec -it drupal_web bash

# Access database shell
docker exec -it drupal_db mysql -u drupal -pdrupal_password drupal

# Run PHP directly
docker exec drupal_web php -v

# Run Composer commands
docker exec drupal_web composer --version
```

## 📦 Managing Dependencies

### Add PHP Package via Composer

```bash
# On your local machine
composer require drupal/module_name

# Then rebuild containers to apply changes
docker-compose down
docker-compose up -d
```

### Install Contributed Modules via Drush

```bash
docker exec drupal_web drush --root=/var/www/html/web pm:install drupal/module_name
```

## 🔒 Database Management

### Using phpMyAdmin (Web Interface)

1. Visit http://localhost:8081
2. Username: `drupal`
3. Password: `drupal_password`
4. Select database: `drupal`

### Using MySQL CLI

```bash
docker exec -it drupal_db mysql -u drupal -pdrupal_password drupal

# Common commands:
SHOW TABLES;
SELECT * FROM users;
DESC users;
```

### Backup Database

```bash
docker exec drupal_db mysqldump -u drupal -pdrupal_password drupal > backup_$(date +%Y%m%d_%H%M%S).sql
```

### Restore Database

```bash
docker exec -i drupal_db mysql -u drupal -pdrupal_password drupal < backup.sql
```

## 🐛 Troubleshooting

### Containers Won't Start

**Check if ports are in use:**

```bash
lsof -i :80   # HTTP
lsof -i :443  # HTTPS
lsof -i :3306 # MySQL
lsof -i :8081 # phpMyAdmin
```

**Check Docker logs:**

```bash
docker-compose logs drupal_web
docker-compose logs drupal_db
```

### Database Connection Error

The database is already configured. If you get connection errors:

1. Verify MySQL is running: `docker-compose ps`
2. Check database config in `web/sites/default/settings.php`
3. Test connection: `docker exec drupal_db mysql -u drupal -pdrupal_password -h mysql drupal`

### Slow File Access (macOS)

This is normal due to Docker's filesystem. Consider:

1. Using named volumes for large files
2. Enabling VirtioFS in Docker preferences (macOS 13+)
3. Excluding node_modules from volume mounts

### Permission Denied Errors

Reset permissions:

```bash
docker exec drupal_web chmod -R 755 /var/www/html/web/sites/default/files
docker exec drupal_web chown -R www-data:www-data /var/www/html/web/sites/default/files
```

### White Page or "Not Found" Errors

1. Clear Drupal cache: `docker exec drupal_web drush --root=/var/www/html/web cache:rebuild`
2. Check web server logs: `docker-compose logs drupal_web | grep -i error`
3. Enable debugging in `web/sites/default/settings.php`

## ⚡ Performance Tips

1. **Don't check "Update modules" on login** - Can be slow in Docker
2. **Use named volumes for large files** - Faster than bind mounts
3. **Keep web/core as symlink** - Saves disk space
4. **Use `--no-dev` with Composer** - Reduces install time

## 📋 Configuration Files

### settings.php

Location: `web/sites/default/settings.php`

Key configurations:
- Database connection settings
- File paths
- Trusted hosts
- Debug settings
- Logging configuration

### services.yml

Location: `web/sites/default/services.yml`

Customize Drupal services, caching, and logging.

### docker-compose.yml

Main Docker configuration file. Modify to:
- Change ports
- Add more containers
- Configure environment variables
- Update volume mounts

### Dockerfile

Custom Docker image. Extend to:
- Install additional system packages
- Add more PHP extensions
- Configure Apache differently

## 🔐 Security for Production

**This setup is for development only.** For production:

1. Change all passwords
2. Set random `DRUPAL_HASH_SALT`
3. Enable HTTPS with certificates
4. Configure firewall rules
5. Set up automated backups
6. Use environment variables for secrets
7. Enable security modules:
   - Admin Toolbar
   - Security Review
   - Two-Factor Authentication

## 📚 Learning Resources

- [Drupal.org Documentation](https://www.drupal.org/docs)
- [Drupal API](https://api.drupal.org)
- [Docker Documentation](https://docs.docker.com)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [PHP Documentation](https://www.php.net/docs.php)

## 🆘 Getting Help

### Check Container Logs

```bash
docker-compose logs drupal_web
```

### Access Container

```bash
docker exec -it drupal_web bash
cd /var/www/html/web
```

### Run Drupal Status Report

Visit: **http://localhost/admin/reports/status**

Or via Drush:

```bash
docker exec drupal_web drush --root=/var/www/html/web status-report
```

## ✅ Verification Checklist

After setup, verify everything works:

- [ ] Containers are running: `docker-compose ps`
- [ ] Drupal installer loads: http://localhost/core/install.php
- [ ] Database connection works
- [ ] Admin user created successfully
- [ ] Can log into admin: http://localhost/user/login
- [ ] Drush works: `docker exec drupal_web drush --root=/var/www/html/web status`
- [ ] Can edit local files and changes reflect in browser
- [ ] phpMyAdmin accessible: http://localhost:8081

## 📝 Notes

- All containers run as unprivileged users (except setup)
- Data persists across container restarts
- Use `docker-compose down -v` to remove everything including data
- For production, use proper secrets management
- Consider using `.env` file for sensitive configuration

---

**Last Updated**: November 14, 2026  
**Drupal Version**: 10.1  
**PHP Version**: 8.4  
**MySQL Version**: 8.0  
**Status**: ✅ Ready to Use
