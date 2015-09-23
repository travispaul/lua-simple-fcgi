local test = {}
local accept_count = 0
local start_count = 0

function getenv(env, default)
    return os.getenv(env) or default
end

test.accept = function ()

    accept_count = accept_count + 1

    return "Status: 200 Ok\r\n" ..
        "Content-Type: text/html\r\n\r\n" ..
        accept_count .. "\n" .. start_count .. "\n"
end

test.start = function ()
    start_count = start_count + 1
    return 1
end

return test
