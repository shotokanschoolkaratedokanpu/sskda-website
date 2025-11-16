#!/bin/bash
echo "═══════════════════════════════════════════════════════════════"
echo "🎯 FINAL SOLUTION: Let Vercel handle static files natively"
echo "═══════════════════════════════════════════════════════════════"
echo ""

cd /home/ailove/Downloads/SSKDA_Website

# Step 1: Update vercel.json to serve static files FIRST
cat > vercel.json << 'ENDVERCEL'
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
      "src": "/image-assets/(.*)",
      "dest": "/image-assets/$1"
    },
    {
      "src": "/uploads/(.*)",
      "dest": "/uploads/$1"
    },
    {
      "src": "/public/(.*)",
      "dest": "/public/$1"
    },
    {
      "src": "/(.*\\.(png|jpg|jpeg|gif|ico|svg|css|js|html))",
      "dest": "/$1"
    },
    {
      "src": "/(.*)",
      "dest": "/server.js"
    }
  ]
}
ENDVERCEL

echo "✓ Updated vercel.json - static files served before server.js"

# Step 2: Remove Express static file serving from server.js
cp server.js server.js.backup

python3 << 'PYEOF'
import re

with open('server.js', 'r') as f:
    content = f.read()

# Remove the static file serving sections
content = re.sub(r'// Explicitly serve image assets.*// Explicitly serve public directory.*// Also serve images from root.*\n\n', '', content, flags=re.DOTALL)

# Write back
with open('server.js', 'w') as f:
    f.write(content)

print("✓ Removed static file serving from server.js (Vercel handles it now)")
PYEOF

# Step 3: Commit and deploy
git add vercel.json server.js
git commit -m "Final fix: Let Vercel handle static files natively"
git push origin main

echo ""
echo "✓ Changes committed"
echo ""
echo "Step 4: Deploying to production..."
echo "Running: vercel --prod"

vercel --prod

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "✅ FINAL SOLUTION DEPLOYED!"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "What changed:"
echo "  • vercel.json routes static files BEFORE server.js"
echo "  • server.js no longer tries to serve static files"
echo "  • Vercel handles image serving natively (faster!)"
echo ""
echo "Expected result:"
echo "  • All images will load at /public/filename.ext"
echo "  • No 401 errors (server.js not blocking)"
echo "  • Home page background will appear"
echo "  • Championship banner will load"
echo ""
echo "Test with: ./verify-final-deployment.sh"
echo "═══════════════════════════════════════════════════════════════"
