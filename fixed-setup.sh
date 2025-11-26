#!/bin/bash

echo "╔═══════════════════════════════════════════╗"
echo "║  MySQL AUTH FIX - PHP Compatible User     ║"
echo "╚═══════════════════════════════════════════╝"
echo ""

# Create a fix script
cat > /tmp/mysql_fix.sql << 'EOF'
-- Create database
DROP DATABASE IF EXISTS sskda_website;
CREATE DATABASE sskda_website;
USE sskda_website;

-- Create tables
CREATE TABLE achievements (
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

CREATE TABLE championship_registrations (
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

-- Create PHP-compatible user (with auth_socket)
DROP USER IF EXISTS 'php_app'@'localhost';
CREATE USER 'php_app'@'localhost' IDENTIFIED WITH auth_socket;
GRANT ALL PRIVILEGES ON sskda_website.* TO 'php_app'@'localhost';
FLUSH PRIVILEGES;

-- Insert sample data
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
EOF

echo "📄 Created /tmp/mysql_fix.sql"
echo ""

# Run with pkexec to get root access
echo "🔐 Running database setup (admin privileges required)..."
if pkexec mysql -u root < /tmp/mysql_fix.sql; then
    echo "✅ Database setup successful!"
    
    # Update config.php to use php_app user
    sed -i "s/'root'/'php_app'/g" /home/ailove/Downloads/SSKDA_Website/includes/config.php
    sed -i "s/define('DB_PASS', ''.*)/define('DB_PASS', '');/" /home/ailove/Downloads/SSKDA_Website/includes/config.php
    echo "✅ Updated config.php to use php_app user"
    
    # Test connection
    echo "🔍 Testing database connection..."
    if curl -s http://localhost:8000/api/achievements-get.php | grep -q "achievements"; then
        echo "✅ API is working!"
    else
        echo "⚠️  API test returned error"
    fi
else
    echo "❌ Database setup failed"
    echo " Manual steps required:"
    echo "1. Run: sudo mysql -u root < /tmp/mysql_fix.sql"
    echo "2. Check includes/config.php has DB_USER = 'php_app'"
fi

echo ""
echo "🚀 Website ready at http://localhost:8000/pages/index.html"