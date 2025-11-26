#!/bin/bash
echo "╔════════════════════════════════════════╗"
echo "║         SSKDA SETUP AND RUN            ║"
echo "╚════════════════════════════════════════╝"
echo ""

# Check if database exists
echo "Step 1: Checking database..."
if mysql -u sskda_user -p'sskda_local_pass' -e "USE sskda_website;" 2>/dev/null; then
    echo "✅ Database already exists"
else
    echo "⚠️  Database not found"
    echo ""
    echo "Please run these commands in another terminal:"
    echo ""
    echo "mysql -u root -p <<'MYEOF'"
    cat setup_db.sql
    echo "MYEOF"
    echo ""
    echo "Then run:"
    echo "mysql -u sskda_user -p'sskda_local_pass' sskda_website < database/import.sql"
    echo ""
    echo "After that, press Enter to continue..."
    read -p ""
fi

# Step 2: Start server
echo ""
echo "Step 2: Starting PHP server..."
echo "Server running at http://localhost:8000"
echo "Press Ctrl+C to stop"
echo ""

php -S localhost:8000