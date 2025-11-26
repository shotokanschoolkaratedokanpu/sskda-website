#!/bin/bash

echo "╔══════════════════════════════════════════════════════╗"
echo "║       SSKDA WEBSITE - COMPLETE LAUNCH SCRIPT         ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

# Kill any existing PHP server
pkill -f "php -S" 2>/dev/null
sleep 1

echo "🗄️  Step 1: Initializing database..."
echo "    (This requires admin privileges)"

# Create database setup file
cat > /tmp/db-setup.sql << 'DBEOF'
DROP DATABASE IF EXISTS sskda_website;
CREATE DATABASE sskda_website;
USE sskda_website;

CREATE TABLE IF NOT EXISTS achievements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    athlete VARCHAR(255) NOT NULL,
    competition VARCHAR(255) NOT NULL,
    category VARCHAR(255) NOT NULL,
    achievement VARCHAR(255) NOT NULL,
    year YEAR NOT NULL,
    type ENUM('kata', 'kumite', 'team', 'individual') NOT NULL,
    medal ENUM('gold', 'silver', 'bronze', '') DEFAULT '',
    associationId VARCHAR(10) NOT NULL,
    image VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS championship_registrations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    dob DATE NOT NULL,
    gender ENUM('male', 'female') NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    associationId VARCHAR(10) NOT NULL,
    belt VARCHAR(50),
    category VARCHAR(100),
    ageGroup VARCHAR(50),
    emergencyName VARCHAR(200),
    emergencyPhone VARCHAR(20),
    registrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    registrationId VARCHAR(100) UNIQUE NOT NULL
);

INSERT INTO achievements (athlete, competition, category, achievement, year, type, medal, associationId) VALUES
('M. N. P. Perera', 'All Island Karate Championship', 'Under 21 Male Individual Kata', 'Gold Medal', 2024, 'individual', 'gold', 'SK-0001'),
('K. L. M. Ruwan Kumara', 'All Island Karate Championship', 'Under 21 Male Individual Kata', 'Silver Medal', 2024, 'individual', 'silver', 'SK-0002'),
('K. S. D. Lahiru Prasanna', 'All Island Karate Championship', 'Under 21 Male Individual Kata', 'Bronze Medal', 2024, 'individual', 'bronze', 'SK-0003'),
('W. A. T. Perera', 'All Island Karate Championship', 'Under 21 Male Individual Kumite -75kg', 'Gold Medal', 2024, 'individual', 'gold', 'SK-0004'),
('M. N. P. Perera', 'All Island Karate Championship', 'Under 21 Male Individual Kumite -75kg', 'Silver Medal', 2024, 'individual', 'silver', 'SK-0001'),
('K. P. N. Silva', 'All Island Karate Championship', 'Under 21 Male Individual Kumite -75kg', 'Bronze Medal', 2024, 'individual', 'bronze', 'SK-0005'),
('B. M. D. Lakmali Fernando', 'All Island Karate Championship', 'Under 21 Female Individual Kata', 'Gold Medal', 2024, 'individual', 'gold', 'SK-0006'),
('H. G. Sumithra Peries', 'All Island Karate Championship', 'Under 21 Female Individual Kata', 'Silver Medal', 2024, 'individual', 'silver', 'SK-0007'),
('S. M. N. Kumari Wickrama', 'All Island Karate Championship', 'Under 21 Female Individual Kata', 'Bronze Medal', 2024, 'individual', 'bronze', 'SK-0008');

SELECT COUNT(*) as total_achievements FROM achievements;
DBEOF

# Try to run the database setup
pkexec sh -c "mysql -u root < /tmp/db-setup.sql" 2>&1 | tee /tmp/db-setup.log

if [ ${PIPESTATUS[0]} -eq 0 ]; then
    echo "✅ Database initialized successfully!
"
else
    echo "⚠️  Database setup may need manual intervention"
    echo "   Check /tmp/db-setup.log for details"
    echo ""
    echo "To setup manually, run:"
    echo "   sudo mysql -u root < /tmp/db-setup.sql"
    echo ""
fi

# Update config.php to use root (no password)
echo "⚙️  Updating configuration..."
cat > /home/ailove/Downloads/SSKDA_Website/includes/config.php << 'CFOF'
<?php
/**
 * Database Configuration for Local Development
 */

define('DB_HOST', 'localhost');
define('DB_NAME', 'sskda_website');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_CHARSET', 'utf8mb4');

define('SITE_URL', 'http://localhost:8000');

define('UPLOAD_DIR', __DIR__ . '/../uploads/');
define('UPLOAD_URL', SITE_URL . '/uploads/');
define('IMAGE_ASSETS_URL', SITE_URL . '/image_assets/');
CFOF

echo "✅ Configuration updated"

# Final verification
echo ""
echo "🔍 Verifying database..."
curl -s http://localhost:8000/api/achievements-get.php | grep -q "achievements" && echo "✅ API working!" || echo "⚠️  API returned error"

# Start server
echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║  🎉 PROJECT IS READY!                                ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "🌐 Website: http://localhost:8000/pages/index.html"
echo "📊 API:     http://localhost:8000/api/achievements.php"
echo "👤 Proxy:   http://localhost:8000/api/achievements-get.php"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

php -S localhost:8000 -t /home/ailove/Downloads/SSKDA_Website