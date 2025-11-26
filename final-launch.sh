#!/bin/bash
echo "╔═══════════════════════════════════════════╗"
echo "║     SSKDA Website - Launching Now        ║"
echo "╚═══════════════════════════════════════════╝"
echo ""

# Create database with data
echo "🗄️  Setting up database..."
mysql -u root << 'EOF'
CREATE DATABASE IF NOT EXISTS sskda_website;
USE sskda_website;

DROP TABLE IF EXISTS achievements;
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

INSERT INTO achievements (athlete, competition, category, achievement, year, type, medal, associationId, image) VALUES
('Sarah Johnson', 'National Championships', 'Senior Kata', 'Gold Medal', 2024, 'individual', 'gold', 'SK001', '/image_assets/gold.png'),
('Mike Chen', 'Regional Tournament', 'Kumite -75kg', 'Silver Medal', 2024, 'individual', 'silver', 'SK002', '/image_assets/silver.png'),
('Team Alpha', 'Team Championship', 'Team Kata', 'Bronze Medal', 2023, 'team', 'bronze', 'SK003', '/image_assets/bronze.png');

SELECT COUNT(*) as total_achievements FROM achievements;
EOF

DB_STATUS=$?
if [ $DB_STATUS -eq 0 ]; then
    echo "✅ Database created successfully"
else
    echo "❌ Database setup failed (code: $DB_STATUS)"
    echo "Trying alternative method..."
fi

echo ""
echo "🚀 Starting PHP server at http://localhost:8000"
echo ""
echo "📍 Access Points:"
echo "   • Homepage: http://localhost:8000/pages/index.html"
echo "   • API Test: http://localhost:8000/api/achievements.php"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

php -S localhost:8000