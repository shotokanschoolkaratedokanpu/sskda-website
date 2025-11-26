# InfinityFree Migration Plan - Node.js/Express to PHP/MySQL

## ⚠️ CRITICAL: InfinityFree DOES NOT Support Node.js/Express

**InfinityFree Free Hosting Only Supports:**
- ✅ PHP (backend scripting)
- ✅ MySQL (databases)
- ✅ Apache Web Server
- ✅ Static Files (HTML, CSS, JS, Images)
- ❌ Node.js (not supported)
- ❌ Express.js (not supported)
- ❌ Persistent server processes (not allowed)

---

## 📋 Required Codebase Changes

### 1. Backend: Convert Express/Node.js → PHP

**Current:** `server.js` (Express.js with 267 lines)
**New:** Multiple PHP files for each endpoint

#### PHP File Structure:
```
/
├── index.php              # Main entry point
├── api/
│   ├── achievements.php   # GET/POST achievements
│   ├── registrations.php  # GET/POST championship registrations
│   └── upload.php         # File upload handler
├── includes/
│   ├── config.php         # MySQL connection settings
│   ├── db.php             # Database connection class
│   └── functions.php      # Common functions
├── uploads/               # User uploaded images
├── image_assets/          # Static images
├── html/
│   ├── index.html         # Static pages remain
│   ├── register.html
│   ├── member-achievements.html
│   └── ...
└── .htaccess              # URL rewriting rules
```

---

### 2. Database: Convert JSON → MySQL

**Current:** JSON files (`achievements.json`, `championship-registrations.json`)
**New:** MySQL tables

#### SQL Schema:

**Table: `achievements`**
```sql
CREATE TABLE achievements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    athlete VARCHAR(255) NOT NULL,
    competition VARCHAR(255) NOT NULL,
    category VARCHAR(255) NOT NULL,
    achievement VARCHAR(255) NOT NULL,
    year YEAR NOT NULL,
    type ENUM('kata', 'kumite', 'team', 'individual') NOT NULL,
    medal ENUM('gold', 'silver', 'bronze', '') DEFAULT '',
    associationId VARCHAR(10) NOT NULL,
    image VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Table: `championship_registrations`**
```sql
CREATE TABLE championship_registrations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    dob DATE NOT NULL,
    gender ENUM('male', 'female') NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    associationId VARCHAR(10) NOT NULL,
    belt VARCHAR(50),
    category VARCHAR(100),
    ageGroup VARCHAR(50),
    emergencyName VARCHAR(200),
    emergencyPhone VARCHAR(20),
    registrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    registrationId VARCHAR(100) UNIQUE NOT NULL
);
```

---

### 3. API Endpoints: Convert Express Routes → PHP Scripts

**Current:** `app.get('/api/achievements', ...)`
**New:** Separate PHP files

#### GET Achievements (`api/achievements.php`):
```php
<?php
header('Content-Type: application/json');
require_once '../includes/db.php';

$db = new Database();
$conn = $db->getConnection();

// Build query based on filters
$sql = "SELECT * FROM achievements WHERE 1=1";
$params = [];
$types = "";

if (isset($_GET['associationId'])) {
    $sql .= " AND associationId = ?";
    $params[] = $_GET['associationId'];
    $types .= "s";
}

if (isset($_GET['type']) && $_GET['type'] !== 'all') {
    $sql .= " AND type = ?";
    $params[] = $_GET['type'];
    $types .= "s";
}

// Execute prepared statement
$stmt = $conn->prepare($sql);
if ($params) {
    $stmt->bind_param($types, ...$params);
}
$stmt->execute();
$result = $stmt->get_result();

$achievements = [];
while ($row = $result->fetch_assoc()) {
    $achievements[] = $row;
}

echo json_encode($achievements);
?>
```

---

### 4. File Uploads: Convert Multer → PHP

**Current:** `multer` middleware in Node.js
**New:** PHP `$_FILES` handling

#### File Upload (`api/upload.php`):
```php
<?php
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit;
}

$uploadDir = '../uploads/';
if (!file_exists($uploadDir)) {
    mkdir($uploadDir, 0755, true);
}

if (isset($_FILES['achievementImage'])) {
    $file = $_FILES['achievementImage'];
    $filename = time() . '-' . basename($file['name']);
    $uploadPath = $uploadDir . $filename;
    
    if (move_uploaded_file($file['tmp_name'], $uploadPath)) {
        echo json_encode(['success' => true, 'path' => '/uploads/' . $filename]);
    } else {
        http_response_code(500);
        echo json_encode(['error' => 'File upload failed']);
    }
}
?>
```

---

### 5. Static File Serving: Apache .htaccess

**Current:** Express static middleware
**New:** Apache `.htaccess` configuration

#### `.htaccess` File:
```apache
# Enable URL rewriting
RewriteEngine On

# Redirect API calls to PHP files
RewriteRule ^api/achievements$ api/achievements.php [L]
RewriteRule ^api/championship-registration$ api/registrations.php [L]
RewriteRule ^api/championship-registrations$ api/registrations.php [L]
RewriteRule ^api/upload$ api/upload.php [L]

# Serve static files directly
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^.*$ index.php [L]

# Enable CORS
Header set Access-Control-Allow-Origin "*"
Header set Access-Control-Allow-Methods "GET, POST, OPTIONS"
Header set Access-Control-Allow-Headers "Content-Type"
```

---

### 6. HTML Pages: Update Form Actions & API Calls

**Current:** `action="/submit-achievement"` (Express route)
**New:** `action="api/submit-achievement.php"` (PHP script)

#### Changes needed:
1. **Form Actions:**
   ```html
   <!-- Before -->
   <form action="/submit-achievement" method="POST" enctype="multipart/form-data">
   
   <!-- After -->
   <form action="api/submit-achievement.php" method="POST" enctype="multipart/form-data">
   ```

2. **JavaScript API Calls:**
   ```javascript
   // Before
   fetch('/api/achievements')
   
   // After (same path, but handled by PHP via .htaccess)
   fetch('/api/achievements.php')
   // OR keep as /api/achievements with .htaccess rewrite
   ```

3. **Image Paths:** Already updated to `/image_assets/` ✓

---

### 7. Security Considerations

**MySQL Injection Prevention:**
- ✅ Use prepared statements (shown in examples above)
- ✅ Validate all user inputs
- ✅ Sanitize file uploads (check file types, size limits)

**File Upload Security:**
```php
$allowedTypes = ['image/jpeg', 'image/png', 'image/gif'];
$maxSize = 5 * 1024 * 1024; // 5MB

if (!in_array($file['type'], $allowedTypes)) {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid file type']);
    exit;
}

if ($file['size'] > $maxSize) {
    http_response_code(400);
    echo json_encode(['error' => 'File too large']);
    exit;
}
```

---

## 📊 Work Required Summary

### Estimated Effort: 4-6 hours

**Priority 1 - Critical (Backend):**
- [ ] Create MySQL database on InfinityFree (30 min)
- [ ] Create PHP database connection class (15 min)
- [ ] Convert `server.js` (267 lines) to PHP endpoints (2-3 hours)
  - [ ] `api/achievements.php` - GET/POST achievements
  - [ ] `api/registrations.php` - GET/POST championship registrations
  - [ ] `api/upload.php` - File upload handler
  - [ ] `includes/functions.php` - Common utilities

**Priority 2 - Database:**
- [ ] Convert achievements.json to MySQL schema (15 min)
- [ ] Convert championship-registrations.json to MySQL schema (15 min)
- [ ] Write PHP script to import existing JSON data to MySQL (30 min)

**Priority 3 - Frontend:**
- [ ] Update HTML form actions to point to PHP files (30 min)
- [ ] Update any JavaScript fetch URLs if needed (15 min)
- [ ] Test all pages load correctly (15 min)

**Priority 4 - Configuration:**
- [ ] Create `.htaccess` URL rewrite rules (15 min)
- [ ] Create `config.php` with database credentials (15 min)
- [ ] Test file upload functionality (15 min)
- [ ] Set proper file permissions (15 min)

**Priority 5 - Testing:**
- [ ] Test all forms (registration, achievement submission) (30 min)
- [ ] Test file uploads (15 min)
- [ ] Test API endpoints (15 min)
- [ ] Verify image serving (15 min)

---

## 🎯 Decision Point: Should We Migrate?

### **Alternative 1: Keep Node.js - Use Different Host**
If you want to keep the Express.js backend, use:
- ✅ Vercel (current - free tier available)
- ✅ Railway.app (free tier available)
- ✅ Render.com (free tier available)
- ✅ Heroku (with free alternatives)

**Pros:**
- No code rewrite needed
- Keep current architecture
- Faster development

**Cons:**
- Different host than InfinityFree
- May have usage limits

---

### **Alternative 2: Migrate to PHP/MySQL**
**Pros:**
- ✅ InfinityFree is truly free (no time limits)
- ✅ PHP/MySQL is production-proven
- ✅ More job market demand
- ✅ Easier to find hosting in future

**Cons:**
- ❌ Requires complete backend rewrite (4-6 hours)
- ❌ Need to learn PHP/MySQL specifics
- ❌ Testing required to ensure everything works

---

### **Alternative 3: Static Site with JavaScript**
Convert to static HTML + JavaScript only:
- ✅ Use client-side JavaScript for dynamic content
- ✅ Store data in localStorage or JSON files
- ✅ Upload to InfinityFree as static site

**Limitations:**
- ❌ Cannot save data between users
- ❌ Data lost when clearing browser
- ❌ No centralized database
- ❌ File uploads problematic

**Recommendation:** Not suitable for a multi-user karate association site.

---

## 🚀 My Recommendation

**For a functional karate association website with user registrations and achievement tracking, I recommend either:**

### Option A: **Keep Node.js, Use Vercel** (Easiest)
- Keep current code as-is (it's already working)
- Deploy to Vercel (free tier)
- No code changes needed
- 30 minutes to deploy vs 4-6 hours to rewrite

### Option B: **Migrate to PHP/MySQL** (Sustainable)
- Rewrite backend to PHP/MySQL
- Use InfinityFree (truly free, no time limits)
- More learning opportunity
- Better long-term hosting options

**Time comparison:**
- Vercel deployment: 30 minutes
- PHP migration: 4-6 hours

**Both are viable. Which would you prefer?**

---

## 📚 Resources Needed for PHP Migration

**If you choose to migrate to PHP/MySQL, you'll need:**

1. **InfinityFree Account:**
   - Sign up at https://infinityfree.net
   - Create a new hosting account
   - Note: MySQL database credentials
   - Note: FTP credentials

2. **PHP Resources:**
   - PHP 8.0+ syntax reference
   - MySQLi or PDO for database access
   - PHP file upload handling
   - Basic PHP security practices

3. **Migration Tools:**
   - MySQL client (phpMyAdmin is built into InfinityFree)
   - FileZilla for FTP uploads
   - Text editor for PHP development

---

**I've created the complete migration plan above. Please let me know if you'd like to:**
1. Proceed with PHP/MySQL migration (4-6 hours work)
2. Keep Node.js and deploy to Vercel/Railway/Render (30 minutes)
3. Explore other hosting options

I can help with either approach! Just let me know your preference.