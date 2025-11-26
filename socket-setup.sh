#!/bin/bash

echo "╔═══════════════════════════════════════════╗"
echo "║  DATABASE SETUP WITH SOCKET AUTH          ║"
echo "╚═══════════════════════════════════════════╝"
echo ""
echo "Current user: $(whoami)"
echo ""

# Create setup SQL
cat > /tmp/socket-setup.sql << 'EOF'
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

-- Create user with socket auth
DROP USER IF EXISTS '$(whoami)'@'localhost';
CREATE USER '$(whoami)'@'localhost' IDENTIFIED WITH auth_socket;
GRANT ALL PRIVILEGES ON sskda_website.* TO '$(whoami)'@'localhost';
FLUSH PRIVILEGES;

SELECT COUNT(*) as achievements_count FROM achievements;
EOF

echo "🔐 Running database setup (requires admin)..."
if pkexec mysql -u root < /tmp/socket-setup.sql; then
    echo "✅ Database created successfully!"
    
    # Update config to use current system user
    sed -i "s/'root'/'$(whoami)'/g" includes/config.php
    sed -i "s/define('DB_PASS', '.*')/define('DB_PASS', '');/g" includes/config.php
    echo "✅ Updated config.php to use system user: $(whoami)"
    
    # Test API
    sleep 2
    echo ""
    echo "🧪 Testing API..."
    RESULT=$(curl -s http://localhost:8000/api/achievements.php)
    echo "$RESULT" | python3 -m json.tool 2>/dev/null || echo "$RESULT"
    
    echo ""
    echo "🎉 Setup complete! Website: http://localhost:8000/pages/index.html"
else
    echo "❌ Setup failed. Try manual: sudo mysql -u root < /tmp/socket-setup.sql"
fi