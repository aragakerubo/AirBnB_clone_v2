-- Script that prepares a MySQL server for the project

-- Create the database
CREATE DATABASE IF NOT EXISTS `hbnb_test_db` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

-- Create the user
CREATE USER IF NOT EXISTS 'hbnb_test'@'localhost' IDENTIFIED BY 'hbnb_test_pwd';

-- Grant privileges ALL PRIVILEGES to the user on hbnb_test_db
GRANT ALL PRIVILEGES ON `hbnb_test_db`.* TO 'hbnb_test'@'localhost';

-- Grant SELECT privileges to the user on performance_schema
GRANT SELECT ON `performance_schema`.* TO 'hbnb_test'@'localhost';

-- Flush privileges
FLUSH PRIVILEGES;