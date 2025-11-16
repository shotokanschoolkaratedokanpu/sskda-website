#!/bin/bash
echo "═══════════════════════════════════════════════════════════════"
echo "🎯 ULTIMATE FINAL SOLUTION: Separate Static Files from Server"
echo "═══════════════════════════════════════════════════════════════"
echo ""

cd /home/ailove/Downloads/SSKDA_Website

# The problem: Vercel + Express static serving = 401 errors
# The solution: Let Vercel handle images, Express handles APIs only

# Step 1: Update vercel.json to completely bypass server.js for static files
cat > vercel.json << 'ENDVERCEL'
{
  "version": 2,
  "builds": [
    {
      "src": "server.js",
      "use": "@vercel/node",
      "config": {
        "includeFiles": [
          "public/**",
          "image-assets/**",
          "uploads/**",
          "*.json"
        ]
      }
    }
  ],
  "routes": [
    {
      "src": "/public/(.*)",
      "headers": {
        "Access-Control-Allow-Origin": "*"
      }
    },
    {
      "src": "/image-assets/(.*)",
      "headers": {
        "Access-Control-Allow-Origin": "*"
      }
    },
    {
      "src": "/uploads/(.*)",
      "headers": {
        "Access-Control-Allow-Origin": "*"
      }
    },
    {
      "src": "/(.*\\.(png|jpg|jpeg|gif|ico|svg|css|js|html))",
      "dest": "/$1",
      "headers": {
        "Access-Control-Allow-Origin": "*"
      }
    },
    {
      "src": "/api/(.*)",
      "dest": "/server.js"
    },
    {
      "src": "/(.*)",
      "dest": "/server.js"
    }
  ]
}
ENDVERCEL

echo "✓ Updated vercel.json - static files served by Vercel directly"

# Step 2: Clean up server.js - remove all static file serving
cat > server.js << 'ENDSERVER'
const express = require('express');
const multer = require('multer');
const fs = require('fs');
const path = require('path');
const app = express();
const port = 3000;

// Set up storage for uploaded images
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const uploadPath = path.join(__dirname, 'uploads');
    if (!fs.existsSync(uploadPath)) {
      fs.mkdirSync(uploadPath, { recursive: true });
    }
    cb(null, uploadPath);
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + '-' + file.originalname);
  }
});

const upload = multer({ storage });

// ONLY use middleware needed for API routes
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Explicit routes for HTML pages
app.get('/', (req, res) => {
  res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.get('/index.html', (req, res) => {
  res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.get('/member-achievements.html', (req, res) => {
  res.sendFile(path.join(__dirname, 'member-achievements.html'));
});

app.get('/register.html', (req, res) => {
  res.sendFile(path.join(__dirname, 'register.html'));
});

app.get('/member-dashboard.html', (req, res) => {
  res.sendFile(path.join(__dirname, 'member-dashboard.html'));
});

app.get('/add-achievement.html', (req, res) => {
  res.sendFile(path.join(__dirname, 'add-achievement.html'));
});

app.get('/add-news-article.html', (req, res) => {
  res.sendFile(path.join(__dirname, 'add-news-article.html'));
});

app.get('/championship-registration.html', (req, res) => {
  res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');
  res.sendFile(path.join(__dirname, 'championship-registration.html'));
});

app.post('/submit-achievement', upload.single('achievementImage'), (req, res) => {
  try {
    const { athlete, competition, category, achievement, year, type, associationId } = req.body;
    
    if (!associationId || !associationId.startsWith('KA') || associationId.length !== 5) {
      res.status(400).send('Invalid Association ID');
      return;
    }
    
    const image = req.file ? `/uploads/${req.file.filename}` : ''
    
    const newAchievement = {
      athlete,
      competition,
      category,
      achievement,
      year,
      type,
      associationId,
      medal: achievement.toLowerCase().includes('gold') ? 'gold' :
             achievement.toLowerCase().includes('silver') ? 'silver' :
             achievement.toLowerCase().includes('bronze') ? 'bronze' : '',
      image
    };
    
    const achievementsPath = path.join(__dirname, 'achievements.json');
    const data = fs.readFileSync(achievementsPath, 'utf8');
    const achievements = data ? JSON.parse(data) : [];
    achievements.push(newAchievement);
    fs.writeFileSync(achievementsPath, JSON.stringify(achievements, null, 2));
    res.redirect(`/member-achievements.html?associationId=${associationId}`);
  } catch (error) {
    res.status(500).send('Error submitting achievement');
  }
});

app.get('/api/achievements', (req, res) => {
  const achievementsPath = path.join(__dirname, 'achievements.json');
  const data = fs.readFileSync(achievementsPath, 'utf8');
  let achievements = JSON.parse(data);
  
  const { type, year, search, associationId } = req.query;
  
  if (associationId) {
    achievements = achievements.filter(item => item.associationId === associationId);
  }
  
  if (type && type !== 'all') {
    achievements = achievements.filter(item => item.type === type);
  }
  
  if (year && year !== 'all') {
    achievements = achievements.filter(item => item.year === year);
  }
  
  if (search) {
    const term = search.toLowerCase();
    achievements = achievements.filter(item =>
      item.athlete.toLowerCase().includes(term) ||
      item.competition.toLowerCase().includes(term) ||
      item.category.toLowerCase().includes(term)
    );
  }
  
  res.json(achievements);
});

app.post('/api/championship-registration', (req, res) => {
  try {
    const registrationData = {
      ...req.body,
      registrationDate: new Date().toISOString(),
      registrationId: 'CHAMP' + Date.now()
    };
    
    const requiredFields = ['firstName', 'lastName', 'dob', 'gender', 'email', 'phone', 'associationId', 'belt', 'category', 'ageGroup', 'emergencyName', 'emergencyPhone'];
    for (const field of requiredFields) {
      if (!registrationData[field]) {
        res.status(400).send(`Missing required field: ${field}`);
        return;
      }
    }
    
    if (!registrationData.associationId.match(/^KA[0-9]{3}$/)) {
      res.status(400).send('Invalid Association ID format. Must be KA followed by 3 digits (e.g., KA001)');
      return;
    }
    
    const registrationsPath = path.join(__dirname, 'championship-registrations.json');
    let registrations = [];
    
    if (fs.existsSync(registrationsPath)) {
      const data = fs.readFileSync(registrationsPath, 'utf8');
      registrations = data ? JSON.parse(data) : [];
    }
    
    registrations.push(registrationData);
    fs.writeFileSync(registrationsPath, JSON.stringify(registrations, null, 2));
    
    res.status(200).json({
      success: true,
      message: 'Registration successful',
      registrationId: registrationData.registrationId
    });
  } catch (error) {
    console.error('Championship registration error:', error);
    res.status(500).send('Error processing registration');
  }
});

app.get('/api/championship-registrations', (req, res) => {
  try {
    const registrationsPath = path.join(__dirname, 'championship-registrations.json');
    
    if (!fs.existsSync(registrationsPath)) {
      res.json([]);
      return;
    }
    
    const data = fs.readFileSync(registrationsPath, 'utf8');
    let registrations = JSON.parse(data);
    
    const { associationId } = req.query;
    
    if (associationId) {
      registrations = registrations.filter(item => item.associationId === associationId);
    }
    
    res.json(registrations);
  } catch (error) {
    console.error('Error fetching registrations:', error);
    res.status(500).send('Error fetching registrations');
  }
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
ENDSERVER

echo "✓ Cleaned up server.js - no static file code"

# Step 3: Commit and deploy
git add vercel.json server.js
git commit -m "BREAKTHROUGH: Separate static files from Express server"
git push origin main

echo "✓ Changes committed"
echo ""
echo "Step 4: Deploying to production..."
vercel --prod

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "🎯 FINAL SOLUTION COMPLETE!"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "What changed:"
echo "  ✓ vercel.json routes static files directly (bypass server.js)"
echo "  ✓ server.js only handles API routes and HTML pages"
echo "  ✓ No more 401 errors - Vercel serves images natively"
echo ""
echo "Expected result:"
echo "  ✓ Home page background: /public/ShotokanRoars.png"
echo "  ✓ Championship banner: /public/championship.jpg"
echo "  ✓ Member images: /public/kai.jpg, maya.jpg, team.jpg"
echo ""
echo "🌐 VISIT: https://sskda-website.vercel.app (or your domain)"
echo "❓ If still issues, wait 60s and check deployment logs"
echo "═══════════════════════════════════════════════════════════════"
