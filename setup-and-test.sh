#!/bin/bash
  set -e  # Exit on error

  echo "╔══════════════════════════════════════════════════════
  ════════╗"
  echo "║     SSKDA PHP Website - Setup Script
        ║"
  echo "╚══════════════════════════════════════════════════════
  ════════╝"
  echo ""

  # Step 1: Check MySQL
  echo "🔐 Step 1: Checking MySQL root password..."
  if sudo mysql -u root -e "SELECT 1" >/dev/null 2>&1; then
      echo "✅ MySQL root password already set"
  else
      echo "Please run: sudo mysql_secure_installation"
      echo "Then re-run this script"
      exit 1
  fi
  echo ""

  # Step 2: Create DB and user
  echo "🗄️  Step 2: Creating database and user..."
  DB_PASS=$(openssl rand -base64 12)
  echo "Password: $DB_PASS"

  # Use separate MySQL commands
  echo "CREATE DATABASE IF NOT EXISTS sskda_website;" | sudo my
  sql -u root
  echo "CREATE USER IF NOT EXISTS 'sskda_user'@'localhost' IDEN
  TIFIED BY '$DB_PASS';" | sudo mysql -u root
  echo "GRANT ALL PRIVILEGES ON sskda_website.* TO 'sskda_user'
  @'localhost';" | sudo mysql -u root
  echo "FLUSH PRIVILEGES;" | sudo mysql -u root
  echo "✅ Database and user created"
  echo ""

  # Step 3: Import data
  echo "📥 Step 3: Importing data..."
  if [ -f "database/import.sql" ]; then
      mysql -u sskda_user -p"$DB_PASS" sskda_website < database
  /import.sql
      echo "✅ Data imported"
  else
      echo "❌ database/import.sql not found"
      exit 1
  fi
  echo ""

  # Step 4: Update config.php
  echo "⚙️  Step 4: Updating config.php..."
  if [ -f "includes/config.php" ]; then
      cp includes/config.php includes/config.php.backup
      sudo sed -i "s/'if0_database'/'sskda_website'/g" includes
  /config.php
      sudo sed -i "s/'if0_user'/'sskda_user'/g" includes/config
  .php
      sudo sed -i "s/'your_password'/'$DB_PASS'/g" includes/con
  fig.php
      sudo sed -i "s|'https://yoursite.epizy.com'|'http://local
  host:8000'|g" includes/config.php
      echo "✅ config.php updated"
  else
      echo "❌ includes/config.php not found"
      exit 1
  fi
  echo ""

  # Step 5: Copy files
  echo "📂 Step 5: Copying files..."
  sudo rm -rf /var/www/html/sskda
  sudo mkdir -p /var/www/html/sskda
  sudo cp -r ./* /var/www/html/sskda/
  sudo chown -R www-data:www-data /var/www/html/sskda
  sudo chmod -R 755 /var/www/html/sskda
  sudo chmod 755 /var/www/html/sskda/uploads
  echo "✅ Files copied to /var/www/html/sskda"
  echo ""

  # Step 6: Create start script
  echo "🚀 Step 6: Creating start script..."
  sudo tee /tmp/start-server.sh > /dev/null <<'EOF'
  #!/bin/bash
  cd /var/www/html/sskda
  sudo php -S localhost:8000
  EOF
  sudo chmod +x /tmp/start-server.sh

  sudo tee /tmp/stop-server.sh > /dev/null <<'EOF'
  #!/bin/bash
  sudo pkill -f "php -S localhost:8000"
  EOF
  sudo chmod +x /tmp/stop-server.sh

  echo "✅ Start script: /tmp/start-server.sh"
  echo "✅ Stop script:  /tmp/stop-server.sh"
  echo ""

  # Step 7: Verify database
  echo "🔍 Step 7: Verifying database..."
  COUNT=$(mysql -u sskda_user -p"$DB_PASS" -e "SELECT COUNT(*)
  FROM sskda_website.achievements;" -s -N)
  if [ "$COUNT" -eq 11 ]; then
      echo "✅ Database verified: $COUNT achievements"
  else
      echo "⚠️  Expected 11, found: $COUNT"
  fi
  echo ""

  echo "╔══════════════════════════════════════════════════════
  ════════╗"
  echo "║                    🎉 SETUP COMPLETE!               …
         ║"
  echo "╚══════════════════════════════════════════════════════
  ════════╝"
  echo ""
  echo "🚀 TO START SERVER:"
  echo "   /tmp/start-server.sh"
  echo ""
  echo "🧪 TO TEST:"
  echo "   curl -s http://localhost:8000/api/achievements-get.p
  hp"
  echo "   curl -I http://localhost:8000/image_assets/ShotokanR
  oars.png"
  echo ""

  # Save password
  echo "$DB_PASS" > /tmp/sskda-password.txt
  sudo chmod 600 /tmp/sskda-password.txt
  echo "✅ Password saved: /tmp/sskda-password.txt"
  SCRIPT