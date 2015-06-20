local util = {}

function util.split(str, sep)
    local result = {}
    local i = 0
    for ea in string.gmatch(str or '', '([^' .. (sep or '%s') .. ']+)') do
        result[i] = ea
        i = i + 1
    end
    return result
end

function util.read(file)
    local f = io.open(file, 'rb')

    if not f then
        return nil
    end

    local content = f:read('*all')
    f:close()
    return content
end

function util.header(content, status)
    return 'Status: ' .. (status or '200 Ok') .. "\r\n" ..
           'Content-Type: ' .. (content or 'text/html') .. "\r\n\r\n"
end

function util.response(body, content, status)
    return util.header(content, status) .. (body or '')
end

return util