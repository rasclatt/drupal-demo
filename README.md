# Drupal Development Setup

A complete, best-practices Drupal 10 development environment using Docker Compose.

## Project Structure

```
.
├── web/                          # Drupal root (version controlled)
│   ├── core/                     # Drupal core (managed by Composer)
│   ├── modules/
│   │   ├── contrib/              # Contributed modules (managed by Composer)
│   │   └── custom/               # Your custom modules
│   ├── themes/
│   │   ├── contrib/              # Contributed themes (managed by Composer)
│   │   └── custom/               # Your custom themes
│   ├── profiles/                 # Installation profiles
│   └── index.php
├── files/                         # Public files (not version controlled)
├── vendor/                        # PHP dependencies (managed by Composer)
├── composer.json                  # Drupal dependencies
├── composer.lock                  # Locked dependency versions
├── Dockerfile                     # Container configuration
├── docker-compose.yml             # Docker services
├── .gitignore                     # Git ignore rules
├── .env.example                   # Environment template
└── setup.sh                       # Initial setup script
```

## Quick Start

### First Time Setup

```bash
chmod +x setup.sh
./setup.sh
```

This will:
1. Install Drupal via Composer
2. Start Docker containers
3. Run Drupal installation
4. Set up default admin user

### Manual Steps (if needed)

```bash
# Install dependencies
docker-compose run --rm drupal composer install

# Start containers
docker-compose up -d

# Install Drupal
docker-compose exec drupal drush site:install standard \
  --db-url=mysql://drupal:drupal_password@mysql:3306/drupal \
  --site-name="My Drupal Site" \
  --account-name=admin \
  --account-pass=admin
```

## Access

- **Drupal:** http://localhost
- **phpMyAdmin:** http://localhost:8081
  - User: `drupal`
  - Password: `drupal_password`

## Default Credentials

- **Admin Username:** `admin`
- **Admin Password:** `admin`
- **Database:** `drupal`
- **DB User:** `drupal`
- **DB Password:** `drupal_password`

## Common Commands

### Drupal / Drush

```bash
# Run Drush commands
docker-compose exec drupal drush status
docker-compose exec drupal drush cache:rebuild
docker-compose exec drupal drush config:export
docker-compose exec drupal drush config:import

# Access Drupal shell
docker-compose exec drupal bash
```

### Composer

```bash
# Add a contributed module
docker-compose exec drupal composer require drupal/metatag

# Update dependencies
docker-compose exec drupal composer update

# Install from composer.lock
docker-compose exec drupal composer install
```

### Docker

```bash
# Start containers
docker-compose up -d

# Stop containers
docker-compose down

# View logs
docker-compose logs -f drupal

# Rebuild container
docker-compose up -d --build
```

## Development Workflow

1. **Create custom modules:** Create folders in `web/modules/custom/`
2. **Create custom themes:** Create folders in `web/themes/custom/`
3. **Add contributed packages:** Use `docker-compose exec drupal composer require drupal/package_name`
4. **Version control:** Commit `web/`, `composer.json`, `composer.lock`, config files, but NOT `vendor/` or `web/core/`

## Database Management

- Access database via phpMyAdmin: http://localhost:8081
- Export/Import via Drush:
  ```bash
  docker-compose exec drupal drush sql:dump > backup.sql
  docker-compose exec drupal drush sql:cli < backup.sql
  ```

## Production Deployment

- Use `composer.lock` to ensure identical versions
- Don't commit `vendor/` directory
- Commit only:
  - `web/modules/custom/`
  - `web/themes/custom/`
  - `composer.json` and `composer.lock`
  - Configuration files
- Run `composer install --no-dev` on production

## Troubleshooting

### "Connection refused" to MySQL
Wait 10-15 seconds for MySQL to fully start, then try again.

### File permissions issues
```bash
docker-compose exec drupal chown -R www-data:www-data /var/www/html
```

### Clear all caches
```bash
docker-compose exec drupal drush cache:rebuild
```

### Reset to fresh install
```bash
docker-compose down -v
rm -rf web/ vendor/ files/
./setup.sh
```
