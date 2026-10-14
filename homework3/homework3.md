# Подключение к Config Server Replica Set
C:\Users\alexs>docker exec -it cfg1 mongosh --port 27019
Current Mongosh Log ID: 6acdde7cae11038d34b5ffee
Connecting to:          mongodb://127.0.0.1:27019/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.10.0
Using MongoDB:          7.0.40
Using Mongosh:          2.10.0

For mongosh info see: https://www.mongodb.com/docs/mongodb-shell/


To help improve our products, anonymous usage data is collected and sent to MongoDB periodically (https://www.mongodb.com/legal/privacy-policy).
You can opt-out by running the disableTelemetry() command.

------
   The server generated these startup warnings when booting
   2026-10-13T07:27:09.681+00:00: Using the XFS filesystem is strongly recommended with the WiredTiger storage engine. See http://dochub.mongodb.org/core/prodnotes-filesystem
   2026-10-13T07:27:11.517+00:00: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted
   2026-10-13T07:27:11.517+00:00: vm.max_map_count is too low
------


# Инициализация Replica Set
test> rs.initiate({
|   _id: "shard1RS",
|   members: [
|     { _id: 0, host: "shard1a:27018" },
|     { _id: 1, host: "shard1b:27018" },
|     { _id: 2, host: "shard1c:27018" }
|   ]
| })
{ ok: 1 }
shard1RS [direct: other] test>

# Второй шард
C:\Users\alexs>docker exec -it shard2a mongosh --port 27018
Current Mongosh Log ID: 6acde10fbe50ab8575e8093c
Connecting to:          mongodb://127.0.0.1:27018/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.10.0
Using MongoDB:          7.0.40
Using Mongosh:          2.10.0

For mongosh info see: https://www.mongodb.com/docs/mongodb-shell/


To help improve our products, anonymous usage data is collected and sent to MongoDB periodically (https://www.mongodb.com/legal/privacy-policy).
You can opt-out by running the disableTelemetry() command.

------
   The server generated these startup warnings when booting
   2026-10-13T07:27:09.683+00:00: Using the XFS filesystem is strongly recommended with the WiredTiger storage engine. See http://dochub.mongodb.org/core/prodnotes-filesystem
   2026-10-13T07:27:11.668+00:00: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted
   2026-10-13T07:27:11.669+00:00: vm.max_map_count is too low
------

test> rs.initiate({
|   _id: "shard2RS",
|   members: [
|     { _id: 0, host: "shard2a:27018" },
|     { _id: 1, host: "shard2b:27018" },
|     { _id: 2, host: "shard2c:27018" }
|   ]
| })
{ ok: 1 }
shard2RS [direct: other] test> rs.status().members.map(m => ({ name: m.name, state: m.stateStr }))
[
  { name: 'shard2a:27018', state: 'SECONDARY' },
  { name: 'shard2b:27018', state: 'PRIMARY' },
  { name: 'shard2c:27018', state: 'SECONDARY' }
]
shard2RS [direct: secondary] test>

# Третий шард
C:\Users\alexs>docker exec -it shard3a mongosh --port 27018
Current Mongosh Log ID: 6acde27a8988f7211e9416ff
Connecting to:          mongodb://127.0.0.1:27018/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.10.0
Using MongoDB:          7.0.40
Using Mongosh:          2.10.0

For mongosh info see: https://www.mongodb.com/docs/mongodb-shell/


To help improve our products, anonymous usage data is collected and sent to MongoDB periodically (https://www.mongodb.com/legal/privacy-policy).
You can opt-out by running the disableTelemetry() command.

------
   The server generated these startup warnings when booting
   2026-10-13T07:27:09.650+00:00: Using the XFS filesystem is strongly recommended with the WiredTiger storage engine. See http://dochub.mongodb.org/core/prodnotes-filesystem
   2026-10-13T07:27:11.594+00:00: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted
   2026-10-13T07:27:11.594+00:00: vm.max_map_count is too low
------

test> rs.initiate({
|   _id: "shard3RS",
|   members: [
|     { _id: 0, host: "shard3a:27018" },
|     { _id: 1, host: "shard3b:27018" },
|     { _id: 2, host: "shard3c:27018" }
|   ]
| })
{ ok: 1 }
shard3RS [direct: other] test> rs.status().members.map(m => ({ name: m.name, state: m.stateStr }))
[
  { name: 'shard3a:27018', state: 'PRIMARY' },
  { name: 'shard3b:27018', state: 'SECONDARY' },
  { name: 'shard3c:27018', state: 'SECONDARY' }
]
shard3RS [direct: secondary] test>

# Проверка cfg
C:\Users\alexs>docker exec -it cfg1 mongosh --port 27019
Current Mongosh Log ID: 6acde3271aea10850e6116c5
Connecting to:          mongodb://127.0.0.1:27019/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.10.0
Using MongoDB:          7.0.40
Using Mongosh:          2.10.0

For mongosh info see: https://www.mongodb.com/docs/mongodb-shell/

------
   The server generated these startup warnings when booting
   2026-10-13T07:27:09.681+00:00: Using the XFS filesystem is strongly recommended with the WiredTiger storage engine. See http://dochub.mongodb.org/core/prodnotes-filesystem
   2026-10-13T07:27:11.517+00:00: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted
   2026-10-13T07:27:11.517+00:00: vm.max_map_count is too low
------

cfgrs [direct: primary] test> rs.status().members.map(m => ({ name: m.name, state: m.stateStr }))
[
  { name: 'cfg1:27019', state: 'PRIMARY' },
  { name: 'cfg2:27019', state: 'SECONDARY' },
  { name: 'cfg3:27019', state: 'SECONDARY' }
]
cfgrs [direct: primary] test> rs.conf().configsvr
true
cfgrs [direct: primary] test>

# Добавление шардов
[direct: mongos] test> sh.addShard("shard1RS/shard1a:27018,shard1b:27018,shard1c:27018")
{
  shardAdded: 'shard1RS',
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1791878420, i: 4 }),
    signature: {
      hash: Binary.createFromBase64('AAAAAAAAAAAAAAAAAAAAAAAAAAA=', 0),
      keyId: Long('0')
    }
  },
  operationTime: Timestamp({ t: 1791878420, i: 4 })
}
[direct: mongos] test> sh.addShard("shard2RS/shard2a:27018,shard2b:27018,shard2c:27018")
{
  shardAdded: 'shard2RS',
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1791879644, i: 14 }),
    signature: {
      hash: Binary.createFromBase64('AAAAAAAAAAAAAAAAAAAAAAAAAAA=', 0),
      keyId: Long('0')
    }
  },
  operationTime: Timestamp({ t: 1791879644, i: 4 })
}
[direct: mongos] test> sh.addShard("shard3RS/shard3a:27018,shard3b:27018,shard3c:27018")
{
  shardAdded: 'shard3RS',
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1791879678, i: 3 }),
    signature: {
      hash: Binary.createFromBase64('AAAAAAAAAAAAAAAAAAAAAAAAAAA=', 0),
      keyId: Long('0')
    }
  },
  operationTime: Timestamp({ t: 1791879678, i: 3 })
}

# Включение шардирования
[direct: mongos] test> sh.enableSharding("homework_db")
{
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1791883013, i: 9 }),
    signature: {
      hash: Binary.createFromBase64('AAAAAAAAAAAAAAAAAAAAAAAAAAA=', 0),
      keyId: Long('0')
    }
  },
  operationTime: Timestamp({ t: 1791883013, i: 3 })
}

# Шардирование коллекции
[direct: mongos] test> sh.shardCollection("homework_db.users", { user_id: "hashed" })
{
  collectionsharded: 'homework_db.users',
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1791883609, i: 33 }),
    signature: {
      hash: Binary.createFromBase64('AAAAAAAAAAAAAAAAAAAAAAAAAAA=', 0),
      keyId: Long('0')
    }
  },
  operationTime: Timestamp({ t: 1791883609, i: 33 })
}

# Проверка распределения данных
[direct: mongos] homework_db> sh.getShardedDataDistribution().toArray().filter(x => x.ns === "homework_db.users").shift().shards
[
  {
    shardName: 'shard3RS',
    numOrphanedDocs: 0,
    numOwnedDocuments: 33755,
    ownedSizeBytes: 10869110,
    orphanedSizeBytes: 0
  },
  {
    shardName: 'shard2RS',
    numOrphanedDocs: 0,
    numOwnedDocuments: 33103,
    ownedSizeBytes: 10659166,
    orphanedSizeBytes: 0
  },
  {
    shardName: 'shard1RS',
    numOrphanedDocs: 0,
    numOwnedDocuments: 33142,
    ownedSizeBytes: 10671724,
    orphanedSizeBytes: 0
  }
]

## Выполнена запись 30000 документов с user_id: 999999 (одинаковое значение ключа шардирования). Предполагается, что эти записи попадут в один чанк.


# Проверка распределения данных после добавления записей на один шард
[direct: mongos] homework_db> sh.getShardedDataDistribution().toArray().filter(x => x.ns === "homework_db.users").shift().shards
[
  {
    shardName: 'shard1RS',
    numOrphanedDocs: 0,
    numOwnedDocuments: 33142,
    ownedSizeBytes: 10671724,
    orphanedSizeBytes: 0
  },
  {
    shardName: 'shard3RS',
    numOrphanedDocs: 0,
    numOwnedDocuments: 33755,
    ownedSizeBytes: 10869110,
    orphanedSizeBytes: 0
  },
  {
    shardName: 'shard2RS',
    numOrphanedDocs: 0,
    numOwnedDocuments: 63103,
    ownedSizeBytes: 20382269,
    orphanedSizeBytes: 0
  }
]

# Добавление шарда
[direct: mongos] test> sh.addShard("shard4RS/shard4a:27018,shard4b:27018,shard4c:27018")
{
  shardAdded: 'shard4RS',
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1791888765, i: 3 }),
    signature: {
      hash: Binary.createFromBase64('AAAAAAAAAAAAAAAAAAAAAAAAAAA=', 0),
      keyId: Long('0')
    }
  },
  operationTime: Timestamp({ t: 1791888765, i: 3 })
}

# Проверка распределения
[direct: mongos] homework_db> sh.getShardedDataDistribution().toArray().filter(x => x.ns === "homework_db.users").shift().shards
[
  {
    shardName: 'shard1RS',
    numOrphanedDocs: 0,
    numOwnedDocuments: 33142,
    ownedSizeBytes: 10671724,
    orphanedSizeBytes: 0
  },
  {
    shardName: 'shard3RS',
    numOrphanedDocs: 0,
    numOwnedDocuments: 33755,
    ownedSizeBytes: 10869110,
    orphanedSizeBytes: 0
  },
  {
    shardName: 'shard4RS',
    numOrphanedDocs: 0,
    numOwnedDocuments: 16547,
    ownedSizeBytes: 5328134,
    orphanedSizeBytes: 0
  },
  {
    shardName: 'shard2RS',
    numOrphanedDocs: 16547,
    numOwnedDocuments: 16556,
    ownedSizeBytes: 5331032,
    orphanedSizeBytes: 5328134
  }
]

# Остановка secondary-шарда
docker stop shard1b

shard1RS [direct: primary] test> rs.status().members.map(m => ({ name: m.name, state: m.stateStr, health: m.health }))
[
  { name: 'shard1a:27018', state: 'PRIMARY', health: 1 },
  {
    name: 'shard1b:27018',
    state: '(not reachable/healthy)',
    health: 0
  },
  { name: 'shard1c:27018', state: 'SECONDARY', health: 1 }
]

# Запуск shard1b (secondary) и остановка shard1a (primary)
docker start shard1b
docker stop shard1a

# Проверка
shard1RS [direct: primary] test> rs.status().members.map(m => ({ name: m.name, state: m.stateStr, health: m.health }))
[
  {
    name: 'shard1a:27018',
    state: '(not reachable/healthy)',
    health: 0
  },
  { name: 'shard1b:27018', state: 'PRIMARY', health: 1 },
  { name: 'shard1c:27018', state: 'SECONDARY', health: 1 }
]

# Проверка после восстановления
shard1RS [direct: primary] test> rs.status().members.map(m => ({ name: m.name, state: m.stateStr, health: m.health }))
[
  { name: 'shard1a:27018', state: 'SECONDARY', health: 1 },
  { name: 'shard1b:27018', state: 'PRIMARY', health: 1 },
  { name: 'shard1c:27018', state: 'SECONDARY', health: 1 }
]

# Остановка cfg2 
docker stop cfg2

# Проверка
cfgrs [direct: secondary] test> rs.status().members.map(m => ({ name: m.name, state: m.stateStr, health: m.health }))
[
  { name: 'cfg1:27019', state: 'SECONDARY', health: 1 },
  { name: 'cfg2:27019', state: '(not reachable/healthy)', health: 0 },
  { name: 'cfg3:27019', state: 'PRIMARY', health: 1 }
]

# Проверка после восстановления
cfgrs [direct: secondary] test> rs.status().members.map(m => ({ name: m.name, state: m.stateStr, health: m.health }))
[
  { name: 'cfg1:27019', state: 'SECONDARY', health: 1 },
  { name: 'cfg2:27019', state: 'SECONDARY', health: 1 },
  { name: 'cfg3:27019', state: 'PRIMARY', health: 1 }
]

# Остановка mongos1
docker stop mongos1

# Проверка
[direct: mongos] test> use homework_db
switched to db homework_db
[direct: mongos] homework_db> db.users.countDocuments()
100000


active mongoses
[ { '7.0.40': 1 } ]

# Проверка после восстановления
active mongoses
[ { '7.0.40': 2 } ]

# Создание keyfile
$bytes = New-Object byte[] 756
[System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes)
[Convert]::ToBase64String($bytes) | Out-File -Encoding ascii -NoNewline keyfile

# Создание пользователя admin
use admin

db.createUser({
  user: "clusterAdmin",
  pwd: "SecurePass123",
  roles: [
    { role: "userAdminAnyDatabase", db: "admin" },
    { role: "clusterAdmin", db: "admin" }
  ]
})

# Проверка
[direct: mongos] admin> db.auth("clusterAdmin", "SecurePass123")
{ ok: 1 }

# Создание пользователей с разными ролями
[direct: mongos] admin> use homework_db
switched to db homework_db
[direct: mongos] homework_db> db.createUser({
|   user: "reader",
|   pwd: "readerPass123",
|   roles: [{ role: "read", db: "homework_db" }]
| })
{
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1791899974, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('tXPDq1gC1pcjOzjQfE5DfzRmKLo=', 0),
      keyId: Long('7696145128833941507')
    }
  },
  operationTime: Timestamp({ t: 1791899974, i: 1 })
}
[direct: mongos] homework_db> db.createUser({
|   user: "writer",
|   pwd: "writerPass123",
|   roles: [{ role: "readWrite", db: "homework_db" }]
| })
{
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1791899982, i: 2 }),
    signature: {
      hash: Binary.createFromBase64('LGXIoz9XjJxsQ2d/7TphXN4ojEs=', 0),
      keyId: Long('7696145128833941507')
    }
  },
  operationTime: Timestamp({ t: 1791899982, i: 2 })
}
[direct: mongos] homework_db> db.createUser({
|   user: "dbAdmin",
|   pwd: "dbAdminPass123",
|   roles: [
|     { role: "dbAdmin", db: "homework_db" },
|     { role: "readWrite", db: "homework_db" }
|   ]
| })
{
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1791899990, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('XExvcrrQ+y5pJM9l9RU5mX02Y+0=', 0),
      keyId: Long('7696145128833941507')
    }
  },
  operationTime: Timestamp({ t: 1791899990, i: 1 })
}

# Попытка записи без авторизации
[direct: mongos] homework_db> db.users.insertOne({ user_id: 1, name: "test" })
MongoServerError[Unauthorized]: not authorized on homework_db to execute command { insert: "users", documents: [ { user_id: 1, name: "test", _id: ObjectId('6acf25e54d07dfccd7962d82') } ], ordered: true, lsid: { id: UUID("0809054f-5574-4ea1-98d7-124548bcaf11") }, txnNumber: 1, $clusterTime: { clusterTime: Timestamp(1791960534, 1), signature: { hash: BinData(0, E16A0B46664EBD6E422037DC769F178D4351914E), keyId: 7696145128833941507 } }, $db: "homework_db" }

# Подключение пользователя с правами записи
docker exec -it mongos1 mongosh --port 27017 -u writer -p writerPass123 --authenticationDatabase homework_db

# Запись документа
[direct: mongos] homework_db> db.users.insertOne({ user_id: 1, name: "WriterTest" })
{
  acknowledged: true,
  insertedId: ObjectId('6acf27647c7b542ec676f705')
}
[direct: mongos] homework_db> db.users.findOne({ user_id: 1 })
{
  _id: ObjectId('6acf27647c7b542ec676f705'),
  user_id: 1,
  name: 'WriterTest'
}
