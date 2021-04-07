use vk;
show tables;

-- Часть 1
-- Ниже приведеы 3 шт индексов, которые я бы добавил, 
-- т.к считаю что на стр вк часто используются данные поля
-- 1) Медиа / имя файла 
EXPLAIN ANALYZE
SELECT filename FROM media m2
WHERE filename;

DROP INDEX media_filename_idx ON media;
CREATE INDEX media_filename_idx ON media(filename);

-- 2) Профиль / id фотки
EXPLAIN ANALYZE
SELECT photo_id FROM profiles p2 
WHERE photo_id;

DROP INDEX profiles_photo_id_idx ON profiles;
CREATE INDEX profiles_photo_id_idx ON profiles(photo_id);

-- 3) Посты / заголовки
EXPLAIN ANALYZE
select head from posts p;

DROP INDEX posts_head_idx ON posts;
CREATE INDEX posts_head_idx ON posts(head);


-- -----------------------------------------
-- Часть 2

SELECT DISTINCT mt.name,
  AVG(m.size) OVER w AS avg_size,
  MIN(m.size) OVER w AS min_size,
  MAX(m.size) OVER w AS max_size,
  SUM(m.size) OVER w AS total_by_type,
  SUM(m.size) OVER() AS total,
  SUM(m.size) OVER w / SUM(m.size) OVER() * 100 AS "%"
FROM media m
JOIN media_types mt ON mt.id = m.media_type_id
WINDOW w AS (PARTITION BY m.media_type_id)
ORDER BY name
;



-- Убираем DISTINCT
SELECT mt.name,
  AVG(m.size) OVER w AS avg_size,
  MIN(m.size) OVER w AS min_size,
  MAX(m.size) OVER w AS max_size,
  SUM(m.size) OVER w AS total_by_type,
  SUM(m.size) OVER() AS total,
  SUM(m.size) OVER w / SUM(m.size) OVER() * 100 AS "%"
FROM media m
JOIN media_types mt ON mt.id = m.media_type_id
WINDOW w AS (PARTITION BY m.media_type_id)
ORDER BY name
;

-- -----------------------------------------

SELECT * from communities c;
SELECT * from users u ;
select * from communities_users cu;

select DISTINCT c.name,
	AVG(cu.user_id) OVER w as avg_users
from communities c
join communities_users cu 
on cu.community_id = c.id
join users u2 
on u2.id = cu.community_id
WINDOW w AS (PARTITION BY c.name)
ORDER BY c.name
;

-- -----------------------------------------

SELECT * from communities c;
SELECT * from users u ;
select * from communities_users cu;
SELECT * from profiles p;


-- Вот этот запрос смотреть!
-- ] плохо разобрался в теме, примеры в лекции на мой взгялд проще
-- и не хватило методички по оконным ф-циям, с примерами
SELECT DISTINCT c.name,
	sum(cu.user_id / cu.user_id) over() as avg_users,
	sum(cu.community_id / cu.community_id) over(PARTITION BY cu.community_id) as avg_comm,
	sum(cu.community_id / cu.community_id) over(PARTITION BY cu.community_id) as asd,
	min(p2.birthday) over(PARTITION BY cu.community_id) as min_day,
	max(p2.birthday) over(PARTITION BY cu.community_id) as max_day
from communities c
join communities_users cu 
on cu.community_id = c.id
join users u2 
on u2.id = cu.community_id
join profiles p2 
on p2.user_id = u2.id;


-- select DISTINCT c.name,
-- 	sum(cu.community_id) over() / sum(cu.community_id) over(PARTITION BY cu.community_id) as avg_users,
-- 	min(p2.birthday) over w as min_age,
-- 	max(p2.birthday) over w as max_age,
-- 	SUM(cu.community_id) OVER w as all_users
-- from communities c
-- join communities_users cu 
-- on cu.community_id = c.id
-- join users u2 
-- on u2.id = cu.community_id
-- join profiles p2 
-- on p2.user_id = u2.id
-- WINDOW w AS ()
-- ORDER BY c.name
-- ;
