show databases;
use vk;

-- Предложение 1
-- Добавить отчество
ALTER TABLE profiles
ADD patronymic_name VARCHAR(100) COMMENT 'Отчество пользователя' AFTER user_id;

-- Предложение 2
-- Убрать из таблицы users поля first_name, last_name - переносим в profiles
ALTER TABLE profiles
  ADD first_name varchar(100) NOT NULL COMMENT 'Имя пользователя' AFTER user_id,
  ADD last_name varchar(100)  NOT NULL COMMENT 'Фамилия пользователя' AFTER first_name
;
select * from profiles limit 5;

-- Добавить в таблицу messages поле "Признак прочтения"
ALTER TABLE messages
ADD is_read BOOLEAN COMMENT "Признак прочтения" AFTER is_delivered;
select * from messages limit 5;

-- Заменить поле "статус пользователя" справочником
-- Создаем справочник статусов пользователей
CREATE TABLE user_statuses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name VARCHAR(100) NOT NULL COMMENT "Название статуса",
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Справочник статусов пользователя";

-- Заполняем справочник статусов пользователей
INSERT INTO user_statuses (name) VALUES ('Single'), ('Married');
select * from user_statuses limit 5;

-- Изменяем тип поля
ALTER TABLE profiles RENAME COLUMN status TO user_status_id;
UPDATE profiles set user_status_id = null;
ALTER TABLE profiles MODIFY COLUMN user_status_id INT UNSIGNED;
select * from profiles limit 5;

-- Заменить поле "пол" справочником
-- Создаем справочник полов
CREATE TABLE gender (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  gender VARCHAR(25) COMMENT "Название пола",
  gender_info VARCHAR(150) COMMENT "Информация о поле",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Варианты полов";

-- Заполняем справочник полов
INSERT INTO gender (gender, gender_info) VALUES ('M', 'Male'), ('F', 'Female');
select * from gender limit 5;

-- Меняем тип поля gender на INT для использования справочника
ALTER TABLE vk.profiles MODIFY COLUMN gender char(1) NULL COMMENT 'Пол';
UPDATE profiles set gender = null;
ALTER TABLE profiles MODIFY COLUMN gender INT UNSIGNED;
ALTER TABLE profiles RENAME COLUMN gender TO gender_id;
select * from profiles limit 5;

-- ************** Дорабатываем тестовые данные - и так добавляю вывод 5 записей после изменений, поэтому закомментировал
/*SELECT * FROM friendship_statuses;
SELECT * FROM media_types;
SELECT * FROM user_statuses;
SELECT * FROM gender;

SELECT * FROM users;
SELECT * FROM profiles;
SELECT * FROM media;
SELECT * FROM friendship;
SELECT * FROM messages;
SELECT * FROM communities;
SELECT * FROM communities_users;
*/

-- чистим таблицы для внесения в них новых данных
truncate TABLE friendship_statuses;
truncate TABLE media_types;

-- Заполним справочники
INSERT INTO friendship_statuses (name) VALUES ('Requested'), ('Approved'), ('Declined');
INSERT INTO media_types (name) VALUES ('Image'), ('Video'), ('Audio');
select * from friendship_statuses limit 5;
select * from media_types limit 5;

-- Перенесем данные из users
UPDATE profiles p
SET
  p.first_name = (SELECT u.first_name FROM users u WHERE id = p.user_id),
  p.last_name = (SELECT u.last_name FROM users u WHERE id = p.user_id),
  p.patronymic_name = (SELECT u.first_name FROM users u WHERE id = p.user_id)
;

-- убираю запрос демонстрацию
-- SELECT id FROM gender ORDER BY rand() LIMIT 1;
-- Заполним пол случайными значениями из справочника
UPDATE profiles
SET
  gender_id = (SELECT id FROM gender ORDER BY rand() LIMIT 1)
;
select * from profiles limit 5;

-- SELECT id FROM user_statuses us ORDER BY rand() LIMIT 1;
-- Заполним статус случайными значениями из справочника
UPDATE profiles p
SET
  p.user_status_id = (SELECT us.id FROM user_statuses us ORDER BY rand() LIMIT 1)
;
select * from profiles limit 5;

-- SELECT DISTINCT user_status_id FROM profiles ORDER BY user_status_id;
-- Заполним тип медиафайла случайными значениями из справочника
UPDATE media
SET
  media_type_id = (SELECT id FROM media_types ORDER BY rand() LIMIT 1)
;
select * from media limit 5;

-- Обновим друзей
UPDATE friendship f
SET
  friend_id = (SELECT u.id FROM users u WHERE u.id != f.user_id ORDER BY rand() LIMIT 1)
;

-- Ниже проверка, что ты не сам у себя в друзьях
SELECT * FROM friendship WHERE user_id = friend_id;
-- Заполним статусы дружбы случайными значениями из справочника
UPDATE friendship
SET
  status_id = (SELECT id FROM friendship_statuses ORDER BY rand() LIMIT 1)
;
select * from friendship limit 5;

-- Обновим сообщения, чтобы не было отправленных самим себе
UPDATE messages m
SET
  m.to_user_id = (SELECT u.id FROM users u WHERE u.id != m.from_user_id ORDER BY rand() LIMIT 1)
;
select * from messages limit 5;

-- Заполним флаг прочтения 0 или 1 там, где доставлены
UPDATE messages
SET is_read = IF(rand() > 0.5, 0, 1)
WHERE is_delivered = 1;

SELECT * FROM media_types;

-- выбираем одну произвольдую запись для проверки
SELECT * FROM media
WHERE media_type_id = (SELECT id FROM media_types WHERE name = 'Image')
ORDER BY rand() LIMIT 1;

-- Заполним ссылки на фото в профилях, где у пользователя есть фотографии
UPDATE profiles p
SET p.photo_id = (
  SELECT m.id FROM media m
  WHERE m.media_type_id = (SELECT id FROM media_types WHERE name = 'Image')
  AND m.user_id = p.user_id
  ORDER BY rand() LIMIT 1
);
select * from profiles limit 5;

-- Удаляем поля, которые перенесли/заменили
ALTER TABLE users DROP COLUMN first_name;
ALTER TABLE users DROP COLUMN last_name;
select * from users limit 5;
