# Drupal Docker Installation Guide

This guide explains how to set up and use the Drupal Docker environment for local development.

## Prerequisites

- Docker and Docker Compose installed on your system
- About 2-3 GB of disk space for the images and database

## Quick Start

### 1. Start the Containers

```bash
cd /Users/developer/Documents/Clients/Drupal
docker-compose up -d
```

This will start three containers:
- **drupal_web**: Apache + PHP + Drupal
- **drupal_db**: MySQL 8.0 database
- **drupal_phpmyadmin**: phpMyAdmin for database management

### 2. Complete the Web-Based Installation

Once the containers are running (usually takes 30-60 seconds), open your browser to:

**http://localhost**

You'll be redirected to the installer at **http://localhost/core/install.php**

Follow these steps:
1. **Choose language**: Select English (or your preferred language) and click "Save and continue"
2. **Choose profile**: Select "Standard" profile and click "Save and continue"
3. **Verify requirements**: The system will check requirements. All should pass.
4. **Set up database**: The database connection should already be configured:
   - Database name: `drupal`
   - Database user: `drupal`
   - Database password: `drupal_password`
   - Database host: `mysql`
   - Port: `3306`
   - Click "Save and continue"
5. **Install site**: The installation will proceed automatically. This may take 2-5 minutes.
6. **Configure site**: 
   - Site name: Enter your site name (e.g., "My Drupal Site")
   - Site email: Enter an admin email
   - Username: `admin`
   - Password: Choose a secure password
   - Click "Save and continue"

### 3. Access Your Drupal Site

After installation completes, you'll be taken to the Drupal home page.

Admin login: **http://localhost/user/login**
- Username: `admin`
- Password: (the one you set during installation)

## Environment Setup

### Directory Structure

```
/Users/developer/Documents/Clients/Drupal/
├── web/                 # Drupal web root (served by Apache)
│   ├── modules/
│   │   └── custom/      # Your custom modules
│   ├── themes/
│   │   └── custom/      # Your custom themes
│   ├── sites/
│   │   └── default/     # Site configuration
│   │       └── files/   # User-uploaded files
│   └── ...
├── modules/             # Custom modules (links to web/modules/custom)
├── themes/              # Custom themes (links to web/themes/custom)
├── vendor/              # Composer dependencies
├── files/               # Uploaded files directory
├── docker-compose.yml   # Docker Compose configuration
├── Dockerfile           # Docker image definition
└── composer.json        # PHP dependencies configuration
```

### Docker Services

#### Drupal Web Container
- **Image**: `drupal:10-apache`
- **Port**: 80 (HTTP), 443 (HTTPS)
- **Working Directory**: `/var/www/html`
- **Volumes**: 
  - `./web` → `/var/www/html/web`
  - `./vendor` → `/var/www/html/vendor`
  - `./modules` → `/var/www/html/modules`
  - `./themes` → `/var/www/html/themes`
  - `./files` → `/var/www/html/web/sites/default/files`

#### MySQL Database
- **Image**: `mysql:8.0`
- **Port**: 3306
- **Database**: `drupal`
- **User**: `drupal`
- **Password**: `drupal_password`
- **Root Password**: `root_password`

#### phpMyAdmin
- **Image**: `phpmyadmin:latest`
- **Port**: 8081
- **URL**: **http://localhost:8081**

## Common Development Tasks

### Edit Modules and Themes

Your custom modules and themes should be placed in:
- Custom Modules: `./modules/`
- Custom Themes: `./themes/`

These are automatically available in the container at:
- `/var/www/html/modules`
- `/var/www/html/themes`

### Run Drush Commands

Execute Drush commands inside the container:

```bash
docker exec drupal_web drush --root=/var/www/html/web [command]
```

Common Drush commands:

```bash
# Clear all caches
docker exec drupal_web drush --root=/var/www/html/web cache:rebuild

# Run database updates
docker exec drupal_web drush --root=/var/www/html/web updb

# Check site status
docker exec drupal_web drush --root=/var/www/html/web status
```

### Access the MySQL Database

Option 1: Using phpMyAdmin (Web Interface)
- Visit **http://localhost:8081**
- Username: `drupal`
- Password: `drupal_password`

Option 2: Using MySQL CLI
```bash
docker exec -it drupal_db mysql -u drupal -pdrupal_password drupal
```

### View Container Logs

```bash
# View Drupal web server logs
docker logs drupal_web

# View MySQL logs
docker logs drupal_db

# Follow logs in real-time
docker logs -f drupal_web
```

### Access the Container Shell

```bash
docker exec -it drupal_web bash
```

## Troubleshooting

### Containers Won't Start

```bash
# Check logs
docker-compose logs

# Ensure no other services are using ports 80, 443, 3306, 8081
lsof -i :80
lsof -i :443
lsof -i :3306
lsof -i :8081
```

### Database Connection Fails

The database connection is automatically configured in `web/sites/default/settings.php`. If you need to modify it:

```php
$databases['default']['default'] = [
  'database' => 'drupal',
  'username' => 'drupal',
  'password' => 'drupal_password',
  'host' => 'mysql',
  'port' => '3306',
  'driver' => 'mysql',
  'prefix' => '',
  'collation' => 'utf8mb4_unicode_ci',
];
```

### Slow Performance

This is typically due to file synchronization on macOS. Consider:
1. Using named volumes for large directories
2. Enabling Docker's VirtioFS (macOS 13+)
3. Using Docker Buildkit

## Production Deployment

**This setup is for development only.** For production deployment:

1. Change all passwords in `docker-compose.yml`
2. Set `DRUPAL_HASH_SALT` to a secure random value
3. Enable HTTPS with proper certificates
4. Use a more robust database backup strategy
5. Implement proper logging and monitoring
6. Consider using Docker Swarm or Kubernetes for orchestration

## Useful Links

- [Drupal Documentation](https://www.drupal.org/docs)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [PHP Documentation](https://www.php.net/docs.php)
- [MySQL Documentation](https://dev.mysql.com/doc/)

## Support

For issues with Drupal, visit: https://www.drupal.org/docs
For Docker issues, visit: https://docs.docker.com/

## License

Drupal is licensed under the GNU General Public License v2 or later.
