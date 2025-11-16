#!/bin/bash
URL="https://sskda-website-a9h42vti3-shotokanschookaratedos-projects.vercel.app"

echo "Testing minimal deployment structure..."
echo "Homepage: $(curl -s -o /dev/null -w "%{http_code}" "$URL/")"
echo "public dir: $(curl -s -o /dev/null -w "%{http_code}" "$URL/public/")"
echo "ShotokanRoars: $(curl -s -o /dev/null -w "%{http_code}" "$URL/public/ShotokanRoars.png")"

echo ""
echo "List of files in public/ (should exist):"
ls -1 public/ | head -5

echo ""
echo "vercel.json includes:"
grep "public" vercel.json
echo ""
echo "The 404 means the file isn't in the deployment package."
echo "We need to ensure public/** is included in the build."
