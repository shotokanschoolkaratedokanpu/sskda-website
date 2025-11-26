#!/bin/bash

echo "╔═══════════════════════════════════════════╗"
echo "║  SSKDA WEBSITE - FINAL SETUP              ║"
echo "╚═══════════════════════════════════════════╝"
echo ""

# Run the database setup via pkexec
pkexec sh -c '
mysql -u root << "EOF"
CREATE DATABASE IF NOT EXISTS sskda_website;
USE sskda_website;

CREATE TABLE IF NOT EXISTS achievements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    athlete VARCHAR(255) NOT NULL,
    competition VARCHAR(255) NOT NULL,
    category VARCHAR(255) NOT NULL,
    achievement VARCHAR(255) NOT NULL,
    year YEAR NOT NULL,
    type ENUM("kata", "kumite", "team", "individual") NOT NULL,
    medal ENUM("gold", "silver", "bronze", "") DEFAULT "",
    associationId VARCHAR(10) NOT NULL,
    image VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO achievements (id, athlete, competition, category, achievement, year, type, medal, associationId, image) VALUES
("Kai Johnson", "World Karate Championship", "Kata - Senior", "Gold Medal", "2024", "kata", "gold", "KA001", "/image_assets/kai.jpg"),
("Maya Chen", "National Tournament", "Kumite -67kg", "Silver Medal", "2024", "kumite", "silver", "KA001", "/image_assets/maya.jpg"),
("Team Kata", "Regional Championships", "Team Kata", "Bronze Medal", "2024", "team", "bronze", "KA001", "/image_assets/team.jpg");

SELECT COUNT(*) as total_achievements FROM achievements;
EOF
' 2>/dev/null

echo ""
echo "╔═══════════════════════════════════════════╗"
echo "║  ✅ Setup complete!                       ║"
echo "║  🚀 Starting server at localhost:8000     ║"
echo "╚═══════════════════════════════════════════╝"
echo ""
echo "Visit: http://localhost:8000/pages/index.html"
echo "Press Ctrl+C to stop"
echo ""

php -S localhost:8000 -t /home/ailove/Downloads/SSKDA_Website