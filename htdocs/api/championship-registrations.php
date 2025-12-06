<?php
/**
 * Unified endpoint for /api/championship-registrations
 * Routes GET and POST requests
 */

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    require_once 'registrations-get.php';
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    require_once 'registrations-post.php';
} else {
    http_response_code(405);
    header('Content-Type: application/json');
    echo json_encode(['error' => 'Method not allowed']);
}
