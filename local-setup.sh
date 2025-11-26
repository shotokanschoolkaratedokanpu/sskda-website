#!/bin/bash
set -e

echo "=== SSKDA Local Development Setup ==="

# Step 1: Create database setup script
cat > /tmp/setup_db.sql << 'EOF'
DROP DATABASE IF EXISTS sskda_website;
CREATE DATABASE IF NOT EXISTS sskda_website;
CREATE USER IF NOT EXISTS 'sskda_user'@'localhost' IDENTIFIED BY 'sskda_local_pass';
GRANT ALL PRIVILEGES ON sskda_website.* TO 'sskda_user'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "📄 Database setup script created at /tmp/setup_db.sql"
echo ""
echo "⚠️  PLEASE RUN THIS MANUAL STEP:"
echo "    $ mysql -u root -p < /tmp/setup_db.sql"
echo ""
echo "After that, press Enter to continue with the rest of setup..."
read -p ""

# Step 2: Import data
echo "📥 Importing data..."
if [ -f "database/import.sql" ]; then
    mysql -u sskda_user -p'sskda_local_pass' sskda_website < database/import.sql
    echo "✅ Data imported"
else
    echo "❌ database/import.sql not found"
    exit 1
fi

# Step 3: Deploy files
echo "📂 Deploying files..."
WEB_DIR="/var/www/html/sskda"
sudo rm -rf "$WEB_DIR"
sudo mkdir -p "$WEB_DIR"
sudo cp -r ./* "$WEB_DIR/"
sudo chmod -R 755 "$WEB_DIR"
sudo chown -R www-data:www-data "$WEB_DIR" 2>/dev/null || true
echo "✅ Files deployed to $WEB_DIR"

# Step 4: Create start script
echo "🚀 Creating start script..."
START_SCRIPT="/tmp/start-sskda.sh"
sudo tee "$START_SCRIPT" > /dev/null << 'SERVER'
#!/bin/bash
cd /var/www/html/sskda
php -S localhost:8000
SERVER
sudo chmod +x "$START_SCRIPT"
echo "✅ Start script created at $START_SCRIPT"

# Step 5: Verify
echo "🔍 Verifying database..."
COUNT=$(mysql -u sskda_user -p'sskda_local_pass' -e "SELECT COUNT(*) FROM sskda_website.achievements;" -s -N 2>/dev/null || echo "0")
echo "Found $COUNT achievements (expected 11)"

echo ""
echo "╔════════════════════════════════════════╗"
echo "║         ✅ SETUP COMPLETE!             ║"
echo "╚════════════════════════════════════════╝"
echo ""
echo "🚀 TO START SERVER:"
echo "   $ $START_SCRIPT"
echo ""
echo "🌐 Then open: http://localhost:8000/pages/index.html"
echo "🧪 Test API:  http://localhost:8000/api/achievements-get.php"