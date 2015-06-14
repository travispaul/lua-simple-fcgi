local test = {}
local counter

test.accept = function ()

    counter = counter + 1

    header = "Status: 200 Ok\r\n" ..
        "Content-Type: text/html\r\n\r\n"

    body = "<h1>Hello!</h1>" ..
        "uri:" .. os.getenv("REQUEST_URI") ..
        "<br />method: " .. os.getenv("REQUEST_METHOD") ..
        "<br />requests: " .. counter

    return header .. body
end

test.start = function ()
    counter = 0
end

return test