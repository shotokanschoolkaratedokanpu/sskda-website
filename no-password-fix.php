<?php
/**
 * Test database connection
 */
require_once __DIR__ . '/includes/config.php';

echo "Testing connection...\n";
echo "DB_HOST: " . DB_HOST . "\n";
echo "DB_USER: " . DB_USER . "\n";
echo "DB_PASS: [" . (empty(DB_PASS) ? "empty" : "set") . "]\n";

$conn = @mysqli_connect(DB_HOST, DB_USER, DB_PASS, DB_NAME);

if (!$conn) {
    echo "Connection failed: " . mysqli_connect_error() . "\n";
    exit(1);
}

echo "✅ Connected successfully!\n";
$result = mysqli_query($conn, "SELECT COUNT(*) as count FROM achievements");
$row = mysqli_fetch_assoc($result);
echo "Achievements count: " . $row['count'] . "\n";
mysqli_close($conn);
?>