#!/bin/bash
set -e

echo "=== SSKDA Setup Script ==="

# Step 1: Check MySQL
echo "Step 1: Checking MySQL..."
if sudo mysql -u root -e "SELECT 1" >/dev/null 2>&1; then
    echo "✅ MySQL password set"
else
    echo "❌ Run: sudo mysql_secure_installation first"
    exit 1
fi

# Step 2: Create DB and user
echo "Step 2: Creating database..."
DB_PASS=$(openssl rand -base64 12)
echo "Password: $DB_PASS"

echo "CREATE DATABASE sskda_website;" | sudo mysql -u root
echo "CREATE USER sskda_user@localhost IDENTIFIED BY '$DB_PASS';" | sudo mysql -u root
echo "GRANT ALL ON sskda_website.* TO sskda_user@localhost;" | sudo mysql -u root
echo "FLUSH PRIVILEGES;" | sudo mysql -u root
echo "✅ Database created"

# Step 3: Import
echo "Step 3: Importing data..."
if [ -f database/import.sql ]; then
    mysql -u sskda_user -p"$DB_PASS" sskda_website < database/import.sql
    echo "✅ Data imported"
else
    echo "❌ database/import.sql not found"
    exit 1
fi

# Step 4: Update config
echo "Step 4: Updating config.php..."
if [ -f includes/config.php ]; then
    cp includes/config.php includes/config.php.backup
    sed -i "s/'if0_database'/'sskda_website'/g" includes/config.php
    sed -i "s/'if0_user'/'sskda_user'/g" includes/config.php
    sed -i "s/'your_password'/'$DB_PASS'/g" includes/config.php
    sed -i "s|'https://yoursite.epizy.com'|'http://localhost:8000'|g" includes/config.php
    echo "✅ Config updated"
else
    echo "❌ includes/config.php not found"
    exit 1
fi

# Step 5: Copy files
echo "Step 5: Copying files..."
sudo rm -rf /var/www/html/sskda
sudo mkdir -p /var/www/html/sskda
sudo cp -r ./* /var/www/html/sskda/
sudo chown -R www-data:www-data /var/www/html/sskda
sudo chmod -R 755 /var/www/html/sskda
sudo chmod 755 /var/www/html/sskda/uploads
echo "✅ Files copied"

# Step 6: Create start script
echo "Step 6: Creating start script..."
sudo tee /tmp/start-server.sh > /dev/null << 'EOF'
#!/bin/bash
cd /var/www/html/sskda
sudo php -S localhost:8000
EOF
sudo chmod +x /tmp/start-server.sh

sudo tee /tmp/stop-server.sh > /dev/null << 'EOF'
#!/bin/bash
sudo pkill -f "php -S localhost:8000"
EOF
sudo chmod +x /tmp/stop-server.sh
echo "✅ Start script: /tmp/start-server.sh"

# Step 7: Verify
echo "Step 7: Verifying..."
COUNT=$(mysql -u sskda_user -p"$DB_PASS" -e "SELECT COUNT(*) FROM sskda_website.achievements" -s -N)
echo "Achievements: $COUNT/11"

echo ""
echo "╔════════════════════════════════════════╗"
echo "║         ✅ SETUP COMPLETE!             ║"
echo "╚════════════════════════════════════════╝"
echo ""
echo "🚀 To start: /tmp/start-server.sh"
echo "🧪 To test:  curl http://localhost:8000/api/achievements-get.php"
echo ""
echo "Password: $DB_PASS" > /tmp/sskda-db-pass.txt
chmod 600 /tmp/sskda-db-pass.txt
echo "📋 Password saved: /tmp/sskda-db-pass.txt"
