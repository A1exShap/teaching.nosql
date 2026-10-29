using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;

var factory = new ConnectionFactory { 
    HostName = "localhost", 
    UserName = "admin", 
    Password = "admin123" 
};
var queueName = "homework-queue";

if (args.Length > 0 && args[0] == "produce")
{
    await using var connection = await factory.CreateConnectionAsync();
    await using var channel = await connection.CreateChannelAsync();
    
    await channel.QueueDeclareAsync(queue: queueName, durable: true, exclusive: false, autoDelete: false, arguments: null);

    for (int i = 1; i <= 3; i++)
    {
        var message = $"Test message from C# #{i}";
        var body = Encoding.UTF8.GetBytes(message);
        await channel.BasicPublishAsync(exchange: string.Empty, routingKey: queueName, body: body);
        Console.WriteLine($"Sent: {message}");
    }
}
else if (args.Length > 0 && args[0] == "consume")
{
    await using var connection = await factory.CreateConnectionAsync();
    await using var channel = await connection.CreateChannelAsync();
    
    await channel.QueueDeclareAsync(queue: queueName, durable: true, exclusive: false, autoDelete: false, arguments: null);

    var consumer = new AsyncEventingBasicConsumer(channel);
    consumer.ReceivedAsync += (model, ea) =>
    {
        var body = ea.Body.ToArray();
        var message = Encoding.UTF8.GetString(body);
        Console.WriteLine($"Received: {message}");
        return Task.CompletedTask;
    };

    await channel.BasicConsumeAsync(queue: queueName, autoAck: true, consumer: consumer);
    Console.WriteLine("Waiting for messages... (Ctrl+C to stop)");
    await Task.Delay(Timeout.Infinite);
}
else
{
    Console.WriteLine("Usage: dotnet run -- produce | consume");
}