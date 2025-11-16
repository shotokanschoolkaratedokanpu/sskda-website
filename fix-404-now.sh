#!/bin/bash
# This forces Vercel to redeploy from scratch and clears cache

echo "═══════════════════════════════════════════════════════════════"
echo "🔥 FIXING 404 ERRORS - FORCING CLEAN REDEPLOYMENT"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Method: Create another git push with a file change
echo "Creating a file change to force Vercel to redeploy..."

# Create a deployment marker file with timestamp
echo "<!-- Last Deployed: $(date +"%Y-%m-%d %H:%M:%S") -->" > public/deploy-marker.html
echo "Deployment marker created"

# Add and commit the file
git add public/deploy-marker.html
git commit -m "Force redeploy: Clear cache and trigger build"
git push origin main

echo ""
echo "✓ Git push complete!"
echo ""
echo "Now waiting for Vercel to detect and deploy..."
echo ""
echo "To check deployment status:"
echo "https://vercel.com/shotokanschoolkaratedo/sskda-website/deployments"
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "If you STILL see 404s after 2 minutes, run this:"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "Method 2: Use Vercel Dashboard"
echo "1. Visit: https://vercel.com/shotokanschoolkaratedo/sskda-website/deployments"
echo "2. Find the latest deployment"
echo "3. Click the three dots (...)"
echo "4. Select 'Redeploy'"
echo "5. Uncheck 'Use existing Build Cache'"
echo "6. Click 'Redeploy'"
echo ""
echo "═══════════════════════════════════════════════════════════════"
