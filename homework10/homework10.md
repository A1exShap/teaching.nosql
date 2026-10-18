# Проектирование графа
## Узлы
- (:Operator {name}) — туроператоры (например, «Pegas», «Coral», «Anex»).
- (:Country {name}) — страны (например, «Турция», «Египет»).
- (:Resort {name}) — конкретные курорты/места (например, «Анталия», «Хургада»).
- (:City {name}) — города с аэропортами/вокзалами (например, «Москва», «Стамбул»).

## Связи
- (:Operator)-[:OFFERS]->(:Country) — оператор предлагает страну.
- (:Country)-[:HAS_RESORT]->(:Resort) — в стране есть курорт.
- (:Resort)-[:NEAR_CITY]->(:City) — ближайший к курорту город.
- (:City)-[:ROUTE {transport: 'ground'|'air'}]->(:City) — маршрут между городами с указанием вида транспорта.

## Пример запроса по поиску цепочки от туроператора до курорта наземным транспортом
MATCH (op:Operator)-[:OFFERS]->(c:Country)-[:HAS_RESORT]->(r:Resort)-[:NEAR_CITY]->(city:City)
MATCH path = (city)-[:ROUTE*1..5 {transport: 'ground'}]->(dest:City)
RETURN op.name, c.name, r.name, [n IN nodes(path) | n.name] AS route, dest.name

## Индекс
CREATE INDEX operator_name IF NOT EXISTS FOR (o:Operator) ON (o.name);


# Реализация
## Запуск контейнера
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework10>docker compose up -d
[+] Running 5/5
 ✔ neo4j Pulled                                                                                                   19.9s
   ✔ 4f4fb700ef54 Already exists                                                                                   0.0s
   ✔ 2ce9187fdeea Download complete                                                                               12.6s
   ✔ dbb8dd4100e0 Download complete                                                                                0.5s
   ✔ 86c7147e3b4f Download complete                                                                               11.7s
[+] Running 3/3
 ✔ Network homework10_default      Created                                                                         0.3s
 ✔ Volume "homework10_neo4j-data"  Created                                                                         0.0s
 ✔ Container neo4j-demo            Started                                                                         1.5s

## Проверка контейнера
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework10>docker ps --filter "name=neo4j"
CONTAINER ID   IMAGE        COMMAND                  CREATED              STATUS              PORTS                                                      NAMES
4959961c7488   neo4j:5.26   "tini -g -- /startup…"   About a minute ago   Up About a minute   0.0.0.0:7474->7474/tcp, 7473/tcp, 0.0.0.0:7687->7687/tcp   neo4j-demo

## Создание туроператоров
CREATE (peg:Operator {name: 'Pegas'})
CREATE (coral:Operator {name: 'Coral Travel'})
CREATE (anex:Operator {name: 'Anex Tour'})

## Создание стран
CREATE (tr:Country {name: 'Турция'})
CREATE (eg:Country {name: 'Египет'})

## Создание курортов
CREATE (antalya:Resort {name: 'Анталия'})
CREATE (kemer:Resort {name: 'Кемер'})
CREATE (hurgada:Resort {name: 'Хургада'})

## Создание городов
CREATE (moscow:City {name: 'Москва'})
CREATE (sochi:City {name: 'Сочи'})
CREATE (istanbul:City {name: 'Стамбул'})
CREATE (cairo:City {name: 'Каир'})
CREATE (antalyaCity:City {name: 'Анталия (город)'})

## Связывание операторов со странами
CREATE (peg)-[:OFFERS]->(tr)
CREATE (coral)-[:OFFERS]->(tr)
CREATE (coral)-[:OFFERS]->(eg)
CREATE (anex)-[:OFFERS]->(tr)

## Связывание стран с курортами
CREATE (tr)-[:HAS_RESORT]->(antalya)
CREATE (tr)-[:HAS_RESORT]->(kemer)
CREATE (eg)-[:HAS_RESORT]->(hurgada)

## Связывание курортов с городами
CREATE (antalya)-[:NEAR_CITY]->(antalyaCity)
CREATE (kemer)-[:NEAR_CITY]->(antalyaCity)
CREATE (hurgada)-[:NEAR_CITY]->(cairo)

## Создание маршрутов
CREATE (moscow)-[:ROUTE {transport: 'ground'}]->(sochi)
CREATE (sochi)-[:ROUTE {transport: 'ground'}]->(istanbul)
CREATE (istanbul)-[:ROUTE {transport: 'ground'}]->(antalyaCity)
CREATE (moscow)-[:ROUTE {transport: 'air'}]->(istanbul)
CREATE (moscow)-[:ROUTE {transport: 'air'}]->(cairo)

## Проверка данных
MATCH (n) RETURN n;

MATCH (a)-[r:ROUTE]->(b) RETURN a.name AS From, r.transport AS Transport, b.name AS To;

Выводы приложены в виде скриншотов.

## Проверка плана
EXPLAIN
MATCH (op:Operator {name: 'Pegas'})
RETURN op;

Результат приложен в скрине.

## Создание индекса
CREATE INDEX operator_name_index IF NOT EXISTS FOR (o:Operator) ON (o.name);

## Проверка плана после создания индекса
EXPLAIN
MATCH (op:Operator {name: 'Pegas'})
RETURN op;

Результат приложен в скрине.

## Результат анализа планов "ДО" и "ПОСЛЕ"
- До создания индекса Neo4j перебирает все узлы с меткой Operator, чтобы найти «Pegas». На маленькой базе это происходит быстро, но на большом количестве узлов — это серьезные затраты.
- После создания индекса Neo4j мгновенно находит нужный узел через индекс operator_name_index. Ему не требуется перебор остальных узлов.