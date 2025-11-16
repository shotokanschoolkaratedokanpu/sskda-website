#!/bin/bash
echo "═══════════════════════════════════════════════════════════════"
echo "✅ VERIFYING FINAL DEPLOYMENT - Testing Image URLs"
echo "═══════════════════════════════════════════════════════════════"
echo ""

PROD_URL="https://sskda-website-fc5o8q5r1-shotokanschookaratedos-projects.vercel.app"

echo "Production URL: $PROD_URL"
echo ""
echo "Testing all image paths..."
echo ""

IMAGES=(
    "/public/ShotokanRoars.png"
    "/public/Gemini_Generated_Image_g7c9isg7c9isg7c9.png"
    "/public/championship.jpg"
    "/public/kai.jpg"
    "/public/maya.jpg"
    "/public/team.jpg"
)

success_count=0
total_count=${#IMAGES[@]}

for img in "${IMAGES[@]}"; do
    url="${PROD_URL}${img}"
    status=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    
    if [ "$status" = "200" ]; then
        echo "✅ $img → HTTP $status (SUCCESS)"
        ((success_count++))
    elif [ "$status" = "404" ]; then
        echo "❌ $img → HTTP $status (Not Found)"
    elif [ "$status" = "401" ]; then
        echo "⚠️  $img → HTTP $status (Unauthorized)"
    else
        echo "⏳ $img → HTTP $status (Other)"
    fi
done

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "RESULTS: $success_count / $total_count images working"
echo "═══════════════════════════════════════════════════════════════"
echo ""

if [ $success_count -eq $total_count ]; then
    echo "🎉 ALL IMAGES ARE WORKING!"
    echo ""
    echo "✅ Homepage background should be visible"
    echo "✅ Championship banner should load"
    echo "✅ Member achievement images should display"
    echo ""
    echo "Visit your website: $PROD_URL"
else
    echo "⚠️  Some images still not loading"
    echo "Wait 30 seconds and run this script again"
    echo "Or visit the deployment URL directly"
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "Deployment Details:"
echo "═══════════════════════════════════════════════════════════════"
echo "Commit: 0672f8f"
echo "Strategy: Vercel native static file serving"
echo "Server.js: No longer serves static files"
echo "Images: Handled directly by Vercel CDN"
echo "═══════════════════════════════════════════════════════════════"
