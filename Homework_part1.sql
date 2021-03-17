-- Создание тестовой таблицы `sample`
show databases;
DROP database IF EXISTS sample;
CREATE database sample;
use sample;
show tables;

-- Таблица пользователей №1 для выполнения задания
DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `created_at` varchar(100) CHARACTER SET utf8mb4 COMMENT 'Время создания строки',
  `updated_at` varchar(100) CHARACTER SET utf8mb4 COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='Пользователи';
-- строка для вывода результатов таблицы(проверка)
SELECT * FROM users;


-- 1t задание 
-- вносим данные по условию
insert into users (`created_at`, `updated_at`) values (NULL, NULL), (NOW(), NOW()); 
-- выбрать только один из вариантов обновления таблицы
-- вариант 1
UPDATE users set `created_at` = NOW(), `updated_at` = NOW() WHERE id = 1;
-- вариант 2
UPDATE users set `created_at` = NOW(), `updated_at` = NOW() WHERE created_at <=> NULL;
-- смотрим результат
SELECT * FROM users;


-- 2е задание 
-- для корректности(данные) теста удаляем и создаем таблицу users заново 
-- вносим данные по условию
insert into users (`created_at`, `updated_at`) values ('20.10.2017 8:10', '20.10.2019 18:10');
insert into users (`created_at`, `updated_at`) values ('20.10.2018 8:10', '20.10.2020 18:10');
insert into users (`created_at`, `updated_at`) values ('20.10.2019 8:10', '20.10.2014 18:10');
-- запрос с помощью которого проверяем, что данные теперь в нужном формате
SELECT STR_TO_DATE(`created_at`, "%d.%m.%Y %k:%i") FROM users;
-- обновляе данные в таблице к нужному виду
UPDATE users SET `created_at` = STR_TO_DATE(`created_at`, "%d.%m.%Y %k:%i"); -- , "%W %M %e %Y"
-- модифицируем формат поля `created_at`
ALTER TABLE users MODIFY `created_at` DATETIME;
-- смотрим результат
SELECT * FROM users;


-- 3е задание 
-- удаляем/создает таблицу тестовую по заданию - `storehouses_products`
DROP TABLE IF EXISTS `storehouses_products`;
create table `storehouses_products` (
	`id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
    `product_id` INT unsigned,
    `value` INT unsigned,
    PRIMARY KEY (`id`)
) COMMENT = 'Запасы на складе';
-- добавляем тестовые данные
INSERT INTO storehouses_products (id, product_id, value) VALUES (1, 2, 10), (12, 3, 0), (2, 4, 15), (13, 4, 0);
-- проверяем наличие тестовых данные, удовлетворяющих условию
SELECT * FROM storehouses_products;
-- запрос по заданию
SELECT value FROM storehouses_products ORDER BY CASE WHEN value = 0 then 1 else 0 end, value;


-- 4е задание 
-- удаляем/создает таблицу тестовую по заданию - `users_2`
DROP TABLE IF EXISTS `users_2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_2` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `name` varchar(100) CHARACTER SET utf8mb4 COMMENT 'Имя',
  `birthday_2` varchar(50) CHARACTER SET utf8mb4 COMMENT 'Дата дня рождения в ином формате',
  `birthday` datetime COMMENT 'Дата дня рождения',
   -- `birthday` date COMMENT 'Дата дня рождения',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='Пользователи';
-- вносим данные
insert into users_2 (`name`, `birthday`) values ('Коля', '2018-05-17 00:13:55');
insert into users_2 (`name`, `birthday`) values ('Оля', '2019-03-17 00:13:55');
insert into users_2 (`name`, `birthday`) values ('Нина', '2011-06-17 00:13:55');
insert into users_2 (`name`, `birthday`) values ('Ася', '2020-08-17 00:13:55');
insert into users_2 (`name`, `birthday`) values ('Вася', '2013-05-17 00:13:55');
-- заполняем по полю `birthday` поле `birthday_2` в ином формате
UPDATE users_2 SET birthday_2 = DATE_FORMAT(birthday, '%M %e %Y');
-- проверка того, что сейчас находится в полях таблицы
SELECT name, DATE_FORMAT(`birthday`, "%W %M %e %Y") as d FROM users_2;
select * from users_2;
-- запрос который решает поставленную задачу
SELECT name, birthday_2, MONTH(STR_TO_DATE(birthday_2, '%M %d %Y')) from users_2;


-- 5е задание 
-- используем для простоты таблицу `users_2`
-- стандартное поведение
SELECT * FROM users_2 WHERE id IN (5, 1, 2);
-- необходимый запрос
SELECT * FROM users_2 WHERE id IN (5, 1, 2) ORDER BY CASE
    WHEN id = 3 THEN 0
    WHEN id = 1 THEN 1
    WHEN id = 2 THEN 2
END;
