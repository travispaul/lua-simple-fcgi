local util = require 'util'
local lustache = require 'lustache'
local markdown = require 'markdown'

local fcgi = {}
local actions = {}
local template

function actions.GET(page)
    local view = {page = page}
    local text = util.read('pages/' .. page .. '.md') or
       util.read('pages/404.md')

    -- Due to unusual behavior with partials, we render twice
    view.body = lustache:render(markdown(text), view)
    -- XXX make test case, and file bug report if applicable
 
     return util.response(lustache:render(template, view))
end

function fcgi.start()
    template = util.read('layout.html')
    return 0
end

function fcgi.accept()
    local method = os.getenv('REQUEST_METHOD') or 'GET'
    local url = os.getenv('REQUEST_URI') or arg[1]
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
    
    return actions[method](page)
end

-- comment out in when running as fcgi
fcgi.start()
print(fcgi.accept())
--

return fcgi
