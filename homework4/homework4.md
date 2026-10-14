# Инициализация первой ноды
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework4>docker exec cb-node1 couchbase-cli cluster-init --cluster localhost:8091 --cluster-username Administrator --cluster-password password123 --cluster-ramsize 1024 --cluster-index-ramsize 256 --services data,index,query
SUCCESS: Cluster initialized

# Добавление в кластер второй ноды
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework4>docker exec cb-node1 couchbase-cli server-add --cluster localhost:8091 --username Administrator --password password123 --server-add 172.22.0.3:8091 --server-add-username Administrator --server-add-password password123 --services data,index,query
SUCCESS: Server added

# Добавление в кластер третьей ноды
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework4>docker exec cb-node1 couchbase-cli server-add --cluster localhost:8091 --username Administrator --password password123 --server-add 172.22.0.2:8091 --server-add-username Administrator --server-add-password password123 --services data,index,query
SUCCESS: Server added

# Выполнение rebalance
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework4>docker exec cb-node1 couchbase-cli rebalance --cluster localhost:8091 --username Administrator --password password123
Unable to display progress bar on this os
SUCCESS: Rebalance complete

# Проверка кластера
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework4>docker exec cb-node1 couchbase-cli server-list --cluster localhost:8091 --username Administrator --password password123
ns_1@172.22.0.2 172.22.0.2:8091 healthy active
ns_1@172.22.0.3 172.22.0.3:8091 healthy active
ns_1@172.22.0.4 172.22.0.4:8091 healthy active
# Создание bucket
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework4>docker exec cb-node1 couchbase-cli bucket-create --cluster localhost:8091 --username Administrator --password password123 --bucket travel-sample --bucket-type couchbase --bucket-ramsize 512 --bucket-replica 1
SUCCESS: Bucket created

# Создание индекса
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework4>curl.exe -X POST -u Administrator:password123 http://localhost:8093/query/service -H "Content-Type: application/json" --data-binary "@create_index.json"
{
"requestID": "93bc76c6-b590-4d18-b597-4fb5357fb642",
"signature": null,
"results": [
],
"status": "success",
"metrics": {"elapsedTime": "3.427876848s","executionTime": "3.427719341s","resultCount": 0,"resultSize": 0,"serviceLoad": 6}
}

# Проверка наличия данных
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework4>curl.exe -X POST -u Administrator:password123 http://localhost:8093/query/service -H "Content-Type: application/json" --data-binary "@query.json"
{
"requestID": "b6bc8fe5-db5e-49f2-a11e-f1ff0d97234e",
"signature": {"*":"*"},
"results": [
{"travel-sample":{"id":10,"type":"airline","name":"40-Mile Air","iata":"Q5","icao":"MLA","callsign":"MILE-AIR","country":"United States"}},
{"travel-sample":{"id":10123,"type":"airline","name":"Texas Wings","iata":"TQ","icao":"TXW","callsign":"TXW","country":"United States"}},
{"travel-sample":{"id":10226,"type":"airline","name":"Atifly","iata":"A1","icao":"A1F","callsign":"atifly","country":"United States"}}
],
"status": "success",
"metrics": {"elapsedTime": "7.182572ms","executionTime": "7.124717ms","resultCount": 3,"resultSize": 408,"serviceLoad": 6}
}

# Остановка ноды
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework4>docker stop cb-node2
cb-node2

# Проверка кластера после остановки ноды
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework4>docker exec cb-node1 couchbase-cli server-list --cluster localhost:8091 --username Administrator --password password123
ns_1@172.22.0.2 172.22.0.2:8091 healthy active
ns_1@172.22.0.4 172.22.0.4:8091 healthy active

# Проверка доступности данных
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework4>curl.exe -X POST -u Administrator:password123 http://localhost:8093/query/service -H "Content-Type: application/json" --data-binary "@query.json"
{
"requestID": "c4953e2c-8e00-4d81-b3df-963753cf1655",
"signature": {"*":"*"},
"results": [
{"travel-sample":{"id":10,"type":"airline","name":"40-Mile Air","iata":"Q5","icao":"MLA","callsign":"MILE-AIR","country":"United States"}},
{"travel-sample":{"id":10123,"type":"airline","name":"Texas Wings","iata":"TQ","icao":"TXW","callsign":"TXW","country":"United States"}},
{"travel-sample":{"id":10226,"type":"airline","name":"Atifly","iata":"A1","icao":"A1F","callsign":"atifly","country":"United States"}}
],
"status": "success",
"metrics": {"elapsedTime": "4.51925ms","executionTime": "4.26208ms","resultCount": 3,"resultSize": 408,"serviceLoad": 6}
}

# Выполнение rebalance
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework4>docker exec cb-node1 couchbase-cli rebalance --cluster localhost:8091 --username Administrator --password password123
Unable to display progress bar on this os
SUCCESS: Rebalance complete

# Проверка данных и статистики
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework4>curl.exe -X POST -u Administrator:password123 http://localhost:8093/query/service -H "Content-Type: application/json" --data-binary "@query.json"
{
"requestID": "cd112fe5-f247-4c79-a04a-b755677dddf0",
"signature": {"*":"*"},
"results": [
{"travel-sample":{"id":10,"type":"airline","name":"40-Mile Air","iata":"Q5","icao":"MLA","callsign":"MILE-AIR","country":"United States"}},
{"travel-sample":{"id":10123,"type":"airline","name":"Texas Wings","iata":"TQ","icao":"TXW","callsign":"TXW","country":"United States"}},
{"travel-sample":{"id":10226,"type":"airline","name":"Atifly","iata":"A1","icao":"A1F","callsign":"atifly","country":"United States"}}
],
"status": "success",
"metrics": {"elapsedTime": "3.713454ms","executionTime": "3.609792ms","resultCount": 3,"resultSize": 408,"serviceLoad": 6}
}

D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework4>docker exec cb-node1 cbstats 172.22.0.4:11210 -u Administrator -p password123 all -b travel-sample | findstr "curr_items"
 curr_items:                                                31700
 curr_items_tot:                                            63288
 vb_active_curr_items:                                      31700
 vb_pending_curr_items:                                     0
 vb_replica_curr_items:                                     31588