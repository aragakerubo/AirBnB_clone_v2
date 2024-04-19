-- Script that prepares a MySQL server for the project

-- Create the database
CREATE DATABASE IF NOT EXISTS `hbnb_dev_db` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

-- Create the user
CREATE USER IF NOT EXISTS 'hbnb_dev'@'localhost' IDENTIFIED BY 'hbnb_dev_pwd';

-- Grant privileges ALL PRIVILEGES to the user on hbnb_dev_db
GRANT ALL PRIVILEGES ON `hbnb_dev_db`.* TO 'hbnb_dev'@'localhost';

-- Grant SELECT privileges to the user on performance_schema
GRANT SELECT ON `performance_schema`.* TO 'hbnb_dev'@'localhost';

-- Flush privileges
FLUSH PRIVILEGES;