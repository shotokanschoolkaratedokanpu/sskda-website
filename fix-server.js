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

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Explicit routes for HTML pages (Vercel serverless compatibility)
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

// Handle achievement submission
app.post('/submit-achievement', upload.single('achievementImage'), (req, res) => {
  try {
    const { athlete, competition, category, achievement, year, type, associationId } = req.body;
    
    // Validate association ID
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
    
    // Read existing achievements
    const achievementsPath = path.join(__dirname, 'achievements.json');
    const data = fs.readFileSync(achievementsPath, 'utf8');
    const achievements = data ? JSON.parse(data) : [];
    
    // Add new achievement
    achievements.push(newAchievement);
    
    // Write updated data back
    fs.writeFileSync(achievementsPath, JSON.stringify(achievements, null, 2));
    
    // Redirect to member achievements
    res.redirect(`/member-achievements.html?associationId=${associationId}`);
  } catch (error) {
    res.status(500).send('Error submitting achievement');
  }
});

// API endpoint for achievements with filtering
app.get('/api/achievements', (req, res) => {
  const achievementsPath = path.join(__dirname, 'achievements.json');
  const data = fs.readFileSync(achievementsPath, 'utf8');
  let achievements = JSON.parse(data);
  
  const { type, year, search, associationId } = req.query;
  
  // Filter by association ID if provided
  if (associationId) {
    achievements = achievements.filter(item => item.associationId === associationId);
  }
  
// Apply type filter
  if (type && type !== 'all') {
    achievements = achievements.filter(item => item.type === type);
  }
  
  // Apply year filter
  if (year && year !== 'all') {
    achievements = achievements.filter(item => item.year === year);
  }
  
  
  // Apply search filter
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

// API endpoint for championship registration
app.post('/api/championship-registration', (req, res) => {
  try {
    const registrationData = {
      ...req.body,
      registrationDate: new Date().toISOString(),
      registrationId: 'CHAMP' + Date.now()
    };
    
    // Validate required fields
    const requiredFields = ['firstName', 'lastName', 'dob', 'gender', 'email', 'phone', 'associationId', 'belt', 'category', 'ageGroup', 'emergencyName', 'emergencyPhone'];
    for (const field of requiredFields) {
      if (!registrationData[field]) {
        res.status(400).send(`Missing required field: ${field}`);
        return;
      }
    }
    
    // Validate association ID
    if (!registrationData.associationId.match(/^KA[0-9]{3}$/)) {
      res.status(400).send('Invalid Association ID format. Must be KA followed by 3 digits (e.g., KA001)');
      return;
    }
    
    // Read existing registrations or create new file
    const registrationsPath = path.join(__dirname, 'championship-registrations.json');
    let registrations = [];
    
    if (fs.existsSync(registrationsPath)) {
      const data = fs.readFileSync(registrationsPath, 'utf8');
      registrations = data ? JSON.parse(data) : [];
    }
    
    // Add new registration
    registrations.push(registrationData);
    
    // Write updated data back
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

// API endpoint to get championship registrations
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
    
    // Filter by association ID if provided
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
