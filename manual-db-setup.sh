#!/bin/bash
echo "╔═══════════════════════════════════════════╗"
echo "║  MANUAL Database Setup Instructions       ║"
echo "╚═══════════════════════════════════════════╝"
echo ""
echo "Step 1: Open MySQL with root:"
echo "$ sudo mysql -u root"
echo ""
echo "Step 2: Paste these commands in MySQL:"
echo "─────────────────────────────────────────────"
cat /tmp/mysql_fix.sql
echo ""
echo "─────────────────────────────────────────────"
echo ""
echo "Step 3: After running, press Enter in this terminal"
read -p "Press Enter when done..."

# Update config.php
echo "⚙️  Updating config.php..."
sed -i "s/'root'/'php_app'/g" /home/ailove/Downloads/SSKDA_Website/includes/config.php
sed -i "s/define('DB_PASS', '.*')/define('DB_PASS', '');/g" /home/ailove/Downloads/SSKDA_Website/includes/config.php
echo "✅ Configuration updated"

echo ""
echo "🔍 Testing API..."
curl -s http://localhost:8000/api/achievements-get.php | python3 -m json.tool 2>/dev/null || echo "API test failed"