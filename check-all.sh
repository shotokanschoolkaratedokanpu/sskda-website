#!/bin/bash
echo "═══════════════════════════════════════════════════════════════"
echo "🔍 CHECKING ALL DEPLOYMENTS"
echo "═══════════════════════════════════════════════════════════════"
echo ""

DEPLOYMENTS=(
    "https://sskda-website-nm5si72vr-shotokanschookaratedos-projects.vercel.app"
    "https://sskda-website-fc5o8q5r1-shotokanschookaratedos-projects.vercel.app"
    "https://sskda-website-resz2m07m-shotokanschookaratedos-projects.vercel.app"
    "https://sskda-website-1b6l7zhd6-shotokanschookaratedos-projects.vercel.app"
)

for url in "${DEPLOYMENTS[@]}"; do
    echo "Testing: $url"
    status=$(curl -s -o /dev/null -w "%{http_code}" "$url/public/ShotokanRoars.png")
    echo "  ShotokanRoars.png → $status"
    if [ "$status" = "200" ]; then
        echo "  ✅ THIS ONE WORKS! Visit: $url"
        break
    fi
    echo ""
done

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "The latest deployment (nm5si72vr) should have NO express.static()"
echo "Therefore images should now load correctly!"
echo "═══════════════════════════════════════════════════════════════"
