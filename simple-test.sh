#!/bin/bash
echo "═══════════════════════════════════════════════════════════════"
echo "🔍 TESTING IMAGE ACCESS ON NEW DEPLOYMENT"
echo "═══════════════════════════════════════════════════════════════"
echo ""

URL="https://sskda-website-jb94q3kxt-shotokanschookaratedos-projects.vercel.app"
echo "Testing URL: $URL"
echo ""

echo "1. Testing /public/ShotokanRoars.png..."
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL/public/ShotokanRoars.png"
echo ""

echo "2. Testing /public/championship.jpg..."
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL/public/championship.jpg"
echo ""

echo "3. Testing /public/kai.jpg..."
curl -s -o /dev/null -w "Status: %{http_code}\n" "$URL/public/kai.jpg"
echo ""

echo "═══════════════════════════════════════════════════════════════"
echo "If any show Status: 200, images are working!"
echo "═══════════════════════════════════════════════════════════════"
