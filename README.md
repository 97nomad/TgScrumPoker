# TgScrumPoker

Бот для покера планирования (Scrum Poker)

Живёт по адресу http://t.me/nommy_scrum_poker_bot

## Использование

1. Добавить в групповой чат
2. Дать админские права на удаление сообщений (необязательно)

* `/story текст_истории` - начать голосование за историю
* любая цифра - голосование за историю
* `?`, `inf` и `coffee` - голосование без циферок 
* `/end` - отображение статистики

## Особенности работы

* Для подсчёта очков используется последовательность Фибоначчи
* При голосовании число округляется до ряда Фибоначчи в большую сторону
* Результат всегда округляется до ряда Фибоначчи в большую сторону

## Запуск и конфигурация

### NixOS with Flakes
```
inputs = [
   tg_scrum_poker.url = "github:97nomad/TgScrumPoker";
];

// ...

services.tgScrumPoker = {
	enable = true;
	token = "insert token here";
};
```

### Systemd
```
[Unit]

[Service]
Environment="TG_BOT_TOKEN="insert token here"

ExecStart=/bin/tg_scrum_poker start
ExecStop=/bin/tg_scrum_poker stop
```
