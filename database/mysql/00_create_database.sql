-- Run as a MySQL administrator. Replace database/user/password values before use.
CREATE DATABASE IF NOT EXISTS `rekabet`
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'rekabet_app'@'localhost'
    IDENTIFIED BY 'CHANGE_THIS_TO_A_LONG_RANDOM_PASSWORD';

GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, DROP,
      REFERENCES, TRIGGER, CREATE TEMPORARY TABLES, LOCK TABLES
    ON `rekabet`.* TO 'rekabet_app'@'localhost';

FLUSH PRIVILEGES;
