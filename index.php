<?php
/**
 * SSKDA Website Router
 * This script routes clean URLs (like /register.html) to the actual files in 'pages/'
 */

// 1. SILENT PERMISSION FIX (Just in case)
@chmod(__DIR__, 0755);
@chmod(__DIR__ . '/pages', 0755);

// 2. GET THE REQUESTED PATH
$request = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

// 3. DEFINE THE ROUTE MAP
// This tells the server: "If they ask for X, give them the file in pages/Y"
$routes = [
    '/'                             => 'pages/index.html',
    '/index.php'                    => 'pages/index.html',
    '/index.html'                   => 'pages/index.html',
    '/register.html'                => 'pages/register.html',
    '/member-dashboard.html'        => 'pages/member-dashboard.html',
    '/member-achievements.html'     => 'pages/member-achievements.html',
    '/add-achievement.html'         => 'pages/add-achievement.html',
    '/add-news-article.html'        => 'pages/add-news-article.html',
    '/championship-registration.html'=> 'pages/championship-registration.html'
];

// 4. CHECK IF IT IS A KNOWN PAGE
if (isset($routes[$request])) {
    $file = $routes[$request];
    
    if (file_exists($file)) {
        // Serve the HTML file
        header('Content-Type: text/html');
        readfile($file);
        exit;
    } else {
        // If the file is mapped but missing from the folder
        http_response_code(404);
        echo "<h1>Error 404</h1><p>The file '$file' is missing from the 'pages' folder.</p>";
        exit;
    }
}

// 5. HANDLE ASSETS (Images, CSS, JS, API)
// If the browser asks for /image_assets/logo.png, we look for it directly.
// We remove the leading slash to find the file relative to htdocs.
$relativePath = ltrim($request, '/');

if (file_exists($relativePath) && !is_dir($relativePath)) {
    // Determine content type automatically
    $ext = pathinfo($relativePath, PATHINFO_EXTENSION);
    switch ($ext) {
        case 'css': header('Content-Type: text/css'); break;
        case 'js':  header('Content-Type: application/javascript'); break;
        case 'png': header('Content-Type: image/png'); break;
        case 'jpg': 
        case 'jpeg': header('Content-Type: image/jpeg'); break;
        case 'gif': header('Content-Type: image/gif'); break;
        case 'svg': header('Content-Type: image/svg+xml'); break;
        case 'json': header('Content-Type: application/json'); break;
        case 'php': 
            // If it's an API file (like api/login.php), include it so it runs
            include($relativePath); 
            exit;
    }
    
    // Serve the file
    readfile($relativePath);
    exit;
}

// 6. FINAL FALLBACK (404)
// If it's not in our map, and it's not a real file, it's a 404.
http_response_code(404);
echo "<h1>404 Not Found</h1>";
echo "<p>The page you requested ($request) could not be found.</p>";
?>