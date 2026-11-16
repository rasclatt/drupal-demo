# ✅ Drupal 10 Development Environment - FULLY OPERATIONAL

## Current Status: 🟢 READY FOR DEVELOPMENT

Your complete Drupal 10 development environment is now fully functional and ready to use.

## What's Running

- **Drupal 10 (Apache)** → http://localhost
- **MySQL 8.0 Database** → mysql:3306  
- **phpMyAdmin** → http://localhost:8081

## Directory Structure

```
/Users/developer/Documents/Clients/Drupal/
├── web/                          Full Drupal codebase (version controlled)
│   ├── core → ../vendor/drupal/core (symlink to Drupal core)
│   ├── modules/
│   │   ├── contrib/              Contributed modules
│   │   └── custom/               Your custom modules
│   ├── themes/
│   │   ├── contrib/              Contributed themes
│   │   └── custom/               Your custom themes
│   ├── sites/default/
│   │   ├── settings.php          Database config (created during install)
│   │   ├── services.yml          Service config
│   │   └── files/                Public uploads
│   └── [all core Drupal files]
├── vendor/                       PHP dependencies (Composer managed)
│   ├── drupal/
│   │   ├── core/                 Drupal core package
│   │   ├── autoload.php          ⚠️ Wrapper (compatibility fix)
│   │   └── [contrib packages]
│   ├── symfony/                  Symfony framework
│   ├── autoload.php              Main autoloader
│   └── [all dependencies]
├── composer.json                 Dependency manifest
├── composer.lock                 Locked versions
├── docker-compose.yml            Docker services
├── Dockerfile                    Container config
├── .gitignore                    Git ignore rules
├── README.md                     Full documentation
├── QUICKSTART.md                 Quick reference
└── BOOTSTRAP_FIX.md             Technical details of the fix
```

## What Was Fixed

### Issue 1: Bootstrap Path (/opt/drupal/vendor/composer/../../web/core/includes/bootstrap.inc)
**Problem**: Volume mounts were to the wrong container path  
**Solution**: Updated docker-compose.yml to mount to `/opt/drupal` (the Drupal image base)

### Issue 2: Missing web/core
**Problem**: Drupal core wasn't installed to the correct location  
**Solution**: Created symlink: `web/core → ../vendor/drupal/core`

### Issue 3: Missing autoload.php
**Problem**: install.php expected autoload.php at `/opt/drupal/vendor/drupal/autoload.php`  
**Solution**: Created wrapper autoload.php that requires the real autoloader

## Next Steps: Complete Installation

### Option 1: Web Installer (Recommended)
1. Visit **http://localhost**
2. Follow the Drupal installation wizard
3. When prompted for database settings:
   - Database: `drupal`
   - Username: `drupal`
   - Password: `drupal_password`
   - Host: `mysql`

### Option 2: Command Line (Drush)
```bash
docker-compose exec drupal drush site:install standard \
  --db-url=mysql://drupal:drupal_password@mysql:3306/drupal \
  --site-name="My Drupal Site" \
  --account-name=admin \
  --account-pass=admin
```

## Quick Reference

### Start/Stop
```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f drupal
```

### Development
```bash
# Access Drupal container shell
docker-compose exec drupal bash

# Clear caches
docker-compose exec drupal /opt/drupal/vendor/bin/drush cache:rebuild

# Install contrib module
docker-compose exec drupal composer require drupal/views_bulk_operations

# View Drupal status
docker-compose exec drupal /opt/drupal/vendor/bin/drush status
```

### Database
```bash
# Export database
docker-compose exec drupal /opt/drupal/vendor/bin/drush sql:dump > backup.sql

# Import database  
docker-compose exec drupal /opt/drupal/vendor/bin/drush sql:cli < backup.sql

# Or use phpMyAdmin: http://localhost:8081
```

## Key Files in This Project

| File | Purpose |
|------|---------|
| `docker-compose.yml` | Defines Drupal, MySQL, phpMyAdmin services |
| `Dockerfile` | Extends Drupal image with Composer, Git, Drush |
| `composer.json` | Defines Drupal 10 and all PHP dependencies |
| `composer.lock` | Locks dependency versions for reproducibility |
| `web/` | Your complete Drupal installation (version controlled) |
| `vendor/` | Composer-managed PHP dependencies (NOT version controlled) |
| `vendor/drupal/autoload.php` | ⚠️ Compatibility wrapper for install.php |
| `.gitignore` | Excludes vendor/, core/, contrib modules/themes from git |

## Version Control

**DO commit to git:**
```
web/modules/custom/
web/themes/custom/
composer.json
composer.lock
Documentation (*.md)
.gitignore
```

**DO NOT commit:**
```
web/core/
web/modules/contrib/
web/themes/contrib/
vendor/
web/sites/default/settings.php (environment-specific)
web/sites/default/files/ (user uploads)
```

## Credentials

| Service | User | Password | Host |
|---------|------|----------|------|
| MySQL | drupal | drupal_password | mysql:3306 |
| MySQL Root | root | root_password | mysql:3306 |
| phpMyAdmin | drupal | drupal_password | localhost:8081 |

## Troubleshooting

**Port already in use?**
Edit `docker-compose.yml` and change ports:
```yaml
ports:
  - "8080:80"  # Change 80 to 8080
  - "8081:8081"
```

**Permission denied errors?**
```bash
docker-compose exec drupal chown -R www-data:www-data /opt/drupal/web
```

**Database won't connect?**
Wait 15 seconds for MySQL to initialize, then:
```bash
docker-compose logs mysql
```

**Fresh start?**
```bash
docker-compose down -v
rm -rf web/ vendor/ files/
composer install
docker-compose up -d
```

## Documentation

- `README.md` - Comprehensive guide and reference
- `QUICKSTART.md` - Quick start commands and workflows
- `BOOTSTRAP_FIX.md` - Technical details of how autoload issues were resolved

---

**Ready to start developing Drupal!** 🚀

For questions, see the documentation files or check the Drupal 10 official documentation.
