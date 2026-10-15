-- Этот скрипт выполняется автоматически при первом старте контейнера
-- (папка смонтирована в /docker-entrypoint-initdb.d).
-- База user_service уже создана переменной окружения CLICKHOUSE_DB.

CREATE DATABASE IF NOT EXISTS user_service;

-- Таблица пользователей.
-- Движок ReplacingMergeTree(updated_at): при слиянии частей ClickHouse оставляет
-- только одну строку на каждый ключ сортировки (id) — ту, у которой updated_at максимальный.
-- Это даёт нам "UPDATE" через повторную вставку: пишем новую строку с тем же id
-- и более свежим updated_at, а старая версия схлопывается при merge.
CREATE TABLE IF NOT EXISTS user_service.users
(
    id         UInt64,
    username   String,
    email      String,
    is_active  UInt8    DEFAULT 1,
    created_at DateTime DEFAULT now(),
    updated_at DateTime DEFAULT now()
)
ENGINE = ReplacingMergeTree(updated_at)
ORDER BY id;

-- Немного демо-данных
INSERT INTO user_service.users (id, username, email) VALUES
    (1, 'alice', 'alice@example.com'),
    (2, 'bob',   'bob@example.com'),
    (3, 'carol', 'carol@example.com');
