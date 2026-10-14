# Проверка состояния
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework5>docker exec -it cassandra-1 nodetool status
Datacenter: datacenter1
=======================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address     Load        Tokens  Owns (effective)  Host ID                               Rack
UN  172.23.0.3  80.03 KiB   16      59.3%             c41df1c9-6822-42aa-98e0-e00454456722  rack1
UN  172.23.0.4  147.58 KiB  16      76.0%             c1beae52-e95a-4af9-8e10-0f7b044e2e87  rack1
UN  172.23.0.2  119.85 KiB  16      64.7%             307bafbe-ed8d-40d1-b711-c4bf88ca6216  rack1

# Создание keyspace
cqlsh> CREATE KEYSPACE homework
   ... WITH replication = {
   ...   'class': 'NetworkTopologyStrategy',
   ...   'datacenter1': 3
   ... };
   
cqlsh> DESCRIBE KEYSPACES;
homework  system_auth         system_schema  system_views
system    system_distributed  system_traces  system_virtual_schema

# Создание таблиц
cqlsh:homework> CREATE TABLE sensors_by_room (
      building text,
      room text,
      reading_time timestamp,
      temperature float,
      humidity float,
      sensor_id text,
      PRIMARY KEY ((building, room), reading_time)
);
cqlsh:homework> CREATE TABLE users_by_city (
      city text,
      user_id uuid,
      name text,
      email text,
      age int,
      PRIMARY KEY (city, user_id)
  );

# Проверка созданных таблиц
cqlsh:homework> DESCRIBE TABLE sensors_by_room;

CREATE TABLE homework.sensors_by_room (
    building text,
    room text,
    reading_time timestamp,
    humidity float,
    sensor_id text,
    temperature float,
    PRIMARY KEY ((building, room), reading_time)
) WITH CLUSTERING ORDER BY (reading_time ASC)
    AND additional_write_policy = '99p'
    AND allow_auto_snapshot = true
    AND bloom_filter_fp_chance = 0.01
    AND caching = {'keys': 'ALL', 'rows_per_partition': 'NONE'}
    AND cdc = false
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy', 'max_threshold': '32', 'min_threshold': '4'}
    AND compression = {'chunk_length_in_kb': '16', 'class': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND memtable = 'default'
    AND crc_check_chance = 1.0
    AND default_time_to_live = 0
    AND extensions = {}
    AND gc_grace_seconds = 864000
    AND incremental_backups = true
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair = 'BLOCKING'
    AND speculative_retry = '99p';
cqlsh:homework> DESCRIBE TABLE users_by_city;

CREATE TABLE homework.users_by_city (
    city text,
    user_id uuid,
    age int,
    email text,
    name text,
    PRIMARY KEY (city, user_id)
) WITH CLUSTERING ORDER BY (user_id ASC)
    AND additional_write_policy = '99p'
    AND allow_auto_snapshot = true
    AND bloom_filter_fp_chance = 0.01
    AND caching = {'keys': 'ALL', 'rows_per_partition': 'NONE'}
    AND cdc = false
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy', 'max_threshold': '32', 'min_threshold': '4'}
    AND compression = {'chunk_length_in_kb': '16', 'class': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND memtable = 'default'
    AND crc_check_chance = 1.0
    AND default_time_to_live = 0
    AND extensions = {}
    AND gc_grace_seconds = 864000
    AND incremental_backups = true
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair = 'BLOCKING'
    AND speculative_retry = '99p';

# Заполнение таблицы sensors_by_room
INSERT INTO sensors_by_room (building, room, reading_time, temperature, humidity, sensor_id) 
VALUES ('A', '101', '2026-10-14 08:00:00', 22.5, 45.0, 'sensor-A101-1');
...
INSERT INTO sensors_by_room (building, room, reading_time, temperature, humidity, sensor_id) 
VALUES ('C', '301', '2026-10-14 09:00:00', 26.1, 39.5, 'sensor-C301-1');
# Заполнение таблицы users_by_city
INSERT INTO users_by_city (city, user_id, name, email, age) 
VALUES ('Moscow', uuid(), 'Ivan Petrov', 'ivan@example.com', 30);
...
INSERT INTO users_by_city (city, user_id, name, email, age) 
VALUES ('Ufa', uuid(), 'Sergey Popov', 'sergey@example.com', 40);

# Проверка данных в таблицах
cqlsh:homework> SELECT * FROM sensors_by_room;

 building | room | reading_time                    | humidity | sensor_id     | temperature
----------+------+---------------------------------+----------+---------------+-------------
        B |  201 | 2026-10-14 08:00:00.000000+0000 |       55 | sensor-B201-1 |        19.5
        B |  201 | 2026-10-14 09:00:00.000000+0000 |     54.1 | sensor-B201-1 |        20.2
        A |  102 | 2026-10-14 08:00:00.000000+0000 |     50.5 | sensor-A102-1 |          21
        A |  102 | 2026-10-14 09:00:00.000000+0000 |     49.9 | sensor-A102-1 |        21.8
        A |  101 | 2026-10-14 08:00:00.000000+0000 |       45 | sensor-A101-1 |        22.5
        A |  101 | 2026-10-14 09:00:00.000000+0000 |     44.2 | sensor-A101-1 |        23.1
        A |  101 | 2026-10-14 10:00:00.000000+0000 |     43.8 | sensor-A101-1 |          24
        C |  301 | 2026-10-14 08:00:00.000000+0000 |       40 | sensor-C301-1 |        25.5
        C |  301 | 2026-10-14 09:00:00.000000+0000 |     39.5 | sensor-C301-1 |        26.1
        B |  202 | 2026-10-14 08:00:00.000000+0000 |       60 | sensor-B202-1 |          18

(10 rows)


cqlsh:homework> SELECT * FROM users_by_city;

 city   | user_id                              | age | email              | name
--------+--------------------------------------+-----+--------------------+------------------
 Moscow | 0f92d7ce-978d-472d-9e44-393caf08b6ca |  25 |   anna@example.com |    Anna Sidorova
 Moscow | e1eba3ea-3928-411d-931e-6be81fdce95a |  30 |   ivan@example.com |      Ivan Petrov
 Moscow | f25ab9eb-909e-437a-a488-52ce06784e71 |  35 |   oleg@example.com |      Oleg Ivanov
  Kazan | 291b53ba-ec1b-4c08-84f8-e31d206479f8 |  28 |  maria@example.com | Maria Kuznetsova
  Kazan | c9b567cd-4254-490b-9685-5189c36a3d80 |  32 | dmitry@example.com |    Dmitry Volkov
    Ufa | 3f39b3c5-70a2-4b71-be0f-fa5d8a0704a5 |  40 | sergey@example.com |     Sergey Popov
    Ufa | abee9286-7d5b-46ea-bf70-fc1c0e1748a7 |  27 |  elena@example.com |   Elena Smirnova

(7 rows)


# Запрос с фильтром по clustering key
cqlsh:homework> SELECT * FROM sensors_by_room
            ... WHERE building = 'A' AND room = '101' AND reading_time >= '2026-10-14 09:00:00';

 building | room | reading_time                    | humidity | sensor_id     | temperature
----------+------+---------------------------------+----------+---------------+-------------
        A |  101 | 2026-10-14 09:00:00.000000+0000 |     44.2 | sensor-A101-1 |        23.1
        A |  101 | 2026-10-14 10:00:00.000000+0000 |     43.8 | sensor-A101-1 |          24

(2 rows)

# Запрос с фильтром по partition key
cqlsh:homework> SELECT * FROM sensors_by_room
            ... WHERE building = 'B' AND room = '201';

 building | room | reading_time                    | humidity | sensor_id     | temperature
----------+------+---------------------------------+----------+---------------+-------------
        B |  201 | 2026-10-14 08:00:00.000000+0000 |       55 | sensor-B201-1 |        19.5
        B |  201 | 2026-10-14 09:00:00.000000+0000 |     54.1 | sensor-B201-1 |        20.2

(2 rows)


# Попытка выполнения запроса без индекса
cqlsh:homework> SELECT * FROM sensors_by_room WHERE temperature = 24.0;
InvalidRequest: Error from server: code=2200 [Invalid query] message="Cannot execute this query as it might involve data filtering and thus may have unpredictable performance. If you want to execute this query despite the performance unpredictability, use ALLOW FILTERING"

# Создание вторичного индекса
cqlsh:homework> CREATE INDEX idx_temperature ON sensors_by_room (temperature);

# Повторная попытка выполнения запроса (после создания индекса)
cqlsh:homework> SELECT * FROM sensors_by_room WHERE temperature = 24.0;

 building | room | reading_time                    | humidity | sensor_id     | temperature
----------+------+---------------------------------+----------+---------------+-------------
        A |  101 | 2026-10-14 10:00:00.000000+0000 |     43.8 | sensor-A101-1 |          24

(1 rows)


# Запуск и параметры стресс-тестирования
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework5>docker run --rm --network homework5_cassandra-net scylladb/cassandra-stress write n=10000 -rate threads=4 -node cassandra-1
******************** Stress Settings ********************
Command:
  Type: write
  Count: 10,000
  No Warmup: false
  Consistency Level: LOCAL_ONE
  Serial Consistency Level: SERIAL
  Target Uncertainty: not applicable
  Key Size (bytes): 10
  Counter Increment Distibution: add=fixed(1)
Rate:
  Auto: false
  Thread Count: 4
  OpsPer Sec: 0
Population:
  Sequence: 1..10000
  Order: ARBITRARY
  Wrap: true
Insert:
  Revisits: Uniform:  min=1,max=1000000
  Visits: Fixed:  key=1
  Row Population Ratio: Ratio: divisor=1.000000;delegate=Fixed:  key=1
  Batch Type: not batching
Columns:
  Max Columns Per Key: 5
  Column Names: [C0, C1, C2, C3, C4]
  Timestamp: null
  Variable Column Count: false
  Slice: false
  Size Distribution: Fixed:  key=34
  Count Distribution: Fixed:  key=5
Errors:
  Ignore: false
  Fail fast setting: false
  Tries: 10
Log:
  No Summary: false
  No Settings: false
  File: null
  Interval Millis: 1000
  Level: NORMAL
Mode:
  API: JAVA_DRIVER_NATIVE
  Connection Style: CQL_PREPARED
  CQL Version: CQL3
  Protocol Version: DEFAULT
  Username: null
  Password: null
  Auth Provide Class: null
  Max Pending Per Connection: null
  Connections Per Host: 8
  Request Timeout: 12000 ms
  Compression: NONE
Node:
  Nodes: [cassandra-1]
  Is White List: false
  Datacenter: null
  Rack: null
  Load Balance: auto
  Remote DC Hosts: disabled
Schema:
  Keyspace: keyspace1
  Replication Strategy: org.apache.cassandra.locator.NetworkTopologyStrategy
  Replication Strategy Options: {replication_factor=1}
  Storage Options: {}
  Table Compression: null
  Table Compaction Strategy: null
  Table Compaction Strategy Options: {}
Transport:
  truststore=null; truststore-password=null; keystore=null; keystore-password=null; ssl-protocol=TLS; ssl-alg=SunX509; store-type=JKS; ssl-ciphers=TLS_AES_256_GCM_SHA384,TLS_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256; hostname-verification=true;
Port:
  Native Port: 9042
Send To Daemon:
  *not set*
Graph:
  File: null
  Revision: unknown
  Title: cassandra-stress - 2026-10-14 12:59:21
  Operation: WRITE
TokenRange:
  Wrap: false
  Split Factor: 1

# Результат стресс-тестирования
Results:
Op rate                   :      800 op/s  [WRITE: 800 op/s]
Partition rate            :      800 pk/s  [WRITE: 800 pk/s]
Row rate                  :      800 row/s [WRITE: 800 row/s]
Latency mean              :    4.8 ms [WRITE: 4.8 ms]
Latency median            :    3.4 ms [WRITE: 3.4 ms]
Latency 95th percentile   :   12.3 ms [WRITE: 12.3 ms]
Latency 99th percentile   :   19.4 ms [WRITE: 19.4 ms]
Latency 99.9th percentile :   31.9 ms [WRITE: 31.9 ms]
Latency max               :   61.8 ms [WRITE: 61.8 ms]
Total partitions          :     10,000 [WRITE: 10,000]
Total errors              :          0 [WRITE: 0]
Total operation time      : 00:00:12