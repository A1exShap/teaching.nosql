# Проверка контейнера
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework7>docker exec -it redis-demo redis-cli -a demo123 ping
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
PONG

# Генерация JSON
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework7>docker exec -it redis-demo bash
root@dfdd8dc7cd30:/data# awk 'BEGIN {
  print "["
  for (i = 0; i < 100000; i++) {
    if (i > 0) print ","
    printf "{\"id\":%d,\"name\":\"user_%d\",\"email\":\"user%d@example.com\",\"age\":%d,\"city\":\"city_%d\",\"description\":\"", i, i, i, 18 + (i % 60), i % 100
    for (j = 0; j < 100; j++) printf "x"
    printf "\",\"score\":%d,\"tags\":[\"tag1_%d\",\"tag2_%d\",\"tag3_%d\"]}", i % 1000, i, i, i
  }
  print "]"
}' > /tmp/big_data.json

# Проверка JSON
root@dfdd8dc7cd30:/data# ls -lh /tmp/big_data.json
-rw-r--r-- 1 root root 26M Oct 15 12:38 /tmp/big_data.json

# Запись JSON в Redis
root@dfdd8dc7cd30:/data# time (echo -n "SET big_json_string \""; cat /tmp/big_data.json | tr -d '\n' | sed 's/"/\\"/g'; echo "\"") | redis-cli -a demo123
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
OK

real    0m0.876s
user    0m0.685s
sys     0m0.292s

# Проверка
root@dfdd8dc7cd30:/data# redis-cli -a demo123 STRLEN big_json_string
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
(integer) 26712341

# Замер времени чтения строки
root@dfdd8dc7cd30:/data# time redis-cli -a demo123 GET big_json_string > /dev/null
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.

real    0m0.095s
user    0m0.017s
sys     0m0.048s

# Разделение на хеши
root@dfdd8dc7cd30:/data# awk '
BEGIN {
  for (i = 0; i < 100000; i++) {
    printf "HSET user:%d id %d name user_%d email user%d@example.com age %d city city_%d score %d\n",
      i, i, i, i, 18 + (i % 60), i % 100, i % 1000
  }
}' > /tmp/hset_commands.txt

root@dfdd8dc7cd30:/data# wc -l /tmp/hset_commands.txt
100000 /tmp/hset_commands.txt

root@dfdd8dc7cd30:/data# time cat /tmp/hset_commands.txt | redis-cli -a demo123 --pipe
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
All data transferred. Waiting for the last reply...
Last reply received from server.
errors: 0, replies: 100000

real    0m0.454s
user    0m0.025s
sys     0m0.056s

# Проверка хешей
root@dfdd8dc7cd30:/data# redis-cli -a demo123 DBSIZE
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
(integer) 100001

# Проверка структуры хеша
root@dfdd8dc7cd30:/data# redis-cli -a demo123 HGETALL user:42
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
 1) "id"
 2) "42"
 3) "name"
 4) "user_42"
 5) "email"
 6) "user42@example.com"
 7) "age"
 8) "60"
 9) "city"
10) "city_42"
11) "score"
12) "42"

# Замер времени чтения хешей
root@dfdd8dc7cd30:/data# awk 'BEGIN { for (i = 0; i < 100000; i++) printf "HGETALL user:%d\n", i }' > /tmp/hgetall_commands.txt

time cat /tmp/hgetall_commands.txt | redis-cli -a demo123 --pipe > /dev/null
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.

real    0m1.376s
user    0m1.244s
sys     0m0.031s

# Загрузка JSON как ZSet
root@dfdd8dc7cd30:/data# awk 'BEGIN {
  for (i = 0; i < 100000; i++) {
    printf "ZADD users_by_score %d user:%d\n", i % 1000, i
  }
}' > /tmp/zadd_commands.txt

wc -l /tmp/zadd_commands.txt
100000 /tmp/zadd_commands.txt

root@dfdd8dc7cd30:/data# time cat /tmp/zadd_commands.txt | redis-cli -a demo123 --pipe
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
All data transferred. Waiting for the last reply...
Last reply received from server.
errors: 0, replies: 100000

real    0m0.191s
user    0m0.008s
sys     0m0.037s

# Замер чтения ZSet
root@dfdd8dc7cd30:/data# time redis-cli -a demo123 ZRANGE users_by_score 0 -1 > /dev/null
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.

real    0m0.026s
user    0m0.012s
sys     0m0.005s

root@dfdd8dc7cd30:/data# time redis-cli -a demo123 ZRANGE users_by_score 0 -1 WITHSCORES > /dev/null
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.

real    0m0.038s
user    0m0.015s
sys     0m0.015s

# Загрузка JSON как List
root@dfdd8dc7cd30:/data# awk 'BEGIN {
  for (i = 0; i < 100000; i++) {
    printf "LPUSH users_list user:%d\n", i
  }
}' > /tmp/lpush_commands.txt

wc -l /tmp/lpush_commands.txt
100000 /tmp/lpush_commands.txt

root@dfdd8dc7cd30:/data# time cat /tmp/lpush_commands.txt | redis-cli -a demo123 --pipe
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
All data transferred. Waiting for the last reply...
Last reply received from server.
errors: 0, replies: 100000

real    0m0.093s
user    0m0.022s
sys     0m0.019s

# Замер чтения List
root@dfdd8dc7cd30:/data# time redis-cli -a demo123 LRANGE users_list 0 -1 > /dev/null
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.

real    0m0.021s
user    0m0.015s
sys     0m0.000s

# Результаты замеров
| Структура | Время записи | Время чтения |
| --------- | ------------ | ------------ |
| String    | 0.876 сек    | 0.095 сек    |
| Hash      | 0.454 сек    | 1.376 сек    |
| ZSet      | 0.191 сек    | 0.026 сек    |
| List      | 0.093 сек    | 0.021 сек    |

# Создание кластера
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework7>docker exec -it redis-1 redis-cli -a demo123 --cluster create redis-1:7001 redis-2:7002 redis-3:7003 redis-4:7004 redis-5:7005 redis-6:7006 --cluster-replicas 1
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
>>> Performing hash slots allocation on 6 nodes...
Master[0] -> Slots 0 - 5460
Master[1] -> Slots 5461 - 10922
Master[2] -> Slots 10923 - 16383
Adding replica redis-5:7005 to redis-1:7001
Adding replica redis-6:7006 to redis-2:7002
Adding replica redis-4:7004 to redis-3:7003
M: e6c5e7631af43b3ecb452b5d9b78911b34d27c7a redis-1:7001
   slots:[0-5460] (5461 slots) master
M: 9c010f6424dfbf47ecd9007d392b75c025daa68a redis-2:7002
   slots:[5461-10922] (5462 slots) master
M: 928eee35bf35cd8c73b599dac5110d8077508ad9 redis-3:7003
   slots:[10923-16383] (5461 slots) master
S: a0ddb3021b5bd83aa82efeafc2e708ecf8f892d1 redis-4:7004
   replicates 928eee35bf35cd8c73b599dac5110d8077508ad9
S: c0675847ca1eb5e3e4e636655e70a20d5138a4bc redis-5:7005
   replicates e6c5e7631af43b3ecb452b5d9b78911b34d27c7a
S: 51ddae5c798f9d5417795772c1339978619edfee redis-6:7006
   replicates 9c010f6424dfbf47ecd9007d392b75c025daa68a
Can I set the above configuration? (type 'yes' to accept): yes
>>> Nodes configuration updated
>>> Assign a different config epoch to each node
>>> Sending CLUSTER MEET messages to join the cluster
Waiting for the cluster to join
.
>>> Performing Cluster Check (using node redis-1:7001)
M: e6c5e7631af43b3ecb452b5d9b78911b34d27c7a redis-1:7001
   slots:[0-5460] (5461 slots) master
   1 additional replica(s)
M: 928eee35bf35cd8c73b599dac5110d8077508ad9 172.26.0.5:7003
   slots:[10923-16383] (5461 slots) master
   1 additional replica(s)
S: c0675847ca1eb5e3e4e636655e70a20d5138a4bc 172.26.0.4:7005
   slots: (0 slots) slave
   replicates e6c5e7631af43b3ecb452b5d9b78911b34d27c7a
S: a0ddb3021b5bd83aa82efeafc2e708ecf8f892d1 172.26.0.6:7004
   slots: (0 slots) slave
   replicates 928eee35bf35cd8c73b599dac5110d8077508ad9
S: 51ddae5c798f9d5417795772c1339978619edfee 172.26.0.7:7006
   slots: (0 slots) slave
   replicates 9c010f6424dfbf47ecd9007d392b75c025daa68a
M: 9c010f6424dfbf47ecd9007d392b75c025daa68a 172.26.0.2:7002
   slots:[5461-10922] (5462 slots) master
   1 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.

# Проверка кластера
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework7>docker exec -it redis-1 redis-cli -p 7001 -a demo123 CLUSTER INFO
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
cluster_state:ok
cluster_slots_assigned:16384
cluster_slots_ok:16384
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:6
cluster_size:3
cluster_current_epoch:6
cluster_my_epoch:1
cluster_stats_messages_ping_sent:100
cluster_stats_messages_pong_sent:106
cluster_stats_messages_sent:206
cluster_stats_messages_ping_received:101
cluster_stats_messages_pong_received:100
cluster_stats_messages_meet_received:5
cluster_stats_messages_received:206
total_cluster_links_buffer_limit_exceeded:0

D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework7>docker exec redis-1 redis-cli -p 7001 -a demo123 CLUSTER SLOTS
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
0
5460
172.26.0.2
7001
b8926fc23384a468376c791f4d5c09d42994d7cf

172.26.0.5
7005
0da95506180c42a6cc3bfc88507df412f4837243

5461
10922
172.26.0.3
7002
1c3a1439a85bd5bd915735994f6a13bbf6e3a873

172.26.0.4
7006
f62497720a7140c40ce7747cd48e9de4c472f62c

10923
16383
172.26.0.7
7003
005066a5e03e3da63016df134dd014465d60dfef

172.26.0.6
7004
872299fc8d245ec271dffce96a1cfe37c400706e

# Заполнение данными
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework7>docker exec -it redis-1 bash
root@73772b11e2a2:/data# awk 'BEGIN { for (i = 0; i < 34000; i++) printf "SET {b}:key:%d value_%d\n", i, i }' > /tmp/set_b.txt
root@73772b11e2a2:/data# wc -l /tmp/set_b.txt /tmp/set_c.txt /tmp/set_d.txt
  34000 /tmp/set_b.txt
  34000 /tmp/set_c.txt
  34000 /tmp/set_d.txt
 102000 total

root@73772b11e2a2:/data# time cat /tmp/set_b.txt | redis-cli -p 7001 -a demo123 --pipe
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
All data transferred. Waiting for the last reply...
Last reply received from server.
errors: 0, replies: 34000

real    0m0.102s
user    0m0.001s
sys     0m0.024s

D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework7>docker exec -i redis-2 bash -c "awk 'BEGIN { for (i = 0; i < 34000; i++) printf \"SET {c}:key:%d value_%d\n\", i, i }' | redis-cli -p 7002 -a demo123 --pipe"
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
All data transferred. Waiting for the last reply...
Last reply received from server.
errors: 0, replies: 34000

D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework7>docker exec -i redis-3 bash -c "awk 'BEGIN { for (i = 0; i < 34000; i++) printf \"SET {d}:key:%d value_%d\n\", i, i }' | redis-cli -p 7003 -a demo123 --pipe"
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
All data transferred. Waiting for the last reply...
Last reply received from server.
errors: 0, replies: 34000

# Проверка
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework7>docker exec redis-1 redis-cli -p 7001 -a demo123 DBSIZE
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
34000

D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework7>docker exec redis-2 redis-cli -p 7002 -a demo123 DBSIZE
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
34000

D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework7>docker exec redis-3 redis-cli -p 7003 -a demo123 DBSIZE
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
34000

# Проверка состояния кластера
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework7>docker exec redis-1 redis-cli -p 7001 -a demo123 CLUSTER NODES
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
1c3a1439a85bd5bd915735994f6a13bbf6e3a873 172.26.0.3:7002@17002 master - 0 1792073850000 2 connected 5461-10922
f62497720a7140c40ce7747cd48e9de4c472f62c 172.26.0.4:7006@17006 slave 1c3a1439a85bd5bd915735994f6a13bbf6e3a873 0 1792073850527 2 connected
0da95506180c42a6cc3bfc88507df412f4837243 172.26.0.5:7005@17005 slave b8926fc23384a468376c791f4d5c09d42994d7cf 0 1792073850527 1 connected
005066a5e03e3da63016df134dd014465d60dfef 172.26.0.7:7003@17003 master - 0 1792073849000 3 connected 10923-16383
b8926fc23384a468376c791f4d5c09d42994d7cf 172.26.0.2:7001@17001 myself,master - 0 1792073849000 1 connected 0-5460
872299fc8d245ec271dffce96a1cfe37c400706e 172.26.0.6:7004@17004 slave 005066a5e03e3da63016df134dd014465d60dfef 0 1792073850728 3 connected

# Запрос данных без редиректа
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework7>docker exec redis-1 redis-cli -p 7001 -a demo123 GET "{b}:key:1"
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
value_1

D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework7>docker exec redis-1 redis-cli -p 7001 -a demo123 GET "{c}:key:1"
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
MOVED 7365 172.26.0.3:7002


D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework7>docker exec redis-1 redis-cli -p 7001 -a demo123 GET "{d}:key:1"
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
MOVED 11298 172.26.0.7:7003

# Запрос данных с редиректом
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework7>docker exec redis-1 redis-cli -c -p 7001 -a demo123 GET "{c}:key:1"
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
value_1

D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework7>docker exec redis-1 redis-cli -c -p 7001 -a demo123 GET "{d}:key:1"
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
value_1

# Остановка узла
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework7>docker stop redis-1
redis-1

# Проверка кластера после остановки узла
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework7>docker exec redis-2 redis-cli -p 7002 -a demo123 CLUSTER NODES
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
0da95506180c42a6cc3bfc88507df412f4837243 172.26.0.5:7005@17005 master - 0 1792074212000 7 connected 0-5460
b8926fc23384a468376c791f4d5c09d42994d7cf 172.26.0.2:7001@17001 master,fail - 1792074101579 1792074099000 1 connected
005066a5e03e3da63016df134dd014465d60dfef 172.26.0.7:7003@17003 master - 0 1792074212531 3 connected 10923-16383
1c3a1439a85bd5bd915735994f6a13bbf6e3a873 172.26.0.3:7002@17002 myself,master - 0 1792074211000 2 connected 5461-10922
f62497720a7140c40ce7747cd48e9de4c472f62c 172.26.0.4:7006@17006 slave 1c3a1439a85bd5bd915735994f6a13bbf6e3a873 0 1792074213537 2 connected
872299fc8d245ec271dffce96a1cfe37c400706e 172.26.0.6:7004@17004 slave 005066a5e03e3da63016df134dd014465d60dfef 0 1792074211528 3 connected

# Чтение данных с остановленного узла
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework7>docker exec redis-2 redis-cli -c -p 7002 -a demo123 GET "{b}:key:1"
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
value_1

# Восстановление узла и проверка кластера
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework7>docker start redis-1
redis-1

D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework7>docker exec redis-2 redis-cli -p 7002 -a demo123 CLUSTER NODES
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
0da95506180c42a6cc3bfc88507df412f4837243 172.26.0.5:7005@17005 master - 0 1792074532215 7 connected 0-5460
b8926fc23384a468376c791f4d5c09d42994d7cf 172.26.0.2:7001@17001 slave 0da95506180c42a6cc3bfc88507df412f4837243 0 1792074532014 7 connected
005066a5e03e3da63016df134dd014465d60dfef 172.26.0.7:7003@17003 master - 0 1792074532316 3 connected 10923-16383
1c3a1439a85bd5bd915735994f6a13bbf6e3a873 172.26.0.3:7002@17002 myself,master - 0 1792074531000 2 connected 5461-10922
f62497720a7140c40ce7747cd48e9de4c472f62c 172.26.0.4:7006@17006 slave 1c3a1439a85bd5bd915735994f6a13bbf6e3a873 0 1792074532316 2 connected
872299fc8d245ec271dffce96a1cfe37c400706e 172.26.0.6:7004@17004 slave 005066a5e03e3da63016df134dd014465d60dfef 0 1792074532316 3 connected

# Изменение таймаута (на примере второго узла)
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework7>docker exec redis-2 redis-cli -p 7002 -a demo123 CONFIG SET cluster-node-timeout 2000
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
OK
