from qdrant_client import QdrantClient
from qdrant_client.http import models
from sentence_transformers import SentenceTransformer

# Подключение к Qdrant
client = QdrantClient(host="localhost", port=6333)

# Загрузка модели для эмбеддингов (русскоязычная, обучена для семантического поиска)
print("Загрузка модели...")
model = SentenceTransformer('sergeyzh/rubert-tiny-sts-v2')

# Создание коллекции
collection_name = "bank_support"
if client.collection_exists(collection_name):
    client.delete_collection(collection_name)

client.create_collection(
    collection_name=collection_name,
    vectors_config=models.VectorParams(size=model.get_sentence_embedding_dimension(), distance=models.Distance.COSINE)
)

# Данные
tickets = [
    {"id": 1, "title": "Ошибка CRM", "text": "Система оформления кредитных заявок закрывается после открытия карточки клиента", "department": "credit", "category": "crm"},
    {"id": 2, "title": "Не печатается документ", "text": "После отправки договора на печать устройство не отвечает", "department": "operations", "category": "printing"},
    {"id": 3, "title": "Ошибка входа", "text": "Сотрудник не может войти в систему обработки платежей", "department": "finance", "category": "authentication"},
    {"id": 4, "title": "Проблема Outlook", "text": "Письма остаются в исходящих и не отправляются получателям", "department": "office", "category": "mail"},
    {"id": 5, "title": "Сбой документооборота", "text": "Система электронного согласования зависает при открытии вложений", "department": "legal", "category": "edms"},
    {"id": 6, "title": "Ошибка клиентского приложения", "text": "Приложение для оформления банковских продуктов аварийно завершается после авторизации", "department": "credit", "category": "crm"},
]

# Загрузка данных в Qdrant
print("Загрузка данных в Qdrant...")
for ticket in tickets:
    # Создание вектора из текста
    vector = model.encode(ticket["text"]).tolist()
    
    client.upsert(
        collection_name=collection_name,
        points=[
            models.PointStruct(
                id=ticket["id"],
                vector=vector,
                payload=ticket
            )
        ]
    )

print(f"Загружено {len(tickets)} записей.\n")

# Поисковые запросы
queries = [
    "закрывается программа кредитов",
    "не отправляется электронная почта",
    "невозможно войти в платежную систему",
    "зависает система согласования документов"
]

for query in queries:
    print(f"\n{'='*60}")
    print(f"Запрос: «{query}»")
    print(f"{'='*60}")
    
    query_vector = model.encode(query).tolist()
    
    # Поиск топ 2
    search_result = client.query_points(
        collection_name=collection_name,
        query=query_vector,
        limit=2
    ).points
    
    for i, hit in enumerate(search_result, 1):
        payload = hit.payload
        print(f"{i}. [Score: {hit.score:.4f}]")
        print(f"   ID: {payload['id']}, Title: {payload['title']}")
        print(f"   Text: {payload['text']}")
        print(f"   Category: {payload['category']}\n")