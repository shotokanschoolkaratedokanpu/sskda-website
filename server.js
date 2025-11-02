const express = require('express');
const multer = require('multer');
const fs = require('fs');
const path = require('path');
const app = express();
const port = 3000;

// Remove anime require from server.js (client-side only)

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

// Serve static files
app.use(express.static(__dirname));
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Explicit root route for environments that skip static index fallback
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
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

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});