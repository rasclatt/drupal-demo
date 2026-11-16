FROM drupal:10.1.8-php8.2-apache

# Install additional PHP extensions and tools
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Drush globally
RUN curl -fsSL "https://github.com/drush-ops/drush-launcher/releases/latest/download/drush.phar" -o /usr/local/bin/drush && chmod +x /usr/local/bin/drush

# Enable Apache modules
RUN a2enmod rewrite

# Create PHP error reporting configuration from environment
# (will be set at runtime via docker-compose env_file)
RUN echo 'error_reporting = ${PHP_ERROR_REPORTING:-E_ALL}' > /usr/local/etc/php/conf.d/error-reporting.ini
RUN printf '%s\n' \
    'display_errors = On' \
    'display_startup_errors = On' \
    'log_errors = On' \
    'error_log = /proc/self/fd/2' \
    'error_reporting = E_ALL' \
    > /usr/local/etc/php/conf.d/drupal-debug.ini
RUN echo "memory_limit = 512M" > /usr/local/etc/php/conf.d/memory-limit.ini

WORKDIR /opt/drupal

# Create a startup script that sets up the container after volumes mount
RUN echo '#!/bin/bash\n\
# Apply PHP error reporting from environment variable\n\
if [ ! -z "$PHP_ERROR_REPORTING" ]; then\n\
  echo "error_reporting = $PHP_ERROR_REPORTING" > /usr/local/etc/php/conf.d/error-reporting.ini\n\
fi\n\
\n\
# Remove base image drupal and symlink our web directory\n\
rm -rf /var/www/html\n\
ln -s /opt/drupal/web /var/www/html\n\
\n\
# Ensure web directory exists\n\
mkdir -p /opt/drupal/web\n\
\n\
# Create symlink from web/core to vendor/drupal/core\n\
rm -rf /opt/drupal/web/core\n\
ln -s ../vendor/drupal/core /opt/drupal/web/core\n\
\n\
# Fix web/autoload.php to use absolute path (symlink workaround for chdir() in install.php)\n\
sed -i '"'"'s#return require __DIR__ . '"'"'"'"'"'"'"'"'/../vendor/autoload.php'"'"'"'"'"'"'"'"';#return require '"'"'"'"'"'"'"'"'/opt/drupal/vendor/autoload.php'"'"'"'"'"'"'"'"';#'"'"' /opt/drupal/web/autoload.php 2>/dev/null || true\n\
\n\
# Fix vendor/drupal/autoload.php wrapper to return the ClassLoader object\n\
cat > /opt/drupal/vendor/drupal/autoload.php << '"'"'EOFAUTOLOAD'"'"'\n\
<?php\n\
return require_once __DIR__ . "/../autoload.php";\n\
EOFAUTOLOAD\n\
\n\
# Set proper permissions\n\
chown -R www-data:www-data /opt/drupal/web/sites/default 2>/dev/null || true\n\
chown -R www-data:www-data /opt/drupal/web/files 2>/dev/null || true\n\
\n\
exec "$@"' > /docker-entrypoint-custom.sh && chmod +x /docker-entrypoint-custom.sh

EXPOSE 80 443

# Override the default entrypoint
ENTRYPOINT ["/docker-entrypoint-custom.sh"]
CMD ["apache2-foreground"]


