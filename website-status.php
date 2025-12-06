<?php
/**
 * Website Status Check
 */

header('Content-Type: text/html; charset=utf-8');

// Check PHP config
echo "<h2>🔧 SSKDA Website Status Check</h2>";
echo "<pre>";

// Check includes folder
if (file_exists(__DIR__ . '/includes/config.php')) {
    echo "✅ Config file found\n";
    include __DIR__ . '/includes/config.php';
    
    echo "DB Configuration:\n";
    echo "  Host: " . DB_HOST . "\n";
    echo "  User: " . DB_USER . "\n";
    echo "  Password: " . (empty(DB_PASS) ? "EMPTY" : "SET") . "\n";
    echo "  Database: " . DB_NAME . "\n\n";
} else {
    echo "❌ Config file NOT found\n";
}

// Test database connection
echo "Database Connection Test:\n";
$conn = @mysqli_connect(DB_HOST, DB_USER, DB_PASS, DB_NAME);

if (!$conn) {
    echo "❌ FAILED: " . mysqli_connect_error() . "\n";
    echo "\n🛠️  To fix:\n";
    echo "   Run: sudo mysql -u root\n";
    echo "   Then execute:\n";
    echo "   CREATE USER '" . DB_USER . "'@'localhost' IDENTIFIED WITH auth_socket;\n";
    echo "   GRANT ALL ON " . DB_NAME . ".* TO '" . DB_USER . "'@'localhost';\n";
    echo "   FLUSH PRIVILEGES;\n";
} else {
    echo "✅ SUCCESS - Connected to database\n";
    
    // Check achievements table
    $result = mysqli_query($conn, "SHOW TABLES LIKE 'achievements'");
    if (mysqli_num_rows($result) > 0) {
        echo "✅ Achievements table exists\n";
        
        $count_result = mysqli_query($conn, "SELECT COUNT(*) as count FROM achievements");
        $row = mysqli_fetch_assoc($count_result);
        echo "✅ Achievements loaded: " . $row['count'] . " records\n";
    } else {
        echo "❌ Achievements table NOT found\n";
        echo "Run: sudo mysql -u root < database/import.sql\n";
    }
    
    mysqli_close($conn);
}

echo "\n📍 Website URLs:\n";
echo "   Home: http://localhost:8000/pages/index.html\n";
echo "   Status: http://localhost:8000/website-status.php (this page)\n";
echo "   API: http://localhost:8000/api/achievements.php\n";

echo "</pre>";
?>