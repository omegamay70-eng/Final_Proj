-- 00_env.sql
-- Environment setup for Best Buy Mini Data Warehouse
DROP DATABASE IF EXISTS bestbuy_dw;
CREATE DATABASE bestbuy_dw CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE bestbuy_dw;

-- Strict SQL mode for safer demos
SET SESSION sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
SET autocommit = 1;

-- Ensure InnoDB is default (server-level setting assumed)
-- SHOW VARIABLES LIKE 'default_storage_engine';
