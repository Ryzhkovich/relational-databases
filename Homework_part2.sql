-- Создание тестовой таблицы `sample_2`
show databases;
DROP database IF EXISTS sample_2;
CREATE database sample_2;
use sample_2;
show tables;

-- Таблица пользователей №1 для выполнения задания
DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `name` varchar(100) CHARACTER SET utf8mb4 COMMENT 'Имя',
  `birthday` datetime COMMENT 'Дата дня рождения',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='Пользователи';
-- наполняем таблицу тестовыми значениями
insert into users (`name`, `birthday`) values ('Коля', '2018-05-17 00:13:55');
insert into users (`name`, `birthday`) values ('Оля', '2019-03-17 00:13:55');
insert into users (`name`, `birthday`) values ('Нина', '2011-06-17 00:13:55');
insert into users (`name`, `birthday`) values ('Ася', '2020-08-17 00:13:55');
insert into users (`name`, `birthday`) values ('Вася', '2008-05-17 00:13:55');
-- смотрим результат
SELECT * FROM users u2 ;


-- 1е задание 
SELECT ROUND(AVG((TO_DAYS(NOW()) - TO_DAYS(birthday)) / 365.25), 0) AS AVG_Age FROM users;


-- 2е задание 
SELECT
    DAYNAME(CONCAT(YEAR(NOW()), '-', SUBSTRING(birthday, 6, 10))) AS week_day_of_birthday_in_this_Year,
    COUNT(*) AS amount_of_birthday
FROM
    users
GROUP BY 
    week_day_of_birthday_in_this_Year
ORDER BY
	amount_of_birthday DESC;


-- 3е задание 
DROP TABLE IF EXISTS `valuesNumber`;
CREATE TABLE `valuesNumber` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `value` int COMMENT 'Значение',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='Пользователи';

insert into valuesNumber (`value`) values (1), (2), (3), (4), (5), (6);
SELECT * FROM valuesNumber ;

SELECT ROUND(exp(SUM(log(value))), 0) AS factorial FROM valuesNumber;


