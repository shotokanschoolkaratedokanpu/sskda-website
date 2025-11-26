<?php
/**
 * Database Configuration for Local Development
 */

define('DB_HOST', 'localhost');
define('DB_NAME', 'sskda_website');
define('DB_USER', 'ailove');
define('DB_PASS', '');
define('DB_CHARSET', 'utf8mb4');

define('SITE_URL', 'http://localhost:8000');

define('UPLOAD_DIR', __DIR__ . '/../uploads/');
define('UPLOAD_URL', SITE_URL . '/uploads/');
define('IMAGE_ASSETS_URL', SITE_URL . '/image_assets/');