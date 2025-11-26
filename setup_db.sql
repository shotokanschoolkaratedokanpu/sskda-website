CREATE DATABASE sskda_website;
CREATE USER 'sskda_user'@'localhost' IDENTIFIED BY 'sskda_local_pass';
GRANT ALL PRIVILEGES ON sskda_website.* TO 'sskda_user'@'localhost';
FLUSH PRIVILEGES;
Use sskda_website;