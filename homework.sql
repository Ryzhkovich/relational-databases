show databases;
use shop;
show tables;
select * from users u WHERE id = 1; 
-- ниже мой вывод из БД - shop, таблица - users
-- 1	Геннадий	1990-10-05	2021-03-21 15:27:25	2021-03-21 15:27:25


-- START - Практическое задание по теме “Транзакции, переменные, представления” 

-- 1) В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. 
-- Используйте транзакции.
DROP DATABASE IF EXISTS sample;
CREATE DATABASE sample;
USE sample;

DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	birthday_at DATE DEFAULT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
-- смотрим что пока пусто
SELECT * FROM users;
-- транзакция
START TRANSACTION;
INSERT INTO sample.users (SELECT * FROM shop.users WHERE id = 1);
COMMIT;
-- проверяем что теперь там есть одна необходимая запись
SELECT * FROM users;

-- 2) Создайте представление, 
-- которое выводит название name товарной позиции из таблицы products 
-- и соответствующее название каталога name из таблицы catalogs.

use shop;
select * from products p;
SELECT * from catalogs c;

-- сам запрос, который надо будет 
SELECT p.name, c.name 
from products p 
left join catalogs c 
on p.catalog_id = c.id 

-- сохранение данные в представление - prod_plus_cat
CREATE or REPLACE VIEW prod_plus_cat(prod_name, cat_name) as 
(SELECT p.name, c.name 
from products p 
left join catalogs c 
on p.catalog_id = c.id);

-- проверка представления
SELECT * FROM prod_plus_cat;

-- END - Практическое задание по теме “Транзакции, переменные, представления” 

-- START  - Практическое задание по теме “Хранимые процедуры и функции, триггеры"

-- 1) Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
-- с 18:00 до 00:00 — "Добрый вечер", 
-- с 00:00 до 6:00 — "Доброй ночи".

-- тут я тренировался =)
DROP PROCEDURE IF EXISTS dorepeat;
delimiter //
CREATE PROCEDURE dorepeat(p1 INT)
BEGIN
  SET @x = 0;
  REPEAT SET @x = @x + 1; UNTIL @x > p1 END REPEAT;
END
//
delimiter ;
CALL dorepeat(1000);
SELECT @x;



DROP PROCEDURE IF EXISTS hello;
delimiter // 
CREATE PROCEDURE hello()
BEGIN
	IF(CURTIME() BETWEEN '06:00:00' AND '12:00:00') THEN
		SELECT 'Доброе утро';
	ELSEIF(CURTIME() BETWEEN '12:00:00' AND '18:00:00') THEN
		SELECT 'Добрый день';
	ELSEIF(CURTIME() BETWEEN '18:00:00' AND '00:00:00') THEN
		SELECT 'Добрый вечер';
	ELSE
		SELECT 'Доброй ночи';
	END IF;
END //
delimiter ;

CALL hello();
SELECT CURTIME();

-- 2) В таблице products есть два текстовых поля: 
-- name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. 
-- Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.

-- 45000 - код для пользовательской ошибки
-- FOR EACH ROW - для кадъждого столбца, как в примере из методички
DROP TRIGGER IF EXISTS nullTrigger;
delimiter //
CREATE TRIGGER nullTrigger BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF(ISNULL(NEW.name) AND ISNULL(NEW.description)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trigger Warning! NULL in both fields!';
	END IF;
END //
delimiter ;

-- FAIL
INSERT INTO products (name, description, price, catalog_id)
VALUES (NULL, NULL, 50000, 2); 
-- SUCCESS
INSERT INTO products (name, description, price, catalog_id)
VALUES ("GeForce GTX 2080", NULL, 15000, 1); 


-- END  - Практическое задание по теме “Хранимые процедуры и функции, триггеры"







