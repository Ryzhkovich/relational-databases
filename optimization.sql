-- Практическое задание по теме “Оптимизация запросов”

show databases;
use shop;
show tables;

DROP TABLE IF EXISTS `logs`;
CREATE TABLE `logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор лога',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Время записи лога',
  `table_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Название логируемой таблицы',
  `table_record_id` bigint(20) unsigned DEFAULT NULL COMMENT 'Идентификатор записи логируемой таблицы',
  `table_record_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Поле `name` записи из таблицы',
  PRIMARY KEY (`id`)
) ENGINE=Archive AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Логи таблиц users, catalogs и products';

-- TRIGGER table - users
DROP TRIGGER IF EXISTS log_users_insert;
delimiter //
CREATE TRIGGER log_users_insert AFTER INSERT ON users FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, table_record_id, table_record_name)
	VALUES (NOW(), 'users', NEW.id, NEW.name);
END //
delimiter ;

-- TRIGGER table - catalogs
DROP TRIGGER IF EXISTS log_catalogs_insert;
delimiter //
CREATE TRIGGER log_catalogs_insert AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, table_record_id, table_record_name)
	VALUES (NOW(), 'catalogs', NEW.id, NEW.name);
END //
delimiter ;

-- TRIGGER table - products
DROP TRIGGER IF EXISTS log_products_insert;
delimiter //
CREATE TRIGGER log_products_insert AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, table_record_id, table_record_name)
	VALUES (NOW(), 'products', NEW.id, NEW.name);
END //
delimiter ;



-- Проверка - users
SELECT * FROM users u;
SELECT * FROM logs;

INSERT INTO users (name, birthday_at)
VALUES ('Пингвин-2', '2019-01-03');

-- Проверка - catalogs
SELECT * FROM catalogs c;
SELECT * FROM logs;

INSERT INTO catalogs (name)
VALUES ('Ноутбуки');

-- Проверка - catalogs
SELECT * FROM products p;
SELECT * FROM logs;

INSERT INTO products (name, description, price, catalog_id)
VALUES ('Какая-то техника', 'какое-то описание', 10000, 1);













