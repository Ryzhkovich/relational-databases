-- Добавляем внешние ключи в БД vk
-- Посмотрим ER-диаграмму в DBeaver (связей нет)
-- Для таблицы профилей

-- Смотрим структуру таблицы
DESC profiles;

-- Добавляем внешние ключи
ALTER TABLE profiles
  ADD CONSTRAINT profiles_fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  ADD CONSTRAINT profiles_fk_gender_id
    FOREIGN KEY (gender_id) REFERENCES gender(id) ON DELETE SET NULL,
  ADD CONSTRAINT profiles_fk_user_status_id
    FOREIGN KEY (user_status_id) REFERENCES user_statuses(id);

ALTER TABLE communities_users
  ADD CONSTRAINT comm_users_fk_comm_id
    FOREIGN KEY (community_id) REFERENCES communities(id),
  ADD CONSTRAINT comm_users_fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id)
 ;

-- Для таблицы сообщений

-- Смотрим структуру таблицы
DESC messages;

-- Добавляем внешние ключи
ALTER TABLE messages
  ADD CONSTRAINT messages_fk_from_user_id
    FOREIGN KEY (from_user_id) REFERENCES users(id),
  ADD CONSTRAINT messages_fk_to_user_id
    FOREIGN KEY (to_user_id) REFERENCES users(id);

-- Посмотрим ER-диаграмму в DBeaver (появились связи)

-- Если нужно удалить
ALTER TABLE table_name DROP FOREIGN KEY constraint_name;
ALTER TABLE messages DROP FOREIGN KEY messages_from_user_id_fk;
ALTER TABLE messages DROP FOREIGN KEY messages_to_user_id_fk;


-- мои команды для создания остальных foreign keys !!!

select * from friendship_statuses;
-- foreign key-s для таблицы friendship
ALTER TABLE friendship
  ADD CONSTRAINT friendship_fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT friendship_fk_friend_id
    FOREIGN KEY (friend_id) REFERENCES users(id),
  ADD CONSTRAINT friendship_fk_status_id
    FOREIGN KEY (status_id) REFERENCES friendship_statuses(id);
    
ALTER TABLE friendship DROP FOREIGN KEY friendship_fk_user_id;
ALTER TABLE friendship DROP FOREIGN KEY friendship_fk_friend_id;
ALTER TABLE friendship DROP FOREIGN KEY friendship_fk_status_id;

-- foreign key-s для таблицы communities_users
ALTER TABLE communities_users
  ADD CONSTRAINT communities_users_fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT communities_users_fk_community_id
    FOREIGN KEY (community_id) REFERENCES communities(id);
   
-- foreign key-s для таблицы media
ALTER TABLE media
  ADD CONSTRAINT media_fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT media_fk_media_type_id
    FOREIGN KEY (media_type_id) REFERENCES media_types(id);
   
-- foreign key-s для таблицы posts
ALTER TABLE posts 
  ADD CONSTRAINT posts_fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT posts_fk_community_id
    FOREIGN KEY (community_id) REFERENCES communities(id);
   
-- foreign key-s для таблицы communities_users
ALTER TABLE likes 
  ADD CONSTRAINT likes_fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT likes_fk_target_type_id
    FOREIGN KEY (target_type_id) REFERENCES target_types(id);
