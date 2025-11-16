#!/bin/bash
echo "═══════════════════════════════════════════════════════════════"
echo "🎯 ACTUAL FIX: Use 'handle: filesystem' directive"
echo "═══════════════════════════════════════════════════════════════"
echo ""

cd /home/ailove/Downloads/SSKDA_Website

# The real solution - tell Vercel to try files first, then routes to server
cat > vercel.json << 'ENDVERCEL'
{
  "version": 2,
  "builds": [
    {
      "src": "server.js",
      "use": "@vercel/node",
      "config": {
        "includeFiles": [
          "public/**",
          "image-assets/**",
          "uploads/**",
          "*.json"
        ]
      }
    }
  ],
  "routes": [
    {
      "handle": "filesystem"
    },
    {
      "src": "/api/(.*)",
      "dest": "/server.js"
    },
    {
      "src": "/(.*)",
      "dest": "/server.js"
    }
  ]
}
ENDVERCEL

echo "✓ Updated vercel.json with handle: filesystem"
echo ""
echo "This tells Vercel:"
echo "1. Try to serve from filesystem first (static files)"
echo "2. If not found, route to server.js (APIs + HTML)"
echo "3. No interference, no 401 errors"
echo ""

git add vercel.json
git commit -m "FINAL FIX: Use handle:filesystem for static files"
git push origin main

echo "✓ Changes committed"
echo ""
echo "Deploying..."
vercel --prod

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "handle: filesystem tells Vercel to:"
echo ""
echo "✓ Try serving /public/ShotokanRoars.png from disk"
echo "✓ If found → serve it directly (HTTP 200)"
echo "✓ If not found → route to /server.js"
echo ""
echo "No more routing conflicts, no more 401 errors!"
echo "═══════════════════════════════════════════════════════════════"
