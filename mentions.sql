-- show databases;
-- use coursework;
-- show tables;

-- делаю дз-8

use vk;


-- Я решил переписать запросы из разобранного домашнего задания
-- Буду приводить пример из разобранного ДЗ №6
-- и следом буду писать запрос уже переписанный на join-ы

-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?
SELECT (
  SELECT (SELECT gender_info FROM gender WHERE id = profiles.gender_id)
  FROM profiles WHERE user_id = likes.user_id
) AS gender,
count(*) AS total
FROM likes
GROUP BY gender
ORDER BY total DESC
LIMIT 2;

--  переписанный запрос через  join-ы
select count(l.user_id) as amount, g.gender_info
from likes l
join profiles p on p.user_id = l.user_id 
join gender g on g.id = p.gender_id
group by g.gender_info
ORDER BY amount DESC;


-- 4. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
-- Подбиваем сумму внешним запросом
SELECT SUM(likes_total) FROM (
  SELECT (SELECT COUNT(*) FROM likes WHERE target_id = profiles.user_id AND target_type_id = 2) 
    AS likes_total
  FROM profiles
  ORDER BY birthday 
  DESC LIMIT 10
) AS user_likes;  

-- Другой вариант
SELECT COUNT(*) FROM likes
  WHERE target_type_id = 2
    AND target_id IN (SELECT * FROM (
      SELECT user_id FROM profiles ORDER BY birthday DESC LIMIT 10
    ) AS sorted_profiles ) 
;

-- кажись в файле примеров из классной работе есть где-то опечатка
-- запрос кол-во лайков у 10 самых молодых пользователей
-- выод пользователей с ДР и кол-ва лайков у пользователей, 10 самых молодых
SELECT l.user_id, p.birthday, COUNT(l.target_id) as count
FROM likes l
join profiles p on l.user_id = p.user_id 
GROUP BY l.user_id, p.birthday 
HAVING count > 0
ORDER by p.birthday desc
limit 10;

-- от всех вложенных селектов избавиться не смог(((
select sum(tt.coun) from (
	SELECT l.user_id, p.birthday, COUNT(l.target_id) as coun
	FROM likes l
	join profiles p on l.user_id = p.user_id 
	GROUP BY l.user_id, p.birthday 
	HAVING coun > 0
	ORDER by p.birthday desc
	limit 10
) as tt;


-- 5. Найти 10 пользователей, которые проявляют наименьшую активность
-- в использовании социальной сети
SELECT 
  CONCAT(first_name, ' ', last_name) AS user, 
	(SELECT COUNT(*) FROM likes WHERE likes.user_id = profiles.user_id) +
	(SELECT COUNT(*) FROM media WHERE media.user_id = profiles.user_id) +
	(SELECT COUNT(*) FROM messages WHERE messages.from_user_id = profiles.user_id) AS overall_activity 
	  FROM profiles
	  ORDER BY overall_activity
	  LIMIT 10;
	  
 
-- select sum(tt.coun) from (
	SELECT l.user_id, p.birthday, COUNT(l.target_id) as coun
	FROM likes l
	join profiles p on l.user_id = p.user_id 
	GROUP BY l.user_id, p.birthday 
	HAVING coun > 0
	ORDER by coun
	limit 10
-- ) as tt;
	 
-- select sum(tt.coun) from (
	SELECT l.user_id, p.birthday, COUNT(l.user_id) as coun
	FROM media l
	join profiles p on l.user_id = p.user_id 
	GROUP BY l.user_id, p.birthday 
	HAVING coun > 0
	ORDER by coun 
	limit 10
-- ) as tt;

-- select sum(tt.coun) from (
	SELECT l.from_user_id, p.birthday, COUNT(l.from_user_id) as coun
	FROM messages l
	join profiles p on l.from_user_id = p.user_id 
	GROUP BY l.from_user_id, p.birthday 
	HAVING coun > 0
	ORDER by coun 
	limit 10
-- ) as tt;

-- поппытки сделать c join-ами, пока не вышло	 
SELECT CONCAT(first_name, ' ', last_name) AS user, 
FROM profiles p
join likes l on l.user_id = p.user_id 
join media m on m.user_id = p.user_id 
join messages m2 on m2.from_user_id = p.user_id 
where sum(
	
) as overall_activity
ORDER BY overall_activity
LIMIT 10;