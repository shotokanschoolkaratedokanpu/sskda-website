#!/bin/bash
echo "═══════════════════════════════════════════════════════════════"
echo "🔧 FINAL DEBUG: Check deployment state"
echo "═══════════════════════════════════════════════════════════════"

URL="https://sskda-website-pt2fcvh0j-shotokanschookaratedos-projects.vercel.app"

echo "1. Testing homepage..."
curl -s -I "$URL" | head -5

echo ""
echo "2. Testing image with verbose output..."
curl -v -s "$URL/public/ShotokanRoars.png" 2>&1 | grep -E "< HTTP|Content-Type" | head -3

echo ""
echo "3. Checking HTML source for image references..."
curl -s "$URL/" | grep -i "background.*url\|src.*image" | head -3

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "The 401 suggests the request is hitting authentication"
echo "Double-check: Did you set any environment variables?"
echo "═══════════════════════════════════════════════════════════════"
