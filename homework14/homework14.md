# Проверка контейнеров
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework14>docker ps --filter "name=minio"
CONTAINER ID   IMAGE                                      COMMAND                  CREATED              STATUS              PORTS                              NAMES
2d7a48387d26   pgsty/minio:RELEASE.2026-06-18T00-00-00Z   "/usr/bin/docker-ent…"   About a minute ago   Up About a minute   0.0.0.0:9000-9001->9000-9001/tcp   minio

# Установка MinIO
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework14>tar -xzf mcli_20261018000000.0.0_windows_amd64.tar.gz

D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework14>mcli.exe alias set myminio http://localhost:9000 minioadmin minioadmin
mcli.exe: Configuration written to `C:\Users\alexs\mcli\config.json`. Please update your access credentials.
mcli.exe: Successfully created `C:\Users\alexs\mcli\share`.
mcli.exe: Initialized share uploads `C:\Users\alexs\mcli\share\uploads.json` file.
mcli.exe: Initialized share downloads `C:\Users\alexs\mcli\share\downloads.json` file.
Added `myminio` successfully.

# Создание бакета
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework14>mcli.exe mb myminio/my-bucket
Bucket created successfully `myminio/my-bucket`.

# Создание файла
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework14>echo Test message from S3 CLI > test-file-cli.txt

# Загрузка файла в бакет
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework14>mcli.exe cp test-file-cli.txt myminio/my-bucket/
...test-file-cli.txt: 27 B / 27 B [========================================================================] 286 B/s 0s

# Проверка наличия файла в бакете
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework14>mcli.exe ls myminio/my-bucket
[2026-10-29 19:55:38 MSK]    27B STANDARD test-file-cli.txt

**Скрин с описанными выше операциями представлен в каталоге ДЗ (create_bucket_and_file.png)**

# Программное добавление файла в бакет
D:\PROJECTS\ОБУЧЕНИЕ\2026\teaching.nosql.homeworks\teaching.nosql\homework14\MinioHomework>dotnet run
Created local file: test-file-csharp.txt (20 bytes)
Uploaded to bucket: test-file-csharp.txt

Files in bucket:
 - test-file-cli.txt (27 bytes)
 - test-file-csharp.txt (20 bytes)

**Проект MinioHomework.csproj в каталоге ДЗ**