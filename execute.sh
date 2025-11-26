#!/bin/bash

set -e  # Exit on first error

echo "=== SSKDA Setup ==="

# Check MySQL
sudo mysql -u root -e "SELECT 1" > /dev/null 2>&1
echo "✅ MySQL is ready"

# Generate secure password
DB_PASS=$(openssl rand -hex 16)
echo "🔑 Generated password: $DB_PASS"

# Database setup (combined for efficiency)
sudo mysql -u root -e "
DROP DATABASE IF EXISTS sskda_website;
CREATE DATABASE sskda_website;
CREATE USER IF NOT EXISTS 'sskda_user'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON sskda_website.* TO 'sskda_user'@'localhost';
FLUSH PRIVILEGES;
"
echo "✅ Database configured"

# Import data
if [[ -f "database/import.sql" ]]; then
    mysql -u sskda_user -p"$DB_PASS" sskda_website < database/import.sql
    echo "✅ Data imported"
else
    echo "⚠️  Warning: database/import.sql not found"
fi

# Update configuration
CONFIG_FILE="includes/config.php"
if [[ -f "$CONFIG_FILE" ]]; then
    cp "$CONFIG_FILE" "${CONFIG_FILE}.bak"
    sed -i "s/'if0_database'/'sskda_website'/g" "$CONFIG_FILE"
    sed -i "s/'if0_user'/'sskda_user'/g" "$CONFIG_FILE"
    sed -i "s/'your_password'/'$DB_PASS'/g" "$CONFIG_FILE"
    sed -i "s|'https://yoursite.epizy.com'|'http://localhost:8000'|g" "$CONFIG_FILE"
    echo "✅ Configuration updated"
else
    echo "⚠️  Warning: $CONFIG_FILE not found"
fi

# Deploy files
WEB_DIR="/var/www/html/sskda"
sudo rm -rf "$WEB_DIR"
sudo mkdir -p "$WEB_DIR"
sudo cp -r ./* "$WEB_DIR/"
sudo chmod -R 755 "$WEB_DIR"
echo "✅ Files deployed"

# Create server start script
START_SCRIPT="/tmp/start-sskda.sh"
sudo tee "$START_SCRIPT" > /dev/null << 'SERVER'
#!/bin/bash
cd /var/www/html/sskda && php -S localhost:8000
SERVER
sudo chmod +x "$START_SCRIPT"
echo "✅ Start script created at $START_SCRIPT"

# Save password securely
PASSWORD_FILE="/tmp/sskda-db-pass.txt"
echo "$DB_PASS" | sudo tee "$PASSWORD_FILE" > /dev/null
sudo chmod 600 "$PASSWORD_FILE"
echo "✅ Password saved to $PASSWORD_FILE"

# Final summary
echo ""
echo "====================================="
echo "✅ SETUP COMPLETE!"
echo "====================================="
echo "🚀 Start server: $START_SCRIPT"
echo "🧪 Test API: curl http://localhost:8000/api/achievements-get.php"
echo "🌐 Open browser: http://localhost:8000/pages/index.html"
echo "🔐 DB password: (saved to $PASSWORD_FILE)"