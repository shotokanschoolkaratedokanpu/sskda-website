#!/bin/bash
echo "═══════════════════════════════════════════════════════════════"
echo "🔥 ENSURING FILES ARE IN DEPLOYMENT"
echo "═══════════════════════════════════════════════════════════════"

cd /home/ailove/Downloads/SSKDA_Website

# Move everything to root where Vercel will include it
echo "Moving images to root for deployment guarantee..."

cp public/*.png . 2>/dev/null
cp public/*.jpg . 2>/dev/null

echo "Files now in root: $(ls *.png *.jpg 2>/dev/null | wc -l)"

# Update vercel.json to include root files
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
          "*.png",
          "*.jpg",
          "*.jpeg",
          "*.json",
          "*.html"
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

echo "✓ Updated vercel.json to include all image files"
git add vercel.json *.png *.jpg
git commit -m "FORCE: Include all images in deployment"
git push origin main

echo "Deploying..."
vercel --prod

echo ""
echo "This should ensure files are actually uploaded."
