#!/bin/bash
echo "╔═══════════════════════════════════════════════════╗"
echo "║  SSKDA Website - Complete Local Setup             ║"
echo "╚═══════════════════════════════════════════════════╝"
echo ""

# Function to test database connection
test_db() {
    mysql -u root sskda_website -e "SELECT COUNT(*) FROM achievements" 2>/dev/null
    return $?
}

# Check if database exists and has data
echo "Step 1: Checking database status..."
if test_db; then
    COUNT=$(mysql -u root sskda_website -e "SELECT COUNT(*) FROM achievements" -s -N 2>/dev/null)
    echo "✅ Database exists with $COUNT achievements"
else
    echo "❌ Database not setup or accessible"
    echo ""
    echo "╔═══════════════════════════════════════════════════╗"
    echo "║  MANUAL DATABASE SETUP REQUIRED                    ║"
    echo "╚═══════════════════════════════════════════════════╝"
    echo ""
    echo "Open a NEW terminal and run:"
    echo ""
    echo "sudo mysql -u root << 'EOF'"
    echo "CREATE DATABASE sskda_website;"
    echo "USE sskda_website;"
    cat /home/ailove/Downloads/SSKDA_Website/database/import.sql | grep -v "^--" | head -55
    echo "EOF"
    echo ""
    echo "After running, come back here and press Enter..."
    read -p ""
fi

# Final check
echo ""
echo "Step 2: Final verification..."
if test_db; then
    COUNT=$(mysql -u root sskda_website -e "SELECT COUNT(*) FROM achievements" -s -N 2>/dev/null)
    echo "✅ Database ready ($COUNT achievements loaded)"
else
    echo "⚠️  Database verification failed - continuing anyway"
fi

# Start server
echo ""
echo "╔═══════════════════════════════════════════════════╗"
echo "║  🚀 STARTING PHP DEVELOPMENT SERVER                ║"
echo "╚═══════════════════════════════════════════════════╝"
echo ""
echo "Website: http://localhost:8000/pages/index.html"
echo "API Test: http://localhost:8000/api/achievements.php"
echo "Press Ctrl+C to stop the server"
echo ""

php -S localhost:8000