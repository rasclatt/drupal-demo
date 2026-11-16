#!/bin/bash

##############################################################################
# Drupal Docker Quick Start Script
# 
# This script sets up and starts the Drupal Docker environment
##############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Drupal Docker Environment Setup${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}✗ Docker is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker found${NC}"

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}✗ Docker Compose is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker Compose found${NC}"

# Check if Docker daemon is running
if ! docker info &> /dev/null; then
    echo -e "${RED}✗ Docker daemon is not running${NC}"
    echo "Please start Docker and try again"
    exit 1
fi
echo -e "${GREEN}✓ Docker daemon is running${NC}"
echo ""

# Change to script directory
cd "$SCRIPT_DIR"

# Check required files
echo "Checking required files..."
required_files=("docker-compose.yml" "Dockerfile" "composer.json")
for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}✗ Missing required file: $file${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Found $file${NC}"
done
echo ""

# Start containers
echo "Starting Docker containers..."
echo "This may take 30-60 seconds..."
echo ""

docker-compose up -d

# Wait for containers to be healthy
echo ""
echo "Waiting for containers to be healthy..."
max_attempts=30
attempt=0

while [ $attempt -lt $max_attempts ]; do
    if docker-compose exec -T drupal curl -f http://localhost &> /dev/null; then
        echo -e "${GREEN}✓ All containers are healthy${NC}"
        break
    fi
    echo -n "."
    sleep 1
    attempt=$((attempt + 1))
done

if [ $attempt -eq $max_attempts ]; then
    echo -e "${YELLOW}! Containers may still be starting...${NC}"
fi
echo ""

# Display status
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

echo "Container Status:"
docker-compose ps
echo ""

echo "Next Steps:"
echo "1. Open your browser to: ${YELLOW}http://localhost/core/install.php${NC}"
echo "2. Follow the Drupal installer to complete setup"
echo "3. After installation, access your site at: ${YELLOW}http://localhost${NC}"
echo ""

echo "Useful URLs:"
echo "  - Drupal Installer: ${YELLOW}http://localhost/core/install.php${NC}"
echo "  - phpMyAdmin:       ${YELLOW}http://localhost:8081${NC}"
echo ""

echo "Useful Commands:"
echo "  - View logs:        ${YELLOW}docker-compose logs -f drupal_web${NC}"
echo "  - Access container: ${YELLOW}docker exec -it drupal_web bash${NC}"
echo "  - Stop containers:  ${YELLOW}docker-compose down${NC}"
echo "  - Run Drush:        ${YELLOW}docker exec drupal_web drush --root=/var/www/html/web [command]${NC}"
echo ""

echo "For more information, see INSTALL_GUIDE.md"
echo ""
