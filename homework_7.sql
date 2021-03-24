show databases;

use shop;
show tables;

select * from orders o;
select * from users u;

-- заполнение таблицы orders
INSERT INTO orders(user_id) VALUES (1), (3), (5), (1), (4), (1);


-- Задание 1 
-- Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
-- вариант №1 задания 1
select distinct id, name from users u 
where id in (select user_id from orders o);
-- вариант №2 задания 1
select distinct u.id, u.name from users u 
join orders o on u.id = o.user_id;

-- Задание 2
-- Выведите список товаров products и разделов catalogs, который соответствует товару.
select p.id, p.name, p.price, c.id as cat_id, c.name as catalog
from products p
join catalogs c on p.catalog_id = c.id; 

-- Задание 3
-- (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
-- Поля from, to и label содержат английские названия городов, поле name — русское. 
-- Выведите список рейсов flights с русскими названиями городов.

-- создает табличку полетов
DROP TABLE IF EXISTS flights;
CREATE TABLE IF NOT EXISTS flights(
	`id` SERIAL PRIMARY KEY,
	`from` VARCHAR(50) NOT NULL COMMENT 'english name from', 
	`to` VARCHAR(50) NOT NULL COMMENT 'english name to'
);

-- создаем табличку городов
DROP TABLE IF EXISTS cities;
CREATE TABLE  IF NOT EXISTS cities(
	`label` VARCHAR(50) PRIMARY KEY COMMENT 'en', 
	`name` VARCHAR(50) COMMENT 'ru'
);

-- сначала заполняем табличку с городами
INSERT INTO cities VALUES
 	('Moscow', 'Москва'),
 	('Saint Petersburg', 'Санкт-Петербург'),
 	('Novosibirsk', 'Новосибирск'),
 	('Vladivostok', 'Владивосток'),
 	('Sochi', 'Сочи');
 
 -- заполняем таблицу полетов
INSERT INTO flights VALUES
 	(NULL, 'Vladivostok', 'Saint Petersburg'),
 	(NULL, 'Saint Petersburg', 'Novosibirsk'),
 	(NULL, 'Sochi', 'Novosibirsk'),
 	(NULL, 'Novosibirsk', 'Moscow'),
 	(NULL, 'Moscow', 'Sochi');
 
-- запрос решающий задание №3
SELECT
	f.id AS flight_id,
	(SELECT c.name FROM cities c WHERE c.label = f.`from`) AS `from`,
	(SELECT c.name FROM cities c WHERE c.label = f.`to`) AS `to`
FROM
	flights f;

