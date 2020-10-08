--[[
Попробуем разобраться как работают приложения и что ваще это значит
]]

-- первичная инициализация базы данных


local server = require('http.server').new(nil, 8888, {
  log_requests = true,
  log_errors = true,
})
local json = require('json')

-- index page
server:route({method = 'GET', path = ''}, function()
  return {status = 200, body = 'This is index page'}
end)

-- запуск сервера
server:start()