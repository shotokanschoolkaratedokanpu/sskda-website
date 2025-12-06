#!/bin/bash
echo "╔═══════════════════════════════════════════╗"
echo "║   SSKDA Website - Quick Start             ║"
echo "╚═══════════════════════════════════════════╝"
echo ""
echo "Starting PHP development server..."
echo ""
echo "🌐 Website will be available at:"
echo "   http://localhost:8000/pages/index.html"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""
echo "═══════════════════════════════════════════"
echo ""

# Kill any existing server first
pkill -f "php -S" 2>/dev/null
sleep 1

# Start server
php -S localhost:8000

echo ""
echo "Server stopped."