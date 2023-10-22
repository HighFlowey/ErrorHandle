local module = {}

function module.new(_func: (resolve: () -> (any), reject: () -> (any)) -> ())
    local handler = {}
    local response = nil
    local body = nil

    _func(function(v: any)
        response = true
        body = v
        -- worked
    end, function(v: any)
        body = v
        -- didnt work
    end)

    function handler:andThen(func: (v: any) -> ())
        if response == true then
            func(body)
        end

        return handler
    end

    function handler:catch(func: (v: any) -> ())
        if response ~= true then
            func(body)
        end

        return handler
    end

    return handler
end

--[[

---------------- TEST ---------------------------

local test = module.new(function(resolve, reject)
    if true == true then
        resolve("YES")
    else
        reject("NO")
    end
end)

test:andThen(function(msg: string)
    print(msg)
end):catch(function(msg: string)
    print(msg)
end)

]]

return module