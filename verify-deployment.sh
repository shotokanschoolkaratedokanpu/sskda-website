#!/bin/bash
echo "═══════════════════════════════════════════════════════════════"
echo "🔍 VERIFY DEPLOYMENT - Testing image URLs"
echo "═══════════════════════════════════════════════════════════════"
echo ""

BASE_URL="https://sskda-website-nine.vercel.app"

echo "Testing image URLs on Vercel..."
echo ""

IMAGES=(
    "/public/ShotokanRoars.png"
    "/ShotokanRoars.png"
    "/public/Gemini_Generated_Image_g7c9isg7c9isg7c9.png"
    "/Gemini_Generated_Image_g7c9isg7c9isg7c9.png"
    "/public/championship.jpg"
    "/championship.jpg"
    "/public/kai.jpg"
    "/kai.jpg"
)

for img in "${IMAGES[@]}"; do
    url="${BASE_URL}${img}"
    status=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    if [ "$status" = "200" ]; then
        echo "✅ $img → $status"
    else
        echo "❌ $img → $status"
    fi
done

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "Check your website: $BASE_URL"
echo "═══════════════════════════════════════════════════════════════"
