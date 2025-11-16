#!/bin/bash
echo "═══════════════════════════════════════════════════════════════"
echo "🚨 EMERGENCY FIX: FINAL SOLUTION FOR 404 ERRORS"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Method: Copy all images to root AND update all paths to use public/recho "Step 1: Copying all images to root directory as backup..."
cd /home/ailove/Downloads/SSKDA_Website

for img in public/*.png public/*.jpg public/*.jpeg 2>/dev/null; do
    if [ -f "$img" ]; then
        filename=$(basename "$img")
        cp "$img" "$filename"
        echo "  Copied $filename to root"
    fi
done
echo ""

# Update vercel.json to include files from root
echo "Step 2: Updating vercel.json to explicitly include all images..."

python3 << 'PYEOF'
import json
import os

with open('vercel.json', 'r') as f:
    config = json.load(f)

# Add all image patterns to includeFiles
include_files = config['builds'][0]['config']['includeFiles']
patterns_to_add = ['*.png', '*.jpg', '*.jpeg', 'public/**', 'image-assets/**']

for pattern in patterns_to_add:
    if pattern not in include_files:
        include_files.append(pattern)
        print(f"  Added pattern: {pattern}")

config['builds'][0]['config']['includeFiles'] = include_files

with open('vercel.json', 'w') as f:
    json.dump(config, f, indent=2)

print("  vercel.json updated!")
PYEOF

echo ""
echo "Step 3: Updating all HTML files to use absolute paths..."

# Update all image paths to absolute /public/ paths
python3 << 'PYEOF'
import re
import os

files_to_fix = ['index.html', 'championship-registration.html', 'member-achievements.html', 'add-achievement.html', 'add-news-article.html']

for filename in files_to_fix:
    if os.path.exists(filename):
        with open(filename, 'r') as f:
            content = f.read()
        
        original_content = content
        
        # Fix url() paths
        content = re.sub(r"url\(['\"]((image-assets|public|\.)/)?([^'\"]+)\.(png|jpg|jpeg)['\"]\)", r"url('/public/\3.\4')", content)
        
        # Fix src attributes
        content = re.sub(r'src=["\']((image-assets|public|\.)/)?([^"\']+)\.(png|jpg|jpeg)["\']', r'src="/public/\3.\4"', content)
        
        # Fix background-image styles in news items specifically
        content = re.sub(r"background-image:\s*url\(['\"](?!https)([^'\"]+)['\"]\)", r"background-image: url('/public/\1')", content)
        
        if content != original_content:
            with open(filename, 'w') as f:
                f.write(content)
            print(f"  Fixed image paths in {filename}")

print("  All HTML files updated!")
PYEOF

echo ""
echo "Step 4: Committing changes..."

git add *.png *.jpg *.jpeg vercel.json deploy-marker.html
if [ -f "deploy-timestamp.txt" ]; then
    git add deploy-timestamp.txt
fi
git add *.html

git commit -m "Emergency fix: Include images at root and update all paths"
git push origin main

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "✅ EMERGENCY FIX COMPLETE!"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "What was done:"
echo "  • Copied all images from public/ to root directory"
echo "  • Updated vercel.json to explicitly include image files"
echo "  • Fixed all HTML files to use absolute /public/ paths"
echo "  • Committed and pushed all changes"
echo ""
echo "Expected outcome:"
echo "  • Images will be available at both /public/imagename.png AND /imagename.png"
echo "  • Vercel should have no issues finding the files"
echo "  • 404 errors should disappear in the new deployment"
echo ""
echo "⏰ Wait 60 seconds, then refresh your website!"
echo ""
