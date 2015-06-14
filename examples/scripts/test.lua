local test = {}
local counter


function getenv(env, default)
    return os.getenv(env) or default
end

test.accept = function ()

    counter = counter + 1

    header = "Status: 200 Ok\r\n" ..
        "Content-Type: text/html\r\n\r\n"

    body = "<h1>Hello!</h1>" ..
        "uri:" .. getenv("REQUEST_URI", "\n") ..
        "<br />method: " .. getenv("REQUEST_METHOD", "\n") ..
        "<br />requests: " .. counter .. "\n"

    return header .. body
end

test.start = function ()
    counter = 0
end

return test