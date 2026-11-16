<?php
/**
 * Install Drupal via command line
 */

// Set up the environment
$_SERVER['HTTP_HOST'] = 'localhost';
$_SERVER['SCRIPT_NAME'] = '/index.php';
$_SERVER['PHP_SELF'] = '/index.php';
$_SERVER['REQUEST_METHOD'] = 'POST';

// Change to web root
chdir(__DIR__ . '/web');

// Load autoloader
require_once __DIR__ . '/web/autoload.php';

// Set installation mode
define('MAINTENANCE_MODE', 'install');

// Load the installer
require_once __DIR__ . '/web/core/includes/install.core.inc';

// Run installation with standard profile
$settings = [
  'parameters' => [
    'profile' => 'standard',
    'langcode' => 'en',
  ],
  'forms' => [
    'install_configure_form' => [
      'site_name' => 'My Drupal Site',
      'site_mail' => 'admin@example.com',
      'account' => [
        'name' => 'admin',
        'mail' => 'admin@example.com',
        'pass' => [
          'pass1' => 'admin123',
          'pass2' => 'admin123',
        ],
      ],
      'update_status_module' => [
        1 => TRUE,
        2 => TRUE,
      ],
      'clean_url' => TRUE,
    ],
  ],
];

$class_loader = require __DIR__ . '/web/autoload.php';
install_drupal($class_loader, $settings);

echo "Installation complete!\n";
