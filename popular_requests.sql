
-- Популярные звпросы:

-- 1) Пользователи, которые дольше всего зарегистрированы на сайте с подпиской
select * from users u;

select id, full_name, DATEDIFF(NOW(), created_at) as time_with
from users u
where subscription = 1
order by time_with DESC;

-- 2) пользователи которые сделали более чем по одному заказу в пор]дке уменьшения
SELECT DISTINCT user_id, count(user_id) as c 
from orders o 
group by user_id 
having count(user_id) > 0
ORDER by c DESC;

-- 3) вывод пользователей по дня активации на сайте с подпиской с кол-вом заказов
select u.id, u.full_name, DATEDIFF(NOW(), u.created_at) as time_with, count(o2.user_id) as c 
from users u
left join orders o2 
on o2.user_id = u.id
where u.subscription = 1
group by o2.user_id, u.id 
having count(o2.user_id) > 0
ORDER by c DESC, time_with DESC;



-- 4) Количество товаров по каталогам с названиями каталогов
select p.catalog_id, count(p.catalog_id) as c, c2.name 
from products p
left join catalogs c2 
on c2.id = p.catalog_id 
group by p.catalog_id 
HAVING count(p.catalog_id) > 0
ORDER by c DESC;

-- 5) Количество товаров по брендам с названиями брендов
select brand_id, count(brand_id) as c, b2.name 
from products p
left join brands b2  
on b2.id = p.brand_id 
group by brand_id 
HAVING count(brand_id) > 0
ORDER by c DESC;

-- 6) Самые популярные каталоги по количеству проданных товаров с названием каталогов
-- SELECT * from orders o ;
SELECT p.catalog_id, SUM(op.product_quantity) as s, c2.name 
from order_products op
left join products p 
on p.id = op.product_id
left join catalogs c2 
on c2.id = p.catalog_id 
group by p.catalog_id 
HAVING count(p.catalog_id) > 0
ORDER by s DESC;

-- 7) Самые популярные бренды по количеству проданных товаров с названием брендов
-- SELECT * from orders o ;
SELECT p.brand_id, SUM(op.product_quantity) as s, b2.name 
from order_products op
left join products p 
on p.id = op.product_id
left join brands b2
on b2.id = p.brand_id 
group by p.brand_id 
HAVING count(p.brand_id) > 0
ORDER by s DESC;

-- 8) Вывод стоимости заказов с товаром с id = 9
select p.id, p.name, (op.product_quantity * p.price) as total_sum
from order_products op
left join products p 
on p.id = op.product_id
where p.id = 9
GROUP by total_sum;

-- 9) Вывод суммарной стоимости всех заказов с учетом кол-ва товара с id = 9
SELECT t.id, t.name, sum(t.total_sum) as all_sum
from (
	select p.id, p.name, (op.product_quantity * p.price) as total_sum
	from order_products op
	left join products p 
	on p.id = op.product_id
	where p.id = 9
	GROUP by total_sum
) as t
GROUP by t.id, t.name;

-- 9) Вывод суммарной стоимости всех заказов по всем товарам
SELECT t.id, t.name, sum(t.total_sum) as all_sum
from (
	select p.id, p.name, (op.product_quantity * p.price) as total_sum
	from order_products op
	left join products p 
	on p.id = op.product_id
	group by p.id, total_sum
	HAVING count(p.id) > 0
	-- GROUP by total_sum
) as t
GROUP by t.id, t.name
order by all_sum desc, id asc;

-- 9) Вывод суммарной стоимости всех заказов по всем товарам, с ценой одного товара и общим кол-вом купленных товаров
SELECT t.id, t.name, t.price as single_price, sum(t.total_sum) as all_sum, FLOOR(sum(t.total_sum)/t.price) AS all_good_count
from (
	select p.id, p.name, p.price, (op.product_quantity * p.price) as total_sum
	from order_products op
	left join products p 
	-- outer join products p 
	on p.id = op.product_id
	group by p.id, total_sum
	HAVING count(p.id) >= 0
	-- GROUP by total_sum
) as t
GROUP by t.id, t.name, t.price
order by all_sum desc, id asc;

-- 10) 9 запрос + добавлены некупленные ни разу товары
SELECT t.id, t.name, t.price as single_price, sum(t.total_sum) as all_sum, FLOOR(sum(t.total_sum)/t.price) AS all_good_count
from (
	(
	select p.id, p.name, p.price, (op.product_quantity * p.price) as total_sum
	from order_products op
	left join products p 
	on p.id = op.product_id
	group by p.id, total_sum
	HAVING count(p.id) >= 0
	)
	UNION 
	(
	select p.id, p.name, p.price, (op.product_quantity * p.price) as total_sum
	from order_products op
	right join products p 
	on p.id = op.product_id
	group by p.id, total_sum
	HAVING count(p.id) >= 0
	)
) as t
GROUP by t.id, t.name, t.price
order by all_sum desc, id asc;

-- 11) Количество оценок товаров с названием
select s.product_id, count(s.product_id) as c, p2.name
from score s 
left join products p2 
on p2.id = s.product_id 
group by s.product_id 
HAVING count(s.product_id) > 0
ORDER by c desc;

-- 12) Оценка товаров: общ. кол-во очков, кол-во голосов, средняя оценка, название товара
select s.product_id, sum(s.value) as all_points, count(s.product_id) as voices, p2.name, (sum(s.value)/count(s.value)) as middle_value
from score s 
left join products p2 
on p2.id = s.product_id 
group by s.product_id 
HAVING count(s.product_id) > 0
ORDER by middle_value desc, all_points desc;

-- 13) Товары с отзывами и средней оценкой выше 6
select s.product_id, sum(s.value) as all_points, count(s.product_id) as voices, p2.name, (sum(s.value)/count(s.value)) as middle_value, r2.body 
from score s 
left join products p2 
on p2.id = s.product_id 
left join reviews r2 
on r2.product_id = p2.id
where r2.product_id = s.product_id 
group by s.product_id, r2.body 
HAVING sum(s.value)/count(s.value) > 6
ORDER by middle_value desc, all_points desc;








