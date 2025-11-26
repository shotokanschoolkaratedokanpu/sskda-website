# Local Setup Instructions

## ✅ Current Status

PHP, MySQL, and Apache are installed. The `config.php` has been configured for local development.

## 🗄️ Database Setup Required

Since MySQL requires a password, please follow these steps:

### Step 1: Create Database and User

Open a new terminal and run:

```bash
mysql -u root -p
```

Enter your MySQL root password when prompted.

Then in the MySQL prompt, copy and paste these commands:

```sql
CREATE DATABASE sskda_website;
CREATE USER 'sskda_user'@'localhost' IDENTIFIED BY 'sskda_local_pass';
GRANT ALL PRIVILEGES ON sskda_website.* TO 'sskda_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### Step 2: Import Database Data

In your terminal, run:

```bash
mysql -u sskda_user -p'sskda_local_pass' sskda_website < database/import.sql
```

### Step 3: Test Database Connection

```bash
curl http://localhost:8000/api/achievements.php
```

Should return JSON data with achievements.

## 🚀 How to Start the Server

1. Open a terminal in `/home/ailove/Downloads/SSKDA_Website`
2. Run: `./quick-start.sh`
3. Open browser: http://localhost:8000/pages/index.html

## 📁 Project Structure

- `pages/` - HTML pages (index, achievements, registration)
- `api/` - PHP API endpoints
- `includes/` - Configuration files
- `database/import.sql` - Initial database data
- `image_assets/` - Images and assets
- `uploads/` - File upload directory

## 🧪 Testing URLs

- Homepage: http://localhost:8000/pages/index.html
- Achievements API: http://localhost:8000/api/achievements.php
- Registrations API: http://localhost:8000/api/registrations.php
- Member Achievements: http://localhost:8000/pages/member-achievements.html
- Championship Registration: http://localhost:8000/pages/championship-registration.html