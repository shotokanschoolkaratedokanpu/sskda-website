#!/bin/bash
echo "Setting up database with direct SQL injection..."

# Create a temp file with everything
 cat > /tmp/full-setup.sql <<'EOF'
DROP DATABASE IF EXISTS sskda_website;
CREATE DATABASE sskda_website;
USE sskda_website;

-- SQL Database Setup for InfinityFree
-- Execute these commands in phpMyAdmin on InfinityFree

-- Step 1: Create Database Tables
-- (Paste this into the SQL tab in phpMyAdmin)

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
    weight VARCHAR(50),
    ageCategory VARCHAR(50) NOT NULL,
    weightCategory VARCHAR(100) NOT NULL,
    kata BOOLEAN DEFAULT FALSE,
    kumite BOOLEAN DEFAULT FALSE,
    team BOOLEAN DEFAULT FALSE,
    teamName VARCHAR(255),
    teamMembers TEXT,
    emergencyContact VARCHAR(100),
    emergencyPhone VARCHAR(20),
    medicalInfo TEXT,
    terms BOOLEAN NOT NULL,
    registrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 2: Insert Sample Data

-- Individual Achievements (11 records)
INSERT INTO achievements (athlete, competition, category, achievement, year, type, medal, associationId, image) VALUES
-- 2024 Achievements
('M. N. P. Perera', 'All Island Karate Championship', 'Under 21 Male Individual Kata', 'Gold Medal', 2024, 'individual', 'gold', 'SK-0001', '/image_assets/gold-medal-icon.png'),
('K. L. M. Ruwan Kumara', 'All Island Karate Championship', 'Under 21 Male Individual Kata', 'Silver Medal', 2024, 'individual', 'silver', 'SK-0002', '/image_assets/silver-medal-icon.png'),
('K. S. D. Lahiru Prasanna', 'All Island Karate Championship', 'Under 21 Male Individual Kata', 'Bronze Medal', 2024, 'individual', 'bronze', 'SK-0003', '/image_assets/bronze-medal-icon.png'),

('W. A. T. Perera', 'All Island Karate Championship', 'Under 21 Male Individual Kumite -75kg', 'Gold Medal', 2024, 'individual', 'gold', 'SK-0004', '/image_assets/gold-medal-icon.png'),
('M. N. P. Perera', 'All Island Karate Championship', 'Under 21 Male Individual Kumite -75kg', 'Silver Medal', 2024, 'individual', 'silver', 'SK-0001', '/image_assets/silver-medal-icon.png'),
('K. P. N. Silva', 'All Island Karate Championship', 'Under 21 Male Individual Kumite -75kg', 'Bronze Medal', 2024, 'individual', 'bronze', 'SK-0005', '/image_assets/bronze-medal-icon.png'),

('B. M. D. Lakmali Fernando', 'All Island Karate Championship', 'Under 21 Female Individual Kata', 'Gold Medal', 2024, 'individual', 'gold', 'SK-0006', '/image_assets/gold-medal-icon.png'),
('H. G. Sumithra Peries', 'All Island Karate Championship', 'Under 21 Female Individual Kata', 'Silver Medal', 2024, 'individual', 'silver', 'SK-0007', '/image_assets/silver-medal-icon.png'),
('S. M. N. Kumari Wickrama', 'All Island Karate Championship', 'Under 21 Female Individual Kata', 'Bronze Medal', 2024, 'individual', 'bronze', 'SK-0008', '/image_assets/bronze-medal-icon.png'),

-- 2023 Achievements
('M. N. P. Perera', 'Sri Lanka Open Karate Championship', 'Senior Male Individual Kata', 'Gold Medal', 2023, 'individual', 'gold', 'SK-0001', '/image_assets/gold-medal-icon.png'),
('W. A. T. Perera', 'Sri Lanka Open Karate Championship', 'Senior Male Individual Kumite', 'Silver Medal', 2023, 'individual', 'silver', 'SK-0004', '/image_assets/silver-medal-icon.png');

-- Add a simple test select
SELECT 'Database bootstrapped successfully!' as message;
SELECT COUNT(*) as achievements_count FROM achievements;
EOF

echo "Bootstrap SQL file created at /tmp/full-setup.sql"
echo "Attempting to inject database..."

# Try to use MySQL as root with no password
mysql -u root < /tmp/full-setup.sql 2>/dev/null && echo "✅ Database created successfully" || echo "❌ Database creation failed"

# Try to verify
echo "Verifying database exists..."
mysql -u root -e "USE sskda_website; SELECT COUNT(*) as count FROM achievements;" 2>/dev/null || echo "Could not verify"

echo "Bootstrap complete."