# Проверка контейнеров
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework12>docker ps
CONTAINER ID   IMAGE                             COMMAND                  CREATED         STATUS         PORTS                                        NAMES
5f0b48187868   provectuslabs/kafka-ui:latest     "/bin/sh -c 'java --…"   5 minutes ago   Up 5 minutes   0.0.0.0:8080->8080/tcp                       kafka-ui
5951be2d66b6   confluentinc/cp-kafka:7.5.0       "/etc/confluent/dock…"   5 minutes ago   Up 5 minutes   0.0.0.0:9092->9092/tcp                       kafka
702a59df85ce   confluentinc/cp-zookeeper:7.5.0   "/etc/confluent/dock…"   6 minutes ago   Up 5 minutes   2888/tcp, 0.0.0.0:2181->2181/tcp, 3888/tcp   zookeeper

# Создание топика
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework12>docker exec -it kafka kafka-topics --create --topic homework-topic --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
Created topic homework-topic.

# Отправка сообщений
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework12>docker exec -it kafka kafka-console-producer --topic homework-topic --bootstrap-server localhost:9092
>homework12
>^C
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework12>echo Test message from CMD | docker exec -i kafka kafka-console-producer --topic homework-topic --bootstrap-server localhost:9092

# Чтение сообщений
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework12>docker exec -it kafka kafka-console-consumer --topic homework-topic --bootstrap-server localhost:9092 --from-beginning
homework12
Test message from CMD

# UI for Apache Kafka
Отправка и просмотр предоставлены на изображениях produce.png и messages.png в каталоге ДЗ.

# Программная отправка и получение сообщений
- Проект KafkaHomework.csproj в каталоге ДЗ.
- Там же скрин получения существующих сообщений и ожидание новых (waiting.png).
- Там же скрин программной отправки и получения (produce_and_consume.png).