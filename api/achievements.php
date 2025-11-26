<?php
/**
 * Unified endpoint for /api/achievements
 * Routes GET and POST requests
 */

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    require_once 'achievements-get.php';
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    require_once 'achievements-post.php';
} else {
    http_response_code(405);
    header('Content-Type: application/json');
    echo json_encode(['error' => 'Method not allowed']);
}
