#!/bin/bash
# This will manually force Vercel to deploy the latest commit

echo "=== Manual Vercel Deployment Trigger ==="
echo ""

# Method 3: Use Vercel API directly (most reliable)
echo "Using Vercel API to trigger deployment..."

# Get the project name from git remote
PROJECT_NAME="sskda-website"

# Create deployment using Vercel CLI if available
if command -v vercel &> /dev/null; then
    echo "Deploying with Vercel CLI..."
    vercel --prod --force
else
    echo ""
    echo "Vercel CLI not found. Install it with:"
    echo "npm i -g vercel"
    echo ""
    
    # Manual git method
    echo "Using Git method instead..."
    echo "Creating deployment trigger commit..."
    
    # Make a small change to a file
    echo "<!-- Deployed: $(date) -->" >> deploy-timestamp.txt
    git add deploy-timestamp.txt
    git commit -m "Trigger deployment: $(date)"
    git push origin main
    
    echo ""
    echo "✓ Deployment triggered via git push"
fi

echo ""
echo "Check deployment status:"
echo "https://vercel.com/shotokanschoolkaratedo/sskda-website"
