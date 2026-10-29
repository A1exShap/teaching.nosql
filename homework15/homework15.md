# Проверка контейнера
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework15>docker ps --filter "name=tarantool"
CONTAINER ID   IMAGE                      COMMAND                  CREATED              STATUS                        PORTS                    NAMES
93e4163c4ac8   tarantool/tarantool:2.11   "docker-entrypoint.s…"   About a minute ago   Up About a minute (healthy)   0.0.0.0:3301->3301/tcp   tarantool-demo

# Создание спейса
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework15>docker exec -it tarantool-demo tarantoolctl connect 3301
connected to localhost:3301
localhost:3301> box.schema.space.create('tickets')
---
- engine: memtx
  before_replace: 'function: 0x7653a12a9d98'
  field_count: 0
  is_sync: false
  on_replace: 'function: 0x7653a12a9bd8'
  temporary: false
  index: []
  is_local: false
  enabled: false
  name: tickets
  id: 512
- created
...

# Формат спейса (поля)
localhost:3301> box.space.tickets:format({
    {name = 'id', type = 'unsigned'},
    {name = 'airline', type = 'string'},
    {name = 'departure_date', type = 'string'},
    {name = 'departure_city', type = 'string'},
    {name = 'arrival_city', type = 'string'},
    {name = 'min_price', type = 'unsigned'}
})
---
...

# Создание первичного индекса
localhost:3301> box.space.tickets:create_index('primary', {parts = {'id'}})
---
- unique: true
  parts:
  - type: unsigned
    is_nullable: false
    fieldno: 1
  hint: true
  id: 0
  type: TREE
  space_id: 512
  name: primary
...

# Создание вторичного индекса
localhost:3301> box.space.tickets:create_index('secondary', {
    parts = {'departure_date', 'airline', 'departure_city'},
    unique = false
})
---
- unique: false
  parts:
  - type: string
    is_nullable: false
    fieldno: 3
  - type: string
    is_nullable: false
    fieldno: 2
  - type: string
    is_nullable: false
    fieldno: 4
  hint: true
  id: 1
  type: TREE
  space_id: 512
  name: secondary
...

# Добавление данных
localhost:3301> box.space.tickets:insert{1, 'Aeroflot', '2025-01-01', 'Moscow', 'Sochi', 4500}
box.space.tickets:insert{2, 'S7', '2025-01-01', 'Moscow', 'Novosibirsk', 2800}
box.space.tickets:insert{3, 'UTair', '2025-01-02', 'Moscow', 'Sochi', 3200}
box.space.tickets:insert{4, 'Pobeda', '2025-01-01', 'Moscow', 'Kazan', 1500}
box.space.tickets:insert{5, 'Aeroflot', '2025-01-03', 'Moscow', 'Sochi', 5000}
---
...

# Проверка данных
localhost:3301> box.space.tickets:select{}
---
- - [1, 'Aeroflot', '2025-01-01', 'Moscow', 'Sochi', 4500]
  - [2, 'S7', '2025-01-01', 'Moscow', 'Novosibirsk', 2800]
  - [3, 'UTair', '2025-01-02', 'Moscow', 'Sochi', 3200]
  - [4, 'Pobeda', '2025-01-01', 'Moscow', 'Kazan', 1500]
  - [5, 'Aeroflot', '2025-01-03', 'Moscow', 'Sochi', 5000]
...

# Запрос на выборку минимальной стоимости
localhost:3301> box.space.tickets.index.secondary:select({'2025-01-01'})
---
- - [1, 'Aeroflot', '2025-01-01', 'Moscow', 'Sochi', 4500]
  - [4, 'Pobeda', '2025-01-01', 'Moscow', 'Kazan', 1500]
  - [2, 'S7', '2025-01-01', 'Moscow', 'Novosibirsk', 2800]
...

# Создание Lua-функции
localhost:3301> function get_cheap_tickets()
    local result = {}
    for _, tuple in box.space.tickets:pairs() do
        if tuple.min_price < 3000 then
            table.insert(result, tuple)
        end
    end
    return result
end
---
...

# Вызов Lua-функции
localhost:3301> get_cheap_tickets()
---
- - [2, 'S7', '2025-01-01', 'Moscow', 'Novosibirsk', 2800]
  - [4, 'Pobeda', '2025-01-01', 'Moscow', 'Kazan', 1500]
...

**Скрин с командами в каталоге с ДЗ (tarantool.png)**