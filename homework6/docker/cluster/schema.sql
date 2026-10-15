-- Схема для кластера (docker-compose.cluster.yml).
-- Выполнять ОДИН раз с любого узла — DDL с ON CLUSTER разъедется по всем узлам через Keeper.
--
--   docker exec -i clickhouse-01 clickhouse-client --multiquery < docker/cluster/schema.sql

-- 1. База на всех узлах кластера
CREATE DATABASE IF NOT EXISTS user_service ON CLUSTER demo_cluster;

-- 2. Локальная (шардированная) таблица на каждом узле.
--    ReplicatedReplacingMergeTree хранит данные в Keeper-координируемых репликах.
--    Подстановки {shard}/{replica} берутся из macros.xml конкретного узла.
CREATE TABLE IF NOT EXISTS user_service.users_local ON CLUSTER demo_cluster
(
    id         UInt64,
    username   String,
    email      String,
    is_active  UInt8    DEFAULT 1,
    created_at DateTime DEFAULT now(),
    updated_at DateTime DEFAULT now()
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/{shard}/users_local', '{replica}', updated_at)
ORDER BY id;

-- 3. Распределённая таблица-«фасад». Читает/пишет во все шарды.
--    Ключ шардирования cityHash64(id) детерминированно раскладывает строки по 2 шардам.
CREATE TABLE IF NOT EXISTS user_service.users ON CLUSTER demo_cluster
AS user_service.users_local
ENGINE = Distributed(demo_cluster, user_service, users_local, cityHash64(id));

-- 4. Демо-данные (пишем через распределённую таблицу — строки сами разъедутся по шардам)
INSERT INTO user_service.users (id, username, email) VALUES
    (1, 'alice', 'alice@example.com'),
    (2, 'bob',   'bob@example.com'),
    (3, 'carol', 'carol@example.com'),
    (4, 'dave',  'dave@example.com'),
    (5, 'eve',   'eve@example.com'),
    (6, 'frank', 'frank@example.com');
