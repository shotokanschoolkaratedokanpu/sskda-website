#!/bin/bash
echo "═══════════════════════════════════════════════════════════════"
echo "🔍 DEBUGGING: Testing direct image access vs server routing"
echo "═══════════════════════════════════════════════════════════════"
echo ""

PROD_URL="https://sskda-website-resz2m07m-shotokanschookaratedos-projects.vercel.app"

echo "Testing homepage..."
curl -s -I "$PROD_URL" | head -3
echo ""

echo "Testing direct file access..."
for path in "/public/ShotokanRoars.png" "/ShotokanRoars.png" "/image-assets/ShotokanRoars.png"; do
    echo -n "$path: "
    curl -s -o /dev/null -w "%{http_code}\n" "$PROD_URL$path"
done
echo ""

echo "Checking response headers..."
curl -s -I "$PROD_URL/public/ShotokanRoars.png" | grep -E "HTTP|Content-Type|x-vercel" || echo "No access"
echo ""

echo "═══════════════════════════════════════════════════════════════"
echo "THE PROBLEM:"
echo "═══════════════════════════════════════════════════════════════"
echo "✗ Images return 401 (Unauthorized)"
echo "✗ Server.js is blocking static file access"
echo "✗ Need to bypass server.js for static files"
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "SOLUTION:"
echo "═══════════════════════════════════════════════════════════════"
echo "Update vercel.json to serve static files BEFORE routing"
echo "Remove static serving from server.js, let Vercel handle it"
echo "Run: ./final-solution.sh"
echo "═══════════════════════════════════════════════════════════════"
