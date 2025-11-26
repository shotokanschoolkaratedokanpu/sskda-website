<?php
/**
 * Main entry point - serves HTML pages
 * For InfinityFree hosting
 */

// Get requested path
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

// Serve static files directly
$staticFiles = [
    '/' => 'index.html',
    '/index.html' => 'index.html',
    '/register.html' => 'register.html',
    '/member-dashboard.html' => 'member-dashboard.html',
    '/member-achievements.html' => 'member-achievements.html',
    '/add-achievement.html' => 'add-achievement.html',
    '/add-news-article.html' => 'add-news-article.html',
    '/championship-registration.html' => 'championship-registration.html'
];

if (isset($staticFiles[$path])) {
    $file = $staticFiles[$path];
    if (file_exists($file)) {
        // Determine content type
        $ext = pathinfo($file, PATHINFO_EXTENSION);
        switch ($ext) {
            case 'html':
                header('Content-Type: text/html');
                break;
            case 'css':
                header('Content-Type: text/css');
                break;
            case 'js':
                header('Content-Type: application/javascript');
                break;
        }
        readfile($file);
        exit;
    }
}

// If file exists, serve it
if (file_exists('.' . $path)) {
    $ext = pathinfo('.' . $path, PATHINFO_EXTENSION);
    switch ($ext) {
        case 'png':
            header('Content-Type: image/png');
            break;
        case 'jpg':
        case 'jpeg':
            header('Content-Type: image/jpeg');
            break;
    }
    readfile('.' . $path);
    exit;
}

// Default to index.html
if (file_exists('index.html')) {
    header('Content-Type: text/html');
    readfile('index.html');
} else {
    http_response_code(404);
    echo "Page not found";
}
