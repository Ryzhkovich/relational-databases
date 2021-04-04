-- Создание индексов:
--  Работа с корзиной, заказами, и пользовательскими данными, не такая частая вещь как страница товара, перечень товаров
-- поэтому создал индексы для максимально быстрой работы на страницах товара и перечня товаров
-- поэтому в приоритете все внешние поля у таблиц products, media, specifications(характеристики товара), score(оценки товара)

-- 1) Таблица products будет использоваться наиболее часто, поэтому внешние ключи данной таблицы добавляем в индекс точно
CREATE INDEX index_of_catalog_id USING BTREE ON products (catalog_id);
CREATE INDEX index_of_brand_id USING BTREE ON products (brand_id);
-- 2) Таблица характеристик товара
CREATE INDEX index_of_product_id USING BTREE ON specifications (product_id);
-- 3) Таблица оценок товара
CREATE INDEX index_of_product_id USING BTREE ON score (product_id);
-- пользователя тоже, на всякий
CREATE INDEX index_of_user_id USING BTREE ON score (user_id);
-- 4) Таблица медиа
CREATE INDEX index_of_product_id USING BTREE ON media (product_id);
CREATE INDEX index_of_user_id USING BTREE ON media (user_id);
CREATE INDEX index_of_media_type_id USING BTREE ON media (media_type_id);

-- Представления:
-- Я не стал делать много представлений
-- но те которые создал по моиму времени являлись бы популярными у пользователей интернет-магазина

-- 1) Вывод товаров с наиболее высокими оценками пользователей 
-- (лимитировать выдачу, например limit 10, уже можно при вызове самого представления)
-- most_valuable - имеется ввиду наиболее ценные для пользователей
CREATE view most_valuable as
select s.product_id, sum(s.value) as all_points, count(s.product_id) as voices, p2.name, (sum(s.value)/count(s.value)) as middle_value
from score s 
left join products p2 
on p2.id = s.product_id 
group by s.product_id 
HAVING count(s.product_id) > 0
ORDER by middle_value desc, all_points desc;

-- 10 товаров с самым высоким рейтингом у пользователей
SELECT * from most_valuable limit 10;

-- 2) Самые продоваемые бренды (количество проданных товаров данного бренда)
-- можно либо опять же выводить "5 самых популярных брендов" у пользователей в интернет магазине
-- либо можно когда пользователь заходит на страницу брендов сортировать бренды на страницы в порядке
-- выводимом этим представлением
-- тоже самое можно сделать и с категориями, но я не стал этого делать, т.к. запросы однотипные
CREATE view popular_brands as
SELECT p.brand_id, SUM(op.product_quantity) as s, b2.name 
from order_products op
left join products p 
on p.id = op.product_id
left join brands b2
on b2.id = p.brand_id 
group by p.brand_id 
HAVING count(p.brand_id) > 0
ORDER by s DESC;

-- 5 самых популярных брендов
SELECT * from popular_brands limit 5;


-- Процедуры:
-- мои процедуры предназначены для слежки за работой админов
-- в таблицах news, media

-- данная процедура изменяет переменную @admin в которой 
-- в виде строки хранятся id-шники админов-контент-менеджеров
DROP PROCEDURE IF EXISTS set_admin;
delimiter //
CREATE PROCEDURE set_admin(IN value VARCHAR(255))
BEGIN
	SET @admin = value;
END //
delimiter ;
-- задаем перечеть пользователей админов
CALL set_admin('1,2,3,4');
-- данным выводом мы можем вспомнить какие пользователи у нас админы
SELECT @admin;

-- данная процедура с параметром равным id-шнику админа
-- проверяет последние 5 созданных им записей в таблице media
DROP PROCEDURE IF EXISTS get_admin_activity_media;
delimiter //
CREATE PROCEDURE get_admin_activity_media(IN value int)
BEGIN
	select id, created_at from media m2
	where id = value 
	ORDER by created_at DESC 
	limit 5;
END //
delimiter ;
-- проверка админка с id = 1
call get_admin_activity_media(1);

-- данная процедура с параметром равным id-шнику админа
-- проверяет последние 5 созданных им записей в таблице news
DROP PROCEDURE IF EXISTS get_admin_activity_news;
delimiter //
CREATE PROCEDURE get_admin_activity_news(IN value int)
BEGIN
	select id, created_at from news n2 
	where id = value 
	ORDER by created_at DESC 
	limit 5;
END //
delimiter ;
-- проверка админка с id = 3
call get_admin_activity_news(3);


-- Тригеры:
-- Тригеры на таблицу news, чтобы поля is_public и is_archived не были одновременно равны 1
DROP TRIGGER IF EXISTS validate_is_public_archived_insert;
DROP TRIGGER IF EXISTS validate_is_public_archived_update;
-- ***
DELIMITER //
CREATE TRIGGER validate_is_public_archived_insert BEFORE INSERT ON news FOR EACH ROW
BEGIN
  IF NEW.is_public = 1 AND NEW.is_archived = 1 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cannot INSERT if is_public=1 & is_archived=1 in the same time';
  END IF;
END//

CREATE TRIGGER validate_is_public_archived_update BEFORE UPDATE ON news FOR EACH ROW
BEGIN
  IF NEW.is_public = 1 AND NEW.is_archived = 1 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cannot INSERT if is_public=1 & is_archived=1 in the same time';
  END IF;
END//
DELIMITER ;
-- ***
-- проверяем insert - !!! РАСКОММЕНТИРОВАТЬ ДЛЯ ПРОВЕРКИ !!!
-- INSERT INTO `news` 
-- (`user_id`, `head`, `body`, `is_public`, `is_archived`) 
-- VALUES (1, 'Ullam magni suscipit deserunt quia.', 'Dolor impedit fugit repudiandae voluptas. ', 1, 1);
-- проверяем update !!! РАСКОММЕНТИРОВАТЬ ДЛЯ ПРОВЕРКИ !!!
-- UPDATE `news` 
-- set `is_public` = 1, `is_archived` = 1
-- where id = 1;

-- Тригеры на таблицу actions, чтобы поля activated_at и finished_at не были равны др др одновременно
DROP TRIGGER IF EXISTS validate_activated_finished_at_insert;
DROP TRIGGER IF EXISTS validate_activated_finished_at_update;
-- ***
DELIMITER //
CREATE TRIGGER validate_activated_finished_at_insert BEFORE INSERT ON actions FOR EACH ROW
BEGIN
  IF NEW.activated_at = NEW.finished_at THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cannot INSERT if activated_at = finished_at';
  END IF;
END//

CREATE TRIGGER validate_activated_finished_at_update BEFORE UPDATE ON actions FOR EACH ROW
BEGIN
  IF NEW.activated_at = NEW.finished_at THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cannot INSERT if activated_at = finished_at';
  END IF;
END//
DELIMITER ;
-- ***
-- проверяем insert - !!! РАСКОММЕНТИРОВАТЬ ДЛЯ ПРОВЕРКИ !!!
-- INSERT INTO `actions` 
-- (`product_id`, `head`, `body`, `percentage`, 
-- `product_id_gift`, `price_reduction`, `activated_at`, `finished_at`) 
-- VALUES 
-- ('1', 'Doloribus velit esse deserunt ducimus voluptatem culpa et.', 'Earum quia rerum sit repellendus consectetur officia.', 8, 
-- 1, 0, '2000-01-03 05:54:06', '2000-01-03 05:54:06');
-- проверяем update - !!! РАСКОММЕНТИРОВАТЬ ДЛЯ ПРОВЕРКИ !!!
-- UPDATE `actions` 
-- set `activated_at` = '2000-01-03 05:54:06', `finished_at` = '2000-01-03 05:54:06'
-- where id = 1;

SHOW triggers;





