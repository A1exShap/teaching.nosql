# Проверка состояния контейнеров etcd
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework8>docker ps --filter "name=etcd"
CONTAINER ID   IMAGE                         COMMAND                  CREATED              STATUS                        PORTS                              NAMES
c4926db820ac   quay.io/coreos/etcd:v3.5.15   "/usr/local/bin/etcd…"   About a minute ago   Up About a minute (healthy)   2379-2380/tcp                      etcd-3
bcb07908217d   quay.io/coreos/etcd:v3.5.15   "/usr/local/bin/etcd…"   About a minute ago   Up About a minute (healthy)   2379-2380/tcp                      etcd-2
6efe3997ff23   quay.io/coreos/etcd:v3.5.15   "/usr/local/bin/etcd…"   About a minute ago   Up About a minute (healthy)   0.0.0.0:2379-2380->2379-2380/tcp   etcd-1

# Проверка кластера etcd
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework8>docker exec etcd-1 etcdctl --endpoints=http://172.31.0.11:2379,http://172.31.0.12:2379,http://172.31.0.13:2379 endpoint status --write-out=table
+-------------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
|        ENDPOINT         |        ID        | VERSION | DB SIZE | IS LEADER | IS LEARNER | RAFT TERM | RAFT INDEX | RAFT APPLIED INDEX | ERRORS |
+-------------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
| http://172.31.0.11:2379 | d1c5552bbc34b703 |  3.5.15 |   20 kB |      true |      false |         2 |        143 |                143 |        |
| http://172.31.0.12:2379 |  dff4ee383385c8c |  3.5.15 |   20 kB |     false |      false |         2 |        143 |                143 |        |
| http://172.31.0.13:2379 | de7d60d9631543ae |  3.5.15 |   20 kB |     false |      false |         2 |        143 |                143 |        |
+-------------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+

D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework8>docker exec etcd-1 etcdctl --endpoints=http://172.31.0.11:2379 member list --write-out=table
+------------------+---------+--------+-------------------------+-------------------------+------------+
|        ID        | STATUS  |  NAME  |       PEER ADDRS        |      CLIENT ADDRS       | IS LEARNER |
+------------------+---------+--------+-------------------------+-------------------------+------------+
|  dff4ee383385c8c | started | etcd-2 | http://172.31.0.12:2380 | http://172.31.0.12:2379 |      false |
| d1c5552bbc34b703 | started | etcd-1 | http://172.31.0.11:2380 | http://172.31.0.11:2379 |      false |
| de7d60d9631543ae | started | etcd-3 | http://172.31.0.13:2380 | http://172.31.0.13:2379 |      false |
+------------------+---------+--------+-------------------------+-------------------------+------------+

# Описание результатов
- Один лидер и два follower'а.
- Одинаковый `RAFT TERM = 2` — все узлы в одном сроке выборов.
- Одинаковый `RAFT INDEX = 143` — все узлы применили одинаковое количество записей в лог - репликация работает.
- Ошибок нет — все узлы доступны.

# Запись тестовых данных
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework8>docker exec etcd-1 etcdctl --endpoints=http://172.31.0.11:2379 put /demo/key1 "value_1"
OK

D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework8>docker exec etcd-1 etcdctl --endpoints=http://172.31.0.11:2379 put /demo/key2 "value_2"
OK

D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework8>docker exec etcd-1 etcdctl --endpoints=http://172.31.0.11:2379 put /demo/key3 "value_3"
OK

# Проверка данных
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework8>docker exec etcd-1 etcdctl --endpoints=http://172.31.0.11:2379 get /demo/ --prefix
/demo/key1
value_1
/demo/key2
value_2
/demo/key3
value_3

# Остановка ведущего узла etcd-1
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework8>docker stop etcd-1
etcd-1

# Проверка кластера
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework8>docker exec etcd-2 etcdctl --endpoints=http://172.31.0.12:2379,http://172.31.0.13:2379 endpoint status --write-out=table
+-------------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
|        ENDPOINT         |        ID        | VERSION | DB SIZE | IS LEADER | IS LEARNER | RAFT TERM | RAFT INDEX | RAFT APPLIED INDEX | ERRORS |
+-------------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
| http://172.31.0.12:2379 |  dff4ee383385c8c |  3.5.15 |   20 kB |     false |      false |         3 |        692 |                692 |        |
| http://172.31.0.13:2379 | de7d60d9631543ae |  3.5.15 |   20 kB |      true |      false |         3 |        692 |                692 |        |
+-------------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+

# Проверка данных
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework8>docker exec etcd-2 etcdctl --endpoints=http://172.31.0.12:2379,http://172.31.0.13:2379 get /demo/ --prefix
/demo/key1
value_1
/demo/key2
value_2
/demo/key3
value_3

# Результат проверки
- Кластер выбрал новый ведущий узел - etcd-3.
- Кворум сохранен.
- Все данные доступны.

# Запуск узла etcd-1
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework8>docker start etcd-1
etcd-1

# Проверка кластера
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework8>docker exec etcd-2 etcdctl --endpoints=http://172.31.0.11:2379,http://172.31.0.12:2379,http://172.31.0.13:2379 endpoint status --write-out=table
+-------------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
|        ENDPOINT         |        ID        | VERSION | DB SIZE | IS LEADER | IS LEARNER | RAFT TERM | RAFT INDEX | RAFT APPLIED INDEX | ERRORS |
+-------------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
| http://172.31.0.11:2379 | d1c5552bbc34b703 |  3.5.15 |   20 kB |     false |      false |         3 |       1103 |               1103 |        |
| http://172.31.0.12:2379 |  dff4ee383385c8c |  3.5.15 |   20 kB |     false |      false |         3 |       1103 |               1103 |        |
| http://172.31.0.13:2379 | de7d60d9631543ae |  3.5.15 |   20 kB |      true |      false |         3 |       1103 |               1103 |        |
+-------------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+

D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework8>docker exec etcd-2 etcdctl --endpoints=http://172.31.0.12:2379 member list --write-out=table
+------------------+---------+--------+-------------------------+-------------------------+------------+
|        ID        | STATUS  |  NAME  |       PEER ADDRS        |      CLIENT ADDRS       | IS LEARNER |
+------------------+---------+--------+-------------------------+-------------------------+------------+
|  dff4ee383385c8c | started | etcd-2 | http://172.31.0.12:2380 | http://172.31.0.12:2379 |      false |
| d1c5552bbc34b703 | started | etcd-1 | http://172.31.0.11:2380 | http://172.31.0.11:2379 |      false |
| de7d60d9631543ae | started | etcd-3 | http://172.31.0.13:2380 | http://172.31.0.13:2379 |      false |
+------------------+---------+--------+-------------------------+-------------------------+------------+

# Результат проверки
Узел etcd-1 запущен и вернулся в кластер


# Проверка кластера Consul
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework8>docker exec consul-server-1 consul members
Node              Address           Status  Type    Build   Protocol  DC   Partition  Segment
consul-server-1   172.32.0.10:8301  alive   server  1.18.2  2         dc1  default    <all>
consul-server-2   172.32.0.11:8301  alive   server  1.18.2  2         dc1  default    <all>
consul-server-3   172.32.0.12:8301  alive   server  1.18.2  2         dc1  default    <all>
consul-client-1   172.32.0.20:8301  alive   client  1.18.2  2         dc1  default    <default>
consul-client-2   172.32.0.21:8301  alive   client  1.18.2  2         dc1  default    <default>
consul-client-3   172.32.0.22:8301  alive   client  1.18.2  2         dc1  default    <default>
consul-client-lb  172.32.0.23:8301  alive   client  1.18.2  2         dc1  default    <default>

D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework8>docker exec consul-server-1 consul operator raft list-peers
Node             ID                                    Address           State     Voter  RaftProtocol  Commit Index  Trails Leader By
consul-server-1  151ddf7e-bafd-85d5-9979-4d36344b16f0  172.32.0.10:8300  leader    true   3             126           -
consul-server-3  36a335b8-61de-e539-34e5-f2c2bc9b3a8b  172.32.0.12:8300  follower  true   3             126           0 commits
consul-server-2  aab92881-36c7-da36-ed7c-13fd053a86c4  172.32.0.11:8300  follower  true   3             126           0 commits

# Результат проверки
- 3 сервера + 4 клиента.
- Кворум серверов = 2 из 3.
- Ведущий узел - consul-server-1.

# Остановка ведущего узла
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework8>docker stop consul-server-1
consul-server-1

# Проверка кластера
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework8>docker exec consul-server-2 consul operator raft list-peers
Node             ID                                    Address           State     Voter  RaftProtocol  Commit Index  Trails Leader By
consul-server-3  36a335b8-61de-e539-34e5-f2c2bc9b3a8b  172.32.0.12:8300  leader    true   3             179           -
consul-server-2  aab92881-36c7-da36-ed7c-13fd053a86c4  172.32.0.11:8300  follower  true   3             179           0 commits

# Проверка данных
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework8>docker exec consul-server-2 consul kv get nginx/config/site_title
HashiCorp Consul Demo

# Результат проверки
- Новый ведущий узел — consul-server-3.
- consul-server-1 не в списке.
- Trails Leader By: 0 commits — оставшийся follower полностью синхронизирован с новым лидером.
- HashiCorp Consul Demo - данные не потеряны.

# Запуск узла consul-server-1
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework8>docker start consul-server-1
consul-server-1

# Проверка кластера
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework8>docker exec consul-server-2 consul operator raft list-peers
Node             ID                                    Address           State     Voter  RaftProtocol  Commit Index  Trails Leader By
consul-server-3  36a335b8-61de-e539-34e5-f2c2bc9b3a8b  172.32.0.12:8300  leader    true   3             253           -
consul-server-2  aab92881-36c7-da36-ed7c-13fd053a86c4  172.32.0.11:8300  follower  true   3             253           0 commits
consul-server-1  151ddf7e-bafd-85d5-9979-4d36344b16f0  172.32.0.10:8300  follower  true   3             253           0 commits

# Результат проверки
consul-server-1 запущен и вернулся в кластер