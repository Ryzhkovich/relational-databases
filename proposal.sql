-- Предложение добавить статус "Disable" - значит пользователь в черном списке
INSERT INTO friendship_statuses (name) VALUES ('Requested'), ('Approved'), ('Declined'), ('Disable');
-- Предложение добавить статус "Clip" - клипы уже можно приравнивать к др медиа файлам как фото или видео
INSERT INTO media_types (name) VALUES ('Image'), ('Video'), ('Audio'), ('Clip');
-- Добавить таблицу news - новости
CREATE TABLE `news` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор новости',
  `text` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT 'Текст новости',
  `list_media` json COMMENT 'JSON запись используемых медиа файлов в виде {"key1": "value1"}, где key1 - порядковый номер с 1цы, value1 - id медиа файла, т.к. медиа файлов может быть несколько в одной новости',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`),
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Группы';