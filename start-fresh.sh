#!/bin/bash
echo "╔═══════════════════════════════════════════╗"
echo "║     SSKDA Website - STARTUP SCRIPT       ║"
echo "╚═══════════════════════════════════════════╝"
echo ""

# Install all MySQL components first
echo "🗄️  Setting up database..."

pkexec bash -c 'mysql -u root << "SQL_EOF"
DROP DATABASE IF EXISTS sskda_website;
CREATE DATABASE sskda_website;
DROP USER IF EXISTS "sskda_user"@"localhost";
CREATE USER "sskda_user"@"localhost" IDENTIFIED BY "";
GRANT ALL PRIVILEGES ON sskda_website.* TO "sskda_user"@"localhost";
FLUSH PRIVILEGES;
SQL_EOF
' 2>/dev/null || echo "Database setup attempted"

echo "📥 Importing data..."
if [ -f "database/import.sql" ]; then
    # Try different user/password combinations
    mysql -u root sskda_website < database/import.sql 2>/dev/null || \
    mysql -u root  sskda_website < database/import.sql 2>/dev/null || \
    echo "⚠️  Import may need manual intervention"
else
    echo "❌ database/import.sql not found"
fi

echo ""
echo "🚀 Starting PHP development server..."
echo "===================================="
echo "Website: http://localhost:8000/pages/index.html"
echo "API Test: http://localhost:8000/api/achievements.php"
echo "Press Ctrl+C to stop"
echo "===================================="
php -S localhost:8000