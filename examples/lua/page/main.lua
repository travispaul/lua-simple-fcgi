package.path = package.path .. ";?.lua"

local util = require 'util'
local lustache = require 'lustache'
local markdown = require 'markdown'

local app = {}
local actions = {}
local cache = {}
local template
local requests 

function actions.GET(page)

    if not cache[page] then
        local view = {page = page, requests = requests}
        local text = util.read('pages/' .. page .. '.md') or util.read('pages/404.md')

        -- Due to unusual behavior with partials, we render twice
        view.body = lustache:render(markdown(text), view)
        -- XXX make test case, and file bug report if applicable
    
        cache[page] = util.response(lustache:render(template, view))
    end
    return cache[page]; 
end

function app.restart()
    cache = {}
    template = util.read('layout.html')
    return 0
end

function app.start()
    app.restart()
    requests = 0
    return 0
end

function app.accept()
    local method = os.getenv('REQUEST_METHOD') or 'GET'
    local url = os.getenv('REQUEST_URI')
    local parts = util.split(url, '/')
    local controller = parts[0]
    local page = parts[1]

    if not page then
        page = 'home'
    end

    if not actions[method] or not controller then
        page = '404'
        method = 'GET'
    end
   
    requests = requests + 1
 
    return actions[method](page)
end

-- Testing/Debug
-- app.start()
-- print(app.accept())
-- lua main.lua /page
-- lua main.lua /page/home
-- lua main.lua /page/foo

return app
