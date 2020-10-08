# Небольшой вводный учебник-справочник для того, чтобы побыстрому въехать в тему

## Docker

```bash
$ docker-compose up -d
$ docker-compose exec tarantool tarantool /opt/tarantool/hello.lua
```
Как вариант, можно запускать через `docker`, но мне больше нравится декларативный стиль композа.

## Модуль http

Основная задача - построить какой-то API на быстрой БД, которая еще и сервер приложений. Много где, а в частности [тут](https://habr.com/ru/company/rebrainme/blog/521556/), что на текущий момент (2020-10-09) очень свежая публикация, встречается такой вот код:

```lua
local http_router = require('http.router')
local http_server = require('http.server')
```

И даже на страничке [официального docker-образа](https://hub.docker.com/r/tarantool/tarantool) тарантула, в ссылке на включенный в сборку [модуль http](https://github.com/tarantool/http) мы видим похожий пример кода:

```lua
router = require('http.router').new(options)
server:set_router(router)
```

Однако, при попытке выполнить такой код, вываливается ошибка:

```console
LuajitError: /opt/tarantool/rts.lua:7: module 'http.router' not found:
        no field package.preload['http.router']
        no file '/opt/tarantool/http/router.lua'
        no file '/opt/tarantool/http/router/init.lua'
        no file '/opt/tarantool/http/router.so'
        no file '/opt/tarantool/.rocks/share/tarantool/http/router.lua'
        no file '/opt/tarantool/.rocks/share/tarantool/http/router/init.lua'
        no file '/opt/.rocks/share/tarantool/http/router.lua'
        no file '/opt/.rocks/share/tarantool/http/router/init.lua'
        no file '/.rocks/share/tarantoo
fatal error, exiting the event loop
```

Более того, в [официальной документации](https://www.tarantool.io/ru/doc/latest/reference/reference_lua/http/) нет ни слова про сервер и роутер.

Решение проблемы я нашел в [wiki репозитория проекта на GitHub](https://github.com/tarantool/tarantool/wiki/Recipes-Web). И выглядит это так:

```lua
local function handler(self)
    return self:render{ json = { ['Your-IP-Is'] = self.peer.host } }
end

local server = require('http.server').new(nil, 8080) -- listen *:8080
server:route({ path = '/' }, handler)
server:start()
```

На все про все, у меня ушло несколько часов. Честно говоря, такая ситуация сильно поубавила мой энтузиазм в отношении тарантула. Фактически, базовая фича не документирована, более того, намеренно скрыта в документации ибо там написано 

>Модуль http, в частности вложенный модуль http.client , обеспечивать функциональные возможности HTTP-клиента

Это цитата как есть. Не воодушевляет, камрады. Но я пока только тыкаю палочкой этого паука.

Рабочий код http-сервера в файле `volumes/db-code/http-server.lua`