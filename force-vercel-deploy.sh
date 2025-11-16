#!/bin/bash

echo "=== Forcing Vercel Deployment ==="
echo ""

# Check if vercel CLI is installed
if command -v vercel &> /dev/null; then
    echo "✓ Vercel CLI detected"
    echo "Running: vercel --prod --force"
    echo ""
    vercel --prod --force
    exit 0
else
    echo "✗ Vercel CLI not installed"
    echo ""
fi

# Method 2: Create empty commit to trigger deployment
echo "Method 2: Creating empty commit to trigger GitHub -> Vercel deployment"
echo "Running: git commit --allow-empty -m 'Trigger deployment' && git push origin main"
echo ""

git commit --allow-empty -m "Trigger deployment: Force Vercel rebuild"
git push origin main

echo ""
echo "✓ Empty commit pushed to trigger Vercel deployment"
echo "Check deployment status at: https://vercel.com/shotokanschoolkaratedo/sskda-website/deployments"
exit 0
