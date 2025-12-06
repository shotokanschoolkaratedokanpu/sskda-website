DROP DATABASE IF EXISTS sskda_website;
CREATE DATABASE sskda_website;
USE sskda_website;

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

-- Grant permissions for system user
GRANT ALL PRIVILEGES ON sskda_website.* TO 'ailove'@'localhost' IDENTIFIED WITH auth_socket;
FLUSH PRIVILEGES;