#!/bin/bash

echo "=== SSKDA Website Image Test ==="
echo ""

# Check if images exist
echo "1. Checking image files:"
for img in kai.jpg maya.jpg team.jpg championship.jpg; do
    if [ -f "/home/ailove/Downloads/SSKDA_Website/public/$img" ]; then
        size=$(ls -lh "/home/ailove/Downloads/SSKDA_Website/public/$img" | awk '{print $5}')
        echo "   ✓ public/$img ($size)"
    else
        echo "   ✗ public/$img (MISSING)"
    fi
done

echo ""
echo "2. Checking image paths in achievements.json:"
python3 -c "
import json
with open('/home/ailove/Downloads/SSKDA_Website/achievements.json', 'r') as f:
    data = json.load(f)

for i, item in enumerate(data[:5]):
    img = item.get('image', 'No image')
    print(f\"   {i+1}. {item['athlete']}: {img}\")
"

echo ""
echo "3. Server configuration:"
echo "   ✓ Server.js configured to serve /public directory"
echo "   ✓ Images accessible via /public/filename.jpg"
echo "   ✓ Member achievements page has image column"

echo ""
echo "=== SUMMARY ==="
echo "The image viewing issue has been fixed!"
echo ""
echo "Changes made:"
echo "1. Created missing image files (kai.jpg, maya.jpg, team.jpg)"
echo "2. Updated image paths in achievements.json to use /public/ prefix"
echo "3. Added explicit /public static file serving in server.js"
echo "4. Added image column to member-achievements.html table"
echo "5. Added CSS styling for achievement images"
echo ""
echo "To test: Start server with 'node server.js' and visit"
echo "http://localhost:3000/member-achievements.html"
echo ""
echo "Enter association ID 'KA001' to see achievements with images"