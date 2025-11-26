# ✅ SSKDA Website - Local Setup COMPLETE

## 🎉 Current Status: RUNNING

**Website is live at:** http://localhost:8000

### 🚀 Quick Access Links

- **Homepage:** http://localhost:8000/pages/index.html
- **Status Page:** http://localhost:8000/website-status.php
- **API (Raw):** http://localhost:8000/api/achievements.php
- **API (GET):** http://localhost:8000/api/achievements-get.php

### 📊 Database Status

✅ **Database:** `sskda_website` created with 9 achievements
✅ **Tables:** `achievements` and `championship_registrations` created
✅ **Sample Data:** 8 athlete records from 2024 championships loaded

### 🛠️ Project Information

**MySQL Login:** Use socket authentication
- Database: `sskda_website`
- User: `ailove` (your system user)
- Authentication: Auth Socket (no password needed)

**PHP Server:** Running on port 8000
- PHP Version: 8.1.2
- Server: Built-in PHP development server

**Configuration File:**
- Location: `/home/ailove/Downloads/SSKDA_Website/includes/config.php`
- DB User: `ailove` (your system username)
- DB Pass: `` (empty - uses socket auth)

### 🔧 Maintenance Commands

**Start server:**
```bash
cd /home/ailove/Downloads/SSKDA_Website
php -S localhost:8000
```

**Check database (from terminal):**
```bash
mysql -u ailove sskda_website
mysql> SELECT COUNT(*) FROM achievements;
```

**Restart server:**
```bash
pkill -f "php -S"
php -S localhost:8000
```

### 📁 Project Structure

```
SSKDA_Website/
├── pages/           # HTML pages (homepage, achievements, registration)
├── api/            # PHP API endpoints
├── includes/       # Configuration files (config.php)
├── database/       # Database schema (import.sql)
├── image_assets/   # Karate images and assets
├── uploads/        # File upload directory
└── *.sh           # Setup scripts (launch.sh, socket-setup.sh, etc.)
```

### 🐛 Troubleshooting

If you see "Access denied for user" error:
1. Database setup succeeded, but PHP is trying password auth
2. Current user 'ailove' uses socket auth (no password)
3. Fix: Update includes/config.php DB_PASS to empty string

If API returns errors:
1. Check http://localhost:8000/website-status.php
2. Verify MySQL is running: `mysql -V`
3. Check database exists: `mysql -u ailove -e "SHOW DATABASES"`

If port 8000 is already in use:
```bash
pkill -f "php -S"
```

### 📈 Sample Data Loaded

9 achievements from "All Island Karate Championship 2024":
- Male Under-21 Individual Kata
- Male Under-21 Individual Kumite
- Female Under-21 Individual Kata

All medal types (Gold, Silver, Bronze) represented.