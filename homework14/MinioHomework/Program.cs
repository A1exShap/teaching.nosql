using Minio;
using Minio.DataModel.Args;
using System.Text;

var endpoint = "localhost:9000";
var accessKey = "minioadmin";
var secretKey = "minioadmin";
var bucketName = "my-bucket";

var minioClient = new MinioClient()
    .WithEndpoint(endpoint)
    .WithCredentials(accessKey, secretKey)
    .WithSSL(false)
    .Build();

// Создание файла
var fileName = "test-file-csharp.txt";
var tempPath = Path.Combine(Path.GetTempPath(), fileName);
var fileContent = "Test message from C#";

await File.WriteAllTextAsync(tempPath, fileContent);
Console.WriteLine($"Created local file: {fileName} ({fileContent.Length} bytes)");

// Загрузка файла в бакет
var putArgs = new PutObjectArgs()
    .WithBucket(bucketName)
    .WithObject(fileName)
    .WithStreamData(new MemoryStream(Encoding.UTF8.GetBytes(fileContent)))
    .WithObjectSize(fileContent.Length);

await minioClient.PutObjectAsync(putArgs);
Console.WriteLine($"Uploaded to bucket: {fileName}");

// Удаление временного файла
File.Delete(tempPath);

// Проверка бакета
var listArgs = new ListObjectsArgs()
    .WithBucket(bucketName)
    .WithRecursive(true);

Console.WriteLine("\nFiles in bucket:");
await foreach (var item in minioClient.ListObjectsEnumAsync(listArgs))
{
    Console.WriteLine($" - {item.Key} ({item.Size} bytes)");
}