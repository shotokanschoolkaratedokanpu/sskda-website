# Local Testing Requirements

Your system currently doesn't have PHP, MySQL, or a web server installed. To test the website locally, you need to install these.

---

## Option 1: Install XAMPP (Easiest - Everything in One Package)

**What it is:** XAMPP bundles Apache (web server) + PHP + MySQL + phpMyAdmin in one install.

### For **Ubuntu/Debian Linux:**

```bash
# Download XAMPP
wget https://www.apachefriends.org/xampp-files/8.2.4/xampp-linux-x64-8.2.4-0-installer.run

# Make it executable
sudo chmod +x xampp-linux-x64-8.2.4-0-installer.run

# Run installer
sudo ./xampp-linux-x64-8.2.4-0-installer.run

# Start XAMPP
sudo /opt/lampp/lampp start

# Verify services are running
sudo /opt/lampp/lampp status
```

**Quick test after installing:**
```bash
# Open browser to:
# http://localhost (should show XAMPP dashboard)
```

### For **Windows:**

1. Download XAMPP from: https://www.apachefriends.org/download.html
2. Run the installer (choose PHP 8.0+ version)
3. Check boxes: Apache, PHP, MySQL, phpMyAdmin
4. Complete installation
5. Open XAMPP Control Panel
6. Click "Start" next to Apache and MySQL

### For **macOS:**

1. Download XAMPP from: https://www.apachefriends.org/download.html
2. Open the DMG file
3. Drag XAMPP folder to Applications
4. Open Terminal:
```bash
sudo /Applications/XAMPP/xamppfiles/xampp start
```

---

## Option 2: Install Individual Components (For Advanced Users)

### Install PHP 8.0+:

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install php8.2 php8.2-mysql php8.2-curl php8.2-gd php8.2-mbstring

# Verify
php -v  # Should show PHP 8.2.x
```

**CentOS/RHEL/Fedora:**
```bash
sudo dnf install epel-release
sudo dnf install php php-mysqlnd php-gd php-mbstring

# Verify
php -v
```

**macOS:**
```bash
brew install php

# Verify
php -v
```

### Install MySQL Server:

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install mysql-server

# Start MySQL
sudo systemctl start mysql
sudo systemctl enable mysql

# Secure installation (set root password)
sudo mysql_secure_installation

# Verify
sudo mysql -u root -p
# (enter password, should see mysql> prompt)
```

**CentOS/RHEL/Fedora:**
```bash
sudo dnf install mysql-server
sudo systemctl start mysqld
sudo systemctl enable mysqld
sudo mysql_secure_installation
```

**macOS:**
```bash
brew install mysql
brew services start mysql
mysql_secure_installation
```

### Install Apache:

**Ubuntu/Debian:**
```bash
sudo apt install apache2
sudo systemctl start apache2
sudo systemctl enable apache2

# Verify
sudo systemctl status apache2
# Open browser: http://localhost (should show Apache default page)
```

**CentOS/RHEL/Fedora:**
```bash
sudo dnf install httpd
sudo systemctl start httpd
sudo systemctl enable httpd
```

**macOS:**
Apache is pre-installed. Start it with:
```bash
sudo apachectl start
# Open browser: http://localhost
```

---

## After Installing PHP/MySQL/Apache:

### Step 1: Set Up the Website

```bash
# Copy files to Apache's web root
sudo cp -r /home/ailove/Downloads/SSKDA_Website/* /var/www/html/

# Set proper permissions
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
sudo chmod 755 /var/www/html/uploads/
```

### Step 2: Create MySQL Database

```bash
# Login to MySQL
mysql -u root -p

# In MySQL prompt, run:
CREATE DATABASE sskda_website;
CREATE USER 'sskda_user'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON sskda_website.* TO 'sskda_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;

# Import the schema
mysql -u sskda_user -p sskda_website < /var/www/html/database/import.sql
```

### Step 3: Configure Database

```bash
# Edit the config file
sudo nano /var/www/html/includes/config.php

# Change these lines:
// OLD:
define('DB_HOST', 'sql---.infinityfree.com');
define('DB_NAME', 'if0_database');
define('DB_USER', 'if0_user');
define('DB_PASS', 'your_password');

// NEW (for local testing):
define('DB_HOST', 'localhost');
define('DB_NAME', 'sskda_website');
define('DB_USER', 'sskda_user');
define('DB_PASS', 'your_secure_password');
define('SITE_URL', 'http://localhost');
```

### Step 4: Configure Apache

If you want to use clean URLs (without .php extensions), enable mod_rewrite:

```bash
sudo a2enmod rewrite
sudo systemctl restart apache2

# Edit Apache config to allow .htaccess
sudo nano /etc/apache2/apache2.conf

# Find <Directory /var/www/> section and change:
# FROM:
# AllowOverride None
# TO:
AllowOverride All

# Save and exit
sudo systemctl restart apache2
```

---

## Step 5: Test the Website

### Start the PHP development server (easiest for testing):

```bash
cd /var/www/html
sudo php -S localhost:8000
```

**In your browser, visit:**
- Homepage: http://localhost:8000/pages/index.html
- Achievements API: http://localhost:8000/api/achievements.php
- Achievements Page: http://localhost:8000/pages/member-achievements.html
- Registration Page: http://localhost:8000/pages/championship-registration.html

### Verify database connection:

```bash
# In browser, visit: http://localhost:8000/api/achievements.php
# Should return JSON with 11 achievements
```

---

## Option 3: Use Docker (If You're Familiar With It)

```bash
# Create a docker-compose.yml file
cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  web:
    image: php:8.2-apache
    ports:
      - "8000:80"
    volumes:
      - ./:/var/www/html/
    depends_on:
      - db
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: sskda_website
      MYSQL_USER: sskda_user
      MYSQL_PASSWORD: sskdapass
    ports:
      - "3306:3306"
EOF

# Start containers
docker-compose up -d

# Import database
docker exec -i sskda-website_db_1 mysql -usskda_user -psskdapass sskda_website < database/import.sql

# Edit config.php for Docker connection
sudo nano includes/config.php
# Set: define('DB_HOST', 'db');  # 'db' is the service name

# Test: http://localhost:8000/pages/index.html
```

---

## Quick Check: What I Need From You

To test locally, I need:

### Essential:
1. ✅ **PHP 8.0+ installed** (`php -v` shows version)
2. ✅ **MySQL/MariaDB installed** (`mysql -V` shows version)
3. ✅ **Apache or Nginx installed** (or use PHP built-in server)

### Nice to Have:
4. ✅ **phpMyAdmin** (web UI for MySQL - makes life easier)
5. ✅ **FileZilla** (if you want to test FTP uploads)

---

## 🚀 Easiest Option (If You're New to This)

**Use 000webhost.com instead of local testing:**

1. Sign up: https://www.000webhost.com/ (free)
2. Create a new website
3. You'll get:
   - PHP 8.0+ (pre-installed)
   - MySQL (pre-installed)
   - Web server (pre-configured)
   - FTP access
4. Upload files via their web UI
5. Import database via phpMyAdmin
6. Test live in 10 minutes!

**Advantages:**
- No installation headaches
- Matches production environment
- Easier to show others
- Can access from any device

---

## 📋 Tell Me What You Have:

Please run these commands and tell me the output:

```bash
# Check if PHP is installed
php -v

# Check if MySQL is installed
mysql -V

# Check if Apache/Nginx is installed
apache2 -v  # OR
nginx -v    # OR
httpd -v
```

**Based on your answers, I'll give you the exact next steps to test locally!**
