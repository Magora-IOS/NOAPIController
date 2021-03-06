# NOAPIController
API controller with JSON to Objective-C objects mapping.

## NOAPIController

- запросы представлены в виде объектов
- запрос можно отменить или положить в очередь
- маппинг моделей задаётся в декларативном стиле в формате NSDictionary
- поддержка вложенных объектов (рекурсия при разборе ответа)
- поддержка сборки объектов из нескольких полей
- возможность использовать маппер отдельно от собственно сетевого слоя (например для разбора данных, приходящих через альтернативные каналы связи — сокеты, веб-сокеты, Bluetooth, ...)
- запросы и парсинг ответов в отдельных потоках (очередях)


## APIController

- авто-обновление протухшего access-токена
- организация очереди и авто-ретрай запросов, провалившихся из-за протухшего access-токена
- разбор кастомных ошибок сервера (тело ответа парсится как объект-ошибка в случае ответа с "ошибочным" кодом)
- все методы(запросы) имеют одинаковый набор параметров -> легко автоматизировать обработку ошибок
