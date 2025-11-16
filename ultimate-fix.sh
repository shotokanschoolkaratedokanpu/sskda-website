#!/bin/bash
echo "═══════════════════════════════════════════════════════════════"
echo "🔥 ULTIMATE FIX: Replace Express static serving with Vercel native"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# The problem: @vercel/node with Express static serving doesn't work well
# The solution: Let Vercel handle static files natively

cd /home/ailove/Downloads/SSKDA_Website

# Update vercel.json to use Vercel's native static file handling
cat > vercel.json << 'ENDFILE'
{
  "version": 2,
  "builds": [
    {
      "src": "server.js",
      "use": "@vercel/node"
    }
  ],
  "routes": [
    {
      "src": "/(image-assets|uploads|public)/(.+)",
      "dest": "/$1/$2",
      "headers": {
        "Access-Control-Allow-Origin": "*"
      }
    },
    {
      "src": "/(.*\\.(png|jpg|jpeg|gif|css|js|ico|svg))",
      "dest": "/$1"
    },
    {
      "src": "/(.*)",
      "dest": "/server.js"
    }
  ]
}
ENDFILE

echo "✓ Updated vercel.json with Vercel native static file handling"

# Now redeploy with the new configuration
echo ""
echo "Redeploying with Vercel CLI..."
echo "Running: vercel --prod"
echo ""

vercel --prod

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "✅ ULTIMATE FIX DEPLOYED!"
echo "═══════════════════════════════════════════════════════════════"
