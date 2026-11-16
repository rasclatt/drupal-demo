#!/bin/bash
set -e

echo "=== Drupal Development Setup ==="
echo

cd "$(dirname "$0")"

# Check if web/core exists
if [ ! -d "web/core" ]; then
    echo "Installing Drupal via Composer..."
    # Install composer dependencies locally first
    if command -v composer &> /dev/null; then
        echo "Using local Composer..."
        composer install --ignore-platform-reqs
    else
        echo "Using Docker Composer..."
        docker run --rm -v "$(pwd)":/app composer install --working-dir=/app --ignore-platform-reqs
    fi
    echo "✓ Composer dependencies installed"
else
    echo "web/core already exists, skipping composer install"
fi

echo
echo "Starting Docker containers..."
docker-compose up -d

echo "Waiting for services to be healthy..."
sleep 15

echo
echo "Running Drupal installation..."
docker-compose exec -T drupal drush site:install standard \
    --db-url=mysql://drupal:drupal_password@mysql:3306/drupal \
    --site-name="My Drupal Site" \
    --account-name=admin \
    --account-pass=admin \
    --yes || echo "Note: Site may already be installed"

echo
echo "=== Setup Complete ==="
echo
echo "Access your Drupal site at: http://localhost"
echo "Admin login: admin / admin"
echo "Database: http://localhost:8081"
echo
echo "Your project structure:"
echo "  web/              - Drupal root (core, modules, themes)"
echo "  files/            - Public files"
echo "  composer.json     - Dependency management"
echo "  Dockerfile        - Container configuration"
echo
