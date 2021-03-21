show databases;
use vk;
show tables;

-- Таблица лайков
DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  user_id INT UNSIGNED NOT NULL COMMENT "Идентификатор пользователя",
  target_id INT UNSIGNED NOT NULL COMMENT "Идентификатор объекта",
  target_type_id INT UNSIGNED NOT NULL COMMENT "Идентификатор типа объекта",
  like_type TINYINT UNSIGNED NOT NULL COMMENT "Идентификатор типа лайка (1 - лайк, 0 - дизлайк)",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Лайки";

-- Таблица типов объектов лайков
DROP TABLE IF EXISTS target_types;
CREATE TABLE target_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name VARCHAR(255) NOT NULL UNIQUE COMMENT "Название типа",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Типы объектов лайков";

-- Создадим таблицу постов
DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  community_id INT UNSIGNED,
  head VARCHAR(255),
  body TEXT NOT NULL,
  is_public BOOLEAN DEFAULT TRUE,
  is_archived BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Наполняем таблицу target_types
INSERT INTO target_types (name) VALUES 
  ('messages'),
  ('users'),
  ('media'),
  ('posts');
 
-- Проверяем налаичие необходимых полей в таблицу target_types
SELECT * FROM target_types;

-- Прогнал каждый запрос, чтоб наглядно увидеть действие каждой составляющей
SELECT id FROM users ORDER BY rand() LIMIT 1;
SELECT body FROM messages ORDER BY rand() LIMIT 1;
SELECT
  (SELECT id FROM users ORDER BY rand() LIMIT 1) AS user_id,
  (SELECT body FROM messages ORDER BY rand() LIMIT 1) AS body
FROM messages;
SELECT user_id, substring(body, 1, locate(' ', body) - 1), body FROM (
    SELECT
      (SELECT id FROM users ORDER BY rand() LIMIT 1) AS user_id,
      (SELECT body FROM messages ORDER BY rand() LIMIT 1) AS body
    FROM messages
  ) p;

INSERT INTO posts (user_id, head, body)
  SELECT user_id, substring(body, 1, locate(' ', body) - 1), body FROM (
    SELECT
      (SELECT id FROM users ORDER BY rand() LIMIT 1) AS user_id,
      (SELECT body FROM messages ORDER BY rand() LIMIT 1) AS body
    FROM messages
  ) p;
 
-- Проверяем налаичие необходимых полей в таблицу posts
SELECT * FROM posts;
