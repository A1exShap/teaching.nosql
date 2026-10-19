# Проверка работоспособности контейнера
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework11>curl http://localhost:9200
{
  "name" : "045d0a23d344",
  "cluster_name" : "docker-cluster",
  "cluster_uuid" : "kHd311GXSOukyglTrQZ6sg",
  "version" : {
    "number" : "8.15.0",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "1a77947f34deddb41af25e6f0ddb8e830159c179",
    "build_date" : "2024-08-05T10:05:34.233336849Z",
    "build_snapshot" : false,
    "lucene_version" : "9.11.1",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}

# Создание шаблона
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework11>curl -X PUT "http://localhost:9200/_template/text-template" -H "Content-Type: application/json" --data-binary "@template.json"
{"acknowledged":true}

*Файл template.json, как и другие файлы с командами и запросами, приложены в каталоге с ДЗ*

# Создание индекса
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework11>curl -X PUT "http://localhost:9200/text-demo"
{"acknowledged":true,"shards_acknowledged":true,"index":"text-demo"}

# Добавление доументов
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework11>curl -X POST "http://localhost:9200/_bulk" -H "Content-Type: application/x-ndjson" --data-binary "@documents.json"
{"errors":false,"took":222797319,"items":[{"index":{"_index":"text-demo","_id":"1","_version":1,"result":"created","_shards":{"total":1,"successful":1,"failed":0},"_seq_no":0,"_primary_term":1,"status":201}},{"index":{"_index":"text-demo","_id":"2","_version":1,"result":"created","_shards":{"total":1,"successful":1,"failed":0},"_seq_no":1,"_primary_term":1,"status":201}},{"index":{"_index":"text-demo","_id":"3","_version":1,"result":"created","_shards":{"total":1,"successful":1,"failed":0},"_seq_no":2,"_primary_term":1,"status":201}}]}

# Анализ сообщения о добавлении документов
- Команда выполнена без ошибок (errors":false).
- Все три записи добавлены в индекс.

# Выполнение нечеткого поиска
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework11>curl -X GET "http://localhost:9200/text-demo/_search" -H "Content-Type: application/json" --data-binary "@search.json"
{"took":122,"timed_out":false,"_shards":{"total":1,"successful":1,"skipped":0,"failed":0},"hits":{"total":{"value":3,"relation":"eq"},"max_score":1.2535897,"hits":[{"_index":"text-demo","_id":"1","_score":1.2535897,"_source":{"text":"моя мама мыла посуду а кот жевал сосиски"}},{"_index":"text-demo","_id":"3","_score":0.89614034,"_source":{"text":"мама мыла раму"}},{"_index":"text-demo","_id":"2","_score":0.3235163,"_source":{"text":"рама была отмыта и вылизана котом"}}]}}

# Анализ результата поиска
- Документ 1 («моя мама мыла посуду а кот жевал сосиски»). Score: 1.253 (наивысший). Самый релевантный документ, есть два ключевых слова ("мама" и "сосиски").
- Документ 3 («мама мыла раму»). Score: 0.896.
  В документе есть "мама", но нет "сосиски". Score ниже, чем у предыдущего документа.
- Документ 2 («рама была отмыта и вылизана котом»). Score: 0.323 (низший).
  В документе нет "мама" и "сосиски". Из-за параметра fuzziness: "AUTO" было найдено частичное совпадение с "котом".

# Публикация коллекции Postman
Postman не разрешил Sharing в бесплатной версии.
Коллекция экспортирована в Elasticsearch Demo.postman_collection.json, который вложен в каталог с ДЗ.