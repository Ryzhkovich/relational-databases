-- 3я часть дз
-- "Определить кто больше поставил лайков (всего) - мужчины или женщины?"
select * from likes l;
select * from profiles p ;

-- все id-ки
select user_id from likes;

-- мужчины
select l.user_id, count(l.user_id) as c, p.gender_id 
from likes l 
left join profiles p
on l.user_id = p.user_id
group by l.user_id 
having count(l.user_id) > 0
and p.gender_id = 1;

-- женщины
select l.user_id, count(l.user_id) as c, p.gender_id 
from likes l 
left join profiles p
on l.user_id = p.user_id
group by l.user_id 
having count(l.user_id) > 0
and p.gender_id = 2;

-- кол-во лайков мужчин - в моей таблице 38/80
select sum(c) from (
	select count(l.user_id) as c
	from likes l 
	left join profiles p
	on l.user_id = p.user_id
	where p.gender_id = 1
	group by l.user_id 
	having count(l.user_id) > 0
) as t;

-- кол-во лайков женщин - в моей таблице - 42/80
select sum(c) from (
	select count(l.user_id) as c
	from likes l 
	left join profiles p
	on l.user_id = p.user_id
	where p.gender_id = 2
	group by l.user_id 
	having count(l.user_id) > 0
) as t;


-- 4я часть дз
-- "Подсчитать количество лайков которые получили 10 самых молодых пользователей."
select * from likes l;
select * from profiles p;

-- количество уникальных id пользователей, которым поставили like
select DISTINCT target_id from likes l;

-- специально для сравнения привожу всех самых молодых пользователей
-- чтоб вошли все, кто есть в искомом запросе
select user_id 
from profiles p 
order by birthday DESC 
limit 16;

-- искомый перечень
select user_id 
from profiles p 
where user_id in (select DISTINCT target_id from likes)
order by birthday DESC 
limit 10;







