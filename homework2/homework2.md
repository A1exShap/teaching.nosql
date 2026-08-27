#Работа с MongoDB


**Запуск контейнера
	*По docker-compose.yml (приложен к ДЗ) были подняты контейнеры с MongoDB и Mongo Express.
	
Терминал:
C:\Users\alexs>docker exec -it mongo mongosh
Current Mongosh Log ID: 6a900a45ec6f839f5364054a
Connecting to:          mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.10.0
Using MongoDB:          7.0.40
Using Mongosh:          2.10.0

For mongosh info see: https://www.mongodb.com/docs/mongodb-shell/


To help improve our products, anonymous usage data is collected and sent to MongoDB periodically (https://www.mongodb.com/legal/privacy-policy).
You can opt-out by running the disableTelemetry() command.

------
   The server generated these startup warnings when booting
   2026-08-27T09:45:03.790+00:00: Using the XFS filesystem is strongly recommended with the WiredTiger storage engine. See http://dochub.mongodb.org/core/prodnotes-filesystem
   2026-08-27T09:45:04.149+00:00: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted
   2026-08-27T09:45:04.149+00:00: vm.max_map_count is too low
------

test> show dbs
admin   40.00 KiB
config  92.00 KiB
local   40.00 KiB
test>

**В качестве тестового набора данных я выбрал простой магазин (Клиенты/Товары/Заказы)

**Создание тестовой БД и заполнение данными
test> use hwdb
switched to db hwdb
hwdb> db.users.insertMany([
   { name: "Alex", age: 35, city: "Amsterdam", email: "alex@example.com", registeredAt: new Date("2024-01-10") },
   { name: "John", age: 28, city: "Berlin", email: "john@example.com", registeredAt: new Date("2023-11-05") },
   { name: "Maria", age: 42, city: "Madrid", email: "maria@example.com", registeredAt: new Date("2022-07-21") },
   { name: "Bob", age: 50, city: "Amsterdam", email: "bob@example.com", registeredAt: new Date("2024-02-01") }
 ])
{
  acknowledged: true,
  insertedIds: {
    '0': ObjectId('6a901953ec6f839f5364054b'),
    '1': ObjectId('6a901953ec6f839f5364054c'),
    '2': ObjectId('6a901953ec6f839f5364054d'),
    '3': ObjectId('6a901953ec6f839f5364054e')
  }
}

hwdb> db.products.insertMany([
   { name: "Laptop", category: "Electronics", price: 1200, inStock: 15 },
   { name: "Phone", category: "Electronics", price: 800, inStock: 30 },
   { name: "Desk", category: "Furniture", price: 200, inStock: 10 },
   { name: "Chair", category: "Furniture", price: 120, inStock: 25 }
 ])
{
  acknowledged: true,
  insertedIds: {
    '0': ObjectId('6a901b71ec6f839f5364054f'),
    '1': ObjectId('6a901b71ec6f839f53640550'),
    '2': ObjectId('6a901b71ec6f839f53640551'),
    '3': ObjectId('6a901b71ec6f839f53640552')
  }
}

**Создание третьей коллекции (Заказы) и заполнение данными я выполнил в Mongo Express.
Скрины (создание коллекции и одного документа) в каталоге /gui/1-create-orders


**Проверка состояния БД и коллекции (на примере users)
hwdb> show collections
orders
products
users
hwdb> db.stats()
{
  db: 'hwdb',
  collections: Long('3'),
  views: Long('0'),
  objects: Long('12'),
  avgObjSize: 136.08333333333334,
  dataSize: 1633,
  storageSize: 77824,
  indexes: Long('3'),
  indexSize: 77824,
  totalSize: 155648,
  scaleFactor: Long('1'),
  fsUsedSize: 65486176256,
  fsTotalSize: 1081101176832,
  ok: 1
}
hwdb> db.users.stats()
{
  ok: 1,
  capped: false,
  wiredTiger: {
    metadata: { formatVersion: 1 },
    creationString: 'access_pattern_hint=none,allocation_...,
	type: 'file',
	uri: 'statistics:table:collection-7--2096668434628006166',
    LSM: {
	...
	},
	...
	},
  sharded: false,
  size: 458,
  count: 4,
  numOrphanDocs: 0,
  storageSize: 20480,
  totalIndexSize: 20480,
  totalSize: 40960,
  indexSizes: { _id_: 20480 },
  avgObjSize: 114,
  ns: 'hwdb.users',
  nindexes: 1,
  scaleFactor: 1
}

**Скрины проверки состояния в GUI делать не буду - там все ОЧЕНЬ просто и очевидно :)

**CRUD (на примере заказов)
hwdb> db.orders.insertOne({
   userId: { $oid: "6a901953ec6f839f5364054b" },
   productId: { $oid: "6a901b71ec6f839f5364054f" },
   qty: 3,
   total: 3600,
   status: "pending",
   createdAt: new Date()
 })
{
  acknowledged: true,
  insertedId: ObjectId('6a902609ec6f839f53640553')
}

-------------------------------------------------------------

hwdb> db.orders.find()
[
  {
    _id: ObjectId('6a901ff0665beac0477f74f5'),
    userId: { '$oid': '6a901953ec6f839f5364054b' },
    productId: { '$oid': '6a901b71ec6f839f5364054f' },
    qty: 1,
    total: 1200,
    status: 'paid',
    createdAt: { '$date': '2024-03-01T00:00:00Z' }
  },
  {
    _id: ObjectId('6a902113665beac0477f74f7'),
    userId: { '$oid': '6a901953ec6f839f5364054c' },
    productId: { '$oid': '6a901b71ec6f839f53640550' },
    qty: 2,
    total: 1600,
    status: 'pending',
    createdAt: { '$date': '2024-03-02T00:00:00Z' }
  },
  {
    _id: ObjectId('6a90211d665beac0477f74f9'),
    userId: { '$oid': '6a901953ec6f839f5364054d' },
    productId: { '$oid': '6a901b71ec6f839f53640551' },
    qty: 1,
    total: 200,
    status: 'paid',
    createdAt: { '$date': '2024-03-03T00:00:00Z' }
  },
  {
    _id: ObjectId('6a902128665beac0477f74fb'),
    userId: { '$oid': '6a901953ec6f839f5364054e' },
    productId: { '$oid': '6a901b71ec6f839f53640552' },
    qty: 4,
    total: 480,
    status: 'paid',
    createdAt: { '$date': '2024-03-04T00:00:00Z' }
  },
  {
    _id: ObjectId('6a902609ec6f839f53640553'),
    userId: { '$oid': '6a901953ec6f839f5364054b' },
    productId: { '$oid': '6a901b71ec6f839f5364054f' },
    qty: 3,
    total: 3600,
    status: 'pending',
    createdAt: ISODate('2026-08-27T11:56:57.502Z')
  }
]

-------------------------------------------------------------

hwdb> db.orders.findOne({ _id: ObjectId("6a902609ec6f839f53640553") })
{
  _id: ObjectId('6a902609ec6f839f53640553'),
  userId: { '$oid': '6a901953ec6f839f5364054b' },
  productId: { '$oid': '6a901b71ec6f839f5364054f' },
  qty: 3,
  total: 3600,
  status: 'pending',
  createdAt: ISODate('2026-08-27T11:56:57.502Z')
}

-------------------------------------------------------------

hwdb> db.orders.find({ status: "pending" })
[
  {
    _id: ObjectId('6a902113665beac0477f74f7'),
    userId: { '$oid': '6a901953ec6f839f5364054c' },
    productId: { '$oid': '6a901b71ec6f839f53640550' },
    qty: 2,
    total: 1600,
    status: 'pending',
    createdAt: { '$date': '2024-03-02T00:00:00Z' }
  },
  {
    _id: ObjectId('6a902609ec6f839f53640553'),
    userId: { '$oid': '6a901953ec6f839f5364054b' },
    productId: { '$oid': '6a901b71ec6f839f5364054f' },
    qty: 3,
    total: 3600,
    status: 'pending',
    createdAt: ISODate('2026-08-27T11:56:57.502Z')
  }
]

-------------------------------------------------------------

hwdb> db.orders.find({ status: "pending" }).sort({ createdAt: -1 })
[
  {
    _id: ObjectId('6a902609ec6f839f53640553'),
    userId: { '$oid': '6a901953ec6f839f5364054b' },
    productId: { '$oid': '6a901b71ec6f839f5364054f' },
    qty: 3,
    total: 3600,
    status: 'pending',
    createdAt: ISODate('2026-08-27T11:56:57.502Z')
  },
  {
    _id: ObjectId('6a902113665beac0477f74f7'),
    userId: { '$oid': '6a901953ec6f839f5364054c' },
    productId: { '$oid': '6a901b71ec6f839f53640550' },
    qty: 2,
    total: 1600,
    status: 'pending',
    createdAt: { '$date': '2024-03-02T00:00:00Z' }
  }
]

-------------------------------------------------------------

hwdb> db.orders.updateOne(
   { _id: ObjectId("6a902609ec6f839f53640553") },
   { $set: { status: "paid" } }
 )
{
  acknowledged: true,
  insertedId: null,
  matchedCount: 1,
  modifiedCount: 1,
  upsertedCount: 0
}
hwdb> db.orders.findOne({ _id: ObjectId("6a902609ec6f839f53640553") })
{
  _id: ObjectId('6a902609ec6f839f53640553'),
  userId: { '$oid': '6a901953ec6f839f5364054b' },
  productId: { '$oid': '6a901b71ec6f839f5364054f' },
  qty: 3,
  total: 3600,
  status: 'paid',
  createdAt: ISODate('2026-08-27T11:56:57.502Z')
}

-------------------------------------------------------------

hwdb> db.orders.deleteOne({ _id: ObjectId("6a902609ec6f839f53640553") })
{ acknowledged: true, deletedCount: 1 }
hwdb> db.orders.findOne({ _id: ObjectId("6a902609ec6f839f53640553") })
null
hwdb>

** Создание индексов и проверка до/после

hwdb> db.orders.find({ status: "pending" }).explain("executionStats")
{
  explainVersion: '1',
  queryPlanner: {
    namespace: 'hwdb.orders',
    indexFilterSet: false,
    parsedQuery: { status: { '$eq': 'pending' } },
    queryHash: '4B6FAB47',
    planCacheKey: '4B6FAB47',
    optimizationTimeMillis: 0,
    maxIndexedOrSolutionsReached: false,
    maxIndexedAndSolutionsReached: false,
    maxScansToExplodeReached: false,
    winningPlan: {
      stage: 'COLLSCAN',
      filter: { status: { '$eq': 'pending' } },
      direction: 'forward'
    },
    rejectedPlans: []
  },
  executionStats: {
    executionSuccess: true,
    nReturned: 1,
    executionTimeMillis: 0,
    totalKeysExamined: 0,
    totalDocsExamined: 4,
    executionStages: {
      stage: 'COLLSCAN',
      filter: { status: { '$eq': 'pending' } },
      nReturned: 1,
      executionTimeMillisEstimate: 0,
      works: 5,
      advanced: 1,
      needTime: 3,
      needYield: 0,
      saveState: 0,
      restoreState: 0,
      isEOF: 1,
      direction: 'forward',
      docsExamined: 4
    }
  },
  command: { find: 'orders', filter: { status: 'pending' }, '$db': 'hwdb' },
  serverInfo: {
    host: '4c465364bcd3',
    port: 27017,
    version: '7.0.40',
    gitVersion: '37741b538c02da076d1e34d66113ac0230d4523a'
  },
  serverParameters: {
    internalQueryFacetBufferSizeBytes: 104857600,
    internalQueryFacetMaxOutputDocSizeBytes: 104857600,
    internalLookupStageIntermediateDocumentMaxSizeBytes: 104857600,
    internalDocumentSourceGroupMaxMemoryBytes: 104857600,
    internalQueryMaxBlockingSortMemoryUsageBytes: 104857600,
    internalQueryProhibitBlockingMergeOnMongoS: 0,
    internalQueryMaxAddToSetBytes: 104857600,
    internalDocumentSourceSetWindowFieldsMaxMemoryBytes: 104857600,
    internalQueryFrameworkControl: 'forceClassicEngine'
  },
  ok: 1
}

-------------------------------------------------------------

hwdb> db.orders.createIndex({ status: 1 })
status_1

-------------------------------------------------------------

hwdb> db.orders.find({ status: "pending" }).explain("executionStats")
{
  explainVersion: '1',
  queryPlanner: {
    namespace: 'hwdb.orders',
    indexFilterSet: false,
    parsedQuery: { status: { '$eq': 'pending' } },
    queryHash: '4B6FAB47',
    planCacheKey: '65D76290',
    optimizationTimeMillis: 0,
    maxIndexedOrSolutionsReached: false,
    maxIndexedAndSolutionsReached: false,
    maxScansToExplodeReached: false,
    winningPlan: {
      stage: 'FETCH',
      inputStage: {
        stage: 'IXSCAN',
        keyPattern: { status: 1 },
        indexName: 'status_1',
        isMultiKey: false,
        multiKeyPaths: { status: [] },
        isUnique: false,
        isSparse: false,
        isPartial: false,
        indexVersion: 2,
        direction: 'forward',
        indexBounds: { status: [ '["pending", "pending"]' ] }
      }
    },
    rejectedPlans: []
  },
  executionStats: {
    executionSuccess: true,
    nReturned: 1,
    executionTimeMillis: 0,
    totalKeysExamined: 1,
    totalDocsExamined: 1,
    executionStages: {
      stage: 'FETCH',
      nReturned: 1,
      executionTimeMillisEstimate: 0,
      works: 2,
      advanced: 1,
      needTime: 0,
      needYield: 0,
      saveState: 0,
      restoreState: 0,
      isEOF: 1,
      docsExamined: 1,
      alreadyHasObj: 0,
      inputStage: {
        stage: 'IXSCAN',
        nReturned: 1,
        executionTimeMillisEstimate: 0,
        works: 2,
        advanced: 1,
        needTime: 0,
        needYield: 0,
        saveState: 0,
        restoreState: 0,
        isEOF: 1,
        keyPattern: { status: 1 },
        indexName: 'status_1',
        isMultiKey: false,
        multiKeyPaths: { status: [] },
        isUnique: false,
        isSparse: false,
        isPartial: false,
        indexVersion: 2,
        direction: 'forward',
        indexBounds: { status: [ '["pending", "pending"]' ] },
        keysExamined: 1,
        seeks: 1,
        dupsTested: 0,
        dupsDropped: 0
      }
    }
  },
  command: { find: 'orders', filter: { status: 'pending' }, '$db': 'hwdb' },
  serverInfo: {
    host: '4c465364bcd3',
    port: 27017,
    version: '7.0.40',
    gitVersion: '37741b538c02da076d1e34d66113ac0230d4523a'
  },
  serverParameters: {
    internalQueryFacetBufferSizeBytes: 104857600,
    internalQueryFacetMaxOutputDocSizeBytes: 104857600,
    internalLookupStageIntermediateDocumentMaxSizeBytes: 104857600,
    internalDocumentSourceGroupMaxMemoryBytes: 104857600,
    internalQueryMaxBlockingSortMemoryUsageBytes: 104857600,
    internalQueryProhibitBlockingMergeOnMongoS: 0,
    internalQueryMaxAddToSetBytes: 104857600,
    internalDocumentSourceSetWindowFieldsMaxMemoryBytes: 104857600,
    internalQueryFrameworkControl: 'forceClassicEngine'
  },
  ok: 1
}

** Изменения

1. winningPlan.stage
- ДО: winningPlan.stage: 'COLLSCAN' - сканирование всей коллекции;
- ПОСЛЕ: winningPlan.stage: 'FETCH' ('IXSCAN') - запрос использует индекс.

2. totalKeysExamined
- ДО: totalKeysExamined: 0 - нет ключей;
- ПОСЛЕ: totalKeysExamined: 1 - ключ найден.

3. totalDocsExamined
- ДО: totalDocsExamined: 4 - алгоритм прошелся по всем документам;
- ПОСЛЕ: totalDocsExamined: 1 - алгоритм прочитал только один документ.

4. executionTimeMillis
- Из-за того, что мало документов в коллекции, оба алгоритма показывают 0 мс. Но разница во времени выполнения должна расти при увеличении количества данных.