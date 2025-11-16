#!/bin/bash
PROD_URL="https://sskda-website-resz2m07m-shotokanschookaratedos-projects.vercel.app"

echo "Testing production deployment on: $PROD_URL"
echo ""

curl -s "$PROD_URL" | grep -i "img\|background" | head -5

echo ""
echo "Image test results:"
for img in "/public/ShotokanRoars.png" "/public/championship.jpg" "/public/kai.jpg"; do
    status=$(curl -s -o /dev/null -w "%{http_code}" "${PROD_URL}${img}")
    echo "$img: $status"
done

echo ""
echo "Visit: $PROD_URL"
