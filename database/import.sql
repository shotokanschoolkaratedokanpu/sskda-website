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
    category VARCHAR(100),
    ageGroup VARCHAR(50),
    emergencyName VARCHAR(200),
    emergencyPhone VARCHAR(20),
    registrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    registrationId VARCHAR(100) UNIQUE NOT NULL
);

-- Step 2: Insert Existing Data
-- (Paste this after creating tables)

INSERT INTO achievements (id, athlete, competition, category, achievement, year, type, medal, associationId, image) VALUES
(1, 'Kai Johnson', 'World Karate Championship', 'Kata - Senior', 'Gold Medal', '2024', 'kata', 'gold', 'KA001', '/image_assets/kai.jpg'),
(2, 'Maya Chen', 'National Tournament', 'Kumite -67kg', 'Silver Medal', '2024', 'kumite', 'silver', 'KA001', '/image_assets/maya.jpg'),
(3, 'Team Kata', 'Regional Championships', 'Team Kata', 'Bronze Medal', '2024', 'team', 'bronze', 'KA001', '/image_assets/team.jpg'),
(4, 'Sarah Williams', 'National Karate Championship', 'Women\'s Kata', 'Gold Medal in Team Event', '2022', 'team', 'gold', 'KA001', '/image_assets/kai.jpg'),
(5, 'Robert Brown', 'State Karate Tournament', 'Men\'s Kumite', 'Silver Medal in Individual', '2021', 'individual', 'silver', 'KA001', '/image_assets/maya.jpg'),
(6, 'Emily Davis', 'National Karate Championship', 'Under 18', 'Bronze Medal in Kata', '2020', 'individual', 'bronze', 'KA001', '/image_assets/team.jpg'),
(7, 'David Wilson', 'State Karate Tournament', 'Women\'s Kumite', 'Gold Medal in Team Event', '2019', 'team', 'gold', 'KA001', '/image_assets/kai.jpg'),
(8, 'Michael Taylor', 'Regional Karate Cup', 'Men\'s Kumite', 'Silver Medal in Individual', '2018', 'individual', 'silver', 'KA001', '/image_assets/maya.jpg'),
(9, 'Jessica Anderson', 'National Karate Championship', 'Women\'s Kata', 'Bronze Medal in Team Event', '2017', 'team', 'bronze', 'KA001', '/image_assets/team.jpg'),
(10, 'Daniel Thomas', 'State Karate Tournament', 'Under 21', 'Gold Medal in Individual', '2016', 'individual', 'gold', 'KA001', '/image_assets/kai.jpg'),
(11, 'Lisa Martinez', 'Regional Karate Cup', 'Women\'s Kumite', 'Silver Medal in Team Event', '2015', 'team', 'silver', 'KA001', '/image_assets/maya.jpg');

-- Step 3: Verify Data
SELECT COUNT(*) as total_achievements FROM achievements;
SELECT * FROM achievements ORDER BY year DESC LIMIT 5;
