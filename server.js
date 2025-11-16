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

// Serve static files from root and subdirectories
// In Vercel serverless functions, we need to be explicit about static asset serving
app.use(express.static(__dirname, { 
  dotfiles: 'ignore',
  etag: true,
  extensions: ['html', 'htm'],
  index: ['index.html', 'index.htm'],
  maxAge: '1d',
  redirect: true,
  setHeaders: function(res, path, stat) {
    res.set('x-timestamp', Date.now());
  }
}));

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});