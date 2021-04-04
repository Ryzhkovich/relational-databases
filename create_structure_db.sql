-- Создание таблицы курсовой работы
DROP DATABASE IF EXISTS `coursework`;
-- CREATE DATABASE `coursework`;
-- USE `coursework`;


-- Таблица пользователей - 1
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор пользователя',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Пароль', # тут будет храниться hash пароля пользователя, например md5
  `full_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ФИО',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Почта',
  `phone` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Телефон',
  `subscription` tinyint DEFAULT 0 COMMENT 'Подписка',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания пользователя',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления пользователя',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) COMMENT='Пользователи';


-- Таблица адресов доставки - 2
DROP TABLE IF EXISTS `addresses`;
CREATE TABLE `addresses` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор адреса',
  `user_id` int unsigned NOT NULL COMMENT 'Ссылка на пользователя', -- тут будет внешний ключ
  `city_id` int unsigned NOT NULL COMMENT 'Ссылка на город', -- тут будет внешний ключ
  `street` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Улица',
  `home` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Дом',
  `corpus` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Корпус',
  `flat` SMALLINT unsigned DEFAULT NULL COMMENT 'Кв/Офис',
  `metro` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Метро', -- умышлено таким типом, на самом деле тут внешний ключ, но тогда пришлось бы еще создавать таблицу станций метро
  `index` MEDIUMINT unsigned DEFAULT NULL COMMENT 'Почтовый индекс',
  `phone` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Телефон',
  `other` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Прочее',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания адреса',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления адреса',
  PRIMARY KEY (`id`)
) COMMENT='Адрес доставки';


-- Таблица городов - 3
DROP TABLE IF EXISTS `cities`;
CREATE TABLE `cities` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор адреса',
  `city_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Улица',
  PRIMARY KEY (`id`)
) COMMENT='Города';


-- Таблица заказов - 4
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор пользователя',
  `user_id` int unsigned NOT NULL COMMENT 'Ссылка на пользователя', -- тут будет внешний ключ
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания заказа',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления заказа',
  PRIMARY KEY (`id`)
) COMMENT='Заказы';


-- Таблица заказов - 5
DROP TABLE IF EXISTS `order_products`;
CREATE TABLE `order_products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор пользователя',
  `order_id` bigint(20) unsigned COMMENT 'Ссылка на заказ', -- тут будет внешний ключ
  `product_id` bigint(20) unsigned COMMENT 'Ссылка на товар', -- тут будет внешний ключ
  `product_quantity` int unsigned NOT NULL COMMENT 'Кол-во товара',
  PRIMARY KEY (`id`)
) COMMENT='Заказы';


-- Таблица реквизитов - 6
DROP TABLE IF EXISTS `requisites`;
CREATE TABLE `requisites` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор реквизита',
  `user_id` int unsigned NOT NULL COMMENT 'Ссылка на пользователя', -- тут будет внешний ключ
  `address_id` int unsigned NOT NULL COMMENT 'Ссылка на адрес', -- тут будет внешний ключ
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Название',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Почта',
  `phone` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Телефон',
  `main_state_registration_number` varchar(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ОГРН',
  `taxpayer_identification_number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ИНН',
  `reason_code_registration` varchar(9) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'КПП',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания реквизита',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления пользователя',
  PRIMARY KEY (`id`)
) COMMENT='Адрес доставки';


-- Таблица товаров - 7
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор товара',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT 'Название товара',
  `description` text CHARACTER SET utf8 COLLATE utf8_bin COMMENT 'Описание',
  `price` decimal(11,2) DEFAULT NULL COMMENT 'Цена',
  `catalog_id` int unsigned DEFAULT NULL  COMMENT 'Ссылка на раздел', -- тут будет внешний ключ
  `brand_id` int unsigned DEFAULT NULL  COMMENT 'Ссылка на бренд', -- тут будет внешний ключ
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания товара',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления товара',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
  -- KEY `index_of_catalog_catalog_id` (`catalog_id`),
  -- CONSTRAINT `fk_catalog_id` FOREIGN KEY (`catalog_id`) REFERENCES `catalogs` (`id`)
) COMMENT='Таблица товаров';


-- Таблица разделов - 8
DROP TABLE IF EXISTS `catalogs`;
CREATE TABLE `catalogs` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор раздела',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT 'Название раздела',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания раздела',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления раздела',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `unique_name` (`name`(10))
) COMMENT='Разделы интернет-магазина Мегафон';


-- Таблица брендов - 9
DROP TABLE IF EXISTS `brands`;
CREATE TABLE `brands` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор бренда',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT 'Название бренда',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания бренда',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления бренда',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `unique_name` (`name`(10))
) COMMENT='Бренды интернет-магазина Мегафон';


-- Таблица новостей - 10
DROP TABLE IF EXISTS `news`;
CREATE TABLE `news` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор раздела',
  `user_id` int unsigned NOT NULL COMMENT 'Идентификатор раздела',
  `head` varchar(255) DEFAULT NULL COMMENT 'Заголовок новости',
  `body` text NOT NULL COMMENT 'Тело новости',
  `is_public` tinyint(1) DEFAULT '1' COMMENT 'Является публичной новостью',
  `is_archived` tinyint(1) DEFAULT '0' COMMENT 'Является архивной новостью',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания новости',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления новости',
  PRIMARY KEY (`id`)
  -- CONSTRAINT `posts_fk_community_id` FOREIGN KEY (`community_id`) REFERENCES `communities` (`id`),
  -- CONSTRAINT `posts_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) COMMENT='Новости';


-- Оценки товаров пользователями - 11
DROP TABLE IF EXISTS `score`;
CREATE TABLE `score` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор оценки',
  `user_id` int unsigned COMMENT 'Идентификатор пользователя', -- тут будет внешний ключ
  `product_id` bigint(20) unsigned COMMENT 'Идентификатор товара', -- тут будет внешний ключ
  `value` tinyint unsigned DEFAULT '0' COMMENT 'Значение оценки',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания оценки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления оценки',
  PRIMARY KEY (`id`)
  ) COMMENT='Оценки';


-- Отзывы товаров пользователями - 12
DROP TABLE IF EXISTS `reviews`;
CREATE TABLE `reviews` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор отзыва',
  `user_id` int unsigned COMMENT 'Идентификатор пользователя', -- тут будет внешний ключ
  `product_id` bigint(20) unsigned COMMENT 'Идентификатор товара', -- тут будет внешний ключ
  `body` text NOT NULL COMMENT 'Тело отзыва',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания отзыва',
  PRIMARY KEY (`id`)
  ) COMMENT='Отзывы';


-- Акции товаров - 13
DROP TABLE IF EXISTS `actions`;
CREATE TABLE `actions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор акции',
  `product_id` bigint(20) unsigned NOT NULL COMMENT 'Идентификатор товара', -- тут будет внешний ключ
  `head` varchar(255) DEFAULT NULL COMMENT 'Заголовок акции',
  `body` text NOT NULL COMMENT 'Тело акции',
  `percentage` tinyint unsigned DEFAULT NULL COMMENT 'Процент скидки',
  `product_id_gift` bigint(20) unsigned DEFAULT NULL COMMENT 'Идентификатор товара подарка', -- тут будет внешний ключ
  `price_reduction` int unsigned DEFAULT NULL COMMENT 'Сумма скидки',
  `activated_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время активации акции',
  `finished_at` datetime DEFAULT NULL COMMENT 'Время окончания акции',
  -- `finished_at` datetime generated ALWAYS as (activated_at + interval 1 MONTH) COMMENT 'Время окончания акции',
  PRIMARY KEY (`id`)
  ) COMMENT='Акции';


-- Медиа файлы - 14
DROP TABLE IF EXISTS `media`;
CREATE TABLE `media` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор медиа',
  `user_id` int unsigned NOT NULL COMMENT 'Ссылка на пользователя, который загрузил файл',
  `product_id` bigint(20) unsigned NOT NULL COMMENT 'Принадлежность к товару',
  `filename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Путь к файлу',
  `size` int NOT NULL COMMENT 'Размер файла',
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT 'Метаданные файла',
  `media_type_id` int unsigned NOT NULL COMMENT 'Ссылка на тип контента',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`)
  -- KEY `media_fk_user_id` (`user_id`),
  -- KEY `media_fk_media_type_id` (`media_type_id`),
  -- CONSTRAINT `media_fk_media_type_id` FOREIGN KEY (`media_type_id`) REFERENCES `media_types` (`id`),
  -- CONSTRAINT `media_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  -- CONSTRAINT `media_chk_1` CHECK (json_valid(`metadata`))
) COMMENT='Медиафайлы';


-- Типы медиафайлов - 15
DROP TABLE IF EXISTS `media_types`;
CREATE TABLE `media_types` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор медиа типа',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Название типа',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) COMMENT='Типы медиафайлов';


-- Характеристики товаров - 16
DROP TABLE IF EXISTS `specifications`;
CREATE TABLE `specifications` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор характеристики',
  `product_id` bigint(20) unsigned COMMENT 'Идентификатор товара для характеристики', -- тут будет внешний ключ
  `short_description` varchar(255) NOT NULL COMMENT 'Короткое описание',
  `description` text DEFAULT NULL COMMENT 'Описание',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания характеристики',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления характеристики',
  PRIMARY KEY (`id`)
  ) COMMENT='Характеристики';


-- Связанные товары - 17 
DROP TABLE IF EXISTS `related_products`;
CREATE TABLE `related_products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор характеристики',
  `product_id` bigint(20) unsigned NOT NULL COMMENT 'Идентификатор товара для характеристики', -- тут будет внешний ключ
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания характеристики',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления характеристики',
  PRIMARY KEY (`id`)
  ) COMMENT='Связанные товары';

-- Можно было бы еще еще описать таблицы: запасы, магазины но тогда возможно потребовались еще какие-то смежные таблицы 
-- и их я уже делать не стал, но понимаю как это сделать



