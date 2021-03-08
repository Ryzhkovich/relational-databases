-- создаем БД sample, чтобы после в нее вставлять данные дампа
DROP DATABASE IF EXISTS sample;
CREATE DATABASE sample;

-- Создаем БД example и переключаемся на нее
DROP DATABASE IF EXISTS example;
CREATE DATABASE example;
USE example;

-- Создаем таблицу users
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	-- сделал сразу рекомендуемым способом из 2го видео-урока, 
	-- но в закоменченном виде оставляю 2й вариант реализации
	id SERIAL PRIMARY KEY, 
	-- id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(255) COMMENT 'Имя пользователя'
) COMMENT = 'Пользователи';

-- Добавляю своего пользователя в таблицу users, чтоб не было пустой таблицы
INSERT INTO users VALUES (NULL, 'Саша Рыжкович');

-- Проверяем наличие добавленной записи
SELECT * FROM users;

