--  1) Команды на изменение таблицы(ALTER TABLE):
--  1.1) добавляем доп. поле в таблицу(ADD) с описанием типа + после какого поля вставляем
ALTER TABLE profiles
ADD patronymic_name VARCHAR(100) COMMENT 'Отчество пользователя' AFTER user_id;
--  1.2) переименование поля таблицы(RENAME)
ALTER TABLE profiles RENAME COLUMN status TO user_status_id;
--  1.3) изменение типа поля(MODIFY), его характиристик в таблице
ALTER TABLE profiles MODIFY COLUMN user_status_id INT UNSIGNED;
--  1.4) удаление поля-колонки из таблицы(DROP COLUMN)
ALTER TABLE users DROP COLUMN first_name;

-- 2) Обновление данных таблицы(UPDATE) - INSERT INTO уже использовалась ранее
UPDATE profiles set user_status_id = null;

-- 3) Вложенные запросы на примере UPDATE
-- () - данные, которые вставятся в p.first_name = ()
-- внутри () другой запрос(SELECT), который дает данные
-- похожий запрос может использоваться и в блоке WHERE, только с оператором IN
-- SELECT column_name(s)
-- FROM table_name
-- WHERE column_name IN (SELECT STATEMENT);
UPDATE profiles p
SET
  p.first_name = (SELECT u.first_name FROM users u WHERE u.id = p.user_id),
;

-- 4) Вывод только униальных(DISTINCT) занчений из поля-колонки
SELECT DISTINCT user_status_id FROM profiles ORDER BY user_status_id;

-- 5) Вывод случайно(псевдо) записи из таблицы(ORDER BY rand())
SELECT * FROM media
WHERE media_type_id = (SELECT id FROM media_types WHERE name = 'Image')
ORDER BY rand() LIMIT 1;

-- 6) Очистка таблицы(TRUNCATE)
TRUNCATE TABLE media_types;
