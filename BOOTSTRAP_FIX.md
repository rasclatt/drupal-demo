# FIXED: Drupal Bootstrap Configuration

## Existing site bootstrap

The web front controller explicitly uses `web/` as Drupal's application root
and working directory. Core is symlinked from `vendor/drupal/core`, so Drupal
cannot infer the correct root from the physical location of its PHP classes.
Composer scaffolding is configured not to overwrite `web/index.php`; maintain
that file when updating Drupal. Do not run the installer on an existing site.

## Issue
The error `Missing: /opt/drupal/vendor/composer/../../web/core/includes/bootstrap.inc` occurred because:

1. **Path Mismatch**: The Drupal official Docker image uses `/opt/drupal` as its base, but docker-compose was mounting volumes to `/var/www/html`
2. **Missing web/core**: Drupal Core package wasn't installed in the right location
3. **Symlink Resolution**: The path resolver couldn't find the bootstrap.inc file

## Solution Applied

### 1. Corrected Volume Mounts (docker-compose.yml)
Changed from:
```yaml
volumes:
  - ./web:/var/www/html
  - ./vendor:/var/www/vendor
```

To:
```yaml
volumes:
  - ./web:/opt/drupal/web          # Mount to Drupal image base path
  - ./vendor:/opt/drupal/vendor
  - ./files:/opt/drupal/web/sites/default/files
```

### 2. Created web/core Symlink
Since Composer was installing Drupal Core to `vendor/drupal/core/` instead of creating a proper `web/core` directory, we created a symlink:

```bash
ln -s ../vendor/drupal/core web/core
```

This allows:
- Drupal to find the bootstrap.inc file at `/opt/drupal/web/core/includes/bootstrap.inc`
- Local development access via `./web/core/` for IDE navigation
- Proper path resolution throughout the application

### 3. Updated .gitignore
Added note that `web/core` is a symlink and shouldn't be committed:
```
/web/core                # Symlink to vendor/drupal/core (not version controlled)
```

## Result
✅ Drupal now correctly accesses `bootstrap.inc`
✅ Web installer is accessible at http://localhost
✅ Full codebase available locally at `./web/`
✅ All PHP dependencies managed via Composer in `./vendor/`

## File Locations (Post-Fix)
```
/opt/drupal/                          (in container)
├── web/                              → mounted from ./web/
│   ├── core/ → ../vendor/drupal/core (symlink)
│   ├── modules/custom/               (your code)
│   ├── themes/custom/                (your code)
│   └── sites/default/files/          → mounted from ./files/
└── vendor/                           → mounted from ./vendor/
```

## Why This Works
The symlink approach combines the best of both worlds:
- **Container**: Drupal core is in vendor/ (Composer managed) but accessible as `/opt/drupal/web/core`
- **Local Dev**: IDE can navigate `./web/core/` via symlink for code completion
- **Version Control**: Only custom code and configs are committed; core and vendor/ are excluded
