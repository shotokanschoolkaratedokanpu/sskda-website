-- Run these in mysql as root:
-- mysql -u root -p

CREATE DATABASE IF NOT EXISTS sskda_website;
SHOW DATABASES;
USE sskda_website;

-- Create tables
cREATE TABLE IF NOT EXISTS achievements (
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

-- Insert data
INSERT INTO achievements (athlete, competition, category, achievement, year, type, medal, associationId) VALUES
('John Smith', 'World Championship', 'Senior Kata', 'Gold Medal', 2024, 'individual', 'gold', 'SK001'),
('Jane Doe', 'National Tournament', 'Kumite -67kg', 'Silver Medal', 2024, 'individual', 'silver', 'SK002'),
('Team A', 'Regional Championship', 'Team Kata', 'Bronze Medal', 2023, 'team', 'bronze', 'SK003'),
('Mike Johnson', 'State Tournament', 'Kumite +75kg', 'Gold Medal', 2023, 'individual', 'gold', 'SK004'),
('Emily Wang', 'World Championship', 'Kata Junior', 'Silver Medal', 2022, 'individual', 'silver', 'SK005');

-- Verify
SELECT COUNT(*) as total_achievements FROM achievements;
SELECT * FROM achievements;