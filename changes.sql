-- optimaze  generated data
show tables;

-- START - ТАБЛИЦЫ БЕЗ ВНЕШНИХ КЛЮЧЕЙ

-- 1) Таблица пользователей - 100 шт
select * from users u;
-- Испарвление, чтобы поля update_at не были "моложе" полец created_at
UPDATE users SET created_at =(@temp:=created_at), created_at = updated_at, updated_at = @temp
where created_at > updated_at;

-- 2) Таблица городов - вымышленные сгенерированные города - 100 шт
select * from cities c;

-- 3) Таблица городов - вымышленные сгенерированные города - 10 шт
select * from catalogs c2;
-- Исправление, чтобы поля update_at не были "моложе" полей created_at
UPDATE catalogs SET created_at =(@temp:=created_at), created_at = updated_at, updated_at = @temp
where created_at > updated_at;

-- 4) Таблица брендов - вымышленные сгенерированные бренды - 15 шт
select * from brands b;
-- Исправление, чтобы поля update_at не были "моложе" полей created_at
UPDATE brands SET created_at =(@temp:=created_at), created_at = updated_at, updated_at = @temp
where created_at > updated_at;

-- 5) Таблица медиа типов - данных мало, поменял руками прям в dbeaver, до этого были сгенерированные данные - 10 шт
select * from media_types mt;
-- Исправление, чтобы поля update_at не были "моложе" полей created_at
UPDATE media_types SET created_at =(@temp:=created_at), created_at = updated_at, updated_at = @temp
where created_at > updated_at;

-- END - ТАБЛИЦЫ БЕЗ ВНЕШНИХ КЛЮЧЕЙ

-- START - ТАБЛИЦЫ - 1 ВНЕШНИЙ КЛЮЧ

-- 6) Таблица заказов - 50 шт
SELECT * FROM orders o;
-- Исправление, чтобы поля update_at не были "моложе" полей created_at
UPDATE orders SET created_at =(@temp:=created_at), created_at = updated_at, updated_at = @temp
where created_at > updated_at;
-- чтобы не попротить сгенерированные данные updated_at
ALTER TABLE coursework.orders MODIFY COLUMN updated_at datetime DEFAULT CURRENT_TIMESTAMP NULL COMMENT 'Время обновления новости';
-- user_id делаем произвольных пользователей в данном поле
UPDATE orders set user_id = FLOOR(1 + RAND() * 99);
-- создаем внешний ключ и действие для него при удалении внешнего ключа
ALTER TABLE orders
ADD CONSTRAINT orders_fk_user_id
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
-- возвращаем updated_at
ALTER TABLE coursework.orders MODIFY COLUMN updated_at datetime DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP NULL COMMENT 'Время обновления новости';
   

-- 7) Таблица новостей - 30 шт
SELECT * FROM news n;
-- Исправление, чтобы поля update_at не были "моложе" полей created_at
UPDATE news SET created_at =(@temp:=created_at), created_at = updated_at, updated_at = @temp
where created_at > updated_at;
-- чтобы не попротить сгенерированные данные updated_at
ALTER TABLE coursework.news MODIFY COLUMN updated_at datetime DEFAULT CURRENT_TIMESTAMP NULL COMMENT 'Время обновления новости';
-- user_id делаем произвольных пользователей в данном поле 
-- так как новости в отличие от заказов задают админы, диапазон сделал меньше
UPDATE news set user_id = FLOOR(1 + RAND() * 4);
-- создаем внешний ключ и действие для него при удалении внешнего ключа
ALTER TABLE news
ADD CONSTRAINT news_fk_user_id
FOREIGN KEY (user_id) REFERENCES users(id);
-- возвращаем updated_at
ALTER TABLE coursework.news MODIFY COLUMN updated_at datetime DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP NULL COMMENT 'Время обновления новости';


-- 8) Таблица связанных товаров - 30 шт
SELECT * FROM related_products r;
-- Исправление, чтобы поля update_at не были "моложе" полей created_at
UPDATE related_products SET created_at =(@temp:=created_at), created_at = updated_at, updated_at = @temp
where created_at > updated_at;
-- чтобы не попротить сгенерированные данные updated_at
ALTER TABLE coursework.related_products MODIFY COLUMN updated_at datetime DEFAULT CURRENT_TIMESTAMP NULL COMMENT 'Время обновления новости';
-- product_id делаем произвольные товары в данном поле 
UPDATE related_products set product_id = FLOOR(1 + RAND() * 99);
-- создаем внешний ключ и действие для него при удалении внешнего ключа
ALTER TABLE related_products
ADD CONSTRAINT related_products_fk_product_id
FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;
-- возвращаем updated_at
ALTER TABLE coursework.related_products MODIFY COLUMN updated_at datetime DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP NULL COMMENT 'Время обновления новости';

-- 9) Таблица характеристик товаров - 200(после 212) шт
SELECT * FROM specifications s2;
-- Исправление, чтобы поля update_at не были "моложе" полей created_at
UPDATE specifications SET created_at =(@temp:=created_at), created_at = updated_at, updated_at = @temp
where created_at > updated_at;
-- чтобы не попротить сгенерированные данные updated_at
ALTER TABLE coursework.specifications MODIFY COLUMN updated_at datetime DEFAULT CURRENT_TIMESTAMP NULL COMMENT 'Время обновления новости';
-- product_id делаем произвольные товары в данном поле 
UPDATE specifications set product_id = FLOOR(1 + RAND() * 99);
-- определяем список товаров, которые оказались без свойств
select p.id
from products p
left join specifications s
on s.product_id = p.id
where p.id not in (select DISTINCT product_id from specifications); 

set @q1 = (select count(*)
from products p
left join specifications s
on s.product_id = p.id
where p.id not in (select DISTINCT product_id from specifications));
SELECT @q1;
-- вставляем произвольные повторяющие записи в кол-ве товаров, которые оказались без свойств
INSERT INTO specifications(short_description, description, product_id)
select DISTINCT short_description, description, product_id 
FROM specifications s2 
ORDER BY RAND() 
LIMIT 12; -- @q1; -- 12;
-- Таблица - вспомогательная
DROP TABLE IF EXISTS `test`;
CREATE TABLE `test` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор',
  `product_id` int unsigned NOT NULL COMMENT 'тестовое поле',
  PRIMARY KEY (`id`)
) COMMENT='тестовая таблица';
-- вставляем в поле product_id товары, которые оказались без свойств
insert into test(product_id)
select p.id
from products p
left join specifications s
on s.product_id = p.id
where p.id not in (select DISTINCT product_id from specifications);
-- увеличиваем id на 200, чтобы было совпадение id с id из таблицы specifications
UPDATE test SET id = id + 200;
SELECT * from specifications s where id > 200;
-- обновляем product_id на необходимые
UPDATE specifications s 
        INNER JOIN test t
             ON t.id = s.id
SET s.product_id = t.product_id;
-- проверка, что у всех товаров есть хотя бы по одному свойству
SELECT DISTINCT product_id from specifications;
-- создаем внешний ключ и действие для него при удалении внешнего ключа
ALTER TABLE specifications
ADD CONSTRAINT specifications_fk_product_id
FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE SET NULL;
-- возвращаем updated_at
ALTER TABLE coursework.specifications MODIFY COLUMN updated_at datetime DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP NULL COMMENT 'Время обновления новости';
DROP TABLE IF EXISTS `test`;

-- END - ТАБЛИЦЫ - 1 ВНЕШНИЙ КЛЮЧ

-- START - ТАБЛИЦЫ - 2 ВНЕШНИХ КЛЮЧА

-- 10) Таблица товаров - 100 шт
select * from products p;
-- Испарвление, чтобы поля update_at не были "моложе" полец created_at
UPDATE products SET created_at =(@temp:=created_at), created_at = updated_at, updated_at = @temp
where created_at > updated_at;
-- чтобы не попротить сгенерированные данные updated_at
ALTER TABLE coursework.products MODIFY COLUMN updated_at datetime DEFAULT CURRENT_TIMESTAMP NULL COMMENT 'Время обновления новости';
-- ТАМ ГДЕ ЦЕНА БЫЛА РАВНА 0, вставили не нулевую цену
update products
set price = FLOOR(100 + RAND() * 100000)
WHERE price = 0;
-- создаем внешний ключ и действие для него при удалении внешнего ключа
ALTER TABLE products
ADD CONSTRAINT products_fk_catalog_id
FOREIGN KEY (catalog_id) REFERENCES catalogs(id) ON DELETE CASCADE,
ADD CONSTRAINT products_fk_brand_id
FOREIGN KEY (brand_id) REFERENCES brands(id) ON DELETE CASCADE;
-- возвращаем updated_at
ALTER TABLE coursework.products MODIFY COLUMN updated_at datetime DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP NULL COMMENT 'Время обновления новости';

-- 11) Таблица оценок - 70 шт (10 - 5 звезд, есть половинки)
select * from score s;
-- Испарвление, чтобы поля update_at не были "моложе" полец created_at
UPDATE score SET created_at =(@temp:=created_at), created_at = updated_at, updated_at = @temp
where created_at > updated_at;
-- чтобы не попротить сгенерированные данные updated_at
ALTER TABLE coursework.score MODIFY COLUMN updated_at datetime DEFAULT CURRENT_TIMESTAMP NULL COMMENT 'Время обновления новости';
-- user_id делаем произвольных пользователей в данном поле
UPDATE score set user_id = FLOOR(1 + RAND() * 99);
-- user_id делаем произвольных пользователей в данном поле
UPDATE score set product_id = FLOOR(1 + RAND() * 99);
-- создаем внешний ключ и действие для него при удалении внешнего ключа
ALTER TABLE score
ADD CONSTRAINT score_fk_user_id
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
ADD CONSTRAINT score_fk_product_id
FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;
-- возвращаем updated_at
ALTER TABLE coursework.score MODIFY COLUMN updated_at datetime DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP NULL COMMENT 'Время обновления новости';

-- 12) Таблица отзывов - 40 шт 
select * from reviews r;
-- user_id делаем произвольных пользователей в данном поле
UPDATE reviews set user_id = FLOOR(1 + RAND() * 99);
-- user_id делаем произвольных пользователей в данном поле
UPDATE reviews set product_id = FLOOR(1 + RAND() * 99);
-- создаем внешний ключ и действие для него при удалении внешнего ключа
ALTER TABLE reviews
ADD CONSTRAINT reviews_fk_user_id
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE set null,
ADD CONSTRAINT reviews_fk_product_id
FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE set null;

-- 13) Таблица заказов-товаров - 50 шт 
select * from order_products op;
-- user_id делаем произвольных пользователей в данном поле
UPDATE order_products set order_id = FLOOR(1 + RAND() * 49);
-- user_id делаем произвольных пользователей в данном поле
UPDATE order_products set product_id = FLOOR(1 + RAND() * 99);
-- создаем внешний ключ и действие для него при удалении внешнего ключа
ALTER TABLE order_products
ADD CONSTRAINT order_products_fk_order_id
FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE set null,
ADD CONSTRAINT order_products_fk_product_id
FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE set null;

-- 14) Таблица таблица адресов доставки - 100 шт 
select * from addresses a ;
-- Испарвление, чтобы поля update_at не были "моложе" полец created_at
UPDATE addresses SET created_at =(@temp:=created_at), created_at = updated_at, updated_at = @temp
where created_at > updated_at;
-- чтобы не попротить сгенерированные данные updated_at
ALTER TABLE coursework.addresses MODIFY COLUMN updated_at datetime DEFAULT CURRENT_TIMESTAMP NULL COMMENT 'Время обновления новости';
-- user_id делаем произвольных пользователей в данном поле
UPDATE addresses set user_id = FLOOR(1 + RAND() * 99);
-- user_id делаем произвольных пользователей в данном поле
UPDATE addresses set city_id = FLOOR(1 + RAND() * 99);
-- создаем внешний ключ и действие для него при удалении внешнего ключа
ALTER TABLE addresses
ADD CONSTRAINT addresses_fk_user_id
FOREIGN KEY (user_id) REFERENCES users(id),
ADD CONSTRAINT addresses_fk_city_id
FOREIGN KEY (city_id) REFERENCES cities(id);
-- возвращаем updated_at
ALTER TABLE coursework.addresses MODIFY COLUMN updated_at datetime DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP NULL COMMENT 'Время обновления новости';

-- 15) Таблица реквизитов пользователей - 100 шт 
select * from requisites r2;
-- Испарвление, чтобы поля update_at не были "моложе" полец created_at
UPDATE requisites SET created_at =(@temp:=created_at), created_at = updated_at, updated_at = @temp
where created_at > updated_at;
-- чтобы не попротить сгенерированные данные updated_at
ALTER TABLE coursework.requisites MODIFY COLUMN updated_at datetime DEFAULT CURRENT_TIMESTAMP NULL COMMENT 'Время обновления новости';
-- user_id делаем произвольных пользователей в данном поле
UPDATE requisites set user_id = FLOOR(1 + RAND() * 49);
-- user_id делаем произвольных пользователей в данном поле
UPDATE requisites set address_id = FLOOR(1 + RAND() * 99);
-- создаем внешний ключ и действие для него при удалении внешнего ключа
ALTER TABLE requisites
ADD CONSTRAINT requisites_fk_user_id
FOREIGN KEY (user_id) REFERENCES users(id),
ADD CONSTRAINT requisites_fk_address_id
FOREIGN KEY (address_id) REFERENCES addresses(id);
-- возвращаем updated_at
ALTER TABLE coursework.requisites MODIFY COLUMN updated_at datetime DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP NULL COMMENT 'Время обновления новости';

-- 16) Таблица акций товаров - 20 шт 
select * from actions a2 ;
-- ПОСЛЕ КОМАНД НИЖЕ МИНИМУМ 2 АКЦИИ ДЕЙСТВУЮЩИЕ
UPDATE actions SET finished_at = DATE_ADD(finished_at,INTERVAL 1 YEAR);
UPDATE actions SET finished_at = DATE_ADD(finished_at,INTERVAL 2 YEAR);
-- user_id делаем произвольных пользователей в данном поле
UPDATE actions set product_id = FLOOR(1 + RAND() * 99);
-- были слишком большие цифры, понимаю, что можно было сравнить величины с таблицей products price, но уже устал(
UPDATE actions set price_reduction = 0
WHERE price_reduction > 1200;
-- создаем внешний ключ и действие для него при удалении внешнего ключа
ALTER TABLE actions
ADD CONSTRAINT actions_fk_product_id
FOREIGN KEY (product_id) REFERENCES products(id),
ADD CONSTRAINT actions_fk_product_id_gift
FOREIGN KEY (product_id_gift) REFERENCES products(id);

-- END - ТАБЛИЦЫ - 2 ВНЕШНИХ КЛЮЧА

-- START - ТАБЛИЦЫ - 3 ВНЕШНИХ КЛЮЧА

-- 17) Таблица реквизитов пользователей - 50 шт 
select * from media m;
-- Испарвление, чтобы поля update_at не были "моложе" полец created_at
UPDATE media SET created_at =(@temp:=created_at), created_at = updated_at, updated_at = @temp
where created_at > updated_at;
-- чтобы не попротить сгенерированные данные updated_at
ALTER TABLE coursework.media MODIFY COLUMN updated_at datetime DEFAULT CURRENT_TIMESTAMP NULL COMMENT 'Время обновления новости';
-- user_id делаем произвольных пользователей в данном поле
UPDATE media set user_id = FLOOR(1 + RAND() * 99);
-- user_id делаем произвольных пользователей в данном поле
UPDATE media set product_id = FLOOR(1 + RAND() * 99);
-- делаем чтобы url был уникальный - /tmp/... у меня генератор не генерил таблицу
-- поэтому сделал так
UPDATE media set metadata = CONCAT(metadata, '', id);
-- создаем внешний ключ и действие для него при удалении внешнего ключа
ALTER TABLE media
ADD CONSTRAINT media_fk_user_id
FOREIGN KEY (user_id) REFERENCES users(id),
ADD CONSTRAINT media_fk_product_id
FOREIGN KEY (product_id) REFERENCES products(id),
ADD CONSTRAINT media_fk_media_type_id
FOREIGN KEY (media_type_id) REFERENCES media_types(id);
-- возвращаем updated_at
ALTER TABLE coursework.media MODIFY COLUMN updated_at datetime DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP NULL COMMENT 'Время обновления новости';

-- END - ТАБЛИЦЫ - 3 ВНЕШНИХ КЛЮЧА
