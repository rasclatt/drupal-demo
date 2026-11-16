<?php

/**
 * @file
 * The PHP page that serves all page requests on a Drupal installation.
 *
 * All Drupal code is released under the GNU General Public License.
 * See COPYRIGHT.txt and LICENSE.txt files in the "core" directory.
 */

use Drupal\Core\DrupalKernel;
use Symfony\Component\HttpFoundation\Request;

// Core is symlinked into the web root, so its physical location is not the site root.
if (!chdir(__DIR__)) {
  throw new RuntimeException('Unable to change to the Drupal web root.');
}

$autoloader = require_once 'autoload.php';

$kernel = new DrupalKernel('prod', $autoloader, TRUE, __DIR__);
DrupalKernel::bootEnvironment(__DIR__);

$request = Request::createFromGlobals();
$response = $kernel->handle($request);
$response->send();

$kernel->terminate($request, $response);
