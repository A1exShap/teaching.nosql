using Confluent.Kafka;

var bootstrapServers = "localhost:9092";
var topic = "homework-topic";

if (args.Length > 0 && args[0] == "produce")
{
    var config = new ProducerConfig { BootstrapServers = bootstrapServers };
    using var producer = new ProducerBuilder<Null, string>(config).Build();

    for (int i = 1; i <= 3; i++)
    {
        var message = $"Test message from C#-project #{i}";
        var result = await producer.ProduceAsync(topic, new Message<Null, string> { Value = message });
        Console.WriteLine($"Sent: {message} | Offset: {result.Offset}");
    }
}
else if (args.Length > 0 && args[0] == "consume")
{
    var config = new ConsumerConfig
    {
        BootstrapServers = bootstrapServers,
        GroupId = "csharp-consumer-group",
        AutoOffsetReset = AutoOffsetReset.Earliest
    };

    using var consumer = new ConsumerBuilder<Ignore, string>(config).Build();
    consumer.Subscribe(topic);

    Console.WriteLine("Waiting for messages... (Ctrl+C to stop)");
    var cts = new CancellationTokenSource();
    Console.CancelKeyPress += (_, e) => { e.Cancel = true; cts.Cancel(); };

    try
    {
        while (!cts.Token.IsCancellationRequested)
        {
            var result = consumer.Consume(cts.Token);
            Console.WriteLine($"Received: {result.Message.Value} | Offset: {result.Offset}");
        }
    }
    catch (OperationCanceledException) { }
}
else
{
    Console.WriteLine("Usage: dotnet run -- produce | consume");
}