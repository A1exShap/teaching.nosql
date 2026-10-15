# Проверка состояния контейнера
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework6>docker ps --filter "name=clickhouse-demo"
CONTAINER ID   IMAGE                               COMMAND            CREATED          STATUS                    PORTS                                                      NAMES
74459759af8e   clickhouse/clickhouse-server:24.8   "/entrypoint.sh"   16 seconds ago   Up 14 seconds (healthy)   0.0.0.0:8123->8123/tcp, 0.0.0.0:9000->9000/tcp, 9009/tcp   clickhouse-demo

D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework6>curl http://localhost:8123/ping
Ok.

# Проверка наличия данных
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework6>docker exec -it clickhouse-demo clickhouse-client -u demo --password demo -q "SELECT * FROM user_service.users ORDER BY id"
1       alice   alice@example.com       1       2026-10-14 13:25:22     2026-10-14 13:25:22
2       bob     bob@example.com 1       2026-10-14 13:25:22     2026-10-14 13:25:22
3       carol   carol@example.com       1       2026-10-14 13:25:22     2026-10-14 13:25:22

# Создание trips
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework6>docker exec -it clickhouse-demo clickhouse-client -u demo --password demo
ClickHouse client version 24.8.14.39 (official build).
Connecting to localhost:9000 as user demo.
Connected to ClickHouse server version 24.8.14.

Warnings:
 * Delay accounting is not enabled, OSIOWaitMicroseconds will not be gathered. You can enable it using `echo 1 > /proc/sys/kernel/task_delayacct` or by using sysctl.

99496562d1c4 :) USE user_service;

USE user_service

Query id: 09f15c68-90ce-4bbd-bd6e-2e1f85a81a98

Ok.

0 rows in set. Elapsed: 0.001 sec.

99496562d1c4 :) CREATE TABLE IF NOT EXISTS trips
(
    trip_id UInt32,
    vendor_id Enum8('1' = 1, '2' = 2, '3' = 3, '4' = 4, 'CMT' = 5, 'VTS' = 6, 'DDS' = 7, 'B02512' = 10, 'B02598' = 11, 'B02617' = 12, 'B02682' = 13, 'B02764' = 14, '' = 15),
    pickup_date Date,
    pickup_datetime DateTime,
    dropoff_date Date,
    dropoff_datetime DateTime,
    store_and_fwd_flag UInt8,
    rate_code_id UInt8,
    pickup_longitude Float64,
    pickup_latitude Float64,
    dropoff_longitude Float64,
    dropoff_latitude Float64,
    passenger_count UInt8,
    trip_distance Float64,
    fare_amount Float32,
    extra Float32,
    mta_tax Float32,
    tip_amount Float32,
    tolls_amount Float32,
    ehail_fee FlCREATE TABLE IF NOT EXISTS trips
(
    trip_id UInt32,
    vendor_id Enum8('1' = 1, '2' = 2, '3' = 3, '4' = 4, 'CMT' = 5, 'VTS' = 6, 'DDS' = 7, 'B02512' = 10, 'B02598' = 11, 'B02617' = 12, 'B02682' = 13, 'B02764' = 14, '' = 15),
    pickup_date Date,
    pickup_datetime DateTime,
    dropoff_date Date,
    dropoff_datetime DateTime,
    store_and_fwd_flag UInt8,
    rate_code_id UInt8,
    pickup_longitude Float64,
    pickup_latitude Float64,
    dropoff_longitude Float64,
    dropoff_latitude Float64,
    passenger_count UInt8,
    trip_distance Float64,
    fare_amount Float32,
    extra Float32,
    mta_tax Float32,
    tip_amount Float32,
    tolls_amount Float32,
    ehail_fee Float32,
    improvement_surcharge Float32,
    total_amount Float32,
    payment_type Enum8('UNK' = 0, 'CSH' = 1, 'CRE' = 2, 'NOC' = 3, 'DIS' = 4),
    trip_type UInt8,
    pickup FixedString(25),
    dropoff FixedString(25),
    cab_type Enum8('yellow' = 1, 'green' = 2, 'uber' = 3),
    pickup_nyct2010_gid Int8,
    pickup_ctlabel Float32,
    pickup_borocode Int8,
    pickup_ct2010 String,
    pickup_boroct2010 String,
    pickup_cdeligibil String,
    pickup_ntacode FixedString(4),
    pickup_ntaname String,
    pickup_puma UInt16,
    dropoff_nyct2010_gid UInt8,
    dropoff_ctlabel Float32,
    dropoff_borocode UInt8,
    dropoff_ct2010 String,
    dropoff_boroct2010 String,
    dropoff_cdeligibil String,
    dropoff_ntacode FixedString(4),
    dropoff_ntaname String,
    dropoff_puma UInt16
)
ENGINE = MergeTree
PARTITION BY toYYYYMM(pickup_date)
ORDER BY pickup_datetime;

CREATE TABLE IF NOT EXISTS trips
(
    `trip_id` UInt32,
    `vendor_id` Enum8('1' = 1, '2' = 2, '3' = 3, '4' = 4, 'CMT' = 5, 'VTS' = 6, 'DDS' = 7, 'B02512' = 10, 'B02598' = 11, 'B02617' = 12, 'B02682' = 13, 'B02764' = 14, '' = 15),
    `pickup_date` Date,
    `pickup_datetime` DateTime,
    `dropoff_date` Date,
    `dropoff_datetime` DateTime,
    `store_and_fwd_flag` UInt8,
    `rate_code_id` UInt8,
    `pickup_longitude` Float64,
    `pickup_latitude` Float64,
    `dropoff_longitude` Float64,
    `dropoff_latitude` Float64,
    `passenger_count` UInt8,
    `trip_distance` Float64,
    `fare_amount` Float32,
    `extra` Float32,
    `mta_tax` Float32,
    `tip_amount` Float32,
    `tolls_amount` Float32,
    `ehail_fee` Float32,
    `improvement_surcharge` Float32,
    `total_amount` Float32,
    `payment_type` Enum8('UNK' = 0, 'CSH' = 1, 'CRE' = 2, 'NOC' = 3, 'DIS' = 4),
    `trip_type` UInt8,
    `pickup` FixedString(25),
    `dropoff` FixedString(25),
    `cab_type` Enum8('yellow' = 1, 'green' = 2, 'uber' = 3),
    `pickup_nyct2010_gid` Int8,
    `pickup_ctlabel` Float32,
    `pickup_borocode` Int8,
    `pickup_ct2010` String,
    `pickup_boroct2010` String,
    `pickup_cdeligibil` String,
    `pickup_ntacode` FixedString(4),
    `pickup_ntaname` String,
    `pickup_puma` UInt16,
    `dropoff_nyct2010_gid` UInt8,
    `dropoff_ctlabel` Float32,
    `dropoff_borocode` UInt8,
    `dropoff_ct2010` String,
    `dropoff_boroct2010` String,
    `dropoff_cdeligibil` String,
    `dropoff_ntacode` FixedString(4),
    `dropoff_ntaname` String,
    `dropoff_puma` UInt16
)
ENGINE = MergeTree
PARTITION BY toYYYYMM(pickup_date)
ORDER BY pickup_datetime

Query id: 611178b0-3a2c-4b24-999c-caa50eef3bd5

Ok.

0 rows in set. Elapsed: 0.023 sec.

99496562d1c4 :) SHOW TABLES;

SHOW TABLES

Query id: fa0f0b38-8768-44e5-8942-f56e628c4d27

   ┌─name──┐
1. │ trips │
2. │ users │
   └───────┘

2 rows in set. Elapsed: 0.003 sec.

99496562d1c4 :)

# Загрузка тестовой таблицы
99496562d1c4 :) INSERT INTO trips
SELECT * FROM s3(
    'https://datasets-documentation.s3.eu-west-3.amazonaws.com/nyc-taxi/trips_{1..2}.gz',
    'TabSeparatedWithNames', "
    `trip_id` UInt32,
    `vendor_id` Enum8('1' = 1, '2' = 2, '3' = 3, '4' = 4, 'CMT' = 5, 'VTS' = 6, 'DDS' = 7, 'B02512' = 10, 'B02598' = 11, 'B02617' = 12, 'B02682' = 13, 'B02764' = 14, '' = 15),
    `pickup_date` Date,
    `pickup_datetime` DateTime,
    `dropoff_date` Date,
    `dropoff_datetime` DateTime,
    `store_and_fwd_flag` UInt8,
    `rate_code_id` UInt8,
    `pickup_longitude` Float64,
    `pickup_latitude` Float64,
    `dropoff_longitude` Float64,
    `dropoff_latitude` Float64,
    `passenger_count` UInt8,
    `trip_distance` Float64,
    `fare_amount` Float32,
    `extra` Float32,
    `mta_tax` FlINSERT INTO trips
SELECT * FROM s3(
    'https://datasets-documentation.s3.eu-west-3.amazonaws.com/nyc-taxi/trips_{1..2}.gz',
    'TabSeparatedWithNames', "
    `trip_id` UInt32,
    `vendor_id` Enum8('1' = 1, '2' = 2, '3' = 3, '4' = 4, 'CMT' = 5, 'VTS' = 6, 'DDS' = 7, 'B02512' = 10, 'B02598' = 11, 'B02617' = 12, 'B02682' = 13, 'B02764' = 14, '' = 15),
    `pickup_date` Date,
    `pickup_datetime` DateTime,
    `dropoff_date` Date,
    `dropoff_datetime` DateTime,
    `store_and_fwd_flag` UInt8,
    `rate_code_id` UInt8,
    `pickup_longitude` Float64,
    `pickup_latitude` Float64,
    `dropoff_longitude` Float64,
    `dropoff_latitude` Float64,
    `passenger_count` UInt8,
    `trip_distance` Float64,
    `fare_amount` Float32,
    `extra` Float32,
    `mta_tax` Float32,
    `tip_amount` Float32,
    `tolls_amount` Float32,
    `ehail_fee` Float32,
    `improvement_surcharge` Float32,
    `total_amount` Float32,
    `payment_type` Enum8('UNK' = 0, 'CSH' = 1, 'CRE' = 2, 'NOC' = 3, 'DIS' = 4),
    `trip_type` UInt8,
    `pickup` FixedString(25),
    `dropoff` FixedString(25),
    `cab_type` Enum8('yellow' = 1, 'green' = 2, 'uber' = 3),
    `pickup_nyct2010_gid` Int8,
    `pickup_ctlabel` Float32,
    `pickup_borocode` Int8,
    `pickup_ct2010` String,
    `pickup_boroct2010` String,
    `pickup_cdeligibil` String,
    `pickup_ntacode` FixedString(4),
    `pickup_ntaname` String,
    `pickup_puma` UInt16,
    `dropoff_nyct2010_gid` UInt8,
    `dropoff_ctlabel` Float32,
    `dropoff_borocode` UInt8,
    `dropoff_ct2010` String,
    `dropoff_boroct2010` String,
    `dropoff_cdeligibil` String,
    `dropoff_ntacode` FixedString(4),
    `dropoff_ntaname` String,
    `dropoff_puma` UInt16
") SETTINGS input_format_try_infer_datetimes = 0;

INSERT INTO trips
SETTINGS input_format_try_infer_datetimes = 0
SELECT *
FROM s3('https://datasets-documentation.s3.eu-west-3.amazonaws.com/nyc-taxi/trips_{1..2}.gz', 'TabSeparatedWithNames', `\n    \`trip_id\` UInt32,\n    \`vendor_id\` Enum8('1' = 1, '2' = 2, '3' = 3, '4' = 4, 'CMT' = 5, 'VTS' = 6, 'DDS' = 7, 'B02512' = 10, 'B02598' = 11, 'B02617' = 12, 'B02682' = 13, 'B02764' = 14, '' = 15),\n    \`pickup_date\` Date,\n    \`pickup_datetime\` DateTime,\n    \`dropoff_date\` Date,\n    \`dropoff_datetime\` DateTime,\n    \`store_and_fwd_flag\` UInt8,\n    \`rate_code_id\` UInt8,\n    \`pickup_longitude\` Float64,\n    \`pickup_latitude\` Float64,\n    \`dropoff_longitude\` Float64,\n    \`dropoff_latitude\` Float64,\n    \`passenger_count\` UInt8,\n    \`trip_distance\` Float64,\n    \`fare_amount\` Float32,\n    \`extra\` Float32,\n    \`mta_tax\` Float32,\n    \`tip_amount\` Float32,\n    \`tolls_amount\` Float32,\n    \`ehail_fee\` Float32,\n    \`improvement_surcharge\` Float32,\n    \`total_amount\` Float32,\n    \`payment_type\` Enum8('UNK' = 0, 'CSH' = 1, 'CRE' = 2, 'NOC' = 3, 'DIS' = 4),\n    \`trip_type\` UInt8,\n    \`pickup\` FixedString(25),\n    \`dropoff\` FixedString(25),\n    \`cab_type\` Enum8('yellow' = 1, 'green' = 2, 'uber' = 3),\n    \`pickup_nyct2010_gid\` Int8,\n    \`pickup_ctlabel\` Float32,\n    \`pickup_borocode\` Int8,\n    \`pickup_ct2010\` String,\n    \`pickup_boroct2010\` String,\n    \`pickup_cdeligibil\` String,\n    \`pickup_ntacode\` FixedString(4),\n    \`pickup_ntaname\` String,\n    \`pickup_puma\` UInt16,\n    \`dropoff_nyct2010_gid\` UInt8,\n    \`dropoff_ctlabel\` Float32,\n    \`dropoff_borocode\` UInt8,\n    \`dropoff_ct2010\` String,\n    \`dropoff_boroct2010\` String,\n    \`dropoff_cdeligibil\` String,\n    \`dropoff_ntacode\` FixedString(4),\n    \`dropoff_ntaname\` String,\n    \`dropoff_puma\` UInt16\n`)
SETTINGS input_format_try_infer_datetimes = 0

Query id: 8acd222c-f233-472e-bb88-4cb25fffeb28

Ok.

0 rows in set. Elapsed: 18.472 sec. Processed 2.00 million rows, 163.07 MB (108.26 thousand rows/s., 8.83 MB/s.)
Peak memory usage: 972.03 MiB.

# Проверка количества загруженных записей
99496562d1c4 :) SELECT count() FROM trips;

SELECT count()
FROM trips

Query id: e8097e41-7d22-44b7-a0da-bb5826d31656

   ┌─count()─┐
1. │ 1999657 │ -- 2.00 million
   └─────────┘

1 row in set. Elapsed: 0.003 sec.

# Вычисление средней суммы чаевых
99496562d1c4 :) SELECT round(avg(tip_amount), 2) AS avg_tip FROM trips;

SELECT round(avg(tip_amount), 2) AS avg_tip
FROM trips

Query id: 6840fd68-c828-4101-a5b5-02602c8cc17f

   ┌─avg_tip─┐
1. │    1.68 │
   └─────────┘

1 row in set. Elapsed: 0.011 sec. Processed 2.00 million rows, 8.00 MB (185.45 million rows/s., 741.78 MB/s.)
Peak memory usage: 412.15 KiB.

# Вычисление средней стоимости
99496562d1c4 :) SELECT
    passenger_count,
    ceil(avg(total_amount), 2) AS average_total_amount
FROM trips
GROUP BY passenger_count
ORDER BY passenger_count;

SELECT
    passenger_count,
    ceil(avg(total_amount), 2) AS average_total_amount
FROM trips
GROUP BY passenger_count
ORDER BY passenger_count ASC

Query id: afb21bcd-a0b2-453d-b36c-571cc826e82d

    ┌─passenger_count─┬─average_total_amount─┐
 1. │               0 │                22.69 │
 2. │               1 │                15.97 │
 3. │               2 │                17.15 │
 4. │               3 │                16.76 │
 5. │               4 │                17.33 │
 6. │               5 │                16.35 │
 7. │               6 │                16.04 │
 8. │               7 │                 59.8 │
 9. │               8 │                36.41 │
10. │               9 │                 9.81 │
    └─────────────────┴──────────────────────┘

10 rows in set. Elapsed: 0.016 sec. Processed 2.00 million rows, 10.00 MB (128.43 million rows/s., 642.17 MB/s.)
Peak memory usage: 1.16 MiB.

# Вычисление количества поездок
99496562d1c4 :) SELECT
    pickup_date,
    pickup_ntaname,
    SUM(1) AS number_of_trips
FROM trips
GROUP BY pickup_date, pickup_ntaname
ORDER BY pickup_date ASC
LIMIT 20;

SELECT
    pickup_date,
    pickup_ntaname,
    SUM(1) AS number_of_trips
FROM trips
GROUP BY
    pickup_date,
    pickup_ntaname
ORDER BY pickup_date ASC
LIMIT 20

Query id: c7bd2782-d50a-4766-ad1a-db31d53f500e

    ┌─pickup_date─┬─pickup_ntaname─────────────────────────────┬─number_of_trips─┐
 1. │  2015-07-01 │ Hunters Point-Sunnyside-West Maspeth       │              42 │
 2. │  2015-07-01 │ Newark Airport                             │               1 │
 3. │  2015-07-01 │ Battery Park City-Lower Manhattan          │             363 │
 4. │  2015-07-01 │ Lincoln Square                             │             507 │
 5. │  2015-07-01 │ East Elmhurst                              │               4 │
 6. │  2015-07-01 │ West Concourse                             │               2 │
 7. │  2015-07-01 │ Springfield Gardens South-Brookville       │               2 │
 8. │  2015-07-01 │ Carroll Gardens-Columbia Street-Red Hook   │              19 │
 9. │  2015-07-01 │ Fordham South                              │               2 │
10. │  2015-07-01 │ Washington Heights South                   │               5 │
11. │  2015-07-01 │ East Harlem North                          │              32 │
12. │  2015-07-01 │ Crown Heights North                        │               3 │
13. │  2015-07-01 │ Rego Park                                  │               1 │
14. │  2015-07-01 │ Central Harlem South                       │              33 │
15. │  2015-07-01 │ North Side-South Side                      │              31 │
16. │  2015-07-01 │ Chinatown                                  │             200 │
17. │  2015-07-01 │ Woodside                                   │               8 │
18. │  2015-07-01 │ Turtle Bay-East Midtown                    │             999 │
19. │  2015-07-01 │                                            │             205 │
20. │  2015-07-01 │ Hudson Yards-Chelsea-Flatiron-Union Square │            1206 │
    └─────────────┴────────────────────────────────────────────┴─────────────────┘

20 rows in set. Elapsed: 0.035 sec. Processed 2.00 million rows, 64.32 MB (57.32 million rows/s., 1.84 GB/s.)
Peak memory usage: 1.96 MiB.

# Вычисление длительности поездки
99496562d1c4 :) SELECT
    avg(tip_amount) AS avg_tip,
    avg(fare_amount) AS avg_fare,
    avg(passenger_count) AS avg_passenger,
    count() AS count,
    truncate(date_diff('second', pickup_datetime, dropoff_datetime)/60) AS trip_minutes
FROM trips
WHERE trip_minutes > 0
GROUP BY trip_minutes
ORDER BY trip_minutes DESC
LIMIT 20;

SELECT
    avg(tip_amount) AS avg_tip,
    avg(fare_amount) AS avg_fare,
    avg(passenger_count) AS avg_passenger,
    count() AS count,
    truncate(dateDiff('second', pickup_datetime, dropoff_datetime) / 60) AS trip_minutes
FROM trips
WHERE trip_minutes > 0
GROUP BY trip_minutes
ORDER BY trip_minutes DESC
LIMIT 20

Query id: ae133fdc-1c64-4e13-8874-a8c21e46cf58

    ┌─────────────avg_tip─┬───────────avg_fare─┬──────avg_passenger─┬─count─┬─trip_minutes─┐
 1. │  1.9600000381469727 │                  8 │                  1 │     1 │        27511 │
 2. │                   0 │                 12 │                  2 │     1 │        27500 │
 3. │   0.542166673981895 │ 19.716666666666665 │ 1.9166666666666667 │    60 │         1439 │
 4. │   0.902499997522682 │ 11.270625001192093 │            1.95625 │   160 │         1438 │
 5. │  0.9715789457909146 │ 13.646616541353383 │ 2.0526315789473686 │   133 │         1437 │
 6. │  0.9682692398245518 │ 14.134615384615385 │  2.076923076923077 │   104 │         1436 │
 7. │  1.1022105210705808 │ 13.778947368421052 │  2.042105263157895 │    95 │         1435 │
 8. │  0.8419117699651157 │ 12.441176470588236 │ 2.3529411764705883 │    68 │         1434 │
 9. │   0.894264710300109 │ 13.242647058823529 │  2.411764705882353 │    68 │         1433 │
10. │  0.8565151565002672 │ 15.992424242424242 │  2.212121212121212 │    66 │         1432 │
11. │  0.7527777817514207 │ 14.592592592592593 │ 1.8333333333333333 │    54 │         1431 │
12. │  1.5949999883770942 │            14.9375 │                2.4 │    40 │         1430 │
13. │  1.5668965393099292 │ 15.379310344827585 │ 1.6206896551724137 │    29 │         1429 │
14. │  1.1254838974245134 │ 12.451612903225806 │ 2.3225806451612905 │    31 │         1428 │
15. │  0.8072413935743529 │ 11.517241379310345 │ 2.1724137931034484 │    29 │         1427 │
16. │ 0.49192307545588565 │  12.26923076923077 │ 2.1538461538461537 │    26 │         1426 │
17. │  0.8663333336512248 │ 18.416666666666668 │  2.066666666666667 │    30 │         1425 │
18. │   1.227200002670288 │               12.9 │               2.28 │    25 │         1424 │
19. │  2.0532000160217283 │ 23.672000122070312 │                1.8 │    25 │         1423 │
20. │  1.1123809700920468 │ 10.880952380952381 │ 2.1904761904761907 │    21 │         1422 │
    └─────────────────────┴────────────────────┴────────────────────┴───────┴──────────────┘

20 rows in set. Elapsed: 0.030 sec. Processed 2.00 million rows, 33.99 MB (65.75 million rows/s., 1.12 GB/s.)
Peak memory usage: 2.46 MiB.

# Поездки по районам и часам
99496562d1c4 :) SELECT
    pickup_ntaname,
    toHour(pickup_datetime) AS pickup_hour,
    SUM(1) AS pickups
FROM trips
WHERE pickup_ntaname != ''
GROUP BY pickup_ntaname, pickup_hour
ORDER BY pickups DESC
LIMIT 20;

SELECT
    pickup_ntaname,
    toHour(pickup_datetime) AS pickup_hour,
    SUM(1) AS pickups
FROM trips
WHERE pickup_ntaname != ''
GROUP BY
    pickup_ntaname,
    pickup_hour
ORDER BY pickups DESC
LIMIT 20

Query id: 2531fdf9-689a-493a-bc56-954b2165903c

    ┌─pickup_ntaname─────────────────────────────┬─pickup_hour─┬─pickups─┐
 1. │ Midtown-Midtown South                      │          19 │   23476 │
 2. │ Midtown-Midtown South                      │          18 │   22074 │
 3. │ Midtown-Midtown South                      │          20 │   21109 │
 4. │ Midtown-Midtown South                      │          21 │   21077 │
 5. │ Midtown-Midtown South                      │          22 │   20731 │
 6. │ Midtown-Midtown South                      │          14 │   18415 │
 7. │ Midtown-Midtown South                      │          12 │   18292 │
 8. │ Midtown-Midtown South                      │          13 │   18204 │
 9. │ Midtown-Midtown South                      │          11 │   17709 │
10. │ Midtown-Midtown South                      │          17 │   17657 │
11. │ Midtown-Midtown South                      │          15 │   17517 │
12. │ Midtown-Midtown South                      │          23 │   17449 │
13. │ Midtown-Midtown South                      │          10 │   16491 │
14. │ Midtown-Midtown South                      │          16 │   15458 │
15. │ Midtown-Midtown South                      │           9 │   15238 │
16. │ Midtown-Midtown South                      │           8 │   13324 │
17. │ Midtown-Midtown South                      │           0 │   13082 │
18. │ Hudson Yards-Chelsea-Flatiron-Union Square │          19 │   12694 │
19. │ Hudson Yards-Chelsea-Flatiron-Union Square │          18 │   12540 │
20. │ Hudson Yards-Chelsea-Flatiron-Union Square │          20 │   12066 │
    └────────────────────────────────────────────┴─────────────┴─────────┘

20 rows in set. Elapsed: 0.122 sec. Processed 2.00 million rows, 68.32 MB (16.46 million rows/s., 562.25 MB/s.)
Peak memory usage: 1.86 MiB.

# Дополнительная таблица. Создание БД и таблицы
99496562d1c4 :) CREATE DATABASE IF NOT EXISTS uk;

CREATE DATABASE IF NOT EXISTS uk

Query id: c0e34786-0afe-4f34-a609-ee58b74a4680

Ok.

0 rows in set. Elapsed: 0.008 sec.

99496562d1c4 :) CREATE TABLE IF NOT EXISTS uk.uk_price_paid
(
    price UInt32,
    date Date,
    postcode1 LowCardinality(String),
    postcode2 LowCardinality(String),
    type Enum8('terraced' = 1, 'semi-detached' = 2, 'detached' = 3, 'flat' = 4, 'other' = 0),
    is_new UInt8,
    duration Enum8('freehold' = 1, 'leasehold' = 2, 'unknown' = 0),
    addr1 String,
    addr2 String,
    street LowCardinality(String),
    locality LowCardinality(String),
    town LowCardinality(String),
    district LowCardinality(String),
    county LowCardinality(String)
)
ENGINE = MergeTree
ORDER BY (postcode1, postcode2, addr1, addr2);

CREATE TABLE IF NOT EXISTS uk.uk_price_paid
(
    `price` UInt32,
    `date` Date,
    `postcode1` LowCardinality(String),
    `postcode2` LowCardinality(String),
    `type` Enum8('terraced' = 1, 'semi-detached' = 2, 'detached' = 3, 'flat' = 4, 'other' = 0),
    `is_new` UInt8,
    `duration` Enum8('freehold' = 1, 'leasehold' = 2, 'unknown' = 0),
    `addr1` String,
    `addr2` String,
    `street` LowCardinality(String),
    `locality` LowCardinality(String),
    `town` LowCardinality(String),
    `district` LowCardinality(String),
    `county` LowCardinality(String)
)
ENGINE = MergeTree
ORDER BY (postcode1, postcode2, addr1, addr2)

Query id: 20204588-013f-44cb-833e-d7416396da33

Ok.

0 rows in set. Elapsed: 0.020 sec.

# Загрузка данных
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework6>docker cp pp-complete.csv clickhouse-demo:/var/lib/clickhouse/user_files/pp-complete.csv
Successfully copied 5.53GB to clickhouse-demo:/tmp/pp-complete.csv

99496562d1c4 :) INSERT INTO uk.uk_price_paid
SELECT
    toUInt32(price_string) AS price,
    parseDateTimeBestEffortUS(time) AS date,
    splitByChar(' ', postcode)[1] AS postcode1,
    splitByChar(' ', postcode)[2] AS postcode2,
    transform(a, ['T', 'S', 'D', 'F', 'O'], ['terraced', 'semi-detached', 'detached', 'flat', 'other']) AS type,
    b = 'Y' AS is_new,
    transform(c, ['F', 'L', 'U'], ['freehold', 'leasehold', 'unknown']) AS duration,
    addr1,
    addr2,
    street,
    locality,
    town,
    district,
    county
FROM file(
    'pp-complete.csv',
    'CSV',
    'uuid_string String, price_string String, time String, postcode String, a String, b String, c String, addr1 String, addr2 String, street String, locality String, town String, district String, county String, d String, e String'
);

INSERT INTO uk.uk_price_paid SELECT
    toUInt32(price_string) AS price,
    parseDateTimeBestEffortUS(time) AS date,
    splitByChar(' ', postcode)[1] AS postcode1,
    splitByChar(' ', postcode)[2] AS postcode2,
    transform(a, ['T', 'S', 'D', 'F', 'O'], ['terraced', 'semi-detached', 'detached', 'flat', 'other']) AS type,
    b = 'Y' AS is_new,
    transform(c, ['F', 'L', 'U'], ['freehold', 'leasehold', 'unknown']) AS duration,
    addr1,
    addr2,
    street,
    locality,
    town,
    district,
    county
FROM file('pp-complete.csv', 'CSV', 'uuid_string String, price_string String, time String, postcode String, a String, b String, c String, addr1 String, addr2 String, street String, locality String, town String, district String, county String, d String, e String')

Query id: cdcba0ff-468a-4687-9afa-5a8b1473ebc1

Ok.

0 rows in set. Elapsed: 52.710 sec. Processed 31.61 million rows, 5.53 GB (599.71 thousand rows/s., 104.84 MB/s.)
Peak memory usage: 777.10 MiB.

# Проверка загруженных данных
99496562d1c4 :) SELECT count() FROM uk.uk_price_paid;

SELECT count()
FROM uk.uk_price_paid

Query id: 39290a6c-639b-4a27-92ba-caf38f0f363e

   ┌──count()─┐
1. │ 31610742 │ -- 31.61 million
   └──────────┘

1 row in set. Elapsed: 0.004 sec.

# Выполнение запросов
99496562d1c4 :) SELECT
    toYear(date) AS year,
    round(avg(price), 0) AS avg_price,
    count() AS deals
FROM uk.uk_price_paid
GROUP BY year
ORDER BY year DESC
LIMIT 20;

SELECT
    toYear(date) AS year,
    round(avg(price), 0) AS avg_price,
    count() AS deals
FROM uk.uk_price_paid
GROUP BY year
ORDER BY year DESC
LIMIT 20

Query id: 3c57f590-69c9-4494-83e7-90f33806e7eb

    ┌─year─┬─avg_price─┬───deals─┐
 1. │ 2026 │    357332 │  386238 │
 2. │ 2025 │    390815 │  974087 │
 3. │ 2024 │    400202 │  931453 │
 4. │ 2023 │    406920 │  861502 │
 5. │ 2022 │    414657 │ 1077205 │
 6. │ 2021 │    389597 │ 1281983 │
 7. │ 2020 │    375452 │  897978 │
 8. │ 2019 │    355346 │ 1012236 │
 9. │ 2018 │    351129 │ 1037666 │
10. │ 2017 │    346967 │ 1067647 │
11. │ 2016 │    313751 │ 1046656 │
12. │ 2015 │    297487 │ 1011782 │
13. │ 2014 │    280074 │  985204 │
14. │ 2013 │    257004 │  811189 │
15. │ 2012 │    238408 │  668982 │
16. │ 2011 │    232826 │  661265 │
17. │ 2010 │    236118 │  663358 │
18. │ 2009 │    213418 │  625377 │
19. │ 2008 │    217148 │  649722 │
20. │ 2007 │    219392 │ 1272507 │
    └──────┴───────────┴─────────┘

20 rows in set. Elapsed: 0.057 sec. Processed 31.61 million rows, 189.66 MB (557.64 million rows/s., 3.35 GB/s.)
Peak memory usage: 5.02 MiB.



99496562d1c4 :) SELECT
    type,
    count() AS deals,
    round(avg(price), 0) AS avg_price,
    round(quantile(0.5)(price), 0) AS median_price
FROM uk.uk_price_paid
GROUP BY type
ORDER BY avg_price DESC;

SELECT
    type,
    count() AS deals,
    round(avg(price), 0) AS avg_price,
    round(quantile(0.5)(price), 0) AS median_price
FROM uk.uk_price_paid
GROUP BY type
ORDER BY avg_price DESC

Query id: 47955444-35e2-4b57-9a76-42bdcdec83eb

   ┌─type──────────┬───deals─┬─avg_price─┬─median_price─┐
1. │ other         │  655854 │   1176899 │       260000 │
2. │ detached      │ 7286665 │    313455 │       249000 │
3. │ flat          │ 5686095 │    215288 │       150000 │
4. │ semi-detached │ 8625668 │    188747 │       150000 │
5. │ terraced      │ 9356460 │    171371 │       123000 │
   └───────────────┴─────────┴───────────┴──────────────┘

5 rows in set. Elapsed: 0.063 sec. Processed 31.61 million rows, 158.05 MB (501.71 million rows/s., 2.51 GB/s.)
Peak memory usage: 2.27 MiB.




99496562d1c4 :) SELECT
    county,
    toYear(date) AS year,
    round(avg(price), 0) AS avg_price,
    count() AS deals
FROM uk.uk_price_paid
WHERE date >= '2015-01-01'
GROUP BY county, year
ORDER BY avg_price DESC
LIMIT 20;

SELECT
    county,
    toYear(date) AS year,
    round(avg(price), 0) AS avg_price,
    count() AS deals
FROM uk.uk_price_paid
WHERE date >= '2015-01-01'
GROUP BY
    county,
    year
ORDER BY avg_price DESC
LIMIT 20

Query id: 69124ec7-679e-4e8a-8f6e-feb19a4f9a55

    ┌─county─────────────────┬─year─┬─avg_price─┬──deals─┐
 1. │ NORTH NORTHAMPTONSHIRE │ 2015 │   3464001 │     31 │
 2. │ WEST NORTHAMPTONSHIRE  │ 2018 │   1361697 │     63 │
 3. │ NORTH NORTHAMPTONSHIRE │ 2017 │   1118428 │     52 │
 4. │ WEST NORTHAMPTONSHIRE  │ 2016 │   1017914 │     40 │
 5. │ GREATER LONDON         │ 2023 │    860448 │  96500 │
 6. │ GREATER LONDON         │ 2022 │    858776 │ 122767 │
 7. │ GREATER LONDON         │ 2020 │    853649 │  98157 │
 8. │ GREATER LONDON         │ 2019 │    837443 │ 108239 │
 9. │ NORTH NORTHAMPTONSHIRE │ 2019 │    827854 │    145 │
10. │ GREATER LONDON         │ 2024 │    819278 │ 106790 │
11. │ GREATER LONDON         │ 2018 │    819243 │ 111178 │
12. │ GREATER LONDON         │ 2021 │    799933 │ 143493 │
13. │ GREATER LONDON         │ 2017 │    796816 │ 117667 │
14. │ GREATER LONDON         │ 2025 │    762874 │ 108179 │
15. │ WEST NORTHAMPTONSHIRE  │ 2019 │    752627 │    137 │
16. │ WINDSOR AND MAIDENHEAD │ 2025 │    739981 │   2436 │
17. │ WINDSOR AND MAIDENHEAD │ 2024 │    737897 │   2437 │
18. │ WINDSOR AND MAIDENHEAD │ 2018 │    727736 │   2195 │
19. │ WINDSOR AND MAIDENHEAD │ 2022 │    726048 │   2787 │
20. │ BRIGHTON AND HOVE      │ 2023 │    718683 │   3797 │
    └────────────────────────┴──────┴───────────┴────────┘

20 rows in set. Elapsed: 0.085 sec. Processed 31.61 million rows, 124.40 MB (371.66 million rows/s., 1.46 GB/s.)
Peak memory usage: 29.43 MiB.


# Запуск и проверка кластера
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework6>docker compose -f docker-compose.cluster.yml up -d
[+] Running 9/9
 ✔ clickhouse-keeper Pulled                                                                                        8.2s
   ✔ e3314ce3dd21 Download complete                                                                                0.3s
   ✔ 026923c2b735 Download complete                                                                                0.8s
   ✔ 4c9aa20a07f0 Download complete                                                                                0.8s
   ✔ 897933c88690 Download complete                                                                                0.9s
   ✔ 958e02b8d31a Download complete                                                                                4.1s
   ✔ d402ca802781 Download complete                                                                                1.2s
   ✔ d26a72fff030 Download complete                                                                                0.8s
   ✔ f18232174bc9 Download complete                                                                                0.9s
[+] Running 7/7
 ✔ Network homework6_default       Created                                                                         0.2s
 ✔ Volume "homework6_ch02-data"    Created                                                                         0.0s
 ✔ Volume "homework6_keeper-data"  Created                                                                         0.0s
 ✔ Volume "homework6_ch01-data"    Created                                                                         0.0s
 ✔ Container clickhouse-keeper     Healthy                                                                         6.6s
 ✔ Container clickhouse-01         Started                                                                         6.7s
 ✔ Container clickhouse-02         Started                                                                         6.7s

D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework6>docker ps --filter "name=clickhouse"
CONTAINER ID   IMAGE                               COMMAND            CREATED         STATUS                   PORTS                                                      NAMES
d379448a45d9   clickhouse/clickhouse-server:24.8   "/entrypoint.sh"   2 minutes ago   Up 2 minutes (healthy)   0.0.0.0:8123->8123/tcp, 0.0.0.0:9000->9000/tcp, 9009/tcp   clickhouse-01
e25fdeb45924   clickhouse/clickhouse-server:24.8   "/entrypoint.sh"   2 minutes ago   Up 2 minutes (healthy)   9009/tcp, 0.0.0.0:8124->8123/tcp, 0.0.0.0:9001->9000/tcp   clickhouse-02
11bcc617a2dc   clickhouse/clickhouse-keeper:24.8   "/entrypoint.sh"   2 minutes ago   Up 2 minutes (healthy)   2181/tcp, 10181/tcp, 44444/tcp, 0.0.0.0:9181->9181/tcp     clickhouse-keeper

# Применение и проверка схемы
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework6>docker exec -i clickhouse-01 clickhouse-client --multiquery < docker/cluster/schema.sql
clickhouse-01   9000    0               1       0
clickhouse-02   9000    0               0       0
clickhouse-01   9000    0               1       0
clickhouse-02   9000    0               0       0
clickhouse-01   9000    0               1       0
clickhouse-02   9000    0               0       0

D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework6>docker exec clickhouse-01 clickhouse-client -q "SELECT cluster, shard_num, replica_num, host_name, port FROM system.clusters WHERE cluster='demo_cluster' ORDER BY shard_num, replica_num"
demo_cluster    1       1       clickhouse-01   9000
demo_cluster    2       1       clickhouse-02   9000

D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework6>docker exec clickhouse-01 clickhouse-client -q "SHOW TABLES FROM user_service"
users
users_local

D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework6>docker exec clickhouse-02 clickhouse-client -q "SHOW TABLES FROM user_service"
users
users_local

D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework6>docker exec clickhouse-01 clickhouse-client -q "SELECT * FROM user_service.users ORDER BY id"
1       alice   alice@example.com       1       2026-10-15 08:23:46     2026-10-15 08:23:46
2       bob     bob@example.com 1       2026-10-15 08:23:46     2026-10-15 08:23:46
3       carol   carol@example.com       1       2026-10-15 08:23:46     2026-10-15 08:23:46
4       dave    dave@example.com        1       2026-10-15 08:23:46     2026-10-15 08:23:46
5       eve     eve@example.com 1       2026-10-15 08:23:46     2026-10-15 08:23:46
6       frank   frank@example.com       1       2026-10-15 08:23:46     2026-10-15 08:23:46

# Создание таблиц
clickhouse-01 :) CREATE TABLE IF NOT EXISTS user_service.trips_local ON CLUSTER demo_cluster
(
    trip_id UInt32,
    vendor_id String,
    pickup_date Date,
    pickup_datetime DateTime,
    dropoff_date Date,
    dropoff_datetime DateTime,
    store_and_fwd_flag UInt8,
    rate_code_id UInt8,
    pickup_longitude Float64,
    pickup_latitude Float64,
    dropoff_longitude Float64,
    dropoff_latitude Float64,
    passenger_count UInt8,
    trip_distance Float64,
    fare_amount Float32,
    extra Float32,
    mta_tax Float32,
    tip_amount Float32,
    tolls_amount CREATE TABLE IF NOT EXISTS user_service.trips_local ON CLUSTER demo_cluster
(
    trip_id UInt32,
    vendor_id String,
    pickup_date Date,
    pickup_datetime DateTime,
    dropoff_date Date,
    dropoff_datetime DateTime,
    store_and_fwd_flag UInt8,
    rate_code_id UInt8,
    pickup_longitude Float64,
    pickup_latitude Float64,
    dropoff_longitude Float64,
    dropoff_latitude Float64,
    passenger_count UInt8,
    trip_distance Float64,
    fare_amount Float32,
    extra Float32,
    mta_tax Float32,
    tip_amount Float32,
    tolls_amount Float32,
    ehail_fee Float32,
    improvement_surcharge Float32,
    total_amount Float32,
    payment_type String,
    trip_type UInt8,
    pickup String,
    dropoff String,
    cab_type String,
    pickup_nyct2010_gid Int8,
    pickup_ctlabel Float32,
    pickup_borocode Int8,
    pickup_ct2010 String,
    pickup_boroct2010 String,
    pickup_cdeligibil String,
    pickup_ntacode String,
    pickup_ntaname String,
    pickup_puma UInt16,
    dropoff_nyct2010_gid UInt8,
    dropoff_ctlabel Float32,
    dropoff_borocode UInt8,
    dropoff_ct2010 String,
    dropoff_boroct2010 String,
    dropoff_cdeligibil String,
    dropoff_ntacode String,
    dropoff_ntaname String,
    dropoff_puma UInt16
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{shard}/trips_local', '{replica}')
ORDER BY pickup_datetime;

CREATE TABLE IF NOT EXISTS user_service.trips_local ON CLUSTER demo_cluster
(
    `trip_id` UInt32,
    `vendor_id` String,
    `pickup_date` Date,
    `pickup_datetime` DateTime,
    `dropoff_date` Date,
    `dropoff_datetime` DateTime,
    `store_and_fwd_flag` UInt8,
    `rate_code_id` UInt8,
    `pickup_longitude` Float64,
    `pickup_latitude` Float64,
    `dropoff_longitude` Float64,
    `dropoff_latitude` Float64,
    `passenger_count` UInt8,
    `trip_distance` Float64,
    `fare_amount` Float32,
    `extra` Float32,
    `mta_tax` Float32,
    `tip_amount` Float32,
    `tolls_amount` Float32,
    `ehail_fee` Float32,
    `improvement_surcharge` Float32,
    `total_amount` Float32,
    `payment_type` String,
    `trip_type` UInt8,
    `pickup` String,
    `dropoff` String,
    `cab_type` String,
    `pickup_nyct2010_gid` Int8,
    `pickup_ctlabel` Float32,
    `pickup_borocode` Int8,
    `pickup_ct2010` String,
    `pickup_boroct2010` String,
    `pickup_cdeligibil` String,
    `pickup_ntacode` String,
    `pickup_ntaname` String,
    `pickup_puma` UInt16,
    `dropoff_nyct2010_gid` UInt8,
    `dropoff_ctlabel` Float32,
    `dropoff_borocode` UInt8,
    `dropoff_ct2010` String,
    `dropoff_boroct2010` String,
    `dropoff_cdeligibil` String,
    `dropoff_ntacode` String,
    `dropoff_ntaname` String,
    `dropoff_puma` UInt16
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{shard}/trips_local', '{replica}')
ORDER BY pickup_datetime

Query id: 042f063b-d78b-4552-991b-929bd7a71eb8

   ┌─host──────────┬─port─┬─status─┬─error─┬─num_hosts_remaining─┬─num_hosts_active─┐
1. │ clickhouse-01 │ 9000 │      0 │       │                   1 │                0 │
2. │ clickhouse-02 │ 9000 │      0 │       │                   0 │                0 │
   └───────────────┴──────┴────────┴───────┴─────────────────────┴──────────────────┘

2 rows in set. Elapsed: 0.195 sec.

lickhouse-01 :) CREATE TABLE IF NOT EXISTS user_service.trips ON CLUSTER demo_cluster
AS user_service.trips_local
ENGINE = Distributed(demo_cluster, user_service, trips_local, cityHash64(trip_id));

CREATE TABLE IF NOT EXISTS user_service.trips ON CLUSTER demo_cluster AS user_service.trips_local
ENGINE = Distributed(demo_cluster, user_service, trips_local, cityHash64(trip_id))

Query id: 52bd34bd-e0f7-42bf-8595-0c954521df8b

   ┌─host──────────┬─port─┬─status─┬─error─┬─num_hosts_remaining─┬─num_hosts_active─┐
1. │ clickhouse-01 │ 9000 │      0 │       │                   1 │                0 │
2. │ clickhouse-02 │ 9000 │      0 │       │                   0 │                0 │
   └───────────────┴──────┴────────┴───────┴─────────────────────┴──────────────────┘

2 rows in set. Elapsed: 0.069 sec.

# Загрузка данных
clickhouse-01 :) INSERT INTO user_service.trips
SELECT * FROM s3(
    'https://datasets-documentation.s3.eu-west-3.amazonaws.com/nyc-taxi/trips_{1..2}.gz',
    'TabSeparatedWithNames', "
    `trip_id` UInt32,
    `vendor_id` String,
    `pickup_date` Date,
    `pickup_datetime` DateTime,
    `dropoff_date` Date,
    `dropoff_datetime` DateTime,
    `store_and_fwd_flag` UInt8,
    `rate_code_id` UInt8,
    `pickup_longitude` Float64,
    `pickup_latitude` Float64,
    `dropoff_longitude` Float64,
    `dropoff_latitude` Float64,
    `passenger_count` UInt8,
    `trip_distance` Float64,
    `fare_amount` Float32,
    `extra` Float32,
    `mta_tax` FloINSERT INTO user_service.trips
SELECT * FROM s3(
    'https://datasets-documentation.s3.eu-west-3.amazonaws.com/nyc-taxi/trips_{1..2}.gz',
    'TabSeparatedWithNames', "
    `trip_id` UInt32,
    `vendor_id` String,
    `pickup_date` Date,
    `pickup_datetime` DateTime,
    `dropoff_date` Date,
    `dropoff_datetime` DateTime,
    `store_and_fwd_flag` UInt8,
    `rate_code_id` UInt8,
    `pickup_longitude` Float64,
    `pickup_latitude` Float64,
    `dropoff_longitude` Float64,
    `dropoff_latitude` Float64,
    `passenger_count` UInt8,
    `trip_distance` Float64,
    `fare_amount` Float32,
    `extra` Float32,
    `mta_tax` Float32,
    `tip_amount` Float32,
    `tolls_amount` Float32,
    `ehail_fee` Float32,
    `improvement_surcharge` Float32,
    `total_amount` Float32,
    `payment_type` String,
    `trip_type` UInt8,
    `pickup` String,
    `dropoff` String,
    `cab_type` String,
    `pickup_nyct2010_gid` Int8,
    `pickup_ctlabel` Float32,
    `pickup_borocode` Int8,
    `pickup_ct2010` String,
    `pickup_boroct2010` String,
    `pickup_cdeligibil` String,
    `pickup_ntacode` String,
    `pickup_ntaname` String,
    `pickup_puma` UInt16,
    `dropoff_nyct2010_gid` UInt8,
    `dropoff_ctlabel` Float32,
    `dropoff_borocode` UInt8,
    `dropoff_ct2010` String,
    `dropoff_boroct2010` String,
    `dropoff_cdeligibil` String,
    `dropoff_ntacode` String,
    `dropoff_ntaname` String,
    `dropoff_puma` UInt16
") SETTINGS input_format_try_infer_datetimes = 0;

INSERT INTO user_service.trips
SETTINGS input_format_try_infer_datetimes = 0
SELECT *
FROM s3('https://datasets-documentation.s3.eu-west-3.amazonaws.com/nyc-taxi/trips_{1..2}.gz', 'TabSeparatedWithNames', `\n    \`trip_id\` UInt32,\n    \`vendor_id\` String,\n    \`pickup_date\` Date,\n    \`pickup_datetime\` DateTime,\n    \`dropoff_date\` Date,\n    \`dropoff_datetime\` DateTime,\n    \`store_and_fwd_flag\` UInt8,\n    \`rate_code_id\` UInt8,\n    \`pickup_longitude\` Float64,\n    \`pickup_latitude\` Float64,\n    \`dropoff_longitude\` Float64,\n    \`dropoff_latitude\` Float64,\n    \`passenger_count\` UInt8,\n    \`trip_distance\` Float64,\n    \`fare_amount\` Float32,\n    \`extra\` Float32,\n    \`mta_tax\` Float32,\n    \`tip_amount\` Float32,\n    \`tolls_amount\` Float32,\n    \`ehail_fee\` Float32,\n    \`improvement_surcharge\` Float32,\n    \`total_amount\` Float32,\n    \`payment_type\` String,\n    \`trip_type\` UInt8,\n    \`pickup\` String,\n    \`dropoff\` String,\n    \`cab_type\` String,\n    \`pickup_nyct2010_gid\` Int8,\n    \`pickup_ctlabel\` Float32,\n    \`pickup_borocode\` Int8,\n    \`pickup_ct2010\` String,\n    \`pickup_boroct2010\` String,\n    \`pickup_cdeligibil\` String,\n    \`pickup_ntacode\` String,\n    \`pickup_ntaname\` String,\n    \`pickup_puma\` UInt16,\n    \`dropoff_nyct2010_gid\` UInt8,\n    \`dropoff_ctlabel\` Float32,\n    \`dropoff_borocode\` UInt8,\n    \`dropoff_ct2010\` String,\n    \`dropoff_boroct2010\` String,\n    \`dropoff_cdeligibil\` String,\n    \`dropoff_ntacode\` String,\n    \`dropoff_ntaname\` String,\n    \`dropoff_puma\` UInt16\n`)
SETTINGS input_format_try_infer_datetimes = 0

Query id: fc86c04c-6569-4581-a501-ab85bf810849

Ok.

0 rows in set. Elapsed: 31.958 sec. Processed 2.00 million rows, 163.07 MB (62.57 thousand rows/s., 5.10 MB/s.)
Peak memory usage: 854.22 MiB.

# Проверка данных
clickhouse-01 :) SELECT count() FROM user_service.trips;

SELECT count()
FROM user_service.trips

Query id: 13899e3b-293e-473e-b5b4-2f9c64354530

   ┌─count()─┐
1. │ 1999657 │ -- 2.00 million
   └─────────┘

1 row in set. Elapsed: 0.005 sec.

clickhouse-01 :) SELECT _shard_num AS shard, count() AS cnt FROM user_service.trips GROUP BY shard ORDER BY shard;

SELECT
    _shard_num AS shard,
    count() AS cnt
FROM user_service.trips
GROUP BY shard
ORDER BY shard ASC

Query id: ae35dc8d-88e7-4482-af60-8492d5405dfe

   ┌─shard─┬─────cnt─┐
1. │     1 │  999003 │
2. │     2 │ 1000654 │
   └───────┴─────────┘

2 rows in set. Elapsed: 0.007 sec.

# Выполнение запросов для сравнения скорости
clickhouse-01 :) SELECT round(avg(tip_amount), 2) AS avg_tip FROM user_service.trips;

SELECT round(avg(tip_amount), 2) AS avg_tip
FROM user_service.trips

Query id: a636080c-cb26-408d-b225-0b3c65f8bc3f

   ┌─avg_tip─┐
1. │    1.68 │
   └─────────┘

1 row in set. Elapsed: 0.015 sec. Processed 2.00 million rows, 8.00 MB (136.00 million rows/s., 544.01 MB/s.)
Peak memory usage: 1.19 MiB.

clickhouse-01 :) SELECT
    passenger_count,
    ceil(avg(total_amount), 2) AS average_total_amount
FROM user_service.trips
GROUP BY passenger_count
ORDER BY passenger_count;

SELECT
    passenger_count,
    ceil(avg(total_amount), 2) AS average_total_amount
FROM user_service.trips
GROUP BY passenger_count
ORDER BY passenger_count ASC

Query id: af1e5948-307d-4e80-b856-a28b26afe285

    ┌─passenger_count─┬─average_total_amount─┐
 1. │               0 │                22.69 │
 2. │               1 │                15.97 │
 3. │               2 │                17.15 │
 4. │               3 │                16.76 │
 5. │               4 │                17.33 │
 6. │               5 │                16.35 │
 7. │               6 │                16.04 │
 8. │               7 │                 59.8 │
 9. │               8 │                36.41 │
10. │               9 │                 9.81 │
    └─────────────────┴──────────────────────┘

10 rows in set. Elapsed: 0.014 sec. Processed 2.00 million rows, 10.00 MB (146.27 million rows/s., 731.34 MB/s.)
Peak memory usage: 1.22 MiB.

clickhouse-01 :) SELECT
    pickup_ntaname,
    toHour(pickup_datetime) AS pickup_hour,
    SUM(1) AS pickups
FROM user_service.trips
WHERE pickup_ntaname != ''
GROUP BY pickup_ntaname, pickup_hour
ORDER BY pickups DESC
LIMIT 20;

SELECT
    pickup_ntaname,
    toHour(pickup_datetime) AS pickup_hour,
    SUM(1) AS pickups
FROM user_service.trips
WHERE pickup_ntaname != ''
GROUP BY
    pickup_ntaname,
    pickup_hour
ORDER BY pickups DESC
LIMIT 20

Query id: aa00828c-c8cc-4bef-b104-df8f1b4522b9

    ┌─pickup_ntaname─────────────────────────────┬─pickup_hour─┬─pickups─┐
 1. │ Midtown-Midtown South                      │          19 │   23476 │
 2. │ Midtown-Midtown South                      │          18 │   22074 │
 3. │ Midtown-Midtown South                      │          20 │   21109 │
 4. │ Midtown-Midtown South                      │          21 │   21077 │
 5. │ Midtown-Midtown South                      │          22 │   20731 │
 6. │ Midtown-Midtown South                      │          14 │   18415 │
 7. │ Midtown-Midtown South                      │          12 │   18292 │
 8. │ Midtown-Midtown South                      │          13 │   18204 │
 9. │ Midtown-Midtown South                      │          11 │   17709 │
10. │ Midtown-Midtown South                      │          17 │   17657 │
11. │ Midtown-Midtown South                      │          15 │   17517 │
12. │ Midtown-Midtown South                      │          23 │   17449 │
13. │ Midtown-Midtown South                      │          10 │   16491 │
14. │ Midtown-Midtown South                      │          16 │   15458 │
15. │ Midtown-Midtown South                      │           9 │   15238 │
16. │ Midtown-Midtown South                      │           8 │   13324 │
17. │ Midtown-Midtown South                      │           0 │   13082 │
18. │ Hudson Yards-Chelsea-Flatiron-Union Square │          19 │   12694 │
19. │ Hudson Yards-Chelsea-Flatiron-Union Square │          18 │   12540 │
20. │ Hudson Yards-Chelsea-Flatiron-Union Square │          20 │   12066 │
    └────────────────────────────────────────────┴─────────────┴─────────┘

20 rows in set. Elapsed: 0.040 sec. Processed 2.00 million rows, 68.32 MB (50.50 million rows/s., 1.73 GB/s.)
Peak memory usage: 2.62 MiB.

# Сравнение производительности
| Запрос                          | 1 узел    | Кластер (2 шарда) | Разница                     |
| ------------------------------- | --------- | ----------------- | --------------------------- |
| Средний размер чаевых           | 0.011 сек | **0.015 сек**     | Кластер немного медленнее   |
| Средняя стоимость по пассажирам | 0.016 сек | **0.014 сек**     | Кластер немного быстрее     |
| Поездки по районам и часам      | 0.122 сек | **0.040 сек**     | Кластер значительно быстрее |


*pp-complete.csv удален из каталога перед коммитом/пушем*