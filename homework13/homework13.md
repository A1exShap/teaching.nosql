# Проверка контейнеров
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework13>docker ps --filter "name=rabbitmq"
CONTAINER ID   IMAGE                      COMMAND                  CREATED          STATUS          PORTS                                                                                                         NAMES
47b66578a521   rabbitmq:3.13-management   "docker-entrypoint.s…"   14 minutes ago   Up 13 minutes   4369/tcp, 5671/tcp, 0.0.0.0:5672->5672/tcp, 15671/tcp, 15691-15692/tcp, 25672/tcp, 0.0.0.0:15672->15672/tcp   rabbitmq

# Выдача прав
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework13>docker exec -it rabbitmq rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
Setting permissions for user "admin" in vhost "/" ...

# Создание очереди
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework13>docker exec -it rabbitmq rabbitmqadmin -u admin -p admin123 declare queue name=homework-queue durable=true
queue declared

# Отправка сообщения
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework13>docker exec -it rabbitmq rabbitmqadmin -u admin -p admin123 publish routing_key=homework-queue payload="Test message from CLI"
Message published

# Чтение сообщения
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework13>docker exec -it rabbitmq rabbitmqadmin -u admin -p admin123 get queue=homework-queue ackmode=ack_requeue_true
+----------------+----------+---------------+-----------------------+---------------+------------------+------------+-------------+
|  routing_key   | exchange | message_count |        payload        | payload_bytes | payload_encoding | properties | redelivered |
+----------------+----------+---------------+-----------------------+---------------+------------------+------------+-------------+
| homework-queue |          | 0             | Test message from CLI | 21            | string           |            | True        |
+----------------+----------+---------------+-----------------------+---------------+------------------+------------+-------------+

# RabbitMQ Management (UI)
Публикация и просмотр предоставлены на изображениях publish.png, published.png и messages.png в каталоге ДЗ.

# Программная отправка и получение сообщений
- Проект RabbitMqHomework.csproj в каталоге ДЗ.
- Там же скрин получения существующих сообщений и ожидание новых (waiting.png).
- Там же скрин программной отправки и получения (produce_and_consume.png).