// 1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.
SADD ip '192.168.0.100' '192.168.0.101' '192.168.0.102'
// Невозможно добавить в коллекцию уже имеющиейся в ней ip адрес, только уникальные значения
SADD ip '192.168.0.100'
// просмотрим список уникальных ip
SMEMBERS ip
// кол-во адресов в коллекции
SCARD ip


// 2. При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу
// и наоброт, поиск электронного адреса пользователя по его имени.

// setters
set alex@mail.ru alex
set alex alex@mail.ru
// getters
get alex@mail.ru
get alex


// 3. Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.

// products
use products
db.products.insert(
    {
		"name": "Intel Core i9-9700",
		"description": "Процессор для игровых ПК",
		"price": "28000.00",
		"catalog_id": "Процессоры",
		"created_at": new Date(), "updated_at": new Date()
    }
)

db.products.insert(
    {
		"name": "Intel Core i10-10900",
		"description": "Процессор для игровых ПК",
		"price": "38000.00",
		"catalog_id": "Процессоры",
		"created_at": new Date(), "updated_at": new Date()
    }
)

db.products.find().pretty()
db.products.find({name: "Intel Core i10-10900"}).pretty()

// catalogs
use catalogs
db.catalogs.insertMany([{"name": "Процессоры"}, {"name": "Мат.платы"}, {"name": "Видеокарты"}])

